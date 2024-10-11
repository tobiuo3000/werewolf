import SwiftUI


struct GameSettingView: View{
	@EnvironmentObject var gameStatusData: GameStatusData
	@State var isAlertShown = false
	@State var maxWerewolf: Int = 1
	private let minPlayer = 4
	private let maxPlayer = 2
	//private let secondsRange: [Int] = Array(0..<60)
	//private let minutesRange: [Int] = Array(0..<60)
	
	init(){
		UIStepper.appearance().setDecrementImage(UIImage(systemName: "minus"), for: .normal)
		UIStepper.appearance().setIncrementImage(UIImage(systemName: "plus"), for: .normal)
		//@Binding var GamseSettingViewOffset: CGFloat
	}
	
	
	var body: some View {
		ZStack{
			Image(gameStatusData.currentTheme.textBackgroundImage)  // BACKGROUND SHEEPSKIN
				.resizable()
				.frame(maxWidth: .infinity, maxHeight:.infinity)
				.allowsHitTesting(false)
			
			ScrollView(.vertical){
				VStack{
					HStack{
						Spacer()
						Text("プレイヤー人数: \(gameStatusData.players_CONFIG.count)人")
						Button(action: {
							gameStatusData.players_CONFIG.append(Player(player_order: gameStatusData.players_CONFIG.count, role: .villager, player_name: "プレイヤー\(gameStatusData.players_CONFIG.count)"))
							maxWerewolf = gameStatusData.players_CONFIG.count / 2
						}) {
							Image(systemName: "plus.circle")
								.frame(width: 30, height: 30)
						}
						.myButtonBounce()
						Spacer()
					}
					
					ForEach(gameStatusData.players_CONFIG.indices, id: \.self) { index in
						TextField("", text: $gameStatusData.players_CONFIG[index].player_name)
							.textFieldStyle(RoundedBorderTextFieldStyle())
							.autocorrectionDisabled()
							.padding()
					}
					.onChange(of: gameStatusData.players_CONFIG.count) { _ in
						setConfig()
					}
				}
				.textFrameDesignProxy()
				
				
				
				VStack{
					Text("議論時間  ※ゲーム内でも調整できます")
					
					
					HStack{
						WheelPickerView(selection: $gameStatusData.discussion_minutes_CONFIG, textArg: "分")
							.frame(height: 60) // 高さを調整して内容が見やすくする
						WheelPickerView(selection: $gameStatusData.discussion_seconds_CONFIG, textArg: "秒")
							.frame(height: 60) // 高さを調整して内容が見やすくする
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
				
				Stepper("霊媒師の数: \(gameStatusData.medium_Count_CONFIG)", value: $gameStatusData.medium_Count_CONFIG, in: 0...1)
					.pickerStyle(SegmentedPickerStyle())
					.textFrameDesignProxy()
					.accentColor(.white)
					.onChange(of: gameStatusData.seer_Count_CONFIG) { _ in
						setConfig()
					}
				
				Stepper("騎士の数: \(gameStatusData.hunter_Count_CONFIG)", value: $gameStatusData.hunter_Count_CONFIG, in: 0...1)
					.pickerStyle(SegmentedPickerStyle())
					.textFrameDesignProxy()
					.accentColor(.white)
					.onChange(of: gameStatusData.hunter_Count_CONFIG) { _ in
						setConfig()
					}
				
			}
		}
	}
	
	func setConfig(){
		gameStatusData.villager_Count_CONFIG = gameStatusData.players_CONFIG.count -  gameStatusData.werewolf_Count_CONFIG - gameStatusData.seer_Count_CONFIG - gameStatusData.hunter_Count_CONFIG
		//gameStatusData.discussion_time_CONFIG = selectedTime.minutes * 60 + selectedTime.seconds
	}
}



struct WheelPickerView: UIViewRepresentable {
	@Binding private var selection: Int
	private let content: [Int] = Array(0...59)
	private let textTimeUnit: String
	
	init(selection: Binding<Int>, textArg: String) {
		self._selection = selection
		self.textTimeUnit = textArg
	}
	
	func makeUIView(context: Context) -> UIPickerView {
		let picker = UIPickerView(frame: .zero)
		picker.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
		picker.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
		
		picker.dataSource = context.coordinator
		picker.delegate = context.coordinator
		
		return picker
	}
	
	func updateUIView(_ picker: UIPickerView, context: Context) {
		picker.selectRow(selection, inComponent: 0, animated: true)
	}
	
	func makeCoordinator() -> Coordinator {
		return Coordinator(self)
	}
	
	class Coordinator: NSObject, UIPickerViewDataSource, UIPickerViewDelegate {
		private var wheelPickerView: WheelPickerView
		
		init(_ wheelPickerView: WheelPickerView) {
			self.wheelPickerView = wheelPickerView
		}
		
		func numberOfComponents(in pickerView: UIPickerView) -> Int {
			return 1
		}
		
		func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
			return wheelPickerView.content.count
		}
		
		private func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> Int? {
			return wheelPickerView.content[row]
		}
		
		func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
			wheelPickerView.selection = row
		}
		
		func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
			let label = (view as? UILabel) ?? UILabel()
			label.text = "\(String(wheelPickerView.content[row])) \(String(wheelPickerView.textTimeUnit))"
			label.textAlignment = .center
			label.adjustsFontSizeToFitWidth = true
			label.font = UIFont.systemFont(ofSize: 20)  // define font size
			label.textColor = .white  // define text color
			return label
		}
	}
}
