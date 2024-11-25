//
//  VoteViews.swift
//  werewolf_ver5
//
//  Created by Masanori Sudo on 2024/10/22.
//


import SwiftUI


struct VoteTime: View {
	@EnvironmentObject var gameStatusData: GameStatusData
	@EnvironmentObject var gameProgress: GameProgress
	@State var player_index: Int = 0
	@State var survivors_index: Int = 0
	@State var voteDone: Bool = false
	@State var isAlertShown: Bool = false
	var survivors_list: [Int]
	let highlightColor: Color = Color(red: 0.8, green: 0.5, blue: 0.6)
	@State var tmpPlayer:Player = Player(player_order: 1000, role: .villager, player_name: "none")
	
	var body: some View {
		VStack{
			Spacer()
			if voteDone == false{
				VStack{
					Text("「\(gameProgress.players[player_index].player_name)」さん")
					Text("人狼だと思う人物を選択してください")
				}
				.textFrameDesignProxy()
				
				FadingScrollView(fadeHeight: 80, content:  {
					ForEach(gameProgress.players.filter {$0.isAlive}) { player in
						ZStack{
							Spacer()  // to expand toutchable space
							
							if (gameProgress.players[player_index].player_order != player.player_order)
							{
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
									if gameStatusData.isVoteCountVisible == true {
										Text(": \(player.voteCount)票")
											.font(.title3)
											.foregroundStyle(.white)
									}
								}
								.padding(12)
							}else{
								HStack{
									ZStack{
										Text(player.player_name)
											.padding(12)
											.background(.white)
											.strikethrough(true, color: .white)  // 横棒を赤色で表示
											.cornerRadius(gameStatusData.currentTheme.cornerRadius)
										Text(player.player_name)
											.foregroundColor(.white)
											.padding(10)
											.background(
												Color(.gray)
											)
											.cornerRadius(gameStatusData.currentTheme.cornerRadius)
									}
									if gameStatusData.isVoteCountVisible == true {
										Text(": \(player.voteCount)票")
											.font(.title3)
											.foregroundStyle(.white)
									}
								}
								.padding(12)
							}
						}
					}
				})
			}else{
				if survivors_index+1 < gameProgress.get_num_survivors(){
					VStack{
						Text("次のプレイヤーに端末を渡してください:")
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
					gameStatusData.buttonSE()
					voteDone = false
					if survivors_index+1 == gameProgress.get_num_survivors(){
						gameProgress.stageView = .Vote_result
					}else{
						survivors_index += 1
						player_index = survivors_list[survivors_index]
						
					}
				}
				.myTextBackground()
				.myButtonBounce()
				.padding()
				
				Rectangle()
					.fill(.clear)
					.frame(width: 40, height: 40)
			}
		}
	}
}


struct RunoffView: View{
	@EnvironmentObject var gameStatusData: GameStatusData
	@EnvironmentObject var gameProgress: GameProgress
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
					Text("決選投票です")
					Text("「\(gameProgress.players[player_index].player_name)」さん")
					Text("人狼だと思う人物を選択してください")
				}
				.textFrameDesignProxy()
				
				FadingScrollView(fadeHeight: 80, content: {
					ForEach(gameProgress.highestVotePlayers) { player in
						if gameProgress.players[player_index].player_order != player.player_order{
							HStack{
								Button(player.player_name) {
									tmpPlayer = player
									isAlertShown = true
								}
								.myTextBackground()
								.alert("\(tmpPlayer.player_name)さんに投票しますか？", isPresented: $isAlertShown){
									Button("投票する"){
										tmpPlayer.voteCount += 1
										voteDone = true
										isAlertShown = false
									}
									Button("キャンセル", role: .cancel){
									}
								}
								if gameStatusData.isVoteCountVisible == true {
									Text(": \(player.voteCount)票")
										.font(.title3)
										.foregroundStyle(.white)
								}
							}
							.padding(12)
						}else{
							HStack{
								ZStack{
									Text(player.player_name)
										.padding(12)
										.background(.white)
										.strikethrough(true, color: .white)  // 横棒を赤色で表示
										.cornerRadius(gameStatusData.currentTheme.cornerRadius)
									Text(player.player_name)
										.foregroundColor(.white)
										.padding(10)
										.background(
											Color(.gray)
										)
										.cornerRadius(gameStatusData.currentTheme.cornerRadius)
								}
								if gameStatusData.isVoteCountVisible == true {
									Text(": \(player.voteCount)票")
										.font(.title3)
										.foregroundStyle(.white)
								}
							}
							.padding(12)
						}
					}
				})
			}else{
				if survivors_index+1 < gameProgress.get_num_survivors(){
					VStack{
						Text("次のプレイヤーに端末を渡してください:")
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
					gameStatusData.buttonSE()
					voteDone = false
					if survivors_index+1 == gameProgress.get_num_survivors(){
						gameProgress.stageView = .RunoffVote_result
					}else{
						survivors_index += 1
						player_index = survivors_list[survivors_index]
						
					}
				}
				.myTextBackground()
				.myButtonBounce()
				.padding()
				
				Rectangle()
					.fill(.clear)
					.frame(width: 40, height: 40)
			}
		}
	}
}


