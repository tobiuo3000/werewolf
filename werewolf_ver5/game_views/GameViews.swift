import SwiftUI

enum GameView_display_status{
	case Show_player_role, Before_discussion, After_night, Discussion_time, Vote_time, Vote_result, Night_time, Before_night_time
}




struct GameView: View {
	@EnvironmentObject var gameStatusData: GameStatusData
	@EnvironmentObject var gameProgress: GameProgress
	@State private var num_survivors: Int = 0
	@State private var isAlertShown = false
	@State var TempView: GameView_display_status = .Show_player_role
	
	var body: some View {
		VStack{
			HStack{
				Button(action: {
					isAlertShown = true
				})
				{
					Image(systemName: "stop.circle")
						.frame(width: 30, height: 30)
					
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
			}
			Spacer()
			
			if TempView == .Show_player_role {
				AssignRole(TempView: $TempView)
			}else if TempView == .Before_discussion {
				Before_discussion(TempView: $TempView)
				
			}else if TempView == .Discussion_time {
				Discussion_time(discussion_time: gameStatusData.discussion_time_CONFIG, TempView: $TempView,  num_survivors: $num_survivors)
				
			}else if TempView == .Vote_time{
				VoteTime(TempView: $TempView, player_index: gameProgress.get_survivors_list()[0], survivors_list:gameProgress.get_survivors_list())
				
			}else if TempView == .Vote_result{
				VoteResult(TempView: $TempView)
				
			}else if TempView == .Before_night_time {
				Before_night_time(TempView: $TempView, num_survivors: $num_survivors)
				
			}else if TempView == .Night_time{
				NightTime(TempView: $TempView, players_index: gameProgress.get_survivors_list()[0], survivors_list:gameProgress.get_survivors_list())
				
			}
		}
	}
}



struct VoteResult: View{
	@EnvironmentObject var GameStatusData: GameStatusData
	@EnvironmentObject var gameProgress: GameProgress
	@Binding var TempView: GameView_display_status
	
	var body: some View{
		VStack{
			Spacer()
			
			Text("最も多くの得票を得たプレイヤーは「\(gameProgress.get_hightst_vote()!.player_name)」です")
				.textFrameDesignProxy()
			
			Text("「\(gameProgress.get_hightst_vote()!.player_name)」は処刑されます")
				.textFrameDesignProxy()
			
			Button("次へ") {
				gameProgress.sentence_to_death(suspect_id: gameProgress.get_hightst_vote()!.id)
				gameProgress.get_diary_from_day(target_day: gameProgress.day_currrent_game).executedPlayer = gameProgress.get_hightst_vote()!
				gameProgress.reset_vote_count()
				gameProgress.game_Result()
				if gameProgress.game_result == 0{
					TempView = .Before_night_time
				}else if gameProgress.game_result == 1{
					GameStatusData.game_status = .gameOverScreen
				}else if gameProgress.game_result == 2{
					GameStatusData.game_status = .gameOverScreen
				}
			}
			.myTextBackground()
			.myButtonBounce()
			.padding()
		}
		.frame(maxWidth: .infinity, maxHeight: .infinity)
		.background(Color.black)
	}
}

struct VoteTime: View {
	@EnvironmentObject var GameStatusData: GameStatusData
	@EnvironmentObject var gameProgress: GameProgress
	@Binding var TempView: GameView_display_status
	@State var player_index: Int = 0
	@State var survivors_index: Int = 0
	@State var voteDone: Bool = false
	@State var isAlertShown: Bool = false
	var survivors_list: [Int]
	
	var body: some View {
		VStack{
			if voteDone == false{
				VStack{
					Text("「\(gameProgress.players[player_index].player_name)」さん")
					Text("人狼だと思う人物を選択してください")
				}
				.textFrameDesignProxy()
				
				ScrollView {
					ForEach(gameProgress.players.filter {$0.isAlive}) { player in
						if gameProgress.players[player_index].player_order != player.player_order{
							Button(player.player_name) {
								isAlertShown = true
							}
							.myTextBackground()
							.myButtonBounce()
							.alert("\(player.player_name)さんに投票しますか？", isPresented: $isAlertShown){
								Button("投票する"){
									player.voteCount += 1
									voteDone = true
									isAlertShown = false
								}
								Button("キャンセル", role: .cancel){
								}
							}
							.padding()
						}else{
							ZStack{
								Text(player.player_name)
									.padding(12)
									.background(.white)
									.cornerRadius(GameStatusData.currentTheme.cornerRadius)
								Text(player.player_name)
									.foregroundColor(.white)
									.padding(10)
									.background(
										Color(.gray)
									)
									.cornerRadius(GameStatusData.currentTheme.cornerRadius)
							}
							.padding()
						}
					}
				}
			}else{
				if survivors_index+1 < gameProgress.get_num_survivors(){
					VStack{
						Text("次のプレイヤーに携帯を渡してください")
						Text("次のプレイヤー：「\(gameProgress.players[survivors_list[survivors_index+1]].player_name)」")
					}
					.textFrameDesignProxy()
				}
				
				Button("次へ") {
					voteDone = false
					if survivors_index+1 == gameProgress.get_num_survivors(){
						TempView = .Vote_result
					}else{
						survivors_index += 1
						player_index = survivors_list[survivors_index]
						
					}
				}
				
				.padding()
			}
		}
		.frame(maxWidth: .infinity, maxHeight: .infinity)
		.background(Color.black)
	}
}


struct Before_discussion: View{
	@EnvironmentObject var GameStatusData: GameStatusData
	@EnvironmentObject var gameProgress: GameProgress
	@Binding var TempView: GameView_display_status
	private let columns: [GridItem] = Array(repeating: .init(.flexible()), count: 2)
	
