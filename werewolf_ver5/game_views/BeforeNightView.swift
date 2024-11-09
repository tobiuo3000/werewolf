//
//  BeforeNightView.swift
//  werewolf_ver5
//
//  Created by Masanori Sudo on 2024/10/31.
//

import SwiftUI


struct Before_night_time: View{
	@EnvironmentObject var gameStatusData: GameStatusData
	@EnvironmentObject var gameProgress: GameProgress
	@State var isAlertShown: Bool = false
	let columns: [GridItem] = Array(repeating: .init(.flexible()), count: 2)
	let highlightColor: Color = Color(red: 0.8, green: 0.5, blue: 0.6)
	
	var body: some View{
		VStack {
			
			Spacer()
			VStack{
				Text("夜の時間がやってきます")
				HStack{
					Text("「")
					Text("\(gameProgress.players[gameProgress.get_survivors_list()[0]].player_name)")
						.foregroundStyle(highlightColor)
					Text("」")
				}
				Text("さんに端末を渡してください")
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
			Rectangle()
				.fill(.clear)
				.frame(width: 40, height: 40)
		}
	}
}


