import SwiftUI


struct GameSettingView: View{
	@EnvironmentObject var gameStatusData: GameStatusData
	@State var isAlertShown = false
	@Binding var isReorderingViewShown: Bool
	let highlightColor: Color = Color(red: 0.8, green: 0.5, blue: 0.6)
	//private let secondsRange: [Int] = Array(0..<60)
	//private let minutesRange: [Int] = Array(0..<60)
	
	init(isReorderingViewShown: Binding<Bool>){
		UIStepper.appearance().setDecrementImage(UIImage(systemName: "minus"), for: .normal)
		UIStepper.appearance().setIncrementImage(UIImage(systemName: "plus"), for: .normal)
		//@Binding var GamseSettingViewOffset: CGFloat
		self._isReorderingViewShown = isReorderingViewShown
	}
	
	var body: some View {
		ZStack{
			Image(gameStatusData.currentTheme.textBackgroundImage)  // BACKGROUND SHEEPSKIN
				.resizable()
				.frame(maxWidth: .infinity, maxHeight:.infinity)
				.allowsHitTesting(false)
			
			FadingScrollView(fadeHeight: 30, content: {
				Text("ゲーム設定")
					.font(.system(.largeTitle, design: .serif))
					.fontWeight(.bold)
					.foregroundStyle(.black)
					.padding()
				
				VStack{
					VStack(alignment: .leading){
						ZStack{
							HStack {
								Text("参加プレイヤー数:")
									.font(.title2)
								Spacer()
								Text("\(gameStatusData.players_CONFIG.count)人")
									.font(.title)
									.foregroundStyle(highlightColor)
								Spacer()
								Spacer()
								Spacer()
							}
							HStack{
								Spacer()
								Button(action: {
									isReorderingViewShown = true
								}) {
									Image(systemName: "rectangle.and.pencil.and.ellipsis.rtl")
										.font(.largeTitle)
										.foregroundColor(.blue)
								}
								.myButtonBounce()
								.bouncingUI(interval: 3)
								.padding()
							}
						}
						
						/*
						 ForEach(gameStatusData.players_CONFIG.indices, id: \.self) { index in
						 HStack{
						 Spacer()
						 HStack{
						 Text("\(gameStatusData.players_CONFIG[index].player_order+1)番目: ")
						 Spacer()
						 Text("\(gameStatusData.players_CONFIG[index].player_name)")
						 .foregroundStyle(highlightColor)
						 .font(.title3)
						 }
						 .padding()
						 .background(Color(red: 0.2, green: 0.2, blue: 0.2))
						 .cornerRadius(10)
						 Spacer()
						 }
						 }
						 */
					}
					.onChange(of: gameStatusData.players_CONFIG.count) { _ in
						gameStatusData.update_role_CONFIG()
					}
				}
				.textFrameDesignProxy()
				
				
				VStack{
					HStack{
						Text("ゲーム内議論時間: ")
							.font(.title2)
						Text("\(gameStatusData.discussion_minutes_CONFIG)分 \(gameStatusData.discussion_seconds_CONFIG)秒")
							.foregroundStyle(highlightColor)
							.font(.title)
						Spacer()
					}
					let minutes_range = 1...59
					let seconds_range = 0...50
					
					VStack{
						Stepper("minutes(分):", value: $gameStatusData.discussion_minutes_CONFIG, in: minutes_range)
							.pickerStyle(SegmentedPickerStyle())
							.accentColor(.white)
							.onChange(of: gameStatusData.werewolf_Count_CONFIG) { _ in
								gameStatusData.update_role_CONFIG()
								gameStatusData.calcDiscussionTime()
							}
						
						Stepper("seconds(秒):", value: $gameStatusData.discussion_seconds_CONFIG, in: seconds_range, step: 10)
							.pickerStyle(SegmentedPickerStyle())
							.accentColor(.white)
							.onChange(of: gameStatusData.werewolf_Count_CONFIG) { _ in
								gameStatusData.update_role_CONFIG()
								gameStatusData.calcDiscussionTime()
							}
					}
				}
				.textFrameDesignProxy()
				
				
				Text("役職人数")
					.font(.system(.largeTitle, design: .serif))
					.fontWeight(.bold)
					.foregroundStyle(.black)
					.padding()
				
				VStack{
					VStack{
						HStack{
							Text("現在： ")
							if gameStatusData.num_player_with_role <= gameStatusData.players_CONFIG.count{
								Text("\(gameStatusData.num_player_with_role)")
									.foregroundStyle(highlightColor)
								Text(" / ")
								Text("\(gameStatusData.players_CONFIG.count) 人 ")
							}else{
								VStack{
									HStack{
										Text("\(gameStatusData.num_player_with_role)")
											.foregroundStyle(highlightColor)
										Text(" / ")
										Text("\(gameStatusData.players_CONFIG.count) 人 ")
									}
									Text("※役職の人数を減らしてください")
										.foregroundStyle(highlightColor)
								}
							}
						}
						.font(.title)
						
						Text("")  // make space
						
						HStack{
							Spacer()
							Text("(役職数")
							Text("/")
							Text("プレイヤー数)")
						}
						.font(.title3)
						
						Text(" ")  // make space
							.font(.title)
					}
					
					
					
					ZStack{
						HStack{
							Text("人狼の数:")
							Spacer()
							RoleStepper(value: $gameStatusData.werewolf_Count_CONFIG, lowerBound: 1, upperBound:  gameStatusData.max_werewolf_CONFIG)
								.onChange(of: gameStatusData.werewolf_Count_CONFIG) { _ in
									gameStatusData.update_role_CONFIG()
								}
						}
						Text("\(gameStatusData.werewolf_Count_CONFIG)")
							.foregroundStyle(highlightColor)
							.font(.title)
					}
					
					ZStack{
						HStack{
							Text("見習い占の数:")
							Spacer()
							RoleStepper(value: $gameStatusData.trainee_Count_CONFIG, lowerBound: 0, upperBound:  gameStatusData.max_trainee_CONFIG)
								.onChange(of: gameStatusData.trainee_Count_CONFIG) { _ in
									gameStatusData.update_role_CONFIG()
								}
						}
						Text("\(gameStatusData.trainee_Count_CONFIG)")
							.foregroundStyle(highlightColor)
							.font(.title)
					}
					
					ZStack{
						HStack{
							Text("占い師の数:")
							Spacer()
							RoleStepper(value: $gameStatusData.seer_Count_CONFIG, lowerBound: 0, upperBound: 1)
								.onChange(of: gameStatusData.seer_Count_CONFIG) { _ in
									gameStatusData.update_role_CONFIG()
								}
						}
						Text("\(gameStatusData.seer_Count_CONFIG)")
							.foregroundStyle(highlightColor)
							.font(.title)
					}
					
					ZStack{
						HStack{
							Text("霊媒師の数:")
							Spacer()
							RoleStepper(value: $gameStatusData.medium_Count_CONFIG, lowerBound: 0, upperBound: 1)
								.onChange(of: gameStatusData.medium_Count_CONFIG) { _ in
									gameStatusData.update_role_CONFIG()
								}
						}
						Text("\(gameStatusData.medium_Count_CONFIG)")
							.foregroundStyle(highlightColor)
							.font(.title)
					}
					
					ZStack{
						HStack{
							Text("狩人の数:")
							Spacer()
							RoleStepper(value: $gameStatusData.hunter_Count_CONFIG, lowerBound: 0, upperBound: 1)
								.onChange(of: gameStatusData.hunter_Count_CONFIG) { _ in
									gameStatusData.update_role_CONFIG()
								}
						}
						Text("\(gameStatusData.hunter_Count_CONFIG)")
							.foregroundStyle(highlightColor)
							.font(.title)
					}
					
					ZStack{
						HStack{
							Text("狂人の数:")
							Spacer()
							RoleStepper(value: $gameStatusData.madman_Count_CONFIG, lowerBound: 0, upperBound: 1)
								.onChange(of: gameStatusData.madman_Count_CONFIG) { _ in
									gameStatusData.update_role_CONFIG()
								}
						}
						Text("\(gameStatusData.madman_Count_CONFIG)")
							.foregroundStyle(highlightColor)
							.font(.title)
					}
				}
				.textFrameDesignProxy()
				
				
				Rectangle()
					.fill(.clear)
					.frame(width: 10, height: 10)
				Text("その他ゲーム設定")
					.font(.system(.largeTitle, design: .serif))
					.fontWeight(.bold)
					.foregroundStyle(.black)
					.padding()
				
				VStack{
					Toggle(isOn: $gameStatusData.isVoteCountVisible) {
						Text("投票中に得票数が見えるようにする")
							.font(.title3)
							.foregroundColor(.white)
					}
					.padding()
					
					Toggle(isOn: $gameStatusData.isConsecutiveProtectionAllowed) {
						Text("狩人の同一人物連続ガードを有効にする")
							.font(.title3)
							.foregroundColor(.white)
					}
					.padding()
					
					Toggle(isOn: $gameStatusData.requiresRunoffVote) {
						Text("処刑投票で同票の場合に決選投票をする")
							.font(.title3)
							.foregroundColor(.white)
					}
					.padding()
				}
				.textFrameDesignProxy()
			}
				, perform: {
					print($0)
				}
			)
		}
	}
}