struct RunoffVoteResult: View{
	@EnvironmentObject var gameStatusData: GameStatusData
	@EnvironmentObject var gameProgress: GameProgress
	let highlightColor: Color = Color(red: 0.8, green: 0.5, blue: 0.6)
	
	var body: some View{
		let tmpPlayer = gameProgress.choose_one_random_player(highestList: gameProgress.get_list_highest_vote())!
		if gameProgress.get_list_highest_vote().count == 1{
			VStack{
				VStack{
					Text("最も多くの得票を得たプレイヤーは")
						.foregroundStyle(.white)
					HStack{
						Text("「")
						Text("\(tmpPlayer.player_name)")
							.foregroundStyle(highlightColor)
						Text("」です")
					}
				}
				.textFrameDesignProxy()
				
				HStack{
					Text("「")
					Text("\(tmpPlayer.player_name)")
						.foregroundStyle(highlightColor)
					Text("」は処刑されます")
				}
				.textFrameDesignProxy()
				Spacer()
				Button("次へ") {
					gameProgress.sentence_to_death(suspect_id: tmpPlayer.id)
					gameProgress.get_diary_cur_day().executedPlayer = tmpPlayer
					gameProgress.reset_vote_count()
					gameProgress.game_Result()
					if gameProgress.game_result == 0{
						gameProgress.stageView = .Before_night_time
					}else if gameProgress.game_result == 1{
						gameStatusData.game_status = .gameOverScreen
					}else if gameProgress.game_result == 2{
						gameStatusData.game_status = .gameOverScreen
					}
				}
				.myTextBackground()
				.myButtonBounce()
				.padding()
				
				Rectangle()
					.fill(.clear)
					.frame(width: 40, height: 40)
			}
		}else{  // multiple most voted players
			
			VStack{
				VStack{
					HStack{
						Text("最も多くの得票を得たプレイヤーは")
						Text("\(gameProgress.get_list_highest_vote().count)名")
							.foregroundStyle(highlightColor)
							.font(.title3)
						Text("います")
					}
					Text("\(gameProgress.get_list_highest_vote().count)名の中からランダムで処刑する人物を決めます")
				}
				.textFrameDesignProxy()
				
				Spacer()
				HStack{
					Text("「")
					Text("\(tmpPlayer.player_name)")
						.foregroundStyle(highlightColor)
					Text("」は処刑されます")
				}
				.textFrameDesignProxy()
				Spacer()
				Button("次へ") {
					gameStatusData.buttonSE()
					gameProgress.sentence_to_death(suspect_id: tmpPlayer.id)
					gameProgress.get_diary_cur_day().executedPlayer = tmpPlayer
					gameProgress.reset_vote_count()
					gameProgress.game_Result()
					if gameProgress.game_result == 0{
						gameProgress.stageView = .Before_night_time
					}else if gameProgress.game_result == 1{
						gameStatusData.game_status = .gameOverScreen
					}else if gameProgress.game_result == 2{
						gameStatusData.game_status = .gameOverScreen
					}
				}
				.myTextBackground()
				.myButtonBounce()
				.padding()
				
				Rectangle()
					.fill(.clear)
					.frame(width: 40, height: 40)
			}
		}
	}
}

