
import SwiftUI

struct ContentView: View {
	@EnvironmentObject var gameStatusData: GameStatusData

	var body: some View {
		GeometryReader{ proxy_ContentView in
				VStack{  // closure for .onAppear()
					if gameStatusData.game_status == .titleScreen{
						ZStack{
							Rectangle()
								.foregroundColor(.black)
								.frame(maxHeight: .infinity)
								.ignoresSafeArea()
							
							if gameStatusData.isAnimeShown == true {
								LoopVideoPlayerView(videoFileName: "Wolf", videoFileType: "MOV")
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
							
							/*Image(gameStatusData.currentTheme.titleScreenBackground)
								.resizable()
								.frame(maxHeight: .infinity)
								.ignoresSafeArea()*/
							
							GameStartView()
						}
						.ignoresSafeArea()
					}else if gameStatusData.game_status == .toTitleScreen{
						toTitleView()
					}else if gameStatusData.game_status == .homeScreen{
						BeforeHomeScreen()
					}else if gameStatusData.game_status == .gameScreen{
						ZStack{
							Rectangle()
								.fill(.black)
								.ignoresSafeArea()
							if gameStatusData.isAnimeShown == true {
								LoopVideoPlayerView(videoFileName: "Table", videoFileType: "mov")
							}else{
								Image("still_Table")
									.resizable()
									.scaledToFill()
									.ignoresSafeArea()
									.frame(width: gameStatusData.fullScreenSize.width,
										   height: gameStatusData.fullScreenSize.height)
									.clipped()
							}
							ScrollView{
							}
							/*
							Rectangle()
								.ignoresSafeArea()
								.foregroundColor(.black)
								.frame(width: gameStatusData.fullScreenSize.width,
									   height: gameStatusData.fullScreenSize.height)
							 */
							/*
							Image(gameStatusData.currentTheme.loghouseBackground)
								.resizable()
								.scaledToFit()
								.ignoresSafeArea()
								.frame(width: gameStatusData.fullScreenSize.width,
									   height: gameStatusData.fullScreenSize.height)
								.clipped()
							 */
							GameView()
						}
						
					}else if gameStatusData.game_status == .gameOverScreen{
						GameOverView()
					}
				}
				.onAppear{
					gameStatusData.fullScreenSize = proxy_ContentView.size
					let _ = print(gameStatusData.fullScreenSize)
				}
			}
		}
	}


