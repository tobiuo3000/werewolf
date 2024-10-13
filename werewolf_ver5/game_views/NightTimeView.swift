import SwiftUI



struct NightTime: View {
	@EnvironmentObject var gameStatusData: GameStatusData
	@EnvironmentObject var gameProgress: GameProgress
	@Binding var TempView: GameView_display_status
	@State var players_index: Int
	@State private var survivors_index: Int = 0
	@State private var isActionDone: Bool = false
	@State private var seer_target: Player?
	@State private var werewolf_target: Player?
	@State private var hunter_target: Player?
	@State private var isTargetConfirmed: Bool = false
	@State private var isAlertShown: Bool = false
	@State private var isNightTimeFinished: Bool = false
	@State private var isSomeoneMurdered: Bool = false
	var survivors_list: [Int]
	
	var body: some View {
		if isNightTimeFinished==false {
			VStack{  // this VStack is for modifiers
				if isActionDone==false {
					VStack{
						Text("\(gameProgress.players[players_index].player_name)さん\n夜の行動時間です")
							.textFrameDesignProxy()
						if gameProgress.players[players_index].role_name == Role.villager{
							VStack{
								Text("あなたは市民です")
								Text("怪しまれないように画面タップとかしてて下さい")
							}
							.textFrameDesignProxy()
							
						}else if gameProgress.players[players_index].role_name == Role.seer{
							VStack{
								Text("あなたは占い師です")
								Text("一人の役職を知ることができます")
							}
							.textFrameDesignProxy()
							
							if isTargetConfirmed == true{
								VStack{
									Text("\(seer_target!.player_name)さんの役職は...")
									Text("\(seer_target!.role_name.japaneseName)です")
								}
								.textFrameDesignProxy()
								
							}else{
								ForEach(gameProgress.players.filter { $0.isAlive && $0.id != gameProgress.players[players_index].id}) { player in
									Button(player.player_name) {
										seer_target = player
										isTargetConfirmed = true
									}
									.myTextBackground()
									.myButtonBounce()
								}
							}
						}else if gameProgress.players[players_index].role_name == Role.medium{
							VStack{
								Text("あなたは霊媒師です")
								Text("処刑された人物が人狼かどうかわかります")
							}
							.textFrameDesignProxy()
							
							if gameProgress.day_currrent_game == 0{
								Text("現在はまだ誰も殺されていません")
							}else{
								Text("昨晩殺された\(gameProgress.get_diary_from_day(target_day: gameProgress.day_currrent_game).executedPlayer!.player_name)さんは...)")
								if gameProgress.get_diary_from_day(target_day: gameProgress.day_currrent_game).executedPlayer!.role_name == .werewolf{
									Text("人狼でした")
								}else{
									Text("人狼ではありません")
								}
							}
						}else if gameProgress.players[players_index].role_name == Role.hunter{
							VStack{
								Text("あなたは狩人です")
								Text("今晩人狼から守る人物を選択できます")
							}
							.textFrameDesignProxy()
							
							if isTargetConfirmed == true{
								Text("あなたは今晩\(hunter_target!.player_name)さんを守ります")
									.textFrameDesignProxy()
								
							}else{
								ForEach(gameProgress.players.filter { $0.isAlive && $0.id != gameProgress.players[players_index].id}) { player in
									Button(player.player_name) {
										hunter_target = player
										isTargetConfirmed = true
									}
									.myTextBackground()
									.myButtonBounce()
								}
							}
						}else if gameProgress.players[players_index].role_name == Role.werewolf{
							if isTargetConfirmed == true{
								Text("あなたは今晩\(werewolf_target!.player_name)さんを襲撃します")
									.textFrameDesignProxy()
							}else{
								VStack{
									Text("あなたは人狼です")
									Text("今晩襲う人物を選択してください")
								}
								
								.textFrameDesignProxy()
								ScrollView {
									ForEach(gameProgress.players.filter { $0.isAlive && $0.id != gameProgress.players[players_index].id}) { player in
										Button(player.player_name) {
											werewolf_target = player
											isTargetConfirmed = true
										}
										.myTextBackground()
										.myButtonBounce()
									}
								}
							}
						}
						
						Button("行動を終える") {
							isTargetConfirmed = false
							isActionDone = true
						}
						.myTextBackground()
						.myButtonBounce()
						.alert("行動を終了する", isPresented: $isAlertShown){
							Button("ゲームスタート"){
								isTargetConfirmed = false
								isActionDone = true
							}
							
							Button("キャンセル", role: .cancel){
							}
						}
					}
				}else if isActionDone == true {
					if survivors_index+1 < gameProgress.get_num_survivors(){
						VStack{
							Text("次のプレイヤーに端末を渡してください")
							Text("次のプレイヤー：「\(gameProgress.players[survivors_list[survivors_index+1]].player_name)」")
						}
						.textFrameDesignProxy()
					}else{
						Text("恐怖の夜が明け、朝が来ます")
							.textFrameDesignProxy()
					}
					
					Button("端末を渡した") {
						isActionDone = false
						
						if survivors_index+1 == gameProgress.get_num_survivors(){  // NightTime Processes are done here
							let _ = print(werewolf_target!.player_name)
							let _ = print(werewolf_target!.isAlive)
							isSomeoneMurdered = gameProgress.try_murdering(target: werewolf_target!,
																		   hunter_target: hunter_target)
							isNightTimeFinished = true
							if isSomeoneMurdered == true {
								gameProgress.get_diary_from_day(target_day: gameProgress.day_currrent_game).murderedPlayer = werewolf_target!
							}
						}else{
							survivors_index += 1
							players_index = survivors_list[survivors_index]
							
						}
					}
					.myTextBackground()
					.myButtonBounce()
				}
			}
			.frame(maxWidth: .infinity, maxHeight: .infinity)
			.background(Color.black)
			
			
		} else {  // After NightTime View
			VStack{
				VStack{
					Text("昨晩の犠牲者は...")
					if isSomeoneMurdered{
						Text("\(werewolf_target!.player_name)さんでした")
						Text("残り人数： \(gameProgress.get_num_survivors())")
						
					}else{
						Text("いませんでした")
						Text("残り人数： \(gameProgress.get_num_survivors())")
					}
				}
				.textFrameDesignProxy()
				Button("次へ") {
					isSomeoneMurdered = false
					gameProgress.game_Result()
					if gameProgress.game_result == 0{
						TempView = .Before_discussion
					}else if gameProgress.game_result == 1{
						gameStatusData.game_status = .gameOverScreen
					}else if gameProgress.game_result == 2{
						gameStatusData.game_status = .gameOverScreen
					}
				}
				.myTextBackground()
				.myButtonBounce()
			}
		}
		
	}
}














