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
			Button("ホーム画面へ") {
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
