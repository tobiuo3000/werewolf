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
			Spacer()
			Button("ゲームスタート") {
				gameStatusData.players_CONFIG = makePlayerList(playersNum: 4)
				gameStatusData.werewolf_Count_CONFIG = tempWerewolfCount
				gameStatusData.seer_Count_CONFIG = tempSeerCount
				gameStatusData.villager_Count_CONFIG = tempPlayerCount - tempWerewolfCount - tempSeerCount
				gameStatusData.discussion_time_CONFIG = tempDiscussionTime
				isAnimated.toggle()
				
				DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) { // 1秒のディレイ
					gameStatusData.game_status = .homeScreen
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
	var body: some View {
		VStack {
			if gameProgress.game_result == 1{
				Text("人狼の勝利")
					.foregroundColor(.white)
			}else if gameProgress.game_result == 2{
				Text("村人陣営の勝利")
					.foregroundColor(.white)
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
		.background(Color.black)
		.navigationBarHidden(true)
	}
}


