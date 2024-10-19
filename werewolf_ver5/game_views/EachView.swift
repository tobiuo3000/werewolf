import SwiftUI

struct GameStartView: View{
	@EnvironmentObject var gameStatusData: GameStatusData
	@State private var isAnimated = false
	
	private let tempWerewolfCount = 1
	private let tempSeerCount = 0
	private let tempPlayerCount = 4
	private let tempDiscussionTime = 30
	
	
	var body: some View{
		VStack {
			/*
			 HStack{
			 Spacer()
			 Image("temp_title_logo")
			 .resizable()
			 .aspectRatio(contentMode: .fit)
			 .frame(width: gameStatusData.fullScreenSize.width/4)
			 .opacity(isAnimated ? -1 : 1) // フェードアウト効果
			 .offset(y: isAnimated ? -200 : 0) // 上に移動
			 .animation(.easeInOut(duration: 0.7), value: isAnimated) // アニメーション適用
			 }
			 */
			Spacer()
			Spacer()
			Button("ゲームスタート") {
				isAnimated.toggle()
				
				DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) { // 1秒のディレイ
					gameStatusData.game_status = .homeScreen
					isAnimated.toggle()
				}
			}
			.myTextBackground()
			.myButtonBounce()
			.opacity(isAnimated ? -1 : 1) // フェードアウト効果
			.offset(y: isAnimated ? 200 : 0) // 上に移動
			.animation(.easeInOut(duration: 0.7), value: isAnimated) // アニメーション適用
			
			Spacer()
		}
	}
}




struct GameOverView: View {
	@EnvironmentObject var gameStatusData: GameStatusData
	@EnvironmentObject var gameProgress: GameProgress
	@State var opacity: CGFloat = 1.0
	var body: some View {
		if gameProgress.game_result == 1{
			ZStack{
				Image("wolf_Win")
					.resizable()
					.ignoresSafeArea()
					.scaledToFill()
				VStack{
					Text("人狼の勝利")
						.font(.title)
						.foregroundColor(.white)
					
					Button("改めてゲームスタート") {
						gameProgress.init_player()
						gameStatusData.game_status = .homeScreen
					}
					.foregroundColor(.white)
					.padding()
					.background(Color.blue)
					.cornerRadius(10)
					
				}
				.frame(maxWidth: .infinity, maxHeight: .infinity)
				.navigationBarHidden(true)
				
			}
			.opacity(opacity)
		}else if gameProgress.game_result == 2{
			ZStack{
				Image("villager_Win")
					.resizable()
					.ignoresSafeArea()
					.scaledToFill()
				VStack{
					ZStack{
						Text("村人陣営の勝利")
							.font(.title)
							.foregroundColor(.white)
							.padding(10)
							.background(.black.opacity(0.1))
							.cornerRadius(14)
					}
					Button("改めてゲームスタート") {
						gameProgress.init_player()
						gameStatusData.game_status = .homeScreen
					}
					.foregroundColor(.white)
					.padding()
					.background(Color.blue)
					.cornerRadius(10)
					
				}
				.frame(maxWidth: .infinity, maxHeight: .infinity)
				.navigationBarHidden(true)
			}
			.opacity(opacity)
		}
	}
}


struct toTitleView: View{
	@EnvironmentObject var gameStatusData: GameStatusData
	private let delay: Double = 1.4
	
	var body: some View{
		TransitionLoopBackGround(offset: CGSize(width: 0,
												height: 0))
		.onAppear(){
			DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
				gameStatusData.game_status = .titleScreen
			}
		}
	}
}
