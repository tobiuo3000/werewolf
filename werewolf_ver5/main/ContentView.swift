
import SwiftUI

struct ContentView: View {
	@EnvironmentObject var gameStatusData: GameStatusData

	var body: some View {
		GeometryReader{ proxy_ContentView in
				//VideoPlayerView(videoFileName: "sample_video", videoFileType: "mp4")
				//			.frame(width: 300)
				VStack(spacing:0){
					if gameStatusData.game_status == .titleScreen{
						ZStack{
							Image(gameStatusData.currentTheme.titleScreenBackground)
								.resizable()
								.frame(maxHeight: .infinity)
								.ignoresSafeArea()
							GameStartView()
						}
					}else if gameStatusData.game_status == .homeScreen{
						BeforeHomeScreen()
					}else if gameStatusData.game_status == .gameScreen{
						ZStack{
							Image(gameStatusData.currentTheme.loghouseBackground)
								.resizable()
								.frame(maxHeight: .infinity)
								.ignoresSafeArea()
							
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