struct ReorderingPlayerView: View {
	@EnvironmentObject var gameStatusData: GameStatusData
	@Binding var isReorderingViewShown: Bool
	@State private var isAlertShown: Bool = false
	let viewColor: Color = Color(red: 0.2, green: 0.2, blue: 0.2)
	let highlightColor: Color = Color(red: 0.8, green: 0.5, blue: 0.6)
	let lineWidth: CGFloat = 6
	let baseColor: Color = Color(red: 0.15, green: 0.15, blue: 0.2)
	@State private var borderColor = Color(red: 1.0, green: 0.9, blue: 0.95)
	@Environment(\.editMode) var editMode
	
	
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
							
							ForEach(gameStatusData.players_CONFIG.indices, id: \.self) { index in
								HStack {
									Text("\(gameStatusData.players_CONFIG[index].player_order+1)番目")
										.foregroundStyle(.white)
										.frame(maxWidth: gameStatusData.fullScreenSize.width, alignment: .leading)
										.font(.title2)
									TextField("プレイヤー名", text: $gameStatusData.players_CONFIG[index].player_name)
										.foregroundStyle(.blue)
										.textFieldStyle(RoundedBorderTextFieldStyle())
										.autocorrectionDisabled()
										.frame(maxWidth: gameStatusData.fullScreenSize.width, alignment: .trailing)
									
								}
								.padding()
							}
							.onMove { indices, newOffset in  // FOR EditButton
								gameStatusData.players_CONFIG.move(fromOffsets: indices, toOffset: newOffset)
								gameStatusData.updatePlayerOrder()
							}
							.onDelete(perform: confirmDelete)  // FOR EditButton
							.listRowBackground(viewColor)
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
}

