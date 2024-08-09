import SwiftUI

struct GameSettingView: View{
	@EnvironmentObject var gameStatusData: GameStatusData
	@State var isAlertShown = false
	@State var selectedMinutes: Int = 0
	@State var selectedSeconds: Int = 0
	@State var maxWerewolf: Int = 1
	private let minPlayer = 4
	private let maxPlayer = 2
	
	private let secondsRange:[Int] = Array(0..<60)
	private let minutesRange: [Int] = Array(0..<60)
	
	
	
	
	init(){
		UIStepper.appearance().setDecrementImage(UIImage(systemName: "minus"), for: .normal)
		UIStepper.appearance().setIncrementImage(UIImage(systemName: "plus"), for: .normal)
		//@Binding var GamseSettingViewOffset: CGFloat
	}
	
	func setConfig(){
		gameStatusData.villager_Count_CONFIG = gameStatusData.players_CONFIG.count -  gameStatusData.werewolf_Count_CONFIG - gameStatusData.seer_Count_CONFIG
		gameStatusData.discussion_time_CONFIG = selectedMinutes * 60 + selectedSeconds
	}
	
	var body: some View {
		ZStack{
			Image(gameStatusData.currentTheme.textBackgroundImage)  // BACKGROUND SHEEPSKIN
				.resizable()
				.frame(maxWidth: .infinity, maxHeight:.infinity)
				.allowsHitTesting(false)
			
			ScrollView{
				VStack {
					
					HStack{
						Text("プレイヤー人数: \(gameStatusData.players_CONFIG.count)人")
							.textFrameDesignProxy()
							
						Button(action: {
							gameStatusData.players_CONFIG.append(Player(player_order: gameStatusData.players_CONFIG.count, role: .villager, player_name: "プレイヤー\(gameStatusData.players_CONFIG.count)"))
							maxWerewolf = gameStatusData.players_CONFIG.count / 2
						}) {
							Image(systemName: "plus.circle")
								.frame(width: 30, height: 30)
						}
						.textFrameSimple()
						.myButtonBounce()
					}

						ForEach(0..<gameStatusData.players_CONFIG.count, id: \.self) { index in
							TextField("", text: $gameStatusData.players_CONFIG[index].player_name)
								.textFieldStyle(RoundedBorderTextFieldStyle())
								.padding()
						}
						.onChange(of: gameStatusData.players_CONFIG.count) { _ in
							setConfig()
						}
					
					VStack{
						Text("議論時間  ※ゲーム内でも調整できます")
							.padding()
						
						HStack(spacing: 30) {
							Picker("minutes", selection: $selectedMinutes) {
								ForEach(minutesRange, id: \.self) { minute in
									Text("\(minute) 分")
										
								}
							}
							.pickerStyle(WheelPickerStyle()) // スクロール可能なホイールスタイル
							.frame(height: 60) // 高さを調整して内容が見やすくする
							.onChange(of: selectedMinutes){ newValue1 in
								print("選択された分: \(newValue1)")
								setConfig()
							}

							
							Picker("seconds", selection: $selectedSeconds) {
								ForEach(secondsRange, id: \.self) { second in
									Text("\(second) 秒")
										
								}
							}
							.pickerStyle(WheelPickerStyle()) // スクロール可能なホイールスタイル
							.frame(height: 60) // 高さを調整して内容が見やすくする
							.onChange(of: selectedSeconds){ newValue2 in
								print("選択された分: \(newValue2)")
								setConfig()
							}
						}
					}
					.textFrameDesignProxy()
					
					Stepper("人狼の数: \(gameStatusData.werewolf_Count_CONFIG)", value: $gameStatusData.werewolf_Count_CONFIG, in: 1...maxWerewolf)
						.pickerStyle(SegmentedPickerStyle())
						.textFrameDesignProxy()
						.accentColor(.white)
						.onChange(of: gameStatusData.werewolf_Count_CONFIG) { _ in
							setConfig()
						}
					
					
					Stepper("占い師の数: \(gameStatusData.seer_Count_CONFIG)", value: $gameStatusData.seer_Count_CONFIG, in: 0...1)
						.pickerStyle(SegmentedPickerStyle())
						.textFrameDesignProxy()
						.accentColor(.white)
						.onChange(of: gameStatusData.seer_Count_CONFIG) { _ in
							setConfig()
						}
				}
			}
			
		}
	}
}

