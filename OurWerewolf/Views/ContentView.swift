
import SwiftUI

struct ContentView: View {
	@EnvironmentObject var gameStatusData: GameStatusData
	
	var body: some View {
		GeometryReader{ proxy_ContentView in
			VStack{  // closure for .onAppear()
				if gameStatusData.game_status == .titleScreen{
					GameStartView()
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
							LoopVideoPlayerView(videoFileName: "Table", videoFileType: "mp4")
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
						
							GameView()
						
					}
					
				}else if gameStatusData.game_status == .gameOverScreen{
					GameOverView()
				}
			}
			.onAppear{
				gameStatusData.fullScreenSize = proxy_ContentView.size
				gameStatusData.threeOffSetTab = gameStatusData.fullScreenSize.width
				let _ = print("SCREEN SIZE: \(gameStatusData.fullScreenSize)")
			}
		}
	}
}



