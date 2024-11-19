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
	@State var showingSettings: Bool = false
	
	var body: some View {
		VStack{
			MenuDuringGameView(showingSettings: $showingSettings)
			Spacer()
			ZStack{
				
				AudioPlayerView()
				
				if gameProgress.stageView == .Show_player_role {
					AssignRole()
					
				}else if gameProgress.stageView == .Morning_time{
					MorningView()
					
				}else if gameProgress.stageView == .Before_discussion {
					Before_discussion()
					
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
					
				}
				
				if showingSettings == true{
					SettingsView(showingSettings: $showingSettings)
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
		}
	}
}


struct MenuDuringGameView: View{
	@EnvironmentObject var gameStatusData: GameStatusData
	@EnvironmentObject var gameProgress: GameProgress
	@State private var isAlertShown = false
	let highlightColor: Color = Color(red: 0.8, green: 0.5, blue: 0.6)
	@State var gearImageName = "gearshape"
	@Binding var showingSettings: Bool
	
	var body: some View{
		VStack{
			HStack{
				Button(action: {
					isAlertShown = true
				}){
					Image(systemName: "stop.circle")
						.font(.largeTitle)
				}
				.padding(8)
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
				
				Button(action: {
					showingSettings = true
				}){
					Image(systemName: gearImageName)
						.resizable()
						.frame(width: 30, height: 30)
						.font(.largeTitle)
				}
				.simultaneousGesture(LongPressGesture().onChanged { _ in
					gearImageName = "gearshape.fill"
				})
				.simultaneousGesture(TapGesture().onEnded {
					gearImageName = "gearshape"
				})
				.padding(8)
			}
			Rectangle()  // a bar below TITLE, CONFIG UI
				.foregroundColor(Color(red: 0.95, green: 0.9, blue: 0.80, opacity: 1.0))
				.frame(height: 2)
		}
		.background(.black)
	}
}


