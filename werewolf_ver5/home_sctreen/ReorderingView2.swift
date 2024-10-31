//
//  ReorderingView.swift
//  werewolf_ver5
//
//  Created by Masanori Sudo on 2024/10/31.
//


import SwiftUI


struct ReorderingPlayerView2: View {
	@EnvironmentObject var gameStatusData: GameStatusData
	@Binding var isReorderingViewShown: Bool
	@State private var isAlertShown: Bool = false
	let viewColor: Color = Color(red: 0.2, green: 0.2, blue: 0.2)
	let highlightColor: Color = Color(red: 0.8, green: 0.5, blue: 0.6)
	let lineWidth: CGFloat = 6
	let baseColor: Color = Color(red: 0.15, green: 0.15, blue: 0.2)
	@State private var borderColor = Color(red: 1.0, green: 0.94, blue: 0.98)
	
	@Environment(\.editMode) var editMode
	@State private var draggedItem: Player?
	@State private var dragOffset: CGSize = .zero
	
	
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
								HStack{  // EditButton
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
										Text("プレイヤー編集画面")
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
						
						FadingScrollView() {
							HStack{
								Text("プレイ順序")
									.foregroundStyle(.white)
									.frame(maxWidth: gameStatusData.fullScreenSize.width, alignment: .leading)
									.font(.title2)
								Text("プレイヤー名")
									.foregroundStyle(.white)
									.frame(maxWidth: gameStatusData.fullScreenSize.width, alignment: .leading)
									.font(.title2)
							}
							.listRowBackground(viewColor)
							.padding(lineWidth)
							
							ForEach(gameStatusData.players_CONFIG) { cur_player in
								HStack {
									Text("\(cur_player.player_order+1)番目")
										.foregroundStyle(.white)
										.frame(maxWidth: gameStatusData.fullScreenSize.width, alignment: .leading)
										.font(.title2)
									TextField("プレイヤー名", text: $gameStatusData.players_CONFIG[cur_player.player_order].player_name)
										.foregroundStyle(.blue)
										.textFieldStyle(RoundedBorderTextFieldStyle())
										.autocorrectionDisabled()
										.frame(maxWidth: gameStatusData.fullScreenSize.width, alignment: .trailing)
									ItemRowView(item: cur_player, isEditing: editMode?.wrappedValue.isEditing ?? false, deleteAction: {
																   deleteItem(cur_player)
															   })
															   .offset(draggedItem?.id == cur_player.id ? dragOffset : .zero)
															   .gesture(
																   editMode?.wrappedValue.isEditing == true ? DragGesture()
																	   .onChanged { value in
																		   if draggedItem == nil {
																			   draggedItem = cur_player
																		   }
																		   dragOffset = CGSize(width: 0, height: value.translation.height)
																		   moveItem(cur_player, by: value.translation.height)
																	   }
																	   .onEnded { _ in
																		   draggedItem = nil
																		   dragOffset = .zero
																	   }
																	   : nil
															   )
									
								}
								.padding()
							}
							.navigationBarItems(trailing: EditButton())
							.listStyle(PlainListStyle())
							.background(baseColor)
							.alert("プレイヤーを4名以下にすることはできません", isPresented: $isAlertShown) {
								Button("OK", role: .cancel) {
								}
							}
						}
						
						HStack{
							Spacer()
							Button(action: {
								isReorderingViewShown = false
								let _ = print(isReorderingViewShown)}){
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
					.background(baseColor)
					.overlay(
							RoundedRectangle(cornerRadius: 18)
								.stroke(borderColor, lineWidth: 8)
								//.frame(width: gameStatusData.fullScreenSize.width, height: gameStatusData.fullScreenSize.height*(29/32))
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
	func deleteItem(_ item: Player) {
		if let index = gameStatusData.players_CONFIG.firstIndex(where: { $0.id == item.id }) {
			gameStatusData.players_CONFIG.remove(at: index)
			}
		}

		func moveItem(_ item: Player, by translation: CGFloat) {
			guard let index = gameStatusData.players_CONFIG.firstIndex(where: { $0.id == item.id }) else { return }
			let itemHeight: CGFloat = 60  // アイテムの高さに合わせて調整
			let threshold = itemHeight / 2

			if translation < -threshold, index > 0 {
				withAnimation {
					gameStatusData.players_CONFIG.swapAt(index, index - 1)
				}
				dragOffset = CGSize(width: 0, height: translation + itemHeight)
			} else if translation > threshold, index < gameStatusData.players_CONFIG.count - 1 {
				withAnimation {
					gameStatusData.players_CONFIG.swapAt(index, index + 1)
				}
				dragOffset = CGSize(width: 0, height: translation - itemHeight)
			}
		}
}




struct ItemRowView: View {
	@ObservedObject var item: Player
	let isEditing: Bool
	let deleteAction: () -> Void

	var body: some View {
		HStack {
			if isEditing {
				Button(action: deleteAction) {
					Image(systemName: "minus.circle.fill")
						.foregroundColor(.red)
				}
				.padding(.trailing, 8)
			}
		}
		.padding(.vertical, 4)
	}
}
