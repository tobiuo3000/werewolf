import SwiftUI


struct BeforeGameView: View {
	@EnvironmentObject var gameStatusData: GameStatusData
	@EnvironmentObject var gameProgress: GameProgress
	@State private var isAlertShown = false
	@State var showAllText: Bool = false
	@State var blackOpacity: Double = 0
	@Binding var threeOffSetTab: CGFloat
	@State var isParameterSet: Bool = false
	
	private let columns: [GridItem] = Array(repeating: .init(), count: 2)
	private let cardScale = 0.3
	private let delayBeforeStartingGame = 2.0
	let highlightColor: Color = Color(red: 0.8, green: 0.5, blue: 0.6)
	
	var body: some View {
		ZStack{
			Color.black
				.opacity(blackOpacity)
			
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
							HStack(spacing:1){
								if showAllText{
									Image(systemName: "rectangle.3.offgrid.bubble.left.fill")
								}else{
									Image(systemName: "rectangle.3.offgrid.bubble.left")
								}
								Text("ROLE")
							}
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
					gameStatusData.calc_roles_count()
					isParameterSet = true
				}
			}
			.disabled(gameStatusData.villager_Count_CONFIG < 0)
			
			if gameStatusData.villager_Count_CONFIG < 0{
				ZStack{
					Color.black.opacity(0.3)
					VStack{
						Text("※役職人数が")
						Text("プレイヤー数を超えています")
					}
					.font(.title)
					.foregroundColor(highlightColor)
					.background(){
						Color.white.frame(width: gameStatusData.fullScreenSize.width-20, height: 100)
							.cornerRadius(14)
					}
				}
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
		gameProgress.assignRoles(wolfNum: gameStatusData.werewolf_Count_CONFIG, traineeNum: gameStatusData.trainee_Count_CONFIG, seerNum: gameStatusData.seer_Count_CONFIG, mediumNum: gameStatusData.medium_Count_CONFIG, hunterNum: gameStatusData.hunter_Count_CONFIG, madmanNum: gameStatusData.madman_Count_CONFIG)
		gameProgress.game_start_flag = true
		showAllText = false
	}
}
