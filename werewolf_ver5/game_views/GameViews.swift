import SwiftUI

enum GameView_display_status{
	case Show_player_role, Before_discussion, After_night, Discussion_time, Vote_time, Vote_result, Night_time, Before_night_time
}


struct GameView: View {
	@EnvironmentObject var gameStatusData: GameStatusData
	@EnvironmentObject var gameProgress: GameProgress
	@State private var num_survivors: Int = 0
	@State var TempView: GameView_display_status = .Show_player_role
	
	var body: some View {
		VStack{
			MenuDuringGameView()
			Spacer()
			ZStack{
				
				if TempView == .Show_player_role {
					AssignRole(TempView: $TempView)
					
				}else if TempView == .Before_discussion {
					Before_discussion(TempView: $TempView)
					
				}else if TempView == .Discussion_time {
					Discussion_time(discussion_time: gameStatusData.discussion_time_CONFIG, TempView: $TempView,  num_survivors: $num_survivors)
					
				}else if TempView == .Vote_time{
					VoteTime(TempView: $TempView, player_index: gameProgress.get_survivors_list()[0], survivors_list:gameProgress.get_survivors_list())
					
				}else if TempView == .Night_time{
					NightTime(TempView: $TempView, players_index: gameProgress.get_survivors_list()[0], survivors_list:gameProgress.get_survivors_list())
					
				}else if TempView == .Vote_result{
					VoteResult(TempView: $TempView)
					
				}else if TempView == .Before_night_time {
					Before_night_time(TempView: $TempView, num_survivors: $num_survivors)
					
				}
			}
			BottomButtonGameView(TempView: $TempView)
		}
		.onChange(of: TempView){
			let _ = print(TempView)
		}
	}
}


struct BottomButtonGameView: View{
	@EnvironmentObject var gameStatusData: GameStatusData
	@EnvironmentObject var gameProgress: GameProgress
	@Binding var TempView: GameView_display_status
	
