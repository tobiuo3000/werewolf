
import SwiftUI

struct ContentView: View {
	@EnvironmentObject var gameStatusData: GameStatusData

	var body: some View {
		GeometryReader{ proxy_ContentView in
				VStack{
					if gameStatusData.game_status == .titleScreen{
						ZStack{
							Rectangle()
								.foregroundColor(.black)
								.frame(maxHeight: .infinity)
								.ignoresSafeArea()
							
							VideoPlayerView(videoFileName: "Wolf", videoFileType: "MOV")
								
							
							/*Image(gameStatusData.currentTheme.titleScreenBackground)
								.resizable()
								.frame(maxHeight: .infinity)
								.ignoresSafeArea()*/
							
							GameStartView()
						}
						.ignoresSafeArea()
					}else if gameStatusData.game_status == .homeScreen{
						BeforeHomeScreen()
					}else if gameStatusData.game_status == .gameScreen{
						ZStack{
							Rectangle()
								.ignoresSafeArea()
								.foregroundColor(.black)
								.frame(width: gameStatusData.fullScreenSize.width,
									   height: gameStatusData.fullScreenSize.height)
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





