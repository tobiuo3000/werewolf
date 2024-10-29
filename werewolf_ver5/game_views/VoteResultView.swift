//
//  VoteResultView.swift
//  werewolf_ver5
//
//  Created by Masanori Sudo on 2024/10/22.
//

import SwiftUI


struct VoteResult: View{
	@EnvironmentObject var gameStatusData: GameStatusData
	@EnvironmentObject var gameProgress: GameProgress
	let highlightColor: Color = Color(red: 0.8, green: 0.5, blue: 0.6)
	
	var body: some View{
		let randomlySelectedPlayer = gameProgress.choose_one_random_player(highestList: gameProgress.get_list_highest_vote())!
		
		if gameProgress.get_list_highest_vote().count == 1{
			VStack{
				Spacer()
				VStack{
					Text("最も多くの得票を得た")
						.foregroundStyle(.white)
					Text("処刑されるプレイヤーは")
						.foregroundStyle(.white)
					HStack{
						Text("「")
						Text("\(randomlySelectedPlayer.player_name)")
							.foregroundStyle(highlightColor)
						Text("」です")
					}
				}
				.font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
				.textFrameDesignProxy()
				
				Spacer()
				Button("次へ") {
					gameProgress.sentence_to_death(suspect_id: randomlySelectedPlayer.id)
					gameProgress.get_diary_cur_day().executedPlayer = randomlySelectedPlayer
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
			}
		}else{  // multiple most voted players
			if gameStatusData.requiresRunoffVote{
				BeforeRunoffVoteView()
			}else{
				RandomExecutionView(randomlySelectedPlayer: randomlySelectedPlayer)
			}
		}
	}
}


struct BeforeRunoffVoteView: View {
	@EnvironmentObject var gameStatusData: GameStatusData
	@EnvironmentObject var gameProgress: GameProgress
	let highlightColor: Color = Color(red: 0.8, green: 0.5, blue: 0.6)
	
	var body: some View {
		if gameStatusData.requiresRunoffVote{
			VStack{
				VStack{
					HStack{
						Text("最も多くの得票を得たプレイヤーは")
						Text("\(gameProgress.get_list_highest_vote().count)名")
							.foregroundStyle(highlightColor)
							.font(.title3)
						Text("います")
					}
					Text("これから決選投票を行います")
				}
				.textFrameDesignProxy()
				
				VStack{
					ForEach(gameProgress.get_list_highest_vote()){ player in
						Text("\(player.player_name)")
					}
				}
				.textFrameDesignProxy()
				
				Spacer()
				Button("次へ") {
					gameProgress.highestVotePlayers = gameProgress.get_list_highest_vote()
					gameProgress.reset_vote_count()
					gameProgress.stageView = .Runoff_Vote
				}
				.myTextBackground()
				.myButtonBounce()
				.padding()
			}
		}
	}
}

struct RandomExecutionView: View{
	@EnvironmentObject var gameStatusData: GameStatusData
	@EnvironmentObject var gameProgress: GameProgress
	let highlightColor: Color = Color(red: 0.8, green: 0.5, blue: 0.6)
	var randomlySelectedPlayer: Player
	
	var body: some View{
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
			VStack{
				ForEach(gameProgress.get_list_highest_vote()){ player in
					Text("\(player.player_name)")
				}
			}
			.textFrameDesignProxy()
			
			HStack{
				Text("「")
				Text("\(randomlySelectedPlayer.player_name)")
					.foregroundStyle(highlightColor)
				Text("」は処刑されます")
			}
			.textFrameDesignProxy()
			
			Spacer()
			Button("次へ") {
				gameProgress.sentence_to_death(suspect_id: randomlySelectedPlayer.id)
				gameProgress.get_diary_cur_day().executedPlayer = randomlySelectedPlayer
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
		}
	}
}
