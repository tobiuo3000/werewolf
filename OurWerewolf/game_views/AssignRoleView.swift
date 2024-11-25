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
				gameStatusData.buttonSE()
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
										Text("夜時間の行動で、選んだプレイヤーが「村人」か「人狼」かを知ることができます。")
											.fixedSize(horizontal: false, vertical: true)
										Text("")
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
									Text("夜時間の行動で、選んだプレイヤーが「村人」か「人狼」かを知ることができます。この占い結果は間違っているかもしれません。")
										.fixedSize(horizontal: false, vertical: true)
									Text("")
									Text("初日ランダム占い結果：")
									Text("間違っているかもしれませんが...")
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
							}else if gameProgress.players[Temp_index_num].role_name == Role.villager{
								VStack{
									Text("特殊能力のないプレイヤーです。")
										.fixedSize(horizontal: false, vertical: true)
									Text("処刑の投票を通して、村人陣営の勝利に導きましょう。")
										.fixedSize(horizontal: false, vertical: true)
								}
								.textFrameDesignProxy()
							}else if gameProgress.players[Temp_index_num].role_name == Role.hunter{
								VStack{
									Text("夜時間の行動で、選んだプレイヤーを人狼の襲撃から守ることができます。")
										.fixedSize(horizontal: false, vertical: true)
									Text("人狼があなたの守ったプレイヤーを襲撃した場合、襲撃は失敗します。")
										.fixedSize(horizontal: false, vertical: true)
								}
								.textFrameDesignProxy()
							}else if gameProgress.players[Temp_index_num].role_name == Role.werewolf{
								VStack{
									Text("夜時間の行動で、村人を一人襲撃して殺害できます。")
										.fixedSize(horizontal: false, vertical: true)
									Text("周囲に人狼だと悟られないように、村人陣営を減らしていきましょう。")
										.fixedSize(horizontal: false, vertical: true)
									Text("人狼と村人の数が同数になれば勝利です。")
										.fixedSize(horizontal: false, vertical: true)
								}
								.textFrameDesignProxy()
							}else if gameProgress.players[Temp_index_num].role_name == Role.madman{
								VStack{
									Text("あなたは特別な能力のない人間ですが人狼陣営です。")
										.fixedSize(horizontal: false, vertical: true)
									Text("占い師などに占われても村人と判定されます。人数カウントも村人としてカウントされます。")
										.fixedSize(horizontal: false, vertical: true)
									Text("ゲームを通して人狼をサポートしましょう。")
										.fixedSize(horizontal: false, vertical: true)
								}
								.textFrameDesignProxy()
							}else if gameProgress.players[Temp_index_num].role_name == Role.medium{
								VStack{
									Text("夜時間の際に、直前に処刑されたプレイヤーが「村人」か「人狼」か知ることができます。")
										.fixedSize(horizontal: false, vertical: true)
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
						HStack{
							Text("役職： ")
							Text(gameProgress.players[Temp_index_num].role_name.japaneseName)
								.foregroundStyle(gameStatusData.highlightColor)
						}
						if gameProgress.players[Temp_index_num].role_name == Role.werewolf || gameProgress.players[Temp_index_num].role_name == Role.madman{
							
							HStack{
								Text("陣営： ")
								Text("人狼陣営")
									.foregroundStyle(gameStatusData.highlightColor)
							}
						}else{
							HStack{
								Text("陣営： ")
								Text("村人陣営")
									.foregroundStyle(gameStatusData.highlightColor)
							}
						}
					}
					.textFrameDesignProxy()
					.opacity(textOpacity)
				}else{
					VStack{
						Text("~~さん")
						
						Text("役職： ◯◯")
						Text("陣営： ◯◯")
					}
					.foregroundStyle(Color(.clear))
				}
			}
			
		}
		Text(" ")
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
