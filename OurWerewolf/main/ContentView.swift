
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
							VStack{
								GameView()
								
								if proxy_ContentView.safeAreaInsets.bottom > 0 {  // te
									Rectangle()
										.fill(.black)
										.frame(width: .infinity, height: 34)
								}
							}
							.ignoresSafeArea(edges: [.bottom])
							
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
			}, label: {
				Text("ホーム画面へ")
					.fontWeight(.bold)
					.opacity(opacity)
			}
				   )
			.buttonSEModifier(soundFlag: isAnimated)
			.myTextBackground()
			.myButtonBounce()
			.opacity(opacity)
			.offset(y: offset) // move it down
			
			Spacer()
		}
	}
}

