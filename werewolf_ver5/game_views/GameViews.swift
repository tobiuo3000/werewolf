import SwiftUI

enum GameView_display_status{
	case Show_player_role, Before_discussion, Morning_time, Discussion_time, Vote_time, Vote_result, Runoff_Vote, RunoffVote_result, Night_time, Before_night_time
	
	var japaneseName: String {
		switch self {
		case .Show_player_role: return "役職確認"
		case .Before_discussion: return "議論時間"
		case .Discussion_time: return "議論時間"
		case .Vote_time: return "投票時間"
		case .Vote_result: return "投票結果"
		case .Runoff_Vote: return "決選投票"
		case .RunoffVote_result: return "投票結果"
		case .Before_night_time: return "夜時間"
		case .Night_time: return "夜時間"
		case .Morning_time: return "夜明け時間"
		}
	}
}


struct GameView: View {
	@EnvironmentObject var gameStatusData: GameStatusData
	@EnvironmentObject var gameProgress: GameProgress
	
	var body: some View {
		VStack{
			MenuDuringGameView()
			Spacer()
			ZStack{
				
				if gameProgress.stageView == .Show_player_role {
					AssignRole()
					
				}else if gameProgress.stageView == .Before_discussion {
					Before_discussion()
					let _ = print(gameProgress.get_diary_cur_day())
					let _ = print(gameProgress.get_diary_cur_day().day)
					let _ = print(gameProgress.get_diary_cur_day().id)
					if let p1 = gameProgress.get_diary_cur_day().executedPlayer {
						let _ = print(gameProgress.get_diary_cur_day().executedPlayer!.player_name)
					}
					if let p2 = gameProgress.get_diary_cur_day().murderedPlayer {
						let _ = print(gameProgress.get_diary_cur_day().murderedPlayer!.player_name)
					}
					
				}else if gameProgress.stageView == .Discussion_time {
					Discussion_time(discussion_time: gameStatusData.discussion_time_CONFIG)
					
				}else if gameProgress.stageView == .Vote_time{
					VoteTime(player_index: gameProgress.get_survivors_list()[0], survivors_list:gameProgress.get_survivors_list())
					
				}else if gameProgress.stageView == .Vote_result{
					VoteResult()
					
				}else if gameProgress.stageView == .Runoff_Vote{
					RunoffView(player_index: gameProgress.get_survivors_list()[0], survivors_list:gameProgress.get_survivors_list())
					
				}else if gameProgress.stageView == .RunoffVote_result{
					RunoffVoteResult()
					
				}else if gameProgress.stageView == .Before_night_time {
					Before_night_time()
					
				}else if gameProgress.stageView == .Night_time{
					NightTime(whole_players_index: gameProgress.get_survivors_list()[0], survivors_list:gameProgress.get_survivors_list())
					
				}else if gameProgress.stageView == .Morning_time{
					MorningView()
				}
			}
			BottomButtonGameView()
		}
	}
}


struct BottomButtonGameView: View{
	@EnvironmentObject var gameStatusData: GameStatusData
	@EnvironmentObject var gameProgress: GameProgress
	
	var body: some View{
		VStack{
			if gameProgress.stageView == .Show_player_role {
				
			}else if gameProgress.stageView == .Before_discussion {
				
			}else if gameProgress.stageView == .Discussion_time {
				
			}else if gameProgress.stageView == .Vote_time {
				
			}else if gameProgress.stageView == .Vote_result {
				
			}else if gameProgress.stageView == .Before_night_time {
				
			}else if gameProgress.stageView == .Night_time {
				
			}
			
			Rectangle()
				.fill(.clear)
				.frame(width: 40, height: 40)
		}
	}
}


struct MenuDuringGameView: View{
	@EnvironmentObject var gameStatusData: GameStatusData
	@EnvironmentObject var gameProgress: GameProgress
	@State private var isAlertShown = false
	let highlightColor: Color = Color(red: 0.8, green: 0.5, blue: 0.6)
	