	var body: some View{
		VStack{
			if TempView == .Show_player_role {
				
			}else if TempView == .Before_discussion {
				
				
			}else if TempView == .Discussion_time {
				
			}else if TempView == .Vote_time{
				
				
			}else if TempView == .Vote_result{
				
				
			}else if TempView == .Before_night_time {
				
				
			}else if TempView == .Night_time{
				
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
				Spacer()
				Button(action: {
					isAlertShown = true
				}){
					Image(systemName: "stop.circle")
						.frame(width: 30, height: 30)
				}
				.font(.title)
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
						Text("\(gameProgress.day_currrent_game+1)")
							.font(.title)
							.foregroundStyle(.white)
						Text("日目")
							.font(.title)
							.foregroundStyle(.white)
					}
					Text("\(gameProgress.stage)")
						.foregroundStyle(.white)
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



struct VoteResult: View{
	@EnvironmentObject var gameStatusData: GameStatusData
	@EnvironmentObject var gameProgress: GameProgress
	@Binding var TempView: GameView_display_status
	let highlightColor: Color = Color(red: 0.8, green: 0.5, blue: 0.6)
	
	var body: some View{
		VStack{
			Spacer()
			VStack{
				Text("最も多くの得票を得たプレイヤーは")
					.foregroundStyle(.white)
				HStack{
					Text("「")
					Text("\(gameProgress.get_hightst_vote()!.player_name)")
						.foregroundStyle(highlightColor)
					Text("」です")
				}
			}
			.textFrameDesignProxy()
			
			HStack{
				Text("「")
				Text("\(gameProgress.get_hightst_vote()!.player_name)")
					.foregroundStyle(highlightColor)
				Text("」は処刑されます")
			}
			.textFrameDesignProxy()
			Spacer()
			Button("次へ") {
				gameProgress.sentence_to_death(suspect_id: gameProgress.get_hightst_vote()!.id)
				gameProgress.get_diary_from_day(target_day: gameProgress.day_currrent_game).executedPlayer = gameProgress.get_hightst_vote()!
				gameProgress.reset_vote_count()
				gameProgress.game_Result()
				if gameProgress.game_result == 0{
					TempView = .Before_night_time
				}else if gameProgress.game_result == 1{
					gameStatusData.game_status = .gameOverScreen
				}else if gameProgress.game_result == 2{
					gameStatusData.game_status = .gameOverScreen
				}
			}
			.myTextBackground()
			.myButtonBounce()
			.padding()
		}
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
	let highlightColor: Color = Color(red: 0.8, green: 0.5, blue: 0.6)
	@State var tmpPlayer:Player = Player(player_order: 1000, role: .villager, player_name: "none")
	
	var body: some View {
		VStack{
			if voteDone == false{
				VStack{
					Text("「\(gameProgress.players[player_index].player_name)」さん")
					Text("人狼だと思う人物を選択してください")
				}
				.textFrameDesignProxy()
				
				ScrollView(.vertical) {
					ForEach(gameProgress.players.filter {$0.isAlive}) { player in
						if gameProgress.players[player_index].player_order != player.player_order{
							HStack{
								Button(player.player_name) {
									tmpPlayer = player
									isAlertShown = true
								}
								.myTextBackground()
								.myButtonBounce()
								.alert("\(tmpPlayer.player_name)さんに投票しますか？", isPresented: $isAlertShown){
									Button("投票する"){
										tmpPlayer.voteCount += 1
										voteDone = true
										isAlertShown = false
									}
									Button("キャンセル", role: .cancel){
									}
								}
								
								Text(": \(player.voteCount)票")
									.font(.title3)
									.foregroundStyle(.white)
							}
							.padding(12)
						}else{
							HStack{
								ZStack{
									Text(player.player_name)
										.padding(12)
										.background(.white)
										.strikethrough(true, color: .white)  // 横棒を赤色で表示
										.cornerRadius(GameStatusData.currentTheme.cornerRadius)
									Text(player.player_name)
										.foregroundColor(.white)
										.padding(10)
										.background(
											Color(.gray)
										)
										.cornerRadius(GameStatusData.currentTheme.cornerRadius)
								}
								Text(": \(player.voteCount)票")
									.font(.title3)
							}
							.padding(12)
						}
					}
				}
			}else{
				if survivors_index+1 < gameProgress.get_num_survivors(){
					VStack{
						Text("次のプレイヤーに携帯を渡してください:")
						HStack{
							Text("「")
							Text("\(gameProgress.players[survivors_list[survivors_index+1]].player_name)")
								.foregroundStyle(highlightColor)
							Text("」")
						}
					}
					.textFrameDesignProxy()
				}else{
					VStack{
						Text("投票結果を表示します")
					}
					.textFrameDesignProxy()
				}
				
				Spacer()
				Button("次へ") {
					voteDone = false
					if survivors_index+1 == gameProgress.get_num_survivors(){
						TempView = .Vote_result
					}else{
						survivors_index += 1
						player_index = survivors_list[survivors_index]
						
					}
				}
				.myTextBackground()
				.myButtonBounce()
				.padding()
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
	@Binding var TempView: GameView_display_status
	private let columns: [GridItem] = Array(repeating: .init(.flexible()), count: 2)
	@State var isAlertShown: Bool = false
	
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
					gameProgress.discussion_time = GameStatusData.discussion_time_CONFIG
					gameProgress.diary.append(DailyLog(day: gameProgress.day_currrent_game))
					TempView = .Discussion_time
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
	@Binding var TempView: GameView_display_status
	@Binding var num_survivors: Int
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
				TempView = .Night_time
			}
			.myTextBackground()
			.myButtonBounce()
			
			Spacer()
		}
	}
}


struct Discussion_time: View{
	@EnvironmentObject var gameProgress: GameProgress
	@State var discussion_time: Int
	@Binding var TempView: GameView_display_status
	@Binding var num_survivors: Int
	
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
						if TempView != .Discussion_time {
							timer.invalidate()
						}
						
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
				TempView = .Vote_time
			}
			.myTextBackground()
			.myButtonBounce()
		}
	}
}













