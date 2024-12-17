//
//  BeforeHomeScreenView.swift
//  werewolf_ver5
//
//  Created by Masanori Sudo on 2024/12/17.
//

import SwiftUI


struct BeforeHomeScreen: View {
	@EnvironmentObject var gameStatusData: GameStatusData
	@State var isAnimeDone: Bool = false
	private let delay: Double = 1.4
	
	var body: some View {
		ZStack {
			if isAnimeDone == false{
				TransitionLoopBackGround(offset: CGSize(width: 0,
														height: 0))
				.onAppear(){
					DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
						isAnimeDone = true
					}
				}
			}else{
				ZStack{
					Rectangle()
						.foregroundColor(.black)
						.ignoresSafeArea()
					if gameStatusData.isAnimeShown == true {
						LoopVideoPlayerView(videoFileName: "Loghouse", videoFileType: "mp4")
					}else{
						Image("still_House")
							.resizable()
							.scaledToFill()
							.ignoresSafeArea()
							.frame(width: gameStatusData.fullScreenSize.width,
								   height: gameStatusData.fullScreenSize.height)
							.clipped()
					}
					ScrollView{
					}
					
					HomeScreenView(offsetTab0: -gameStatusData.fullScreenSize.width,
								   offsetTab2: gameStatusData.fullScreenSize.width,
								   thresholdIcon: gameStatusData.fullScreenSize.width/6)
				}
			}
		}
	}
}

