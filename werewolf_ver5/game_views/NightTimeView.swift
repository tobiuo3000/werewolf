import SwiftUI



struct NightTime: View {
	@EnvironmentObject var gameStatusData: GameStatusData
	@EnvironmentObject var gameProgress: GameProgress
	@State private var isActionDone: Bool = false
	@State var whole_players_index: Int
	@State private var survivors_index: Int = 0
	var survivors_list: [Int]
	
	var body: some View {
		
		if isActionDone==false {
			Night_Action_EachPlayer_View(whole_players_index: $whole_players_index, isActionDone: $isActionDone)
			
		}else if isActionDone == true {
			Night_Between_EachPlayer_View(whole_players_index: $whole_players_index, survivors_index: $survivors_index, isActionDone: $isActionDone, survivors_list: survivors_list)
			
		}
	}
}


struct Night_Action_EachPlayer_View: View{
	@EnvironmentObject var gameStatusData: GameStatusData
	@EnvironmentObject var gameProgress: GameProgress
	@Binding var whole_players_index: Int
	@Binding var isActionDone: Bool
	@State private var isTargetConfirmed: Bool = false
	let highlightColor: Color = Color(red: 0.8, green: 0.5, blue: 0.6)
	
	var body: some View{
		VStack{
			VStack{
				Text("\(gameProgress.players[whole_players_index].player_name)さん")
				Text("夜の行動時間です")
			}
			.textFrameDesignProxy()
			
			if gameProgress.players[whole_players_index].role_name == Role.villager{
				Night_Villager(isTargetConfirmed: $isTargetConfirmed, whole_players_index: $whole_players_index)
				
			}else if gameProgress.players[whole_players_index].role_name == Role.seer{
				Night_Seer(isTargetConfirmed: $isTargetConfirmed, whole_players_index: $whole_players_index)
				
			}else if gameProgress.players[whole_players_index].role_name == Role.medium{
				Night_Medium(isTargetConfirmed: $isTargetConfirmed, whole_players_index: $whole_players_index)
				
			}else if gameProgress.players[whole_players_index].role_name == Role.hunter{
				Night_hunter(isTargetConfirmed: $isTargetConfirmed, whole_players_index: $whole_players_index)
				
			}else if gameProgress.players[whole_players_index].role_name == Role.werewolf{
				Night_Werewolf(isTargetConfirmed: $isTargetConfirmed, whole_players_index: $whole_players_index)
			}
			
			Spacer()  // to keep objects' position elevated
			
			if isTargetConfirmed == true{
				Button("行動を終える") {
					isTargetConfirmed = false
					isActionDone = true
				}
				.myTextBackground()
				.myButtonBounce()
			}
		}
	}
}


struct Night_Between_EachPlayer_View: View{
	@EnvironmentObject var gameProgress: GameProgress
	@Binding var whole_players_index: Int
	@Binding var survivors_index: Int
	@Binding var isActionDone: Bool
	@State var proceedToNextPlayer: Bool = false
	var survivors_list: [Int]
	let highlightColor: Color = Color(red: 0.8, green: 0.5, blue: 0.6)
	