	var body: some View{
		VStack{
			HStack{
				Button(action: {
					isAlertShown = true
				}){
					Image(systemName: "stop.circle")
						.font(.largeTitle)
				}
				.alert("進行中のゲームを終了しますか？", isPresented: $isAlertShown){
					Button("はい"){
						gameStatusData.update_role_CONFIG()
						gameStatusData.game_status = .homeScreen
						isAlertShown = false
					}
					Button("いいえ", role:.cancel){}
				}
				
				Spacer()
				VStack{
					HStack{
						Text("\(gameProgress.day_current_game)")
							.font(.title)
							.foregroundStyle(.white)
						Text("日目")
							.font(.title)
							.foregroundStyle(.white)
					}
					HStack{
						Text("[")
							.font(.title2)
							.foregroundStyle(.white)
						Text("\(gameProgress.stageView.japaneseName)")
							.font(.title2)
							.foregroundStyle(highlightColor)
						Text("]")
							.font(.title2)
							.foregroundStyle(.white)
					}
				}
				Spacer()
				Text("生存:")
					.font(.title2)
					.foregroundStyle(.white)
				Text("\(gameProgress.get_num_survivors())")
					.foregroundStyle(highlightColor)
					.font(.title)
					.foregroundStyle(.white)
				
				Text("/ \(gameStatusData.players_CONFIG.count)")
					.font(.title)
					.foregroundStyle(.white)
				Spacer()
			}
			Rectangle()  // a bar below TITLE, CONFIG UI
				.foregroundColor(Color(red: 0.95, green: 0.9, blue: 0.80, opacity: 1.0))
				.frame(height: 2)
		}
		.background(.black)
	}
}


struct MorningView: View {
	@EnvironmentObject var gameStatusData: GameStatusData
	@EnvironmentObject var gameProgress: GameProgress
	@State var isAlertShown: Bool = false
	let highlightColor: Color = Color(red: 0.8, green: 0.5, blue: 0.6)
	
	var body: some View {
		VStack{
			VStack{
				HStack{
					Text("\(gameProgress.day_current_game)日目")
						.foregroundStyle(highlightColor)
					Text("の朝が来ました")
				}
			}
			.textFrameDesignProxy()
			VStack{
				Text("昨晩の犠牲者は...")
				if let tmpPlayer = gameProgress.get_diary_from_day(target_day: gameProgress.day_current_game-1).murderedPlayer{
					Text("\(tmpPlayer.player_name)")
						.foregroundStyle(highlightColor)
						.font(.title2)
					Text("さんでした")
					Text("残り人数： \(gameProgress.get_num_survivors())")
					
				}else{
					Text("いませんでした")
					Text("残り人数： \(gameProgress.get_num_survivors())")
				}
			}
			.textFrameDesignProxy()
			
			let tmpSuspectedPlayers = gameProgress.get_list_highest_vote()
			if let tmpMostSuspectedPlayer = gameProgress.choose_one_random_player(highestList: tmpSuspectedPlayers){
				VStack{
					Text("また、昨晩もっとも疑われた人物は...")
					HStack{
						Text("\(tmpMostSuspectedPlayer.player_name)")
							.foregroundStyle(highlightColor)
						Text("さんです")
					}
				}
				.textFrameDesignProxy()
			}
			
			Spacer()
			Button("次へ") {
				isAlertShown = true
			}
			.myTextBackground()
			.myButtonBounce()
			.alert("次へ", isPresented: $isAlertShown){
				Button("はい"){
					isAlertShown = false
					gameProgress.reset_werewolvesTarget_count()
					gameProgress.game_Result()
					if gameProgress.game_result == 0{
						gameProgress.stageView = .Before_discussion
					}else if gameProgress.game_result == 1{
						gameStatusData.game_status = .gameOverScreen
					}else if gameProgress.game_result == 2{
						gameStatusData.game_status = .gameOverScreen
					}
				}
				Button("いいえ", role:.cancel){}
			}
		}
	}
}



struct ListSurviversView: View{
	@EnvironmentObject var gameProgress: GameProgress
	
	var body: some View{
		VStack{
			Text("生存者一覧")
		}
		.font(.title2)
		.textFrameDesignProxy()
		ScrollView{
			ForEach(0..<gameProgress.players.count, id: \.self) { index in
				if gameProgress.players[index].isAlive == true{
					Text("\(gameProgress.players[index].player_name)")
						.foregroundStyle(.white)
						.padding(16)
					
				}else{
					Text("\(gameProgress.players[index].player_name)")
						.foregroundColor(Color(red: 0.3, green: 0.3, blue: 0.3))
						.strikethrough(true, color: Color(red: 0.6, green: 0.6, blue: 0.6))
						.padding(16)
				}
			}
			.textFrameDesignProxy()
		}
	}
}


