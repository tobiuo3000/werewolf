import SwiftUI


struct BeforeGameView: View {
	@EnvironmentObject var gameStatusData: GameStatusData
	@EnvironmentObject var gameProgress: GameProgress
	@State private var isAlertShown = false
	@Binding var beforeGameViewOffset: CGFloat
	@Binding var gameStartFlag: Bool
	@State var showAllText: Bool = false
	
	private let columns: [GridItem] = Array(repeating: .init(), count: 2)
	private let cardScale = 0.3
	private let delayBeforeStartingGame = 2.0
	
	var body: some View {
		VStack{
			CardGalleryView(beforeGameViewOffset: $beforeGameViewOffset, showAllText: $showAllText, gameStartFlag: $gameStartFlag)

			HStack{
				Spacer()
				Button(action: {
					showAllText.toggle()
				}) {
					Text("文章を表示")
					Image(systemName: "arrow.triangle.2.circlepath.circle")
				}
				.textFrameSimple()
				.myButtonBounce()
			}
			.uiAnimationRToL(animationFlag: $gameStartFlag, delay: 0.2)
			
			Button("ゲームスタート"){
				isAlertShown = true
			}
			.myTextBackground()
			.myButtonBounce()
			.alert("この設定でゲームスタートしますか？", isPresented: $isAlertShown){
				Button("ゲームスタート"){
					gameProgress.players = gameStatusData.players_CONFIG
					gameProgress.assignRoles(wolfNum: gameStatusData.werewolf_Count_CONFIG, seerNum: gameStatusData.seer_Count_CONFIG)
					gameStartFlag = true
					showAllText = false
					DispatchQueue.main.asyncAfter(deadline: .now() + delayBeforeStartingGame) {
						gameStatusData.game_status = .gameScreen
						gameStartFlag = false
					}
				}
				Button("キャンセル", role: .cancel){
				}
			}
			.uiAnimationRToL(animationFlag: $gameStartFlag, delay: 0.3)
			
			Spacer()
		}
	}
}
