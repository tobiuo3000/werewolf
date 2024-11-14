import SwiftUI


struct GameSettingView: View{
	@EnvironmentObject var gameStatusData: GameStatusData
	@State var isAlertShown = false
	@Binding var isReorderingViewShown: Bool
	let highlightColor: Color = Color(red: 0.8, green: 0.5, blue: 0.6)
	//private let secondsRange: [Int] = Array(0..<60)
	//private let minutesRange: [Int] = Array(0..<60)
	
	init(isReorderingViewShown: Binding<Bool>){
		UIStepper.appearance().setDecrementImage(UIImage(systemName: "minus"), for: .normal)
		UIStepper.appearance().setIncrementImage(UIImage(systemName: "plus"), for: .normal)
		//@Binding var GamseSettingViewOffset: CGFloat
		self._isReorderingViewShown = isReorderingViewShown
	}
	
	var body: some View {
		ZStack{
			Image(gameStatusData.currentTheme.textBackgroundImage)  // BACKGROUND SHEEPSKIN
				.resizable()
				.frame(maxWidth: .infinity, maxHeight:.infinity)
				.allowsHitTesting(false)
			
			FadingScrollView(fadeHeight: 30){
				Text("ゲームルール設定")
					.font(.system(.largeTitle, design: .serif))
					.fontWeight(.bold)
					.foregroundStyle(.black)
					.padding()
				
				
				VStack{
					VStack{
						VStack{
							VStack(alignment: .leading){
								ZStack{
									HStack {
										Text("参加プレイヤー数:")
											.font(.title)
										Spacer()
										Text("\(gameStatusData.players_CONFIG.count)人")
											.font(.title)
											.foregroundStyle(highlightColor)
										Spacer()
										Spacer()
										Spacer()
									}
									HStack{
										Spacer()
										Button(action: {
											isReorderingViewShown = true
										}) {
											Image(systemName: "rectangle.and.pencil.and.ellipsis.rtl")
												.font(.largeTitle)
												.foregroundColor(.blue)
										}
										.myButtonBounce()
										.bouncingUI(interval: 3)
										.padding()
									}
								}
							}
							.onChange(of: gameStatusData.players_CONFIG.count) { _ in
								gameStatusData.update_role_CONFIG()
							}
						}
						
						if gameStatusData.num_player_with_role > gameStatusData.players_CONFIG.count{
							Text("※役職人数を減らしてください")
								.lineLimit(nil)
								.foregroundStyle(highlightColor)
								.font(.title)
						}else{
							Text(" ")
								.font(.title)
						}
					}
					
					Text("〜〜村人陣営〜〜")
						.font(.system(.title, design: .serif))
					Text(" ")
					
					ZStack{
						HStack{
							Text("村人の数:")
							Spacer()
						}
						Text("\(gameStatusData.villager_Count_CONFIG)人")
							.foregroundStyle(highlightColor)
							.font(.title)
					}
					
					ZStack{
						HStack{
							Text("見習い占の数:")
							Spacer()
							RoleStepper(value: $gameStatusData.trainee_Count_CONFIG, lowerBound: 0, upperBound:  gameStatusData.max_trainee_CONFIG)
								.onChange(of: gameStatusData.trainee_Count_CONFIG) { _ in
									gameStatusData.update_role_CONFIG()
								}
						}
						Text("\(gameStatusData.trainee_Count_CONFIG)人")
							.foregroundStyle(highlightColor)
							.font(.title)
					}
					
					ZStack{
						HStack{
							Text("占い師の数:")
							Spacer()
							RoleStepper(value: $gameStatusData.seer_Count_CONFIG, lowerBound: 0, upperBound: 1)
								.onChange(of: gameStatusData.seer_Count_CONFIG) { _ in
									gameStatusData.update_role_CONFIG()
								}
						}
						Text("\(gameStatusData.seer_Count_CONFIG)人")
							.foregroundStyle(highlightColor)
							.font(.title)
					}
					
					ZStack{
						HStack{
							Text("霊媒師の数:")
							Spacer()
							RoleStepper(value: $gameStatusData.medium_Count_CONFIG, lowerBound: 0, upperBound: 1)
								.onChange(of: gameStatusData.medium_Count_CONFIG) { _ in
									gameStatusData.update_role_CONFIG()
								}
						}
						Text("\(gameStatusData.medium_Count_CONFIG)人")
							.foregroundStyle(highlightColor)
							.font(.title)
					}
					
					ZStack{
						HStack{
							Text("狩人の数:")
							Spacer()
							RoleStepper(value: $gameStatusData.hunter_Count_CONFIG, lowerBound: 0, upperBound: 1)
								.onChange(of: gameStatusData.hunter_Count_CONFIG) { _ in
									gameStatusData.update_role_CONFIG()
								}
						}
						Text("\(gameStatusData.hunter_Count_CONFIG)人")
							.foregroundStyle(highlightColor)
							.font(.title)
					}
					
					Text(" ")
						.font(.title2)
					Text("〜〜人狼陣営〜〜")
						.font(.system(.title, design: .serif))
					
					
					ZStack{
						HStack{
							Text("人狼の数:")
							Spacer()
							RoleStepper(value: $gameStatusData.werewolf_Count_CONFIG, lowerBound: 1, upperBound:  gameStatusData.max_werewolf_CONFIG)
								.onChange(of: gameStatusData.werewolf_Count_CONFIG) { _ in
									gameStatusData.update_role_CONFIG()
								}
						}
						Text("\(gameStatusData.werewolf_Count_CONFIG)人")
							.foregroundStyle(highlightColor)
							.font(.title)
					}
					
					ZStack{
						HStack{
							Text("狂人の数:")
							Spacer()
							RoleStepper(value: $gameStatusData.madman_Count_CONFIG, lowerBound: 0, upperBound: 1)
								.onChange(of: gameStatusData.madman_Count_CONFIG) { _ in
									gameStatusData.update_role_CONFIG()
								}
						}
						Text("\(gameStatusData.madman_Count_CONFIG)人")
							.foregroundStyle(highlightColor)
							.font(.title)
					}
				}
				.textFrameDesignProxy()
				
				
				Rectangle()
					.fill(.clear)
					.frame(width: 10, height: 10)
				Text("その他ゲーム設定")
					.font(.system(.largeTitle, design: .serif))
					.fontWeight(.bold)
					.foregroundStyle(.black)
					.padding()
				
				VStack{
					HStack{
						Text("ゲーム内議論時間: ")
							.font(.title2)
						Text("\(gameStatusData.discussion_minutes_CONFIG)分 \(gameStatusData.discussion_seconds_CONFIG)秒")
							.foregroundStyle(highlightColor)
							.font(.title)
						Spacer()
					}
					let minutes_range = 1...59
					let seconds_range = 0...50
					
					VStack{
						Stepper("minutes(分):", value: $gameStatusData.discussion_minutes_CONFIG, in: minutes_range)
							.pickerStyle(SegmentedPickerStyle())
							.accentColor(.white)
							.onChange(of: gameStatusData.werewolf_Count_CONFIG) { _ in
								gameStatusData.update_role_CONFIG()
								gameStatusData.calcDiscussionTime()
							}
						
						Stepper("seconds(秒):", value: $gameStatusData.discussion_seconds_CONFIG, in: seconds_range, step: 10)
							.pickerStyle(SegmentedPickerStyle())
							.accentColor(.white)
							.onChange(of: gameStatusData.werewolf_Count_CONFIG) { _ in
								gameStatusData.update_role_CONFIG()
								gameStatusData.calcDiscussionTime()
							}
					}
				}
				.textFrameDesignProxy()
				
				Text(" ")
					.font(.title)
				
				VStack{
					HStack{
						VStack(alignment: .leading){
							Text("「見習い占」")
							Text("占い成功確率")
						}
						Text("：")
							.font(.title)
						Spacer()
						Text("\(gameStatusData.trainee_Probability)％")
							.foregroundStyle(highlightColor)
							.font(.title)
						Spacer()
						RoleStepper(value: $gameStatusData.trainee_Probability, lowerBound: 55, upperBound: 100, step: 5, isIndependentDisable: true)
							.onChange(of: gameStatusData.trainee_Probability) { _ in
								gameStatusData.update_role_CONFIG()
							}
					}
					
					
					Toggle(isOn: $gameStatusData.isFirstNightRandomSeer) {
						Text("占い師(見習い占いを含まない)の初日ランダム白(村人)占いを有効にする")
							.font(.title3)
							.foregroundColor(.white)
					}
					.padding()
					
					Toggle(isOn: $gameStatusData.isVoteCountVisible) {
						Text("投票中に得票数が見えるようにする")
							.font(.title3)
							.foregroundColor(.white)
					}
					.padding()
					
					Toggle(isOn: $gameStatusData.isConsecutiveProtectionAllowed) {
						Text("狩人の同一人物連続ガードを有効にする")
							.font(.title3)
							.foregroundColor(.white)
					}
					.padding()
					
					Toggle(isOn: $gameStatusData.requiresRunoffVote) {
						Text("処刑投票で同票の場合に決選投票をする")
							.font(.title3)
							.foregroundColor(.white)
					}
					.padding()
				}
				.textFrameDesignProxy()
			}
				// print($0)  : print coordinates
		}
	}
}