struct Before_discussion: View{
	@EnvironmentObject var GameStatusData: GameStatusData
	@EnvironmentObject var gameProgress: GameProgress
	private let columns: [GridItem] = Array(repeating: .init(.flexible()), count: 2)
	@State var isAlertShown: Bool = false
	let highlightColor: Color = Color(red: 0.8, green: 0.5, blue: 0.6)
	
	var body: some View{
		VStack{
			
			ListSurviversView()
			
			Spacer()
			Button("議論開始") {
				isAlertShown = true
			}
			.myTextBackground()
			.myButtonBounce()
			.alert("\(GameStatusData.discussion_minutes_CONFIG)分\(GameStatusData.discussion_seconds_CONFIG)秒間の議論が開始します", isPresented: $isAlertShown){
				Button("議論を開始する"){
					gameProgress.reset_suspected_count()
					gameProgress.discussion_time = GameStatusData.discussion_time_CONFIG
					gameProgress.stageView = .Discussion_time
					let _ = print(gameProgress.get_diary_cur_day())
					let _ = print(gameProgress.get_diary_cur_day().day)
					let _ = print(gameProgress.get_diary_cur_day().id)
					if let p1 = gameProgress.get_diary_cur_day().executedPlayer {
						print("executed: \(p1)")
					}
					if let p2 = gameProgress.get_diary_cur_day().murderedPlayer {
						print("executed: \(p2)")
					}
				}
				Button("キャンセル", role: .cancel){
				}
			}
		}
	}
}


struct Discussion_time: View{
	@EnvironmentObject var gameProgress: GameProgress
	@State var discussion_time: Int
	@State var isAlertShown: Bool = false
	
	var body: some View{
		VStack{
			Text("議論時間")
				.textFrameDesignProxy()
				.font(.title2)
			Spacer()
			Text("残り時間: \(discussion_time) 秒")
				.font(.largeTitle)
				.foregroundStyle(.white)
				.onAppear {
					Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
						if gameProgress.stageView != .Discussion_time {
							timer.invalidate()
						}
						
						if discussion_time > 0 {
							discussion_time -= 1
						} else {
							timer.invalidate()
							gameProgress.stageView = .Vote_time
						}
					}
				}
				.padding()
				.background(Color(red: 0.3, green: 0.3, blue: 0.4))
				.cornerRadius(20)
			HStack{
				Text("議論時間に１分追加: ")
					.foregroundStyle(.white)
					.font(.title3)
				Button(action: {
					discussion_time = discussion_time + 60
				}) {
					Image(systemName: "plus.app")
						.font(.title2)
						.foregroundColor(.blue)
				}
				.myButtonBounce()
			}
			.padding()
			Spacer()
			
			Button("議論終了") {
				isAlertShown = true
			}
			.myTextBackground()
			.myButtonBounce()
			.alert("投票を開始しますか？", isPresented: $isAlertShown){
				Button("次へ"){
					gameProgress.stageView = .Vote_time
				}
				Button("キャンセル", role: .cancel){
				}
			}
		}
	}
}


struct Before_night_time: View{
	@EnvironmentObject var GameStatusData: GameStatusData
	@EnvironmentObject var gameProgress: GameProgress
	@State var isAlertShown: Bool = false
	let columns: [GridItem] = Array(repeating: .init(.flexible()), count: 2)
	let highlightColor: Color = Color(red: 0.8, green: 0.5, blue: 0.6)
	
	var body: some View{
		VStack {
			
			Spacer()
			VStack{
				Text("おそろしい夜の時間がやってきます")
				HStack{
					Text("「")
					Text("\(gameProgress.players[gameProgress.get_survivors_list()[0]].player_name)")
						.foregroundStyle(highlightColor)
					Text("」に端末を渡してください")
				}
			}
			.textFrameDesignProxy()
			
			ListSurviversView()
			Spacer()
			
			Button("次へ") {
				isAlertShown = true
			}
			.myTextBackground()
			.myButtonBounce()
			.alert("\(gameProgress.players[gameProgress.get_survivors_list()[0]].player_name)さんですか？", isPresented: $isAlertShown){
				Button("次へ"){
					gameProgress.stageView = .Night_time
					isAlertShown = false
				}
				Button("キャンセル", role: .cancel){
				}
			}
			
			Spacer()
		}
	}
}











