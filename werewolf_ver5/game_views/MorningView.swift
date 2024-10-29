//
//  MorningView.swift
//  werewolf_ver5
//
//  Created by Masanori Sudo on 2024/10/28.
//

import SwiftUI


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
					Text("いませんでした！")
					Text("残り人数： \(gameProgress.get_num_survivors())")
				}
			}
			.textFrameDesignProxy()
			
			let tmpSuspectedPlayers = gameProgress.get_list_highest_suspected()
			if let tmpMostSuspectedPlayer = gameProgress.choose_one_random_suspected(highestList: tmpSuspectedPlayers){
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