	var body: some View{
		VStack{
			if survivors_index+1 < gameProgress.get_num_survivors(){  // if there are players who haven't finished actions
				VStack{
					Text("次のプレイヤーに端末を渡してください")
					Text("次のプレイヤー：「\(gameProgress.players[survivors_list[survivors_index+1]].player_name)」")
				}
				.textFrameDesignProxy()
				
				Spacer()  // to keep objects' position elevated
				
				Button("次へ") {
					proceedToNextPlayer = true
				}
				.myTextBackground()
				.myButtonBounce()
				.alert("\(gameProgress.players[survivors_list[survivors_index+1]].player_name)さんですか？", isPresented: $proceedToNextPlayer){
					Button("次へ"){
						proceedToNextPlayer = false
						isActionDone = false
						survivors_index += 1
						whole_players_index = survivors_list[survivors_index]
					}
					Button("キャンセル", role: .cancel){
					}
				}
			}else{  // NightTime Processes are done here
				
				VStack{
					Text("恐ろしい夜が明けます")
				}
				.textFrameDesignProxy()
				
				Spacer()  // to keep objects' position elevated
				Button("次へ") {
					gameProgress.highestWerewolvesTargets = gameProgress.get_list_highest_werewolvesTarget()
					gameProgress.get_diary_cur_day().murderedPlayer = gameProgress.choose_one_random_player(highestList: gameProgress.highestWerewolvesTargets)!
					
					gameProgress.get_diary_cur_day().werewolvesTarget = gameProgress.get_diary_cur_day().murderedPlayer
					
					if let tmpWolfTarget = gameProgress.get_diary_cur_day().werewolvesTarget{
						if let tmpHunterTarget = gameProgress.get_diary_cur_day().hunterTarget{
							if gameProgress.try_murdering(target: tmpWolfTarget,
														  hunter_target: tmpHunterTarget) == true {
								gameProgress.sentence_to_death(suspect_id: tmpWolfTarget.id)
								gameProgress.get_diary_cur_day().murderedPlayer = gameProgress.get_diary_cur_day().werewolvesTarget!  // a werewolf target is decided by poll
							}
						}else{
							gameProgress.sentence_to_death(suspect_id: tmpWolfTarget.id)
						}
					}
					DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
						gameProgress.stageView = .Morning_time
						gameProgress.day_current_game = gameProgress.day_current_game + 1
						gameProgress.diary.append(DailyLog(day: gameProgress.day_current_game))
						gameProgress.reset_suspected_count()
						gameProgress.reset_werewolvesTarget_count()
					}
				}
				.myTextBackground()
				.myButtonBounce()
			}
		}
	}
}


struct Night_Villager:View{
	@EnvironmentObject var gameStatusData: GameStatusData
	@EnvironmentObject var gameProgress: GameProgress
	@Binding var isTargetConfirmed: Bool
	@State private var isAlertShown: Bool = false
	@State var villager_target: Player?
	@State var tmpPlayer: Player = Player(player_order: 1000, role: .noRole, player_name: "tmp_no_name")  // to avoid nil
	@Binding var whole_players_index: Int
	let highlightColor: Color = Color(red: 0.8, green: 0.5, blue: 0.6)
	
