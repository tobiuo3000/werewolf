//
//  ReorderingView.swift
//  werewolf_ver5
//
//  Created by Masanori Sudo on 2024/10/31.
//


import SwiftUI


struct ReorderingPlayerView: View {
	@EnvironmentObject var gameStatusData: GameStatusData
	@State private var isAlertShown: Bool = false
	let viewColor: Color = Color(red: 0.2, green: 0.2, blue: 0.2)
	let highlightColor: Color = Color(red: 0.8, green: 0.5, blue: 0.6)
	let lineWidth: CGFloat = 6
	let baseColor: Color = Color(red: 0.15, green: 0.15, blue: 0.2)
	@State private var borderColor = Color(red: 1.0, green: 0.94, blue: 0.98)
	@FocusState private var isTextFieldFocused: Bool
	@Environment(\.editMode) var editMode
	
	@Environment(\.managedObjectContext) private var viewContext
	@FetchRequest (sortDescriptors: [NSSortDescriptor(key: "player_order", ascending: true)]) var players_CONFIG_saved: FetchedResults<PlayerEntity>
	
	var body: some View{
		ZStack{
			Color.black.opacity(0.6)
				.ignoresSafeArea()
			Rectangle()
				.foregroundStyle(.clear)
				.frame(height: gameStatusData.fullScreenSize.height/32)
			VStack{
				Rectangle()
					.foregroundStyle(.clear)
					.frame(height: gameStatusData.fullScreenSize.height/16)
				ZStack{
					VStack{
						VStack{
							ZStack{
								HStack{  // HStack for EditButton
									Spacer()
									EditButton()
										.foregroundColor(.blue)
										.font(.title2)
									Rectangle()
										.fill(.clear)
										.frame(width: 10, height: 10)
								}
								HStack{
									Rectangle()
										.fill(.clear)
										.frame(width: 10, height: 10)
									Button(action: {
										gameStatusData.players_CONFIG.append(Player(player_order: gameStatusData.players_CONFIG.count, role: .villager, player_name: "プレイヤー\(gameStatusData.players_CONFIG.count+1)"))
									}) {
										Image(systemName: "person.badge.plus")
											.font(.title)
											.padding(4)
									}
									.myButtonBounce()
									.bouncingUI(interval: 3)
									Spacer()
								}
								HStack{
									Spacer()
									VStack{
										Text("プレイヤー編集")
											.foregroundStyle(.white)
											.fontWeight(.bold)
											.font(.title2)
											.padding(4)
											.border(Color(red: 0.8, green: 0.8, blue: 0.8, opacity: 1.0), width: 2)
											.padding(lineWidth)
										
										HStack{
											Text("合計人数:")
												.foregroundStyle(.white)
												.fontWeight(.bold)
											Text("\(gameStatusData.players_CONFIG.count)人")
												.foregroundStyle(highlightColor)
												.fontWeight(.bold)
										}
										.font(.title2)
									}
									
									Spacer()
									Rectangle()
										.fill(.clear)
										.frame(width: 10, height: 10)  // make space for RIGHT SIDE
								}
							}
						}
						.background(baseColor)
						
						List {
							ZStack{  // this ZStack was for making a line separator in List
								HStack{
									Text("プレイ順序")
									Text("プレイヤー名")
								}
							}
							.foregroundStyle(.white)
							.frame(maxWidth: gameStatusData.fullScreenSize.width, alignment: .leading)
							.font(.title2)
							.listRowBackground(viewColor)
							.padding(lineWidth)
							
							ForEach(gameStatusData.players_CONFIG.indices, id: \.self) { index in
								HStack {
									Text("\(gameStatusData.players_CONFIG[index].player_order+1)番目")
										.foregroundStyle(.white)
										.frame(maxWidth: gameStatusData.fullScreenSize.width, alignment: .leading)
										.font(.title2)
									TextField("プレイヤー名", text: $gameStatusData.players_CONFIG[index].player_name)
										.focused($isTextFieldFocused)
										.foregroundStyle(.blue)
										.textFieldStyle(RoundedBorderTextFieldStyle())
										.autocorrectionDisabled()
										.frame(maxWidth: gameStatusData.fullScreenSize.width, alignment: .trailing)
										.submitLabel(.done)
								}
								.padding()
							}
							.onMove { indices, newOffset in
								gameStatusData.players_CONFIG.move(fromOffsets: indices, toOffset: newOffset)
								gameStatusData.updatePlayerOrder()
							}
							.onDelete(perform: confirmDelete)
							.listRowBackground(viewColor)
							.listRowSeparatorTint(.white)
						}
						.listStyle(PlainListStyle())
						.alert("プレイヤーを4名以下にすることはできません", isPresented: $isAlertShown) {
							Button("OK", role: .cancel) {
							}
						}
						
						
						if isTextFieldFocused == false{
							HStack{
								Spacer()
								Button(action: {
									
									do {
										try savePlayers(players: gameStatusData.players_CONFIG)
										print("Saved successfully!")
									} catch {
										print("Failed to save: \(error)")
									}
									
									gameStatusData.isReorderingViewShown = false
								}
								){
									Image(systemName: "checkmark.circle")
										.font(.largeTitle)
								}
								.myButtonBounce()
								.bouncingUI(interval: 3)
								.padding(8)
								Rectangle()
									.fill(baseColor)
									.frame(width: 10, height: 10)
							}
							.background(baseColor)
						}
					}
					.background(baseColor)
					.overlay(
						RoundedRectangle(cornerRadius: 18)
							.stroke(borderColor, lineWidth: 8)
					)
				}
				.cornerRadius(18)
				.frame(width: gameStatusData.fullScreenSize.width-2*lineWidth)
				
				Rectangle()
					.foregroundStyle(.clear)
					.frame(height: gameStatusData.fullScreenSize.height/40)
			}
		}
	}
	func confirmDelete(at offsets: IndexSet) {
		if gameStatusData.players_CONFIG.count >= 5 {
			deleteItems(at: offsets)
		} else {
			isAlertShown = true
		}
		gameStatusData.updatePlayerOrder()
	}
	
	func deleteItems(at offsets: IndexSet) {
		gameStatusData.players_CONFIG.remove(atOffsets: offsets)
	}
	
	func savePlayers(players: [Player]) throws {
		//let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
		//try viewContext.execute(deleteRequest)
		
		for p in players {
			let entity = PlayerEntity(context: viewContext)
			entity.id = p.id
			entity.player_order = Int64(p.player_order)
			entity.player_name = p.player_name
			entity.role_name = p.role_name.rawValue
			entity.isAlive = p.isAlive
			entity.isInspectedBySeer = p.isInspectedBySeer
			entity.voteCount = Int64(p.voteCount)
			entity.werewolvesTargetCount = Int64(p.werewolvesTargetCount)
			entity.suspectedCount = Int64(p.suspectedCount)
		}
		do{
			try viewContext.save()
		}catch{
			print("Failed to save: \(error)")
		}
	}
}


