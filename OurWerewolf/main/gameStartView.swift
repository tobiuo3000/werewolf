//
//  gameStartView.swift
//  werewolf_ver5
//
//  Created by Masanori Sudo on 2024/11/22.
//

import SwiftUI
import AVFoundation

struct GameStartView: View{
	@EnvironmentObject var gameStatusData: GameStatusData
	@State private var isAnimated = false
	@State var offset: CGFloat = 0
	@State var opacity: CGFloat = 1.0
	private let tempWerewolfCount = 1
	private let tempSeerCount = 0
	private let tempPlayerCount = 4
	private let tempDiscussionTime = 30
	
	var body: some View{
		ZStack{
			Rectangle()
				.foregroundColor(.black)
				.frame(maxHeight: .infinity)
				.ignoresSafeArea()
			
			AudioPlayerView()
			
			if gameStatusData.isAnimeShown == true {
				LoopVideoPlayerView(videoFileName: "Wolf", videoFileType: "mp4")
			}else{
				Image("still_Wolf")
					.resizable()
					.scaledToFill()
					.ignoresSafeArea()
					.frame(width: gameStatusData.fullScreenSize.width,
						   height: gameStatusData.fullScreenSize.height)
					.clipped()
			}
			ScrollView{
			}
			
			VStack {
				Spacer()
				Spacer()
				Button(action: {
					isAnimated.toggle()
					withAnimation(.easeIn(duration: 0.5)) {
						offset = 50
						opacity = 0
					}
					DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) { // 1秒のディレイ
						gameStatusData.game_status = .homeScreen
						isAnimated.toggle()
					}
					
					//AudioServicesPlaySystemSound(1026)
					gameStatusData.buttonSE()
				}, label: {
					Text("ホーム画面へ")
						.fontWeight(.bold)
						.opacity(opacity)
						
				}
				)
				.myTextBackground()
				.myButtonBounce()
				.opacity(opacity)
				.offset(y: offset) // move it down
				
				Spacer()
			}
		}
		.ignoresSafeArea()
	}
}
