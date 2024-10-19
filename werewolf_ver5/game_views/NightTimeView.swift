import SwiftUI



struct NightTime: View {
	@EnvironmentObject var gameStatusData: GameStatusData
	@EnvironmentObject var gameProgress: GameProgress
	@Binding var TempView: GameView_display_status
	@State var players_index: Int
	@State private var survivors_index: Int = 0
	@State private var isActionDone: Bool = false
	@State private var villager_target: Player?
	@State private var seer_target: Player?
	@State private var werewolf_target: Player?
	@State private var hunter_target: Player?
	@State private var isTargetConfirmed: Bool = false
	@State private var isAlertShown: Bool = false
	@State private var isNightTimeFinished: Bool = false
	@State private var isSomeoneMurdered: Bool = false
	@State var tmpPlayer:Player = Player(player_order: 1000, role: .villager, player_name: "none")  // TEMP
	var survivors_list: [Int]
	let highlightColor: Color = Color(red: 0.8, green: 0.5, blue: 0.6)
	
	var body: some View {
		if isNightTimeFinished==false {
			VStack{  // this VStack is for modifiers
				if isActionDone==false {
					VStack{
						VStack{
							Text("\(gameProgress.players[players_index].player_name)さん")
							Text("夜の行動時間です")
						}
						.textFrameDesignProxy()
						
						if gameProgress.players[players_index].role_name == Role.villager{
							
							if isTargetConfirmed == true{
								Text("\(villager_target!.player_name)を選択しました")
									.textFrameDesignProxy()
								Spacer()
								
							}else{
								VStack{
									Text("あなたは市民です")
									Text("他役職の方と同じタップ動作にするため")
									Text("あやしいと思う人物を一人選んでください")
								}
								.textFrameDesignProxy()
								
								Spacer()
								ScrollView(.vertical) {
									ForEach(gameProgress.players.filter { $0.isAlive && $0.id != gameProgress.players[players_index].id}) { player_vil in
										Button(player_vil.player_name) {
											tmpPlayer = player_vil
											isAlertShown = true
										}
										.myTextBackground()
										.myButtonBounce()
										.alert("\(tmpPlayer.player_name)があやしい", isPresented: $isAlertShown){
											Button("次へ"){
												villager_target = tmpPlayer
												isTargetConfirmed = true
												isAlertShown = false
											}
											
											Button("キャンセル", role: .cancel){
											}
										}
									}
								}
							}
						}else if gameProgress.players[players_index].role_name == Role.seer{
							if isTargetConfirmed == false{
								VStack{
									Text("あなたは占い師です")
									Text("一人の役職を知ることができます")
								}
								.textFrameDesignProxy()
							}
							
							if isTargetConfirmed == true{
								VStack{
									Text("\(seer_target!.player_name)さんは...")
									HStack{
										if seer_target!.role_name == .werewolf{
											Text("人狼")
												.foregroundStyle(highlightColor)
											Text("です")
										}else{
											Text("人狼ではありません")
										}
									}
								}
								.textFrameDesignProxy()
								
							}else{
								ScrollView(.vertical) {
									ForEach(gameProgress.players.filter { $0.isAlive && $0.id != gameProgress.players[players_index].id}) { player_seer in
										Button(player_seer.player_name) {
											tmpPlayer = player_seer
											isAlertShown = true
										}
										.myTextBackground()
										.myButtonBounce()
										.alert("\(tmpPlayer.player_name)を占いますか？", isPresented: $isAlertShown){
											Button("決定"){
												seer_target = tmpPlayer
												isTargetConfirmed = true
												isAlertShown = false
											}
											
											Button("キャンセル", role: .cancel){
											}
										}
									}
								}
							}
						}else if gameProgress.players[players_index].role_name == Role.medium{
							VStack{
								Text("あなたは霊媒師です")
								Text("処刑された人物が人狼かどうかわかります")
							}
							.textFrameDesignProxy()
							
							VStack{  // fot Modifier
								if gameProgress.day_currrent_game == -1{
									Text("まだ誰も殺されていません")
								}else{
									Text("処刑された\(gameProgress.get_diary_from_day(target_day: gameProgress.day_currrent_game).executedPlayer!.player_name)さんは...")
									if gameProgress.get_diary_from_day(target_day: gameProgress.day_currrent_game).executedPlayer!.role_name == .werewolf{
										Text("人狼でした")
									}else{
										Text("人狼ではありません")
									}
								}
							}
							.textFrameDesignProxy()
							
							Button("行動を終える") {
								isTargetConfirmed = false
								isActionDone = true
							}
							.myTextBackground()
							.myButtonBounce()
							
						}else if gameProgress.players[players_index].role_name == Role.hunter{
							if isTargetConfirmed == true{
								Text("あなたは今晩\(hunter_target!.player_name)さんを守ります")
									.textFrameDesignProxy()
								
							}else{
								VStack{
									Text("あなたは狩人です")
									Text("今晩人狼から守る人物を選択できます")
								}
								.textFrameDesignProxy()
								.padding()
								ScrollView(.vertical) {
									ForEach(gameProgress.players.filter { $0.isAlive && $0.id != gameProgress.players[players_index].id}) { player_hunter in
										Button(player_hunter.player_name) {
											tmpPlayer = player_hunter
											isAlertShown = true
										}
										.myTextBackground()
										.myButtonBounce()
										.alert("\(tmpPlayer.player_name)を守りますか？", isPresented: $isAlertShown){
											Button("決定"){
												hunter_target = tmpPlayer
												isTargetConfirmed = true
												isAlertShown = false
											}
											
											Button("キャンセル", role: .cancel){
											}
										}
									}
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
								.padding()
								
								ScrollView(.vertical) {
									ForEach(gameProgress.players.filter { $0.isAlive && $0.id != gameProgress.players[players_index].id}) { player_wolf in
										Button(player_wolf.player_name) {
											tmpPlayer = player_wolf
											isAlertShown = true
										}
										.myTextBackground()
										.myButtonBounce()
										.alert("\(tmpPlayer.player_name)を襲いますか？", isPresented: $isAlertShown){
											Button("投票する"){
												werewolf_target = tmpPlayer
												isTargetConfirmed = true
												isAlertShown = false
											}
											
											Button("キャンセル", role: .cancel){
											}
										}
									}
								}
							}
						}
						
						if isTargetConfirmed == true{
							Button("行動を終える") {
								isTargetConfirmed = false
								isActionDone = true
							}
							.myTextBackground()
							.myButtonBounce()
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
					
					Spacer()
					Button("次へ") {
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
				
				Spacer()  // to keep objects' position elevated
			}
			
			
		} else {  // After NightTime View
			VStack{
				VStack{
					Text("昨晩の犠牲者は...")
					if isSomeoneMurdered{
						Text("\(werewolf_target!.player_name)")
							.foregroundStyle(highlightColor)
						Text("さんでした")
						Text("残り人数： \(gameProgress.get_num_survivors())")
						
					}else{
						Text("いませんでした")
						Text("残り人数： \(gameProgress.get_num_survivors())")
					}
				}
				.textFrameDesignProxy()
				
				Spacer()
				Button("次へ") {
					isSomeoneMurdered = false
					gameProgress.day_currrent_game = gameProgress.day_currrent_game + 1
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