	var body: some View{
		VStack{
			Spacer()
			VStack{
				Text("残り人数：\(gameProgress.get_num_survivors())")
				Text("生存者一覧")
			}
			.textFrameDesignProxy()
			
			LazyVGrid(columns: columns, spacing: 20) {
				ForEach(0..<gameProgress.players.count, id: \.self) { index in
					if gameProgress.players[index].isAlive == true{
						Text("\(gameProgress.players[index].player_name)")
							.textFrameDesignProxy()
					}else{
						Text("\(gameProgress.players[index].player_name)")
							.textFrameDesignProxy()
							.background(Color(red: 0.3, green: 0.3, blue: 0.3))
							.foregroundColor(Color(red: 0.5, green: 0.5, blue: 0.5))
					}
				}
			}
			.padding()
			Button("議論時間開始") {
				gameProgress.discussion_time = GameStatusData.discussion_time_CONFIG
				gameProgress.day_currrent_game = gameProgress.day_currrent_game + 1
				gameProgress.diary.append(DailyLog(day: gameProgress.day_currrent_game))
				TempView = .Discussion_time
			}
			.myTextBackground()
			.myButtonBounce()
			Spacer()
		}
	}
}

struct Before_night_time: View{
	@EnvironmentObject var GameStatusData: GameStatusData
	@EnvironmentObject var gameProgress: GameProgress
	@Binding var TempView: GameView_display_status
	@Binding var num_survivors: Int
	let columns: [GridItem] = Array(repeating: .init(.flexible()), count: 2)
	
	
	var body: some View{
		VStack {
			
			Spacer()
			VStack{
				Text("おそろしい夜の時間がやってきます")
				Text("\(gameProgress.players[gameProgress.get_survivors_list()[0]].player_name)さんに端末を渡してください")
			}
			.textFrameDesignProxy()
			
			VStack{
				Text("残り人数：\(num_survivors)")
				Text("生存者一覧")
			}
			.textFrameDesignProxy()
			
			ScrollView {
				LazyVGrid(columns: columns, spacing: 20) {
					ForEach(0..<gameProgress.players.count, id: \.self) { index in
						if gameProgress.players[index].isAlive == true{
							Text("\(gameProgress.players[index].player_name)")
								.textFrameDesignProxy()
								.cornerRadius(20)
						}else{
							Text("\(gameProgress.players[index].player_name)")
								.textFrameDesignProxy()
								.background(Color(red: 0.3, green: 0.3, blue: 0.3))
								.foregroundColor(Color(red: 0.5, green: 0.5, blue: 0.5))
								.cornerRadius(20)
						}
					}
				}
				.padding()
			}
			
			Button("端末を渡した") {
				TempView = .Night_time
			}
			.myTextBackground()
			.myButtonBounce()
			
			Spacer()
		}
		.frame(maxWidth: .infinity, maxHeight: .infinity)
		.background(Color.black)
	}
}


struct Discussion_time: View{
	@EnvironmentObject var gameProgress: GameProgress
	@State var discussion_time: Int
	@Binding var TempView: GameView_display_status
	@Binding var num_survivors: Int
	
	var body: some View{
		Spacer()
		Text("議論時間")
			.textFrameDesignProxy()
		Text("残り時間: \(discussion_time) 秒")
			.onAppear {
				Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
					if discussion_time > 0 {
						discussion_time -= 1
					} else {
						timer.invalidate()
						TempView = .Vote_time
						num_survivors = gameProgress.get_num_survivors()
						
					}
				}
			}
			.padding()
			.background(Color(red: 0.3, green: 0.3, blue: 0.4))
			.cornerRadius(20)
		
		Button("議論を終える") {
			TempView = .Vote_time
		}
		.myTextBackground()
		.myButtonBounce()
		Spacer()
	}
}













