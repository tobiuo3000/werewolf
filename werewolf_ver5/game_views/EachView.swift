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
	@State var opacity_color: CGFloat = 1.0
	@State var opacity_text: CGFloat = 1.0
	@State var opacity_button: CGFloat = 1.0
	var winColor: Color = Color(red: 1.0, green: 1.0, blue: 0.9)
	var loseColor: Color = Color(red: 0.15, green: 0.1, blue: 0.15)
	var body: some View {
		VStack{
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
							.opacity(opacity_text)
						
						Button("改めてゲームスタート") {
							gameProgress.init_player()
							gameStatusData.game_status = .homeScreen
						}
						.foregroundColor(.white)
						.padding()
						.background(Color.blue)
						.cornerRadius(10)
						.opacity(opacity_button)
						
					}
					.frame(maxWidth: .infinity, maxHeight: .infinity)
					.navigationBarHidden(true)
					
					Rectangle()
						.fill(loseColor)
						.frame(width: .infinity,
							   height: .infinity)
						.ignoresSafeArea()
						.opacity(opacity_color)
					
				}
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
								.opacity(opacity_text)
						}
						Button("改めてゲームスタート") {
							gameProgress.init_player()
							gameStatusData.game_status = .homeScreen
						}
						.foregroundColor(winColor)
						.padding()
						.background(Color.blue)
						.cornerRadius(10)
						.opacity(opacity_button)
						
					}
					.frame(maxWidth: .infinity, maxHeight: .infinity)
					.navigationBarHidden(true)
					
					Rectangle()
						.fill(.white)
						.frame(maxWidth: .infinity,
							   maxHeight: .infinity)
						.ignoresSafeArea()
						.opacity(opacity_color)
				}
			}
		}
		.onAppear(){
			DispatchQueue.main.asyncAfter(deadline: .now()) {
				withAnimation(.easeInOut(duration: 4)) {
					opacity_color = 0
				}
			}
			DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
				withAnimation(.easeInOut(duration: 2)) {
					opacity_text = 1.0
				}
			}
			DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
				withAnimation(.easeInOut(duration: 2)) {
					opacity_button = 1.0
				}
			}
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
