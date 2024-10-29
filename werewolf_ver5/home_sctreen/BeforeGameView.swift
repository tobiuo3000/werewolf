import SwiftUI


struct BeforeGameView: View {
	@EnvironmentObject var gameStatusData: GameStatusData
	@EnvironmentObject var gameProgress: GameProgress
	@State private var isAlertShown = false
	@State var showAllText: Bool = false
	@Binding var threeOffSetTab: CGFloat
	@State var isParameterSet: Bool = false
	
	private let columns: [GridItem] = Array(repeating: .init(), count: 2)
	private let cardScale = 0.3
	private let delayBeforeStartingGame = 2.0
	
	var body: some View {
		VStack{
			CardGalleryView(threeOffSetTab: $threeOffSetTab, showAllText: $showAllText)
			
			ZStack{
				HStack{
					Spacer()
					Button("ゲームスタート"){
						isAlertShown = true
					}
					.font(.system(.title2, design: .rounded))
					.fontWeight(.bold)
					.myTextBackground()
					.myButtonBounce()
					.alert("この設定でゲームスタートしますか？", isPresented: $isAlertShown){
						Button("ゲームスタート"){
							initiateGameProgress()
							DispatchQueue.main.asyncAfter(deadline: .now() + delayBeforeStartingGame) {
								gameStatusData.game_status = .gameScreen
								gameProgress.game_start_flag = false
							}
						}
						Button("キャンセル", role: .cancel){
						}
					}
					.uiAnimationRToL(animationFlag: $gameProgress.game_start_flag, delay: 0.3)
					Spacer()
				}
				
				HStack{
					Spacer()
					Button(action: {
						showAllText.toggle()
					}) {
						if showAllText{
							Image(systemName: "rectangle.3.offgrid.bubble.left.fill")
								.font(.title)
						}else{
							Image(systemName: "rectangle.3.offgrid.bubble.left")
						}
						Text("ROLE")
					}
					.myButtonBounce()
					.uiAnimationRToL(animationFlag: $gameProgress.game_start_flag, delay: 0.3)
					Rectangle()
						.fill(.clear)
						.frame(width: 10, height: 10)
				}
			}
			Spacer()
		}
		.onAppear(){
			if isParameterSet == false {
				gameStatusData.calc_vil_count()
				isParameterSet = true
			}
		}
	}
	
	func initiateGameProgress(){
		isParameterSet = false
		gameStatusData.calcDiscussionTime()
		gameProgress.init_gameProgress()
		gameProgress.players = gameStatusData.players_CONFIG.map { $0.copy() as! Player }
		//gameProgress.players = gameStatusData.players_CONFIG  // initiate players property
		gameProgress.discussion_time = gameStatusData.discussion_time_CONFIG
		gameProgress.assignRoles(wolfNum: gameStatusData.werewolf_Count_CONFIG, seerNum: gameStatusData.seer_Count_CONFIG, mediumNum: gameStatusData.medium_Count_CONFIG, hunterNum: gameStatusData.hunter_Count_CONFIG)
		gameProgress.game_start_flag = true
		showAllText = false
	}
}
