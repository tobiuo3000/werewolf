import SwiftUI

struct IntervalSet {
	var minutes: Int = 0
	var seconds: Int = 0
}

struct GameSettingView: View{
	@EnvironmentObject var gameStatusData: GameStatusData
	@State var isAlertShown = false
	@State var selectedTime = IntervalSet()
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
				
				ForEach(gameStatusData.players_CONFIG.indices, id: \.self) { index in
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
						WheelPickerView(selection: $gameStatusData.discussion_minutes_CONFIG)
						.frame(height: 60) // 高さを調整して内容が見やすくする
						
						WheelPickerView(selection: $gameStatusData.discussion_seconds_CONFIG)
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
				
			}
		}
	}
	
	func setConfig(){
		gameStatusData.villager_Count_CONFIG = gameStatusData.players_CONFIG.count -  gameStatusData.werewolf_Count_CONFIG - gameStatusData.seer_Count_CONFIG
		//gameStatusData.discussion_time_CONFIG = selectedTime.minutes * 60 + selectedTime.seconds
	}
}



struct WheelPickerView: UIViewRepresentable {

	@Binding private var selection: Int
	private let content: [Int] = Array(0...59)

	init(selection: Binding<Int>) {
		self._selection = selection
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
			label.text = String(wheelPickerView.content[row])
			label.textAlignment = .center
			label.adjustsFontSizeToFitWidth = true
			return label
		}
	}
}
