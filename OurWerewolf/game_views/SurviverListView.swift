//
//  SurviverListView.swift
//  werewolf_ver5
//
//  Created by Masanori Sudo on 2024/12/09.
//

import SwiftUI


struct ListSurviversView: View{
	@EnvironmentObject var gameStatusData: GameStatusData
	@EnvironmentObject var gameProgress: GameProgress
	
	var body: some View{
		VStack{
			Text("プレイヤー情報")
		}
		.font(.title2)
		.textFrameDesignProxy()
		
		FadingScrollView(fadeHeight: 50){
			ForEach(0..<gameProgress.players.count, id: \.self) { index in
				if gameProgress.players[index].isAlive == true{
					HStack{
						Text("\(gameProgress.players[index].player_name): ")
							.foregroundStyle(.white)
						Text("生存")
					}
					.padding(16)
				}else{
					HStack{
						Text("\(gameProgress.players[index].player_name): ")
							.foregroundColor(Color(red: 0.3, green: 0.3, blue: 0.3))
							.strikethrough(true, color: Color(red: 0.6, green: 0.6, blue: 0.6))
						Text("死亡")
							.foregroundStyle(gameStatusData.highlightColor)
					}
					.padding(16)
				}
			}
		}
		.textFrameDesignProxy()

	}
}

