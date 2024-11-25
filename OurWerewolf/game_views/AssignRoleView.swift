import SwiftUI


struct AssignRole: View{
	@EnvironmentObject var gameStatusData: GameStatusData
	@EnvironmentObject var gameProgress: GameProgress
	@State var Temp_index_num: Int = 0
	@State var isPlayerConfirmationDone = false
	@State var blackOpacity:Double = 1.0
	var duration:Double = 1.0
	
	var body: some View {
		ZStack{
			Color.black.opacity(blackOpacity)
			
			if isPlayerConfirmationDone == false {
				BeforeOnePlayerRole(Temp_index_num: $Temp_index_num,
									isPlayerConfirmationDone: $isPlayerConfirmationDone)
				.onAppear(){
					DispatchQueue.main.asyncAfter(deadline: .now()) {
						withAnimation(.easeIn(duration: duration)) {
							blackOpacity = 0
						}
					}
				}
				.opacity(1-blackOpacity)
			} else if isPlayerConfirmationDone == true {
				OnePlayerRoleShown(Temp_index_num: $Temp_index_num,
								   isPlayerConfirmationDone: $isPlayerConfirmationDone)
			}
		}
	}
}


struct BeforeOnePlayerRole: View{
	@EnvironmentObject var gameStatusData: GameStatusData
	@EnvironmentObject var gameProgress: GameProgress
	@Binding var Temp_index_num: Int
	@State private var isAlertShown = false
	@Binding var isPlayerConfirmationDone: Bool
	let highlightColor: Color = Color(red: 0.8, green: 0.5, blue: 0.6)
	
	var body: some View {
		VStack{
			Spacer()
			if Temp_index_num != 0{
				VStack{
					Text("次のプレイヤーに携帯を渡してください：")
					HStack{
						Text("「")
						Text("\(gameProgress.players[Temp_index_num].player_name)")
							.foregroundStyle(highlightColor)
						Text("」")
					}
					.font(.title2)
				}
				.textFrameSimple()
			}else{
				VStack(alignment: .center){
					Text("役職割り当てを行います")
					HStack{
						Text("\(gameProgress.players[Temp_index_num].player_name)")
							.foregroundStyle(highlightColor)
						Text("さんが")
					}
					Text("「次へ」を押してください")
				}
				.textFrameDesignProxy()
			}
			
			Spacer()
			Button("次へ") {
				isAlertShown = true
			}
			.myTextBackground()
			.myButtonBounce()
			.alert("\(gameProgress.players[Temp_index_num].player_name)さんですか？", isPresented: $isAlertShown){
				Button("はい"){
					isPlayerConfirmationDone = true
					isAlertShown = false
				}
				Button("いいえ", role:.cancel){}
			}
			
			Rectangle()
				.fill(.clear)
				.frame(width: 40, height: 40)
		}
	}
}


struct OnePlayerRoleShown: View {
	@EnvironmentObject var gameStatusData: GameStatusData
	@EnvironmentObject var gameProgress: GameProgress
	@Binding var Temp_index_num: Int
	@Binding var isPlayerConfirmationDone: Bool
	@State private var isAlertShown: Bool = false
	@State private var isCardTapped = false
	@State private var isRoleNameChecked = false
	@State private var isCardFlipped = false
	@State private var isRoleNameShown = false
	@State var cardScale: CGFloat = 1.0
	@State var textScale: CGFloat = 0
	@State var textOpacity: CGFloat = 0.0
	@State var isTapAllowed: Bool = true
	@State var traineeCheckResult: Bool = false
	@State var tmpPlayer_seer: Player = Player(player_order: 1000, role: .noRole, player_name: "tmp_no_name")  // to avoid nil
	@State var tmpPlayer_trainee: Player = Player(player_order: 1001, role: .noRole, player_name: "tmp_no_name")  // to avoid nil
	let highlightColor: Color = Color(red: 0.8, green: 0.5, blue: 0.6)
	