	var body: some View{
		if isTargetConfirmed == true{
			Text("\(tmpPlayer.player_name)を選択しました")
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
				ForEach(gameProgress.players.filter { $0.isAlive && $0.id != gameProgress.players[whole_players_index].id}) { player_vil in
					Button(player_vil.player_name) {
						tmpPlayer = player_vil
						isAlertShown = true
					}
					.myTextBackground()
					.myButtonBounce()
					.alert("\(tmpPlayer.player_name)があやしい", isPresented: $isAlertShown){
						Button("次へ"){
							tmpPlayer.suspectedCount += 1
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
}


struct Night_Seer:View{
	@EnvironmentObject var gameStatusData: GameStatusData
	@EnvironmentObject var gameProgress: GameProgress
	@Binding var isTargetConfirmed: Bool
	@State private var isAlertShown: Bool = false
	@Binding var whole_players_index: Int
	@State var tmpPlayer: Player = Player(player_order: 1000, role: .noRole, player_name: "tmp_no_name")  // to avoid nil
	let highlightColor: Color = Color(red: 0.8, green: 0.5, blue: 0.6)
	
	var body: some View{
		if isTargetConfirmed == false{
			VStack{
				Text("あなたは占い師です")
				Text("一人の役職を知ることができます")
			}
			.textFrameDesignProxy()
		}
		
		if isTargetConfirmed == true{
			VStack{
				Text("\(tmpPlayer.player_name)さんは...")
				HStack{
					if tmpPlayer.role_name == .werewolf{
						Text("人狼")
							.foregroundStyle(highlightColor)
						Text("です")
					}else{
						Text("人狼ではありません")
					}
				}
				.font(.title2)
			}
			.textFrameDesignProxy()
			
		}else{
			ScrollView(.vertical) {
				ForEach(gameProgress.players.filter { $0.isAlive && $0.id != gameProgress.players[whole_players_index].id}) { player_seer in
					Button(player_seer.player_name) {
						tmpPlayer = player_seer
						isAlertShown = true
					}
					.myTextBackground()
					.myButtonBounce()
					.alert("\(tmpPlayer.player_name)を占いますか？", isPresented: $isAlertShown){
						Button("決定"){
							gameProgress.get_diary_cur_day().seerTarget = tmpPlayer  // avoids nil while unrapping an opt value
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
}


struct Night_Medium:View{
	@EnvironmentObject var gameStatusData: GameStatusData
	@EnvironmentObject var gameProgress: GameProgress
	@Binding var isTargetConfirmed: Bool
	@State private var medium_target: Player?
	@State var tmpPlayer: Player = Player(player_order: 1000, role: .noRole, player_name: "tmp_no_name")  // to avoid nil
	@State private var isAlertShown: Bool = false
	@Binding var whole_players_index: Int
	let highlightColor: Color = Color(red: 0.8, green: 0.5, blue: 0.6)
	
	var body: some View{
		if isTargetConfirmed == true{
			Text("\(tmpPlayer.player_name)を選択しました")
				.textFrameDesignProxy()
			Spacer()
			VStack{  // fot Modifier
				Text("霊媒師の行動結果：")
				
				if let _tmpPlayer = (gameProgress.get_diary_from_day(target_day: gameProgress.day_current_game).executedPlayer){
					Text("処刑された\(_tmpPlayer.player_name)さんは")
					if _tmpPlayer.role_name == .werewolf{
						HStack{
							Text("人狼")
								.foregroundStyle(highlightColor)
							Text("でした")
						}
						.font(.title2)
					}else{
						Text("人狼ではありません")
							.font(.title2)
					}
				}
				
			}
			.textFrameDesignProxy()
		}else{
			VStack{
				VStack{
					Text("あなたは霊媒師です")
					Text("処刑された人物が人狼かどうかわかります")
				}
				Text("")
				Text("あやしいと思う人物を一人選んでください")
			}
			.textFrameDesignProxy()
			
			Spacer()
			ScrollView(.vertical) {
				ForEach(gameProgress.players.filter { $0.isAlive && $0.id != gameProgress.players[whole_players_index].id}) { player_vil in
					Button(player_vil.player_name) {
						tmpPlayer = player_vil
						isAlertShown = true
					}
					.myTextBackground()
					.myButtonBounce()
					.alert("\(tmpPlayer.player_name)があやしい", isPresented: $isAlertShown){
						Button("次へ"){
							tmpPlayer.suspectedCount += 1
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
}


struct Night_hunter:View {
	@EnvironmentObject var gameStatusData: GameStatusData
	@EnvironmentObject var gameProgress: GameProgress
	@Binding var isTargetConfirmed: Bool
	@State private var isAlertShown: Bool = false
	@Binding var whole_players_index: Int
	@State var tmpPlayer: Player = Player(player_order: 1000, role: .noRole, player_name: "tmp_no_name")  // to avoid nil
	let highlightColor: Color = Color(red: 0.8, green: 0.5, blue: 0.6)
	
	var body: some View{
		if isTargetConfirmed == true{
			Text("あなたは今晩\(tmpPlayer.player_name)さんを守ります")
				.textFrameDesignProxy()
			
		}else{
			VStack{
				Text("あなたは狩人です")
				Text("今晩人狼から守る人物を選択できます")
			}
			.textFrameDesignProxy()
			.padding()
			ScrollView(.vertical) {
				if gameStatusData.isConsecutiveProtectionAllowed == true {
					ForEach(gameProgress.players.filter { ($0.isAlive) && ($0.id != gameProgress.players[whole_players_index].id)}) { player_hunter in
						Button(player_hunter.player_name) {
							tmpPlayer = player_hunter
							isAlertShown = true
						}
						.myTextBackground()
						.myButtonBounce()
						.alert("\(tmpPlayer.player_name)を守りますか？", isPresented: $isAlertShown){
							Button("決定"){
								gameProgress.get_diary_cur_day().hunterTarget = tmpPlayer  // avoids nil while unrapping an opt value
								isTargetConfirmed = true
								isAlertShown = false
							}
							
							Button("キャンセル", role: .cancel){
							}
						}
					}
				} else {
					
					Text("※現在連続で同じ人を守ることはできません")
					
					if gameProgress.day_current_game == 1{
						ForEach(gameProgress.players.filter { ($0.isAlive) && ($0.id != gameProgress.players[whole_players_index].id)}) { player_hunter in
							Button(player_hunter.player_name) {
								tmpPlayer = player_hunter
								isAlertShown = true
							}
							.myTextBackground()
							.myButtonBounce()
							.alert("\(tmpPlayer.player_name)を守りますか？", isPresented: $isAlertShown){
								Button("決定"){
									gameProgress.get_diary_cur_day().hunterTarget = tmpPlayer  // avoids nil while unrapping an opt value
									isTargetConfirmed = true
									isAlertShown = false
								}
								Button("キャンセル", role: .cancel){
								}
							}
						}
					}else{
						if let tmpHunterTargetYesterday = gameProgress.get_diary_from_day(target_day: gameProgress.day_current_game-1).hunterTarget{
							ForEach(gameProgress.players.filter { ($0.isAlive) && ($0.id != tmpHunterTargetYesterday.id) && ($0.id != gameProgress.players[whole_players_index].id)}) { player_hunter in
								Button(player_hunter.player_name) {
									tmpPlayer = player_hunter
									isAlertShown = true
								}
								.myTextBackground()
								.myButtonBounce()
								.alert("\(tmpPlayer.player_name)を守りますか？", isPresented: $isAlertShown){
									Button("決定"){
										gameProgress.get_diary_cur_day().hunterTarget = tmpPlayer  // avoids nil while unrapping an opt value
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
			}
		}
	}
}


struct Night_Werewolf:View{
	@EnvironmentObject var gameStatusData: GameStatusData
	@EnvironmentObject var gameProgress: GameProgress
	@Binding var isTargetConfirmed: Bool
	@State private var werewolf_target: Player?
	@State var tmpPlayer: Player = Player(player_order: 1000, role: .noRole, player_name: "tmp_no_name")  // to avoid nil
	@State private var isAlertShown: Bool = false
	@Binding var whole_players_index: Int
	let highlightColor: Color = Color(red: 0.8, green: 0.5, blue: 0.6)
	
	var body: some View{
		if isTargetConfirmed == true{
			Text("あなたは今晩\(tmpPlayer.player_name)さんを襲撃します")
				.textFrameDesignProxy()
		}else{
			VStack{
				Text("あなたは人狼です")
				if gameStatusData.werewolf_Count_CONFIG > 1 {
					Text("今晩襲いたい人物に投票してください")
					Text("投票の際には")
					HStack{
						Text("3段階")
							.foregroundStyle(highlightColor)
							.font(.title3)
						Text("で票の重みづけが可能です")
					}
				}else{
					Text("今晩襲う人物を選択してください")
				}
			}
			.textFrameDesignProxy()
			.padding()
			
			ScrollView(.vertical) {
				ForEach(gameProgress.players.filter { $0.isAlive && $0.id != gameProgress.players[whole_players_index].id && $0.role_name != .werewolf}) { player_wolf in
					HStack{
						Button(player_wolf.player_name) {
							tmpPlayer = player_wolf
							isAlertShown = true
						}
						.myTextBackground()
						.myButtonBounce()
						.alert("\(tmpPlayer.player_name)に投票しますか？", isPresented: $isAlertShown){
							if gameStatusData.werewolf_Count_CONFIG > 1 {
								Button("強く投票する(3票)"){
									tmpPlayer.werewolvesTargetCount += 3
									isTargetConfirmed = true
									isAlertShown = false
								}
								Button("投票する(2票)"){
									tmpPlayer.werewolvesTargetCount += 2
									isTargetConfirmed = true
									isAlertShown = false
								}
								Button("弱く投票する(1票)"){
									tmpPlayer.werewolvesTargetCount += 1
									isTargetConfirmed = true
									isAlertShown = false
								}
							}else{
								Button("投票する"){
									tmpPlayer.werewolvesTargetCount += 1
									isTargetConfirmed = true
									isAlertShown = false
								}
							}
							Button("キャンセル", role: .cancel){
							}
						}
						
						Text(": \(player_wolf.werewolvesTargetCount)票")
							.font(.title3)
							.foregroundStyle(.white)
					}
				}
			}
		}
	}
}