	var body: some View {
		GeometryReader { geometry in
			//let safeAreaInsets = geometry.safeAreaInsets
			VStack{
				FadingScrollView{
					VStack{
						TempTexts(Temp_index_num: $Temp_index_num, isPlayerConfirmationDone: $isPlayerConfirmationDone, isRoleNameShown: $isRoleNameShown, isRoleNameChecked: $isRoleNameChecked, cardScale: $cardScale, textScale: $textScale, textOpacity: $textOpacity)
						Text(" ")
							.font(.title2)
						
						ZStack{
							/*
							 CardAllignedView(imageFrameWidth: 60)
							 */
							
							ZStack{
								ZStack{  // for Modifier
									if isCardFlipped == false{
										Image(gameStatusData.currentTheme.cardBackSide)
											.resizable()
											.frame(width: (gameStatusData.fullScreenSize.height/gameStatusData.cardSize.height)*gameStatusData.cardSize.width/2,
												   height: gameStatusData.fullScreenSize.height/2)
											.scaleEffect(cardScale)
									}else{
										Image(gameProgress.players[Temp_index_num].role_name.image_name)
											.resizable()
											.frame(width: (gameStatusData.fullScreenSize.height/gameStatusData.cardSize.height)*gameStatusData.cardSize.width/2,
												   height: gameStatusData.fullScreenSize.height/2)
											.scaleEffect(cardScale)
									}
								}
								.cardFlippedWhenAssigningRole(isCardFlipped: $isCardFlipped, isCardTapped: $isCardTapped,
															  isRoleNameShown: $isRoleNameShown, isRoleNameChecked: $isRoleNameChecked,
															  cardScale: $cardScale, textScale: $textScale,
															  textOpacity: $textOpacity, isTapAllowed: $isTapAllowed)
								if isCardFlipped == false{
									VStack{
										Text("”tap here”")
											.font(.headline)
											.fontWeight(.bold)
											.foregroundStyle(.white)
										Rectangle()
											.fill(.clear)
											.frame(width: 5, height: 5)
										Image(systemName: "hand.tap.fill")
											.font(.largeTitle)
											.foregroundStyle(.white)
									}
									.flickeringUI(interval: 1)
									
								}
							}
						}
						.onAppear(){
							tmpPlayer_seer = gameProgress.get_one_random_vil_side()
							tmpPlayer_trainee = gameProgress.choose_one_random_player(highestList: gameProgress.players)!
							traineeCheckResult = gameStatusData.traineeCheckIfWerewolf(player: tmpPlayer_trainee)
						}
						
						Text(" ")
							.font(.title)
						
						if isRoleNameChecked{
							if gameProgress.players[Temp_index_num].role_name == Role.seer{
								if gameStatusData.isFirstNightRandomSeer{
									VStack{
										Text("初日ランダム占い結果：")
										HStack{
											Text("\(tmpPlayer_seer.player_name)")
												.foregroundStyle(highlightColor)
											Text("さんは")
										}
										Text("は人狼ではありません")
									}
									.textFrameDesignProxy()
								}
							}else if gameProgress.players[Temp_index_num].role_name == Role.trainee{
								VStack{
									Text("間違っているかもしれませんが...")
									Text("初日ランダム占い結果：")
									HStack{
										Text("\(tmpPlayer_trainee.player_name)")
											.foregroundStyle(highlightColor)
										Text("さんは")
									}
									HStack{
										if traineeCheckResult{
											Text("人狼")
												.foregroundStyle(highlightColor)
											Text("です")
										}else{
											Text("人狼ではありません")
										}
									}
								}
								.textFrameDesignProxy()
							}
							
							Text(" ")
								.font(.title)
							
							Button("役職を確認した"){
								gameStatusData.buttonSE()
								isAlertShown = true
							}
							.myTextBackground()
							.myButtonBounce()
							.alert("役職を確認しましたか？", isPresented: $isAlertShown){
								Button("はい"){
									if Temp_index_num+1 < gameProgress.players.count {
										Temp_index_num = Temp_index_num + 1
										isPlayerConfirmationDone = false
									}else{
										gameProgress.day_current_game = gameProgress.day_current_game + 1
										gameProgress.stageView = .Morning_time
										gameProgress.diary.append(DailyLog(day: gameProgress.day_current_game))
									}
									isAlertShown = false
									
								}
								Button("いいえ", role:.cancel){}
							}
							Rectangle()
								.fill(.clear)
								.frame(width: 40, height: 40)
						}
					}
				}
				
			}
		}
	}
}


struct TempTexts: View {
	@EnvironmentObject var gameStatusData: GameStatusData
	@EnvironmentObject var gameProgress: GameProgress
	@Binding var Temp_index_num: Int
	@Binding var isPlayerConfirmationDone: Bool
	@Binding var isRoleNameShown: Bool
	@Binding var isRoleNameChecked: Bool
	@Binding var cardScale: CGFloat
	@Binding var textScale: CGFloat
	@Binding var textOpacity: CGFloat
	
	var body: some View{
		VStack(spacing: 0){
			ZStack(alignment: .center){
				if isRoleNameShown == true{
					VStack(alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/){
						Text("「\(gameProgress.players[Temp_index_num].player_name)」さん")
						Text("役職： \(gameProgress.players[Temp_index_num].role_name.japaneseName)")
					}
					.textFrameDesignProxy()
					.opacity(textOpacity)
				}else{
					VStack(alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/){
						Text("「\(gameProgress.players[Temp_index_num].player_name)」さん")
						Text("役職： \(gameProgress.players[Temp_index_num].role_name.japaneseName)")
					}
					.foregroundStyle(Color(.clear))
				}
			}
			Text(" ")
		}
	}
}




struct CardAllignedView: View{
	@EnvironmentObject var gameStatusData: GameStatusData
	let imageFrameWidth: CGFloat
	
	
	var body: some View{
		ForEach(0..<gameStatusData.players_CONFIG.count, id: \.self) { playerIndex in
			EachCardView(index: playerIndex, imageFrameWidth: imageFrameWidth, imageFrameHeight: CGFloat(imageFrameWidth * (88/63)))
		}
	}
}

struct EachCardView: View{
	@EnvironmentObject var gameStatusData: GameStatusData
	let index: Int
	let imageFrameWidth: CGFloat
	let imageFrameHeight: CGFloat
	
	var body: some View{
		Image(gameStatusData.currentTheme.cardBackSide)
			.resizable()
			.frame(width: imageFrameWidth, height: imageFrameHeight)
			.position(CGPoint(x: imageFrameWidth/2+6,
							  y: (gameStatusData.fullScreenSize.height*1/3 + CGFloat(index)*20)))
	}
}
