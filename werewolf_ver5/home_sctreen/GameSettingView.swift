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
			
			ScrollView(.vertical){
				Text("ゲーム設定")
					.font(.system(.largeTitle, design: .serif))
					.foregroundStyle(.black)
					.padding()
				
				VStack{
					VStack(alignment: .leading){
						ZStack{
							HStack {
								Text("参加プレイヤー数:")
									.font(.title2)
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
						
						/*
						ForEach(gameStatusData.players_CONFIG.indices, id: \.self) { index in
							HStack{
								Spacer()
								HStack{
									Text("\(gameStatusData.players_CONFIG[index].player_order+1)番目: ")
									Spacer()
									Text("\(gameStatusData.players_CONFIG[index].player_name)")
										.foregroundStyle(highlightColor)
										.font(.title3)
								}
								.padding()
								.background(Color(red: 0.2, green: 0.2, blue: 0.2))
								.cornerRadius(10)
								Spacer()
							}
						}
						*/
					}
					.onChange(of: gameStatusData.players_CONFIG.count) { _ in
						gameStatusData.update_role_CONFIG()
					}
				}
				.textFrameDesignProxy()
				
				
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
				
				VStack{
					ZStack{
						Stepper("人狼の数:", value: $gameStatusData.werewolf_Count_CONFIG, in: 1...gameStatusData.max_werewolf_CONFIG)
							.font(.title2)
							.pickerStyle(SegmentedPickerStyle())
							.accentColor(.white)
							.onChange(of: gameStatusData.werewolf_Count_CONFIG) { _ in
								gameStatusData.update_role_CONFIG()
							}
						Text("\(gameStatusData.werewolf_Count_CONFIG)")
							.foregroundStyle(highlightColor)
							.font(.title)
					}
					
					ZStack{
						Stepper("占い師の数:", value: $gameStatusData.seer_Count_CONFIG, in: 0...1)
							.font(.title2)
							.pickerStyle(SegmentedPickerStyle())
							.accentColor(.white)
							.onChange(of: gameStatusData.seer_Count_CONFIG) { _ in
								gameStatusData.update_role_CONFIG()
							}
						Text("\(gameStatusData.seer_Count_CONFIG)")
							.foregroundStyle(highlightColor)
							.font(.title)
					}
					
					ZStack{
						Stepper("霊媒師の数:", value: $gameStatusData.medium_Count_CONFIG, in: 0...1)
							.font(.title2)
							.pickerStyle(SegmentedPickerStyle())
							.accentColor(.white)
							.onChange(of: gameStatusData.medium_Count_CONFIG) { _ in
								gameStatusData.update_role_CONFIG()
							}
						Text("\(gameStatusData.medium_Count_CONFIG)")
							.foregroundStyle(highlightColor)
							.font(.title)
					}
					
					ZStack{
						Stepper("狩人の数:", value: $gameStatusData.hunter_Count_CONFIG, in: 0...1)
							.font(.title2)
							.pickerStyle(SegmentedPickerStyle())
							.accentColor(.white)
							.onChange(of: gameStatusData.hunter_Count_CONFIG) { _ in
								gameStatusData.update_role_CONFIG()
							}
						Text("\(gameStatusData.hunter_Count_CONFIG)")
							.foregroundStyle(highlightColor)
							.font(.title)
					}
				}
				.textFrameDesignProxy()
				
				
				Rectangle()
					.fill(.clear)
					.frame(width: 10, height: 10)
				Text("詳細設定")
					.font(.system(.largeTitle, design: .serif))
					.foregroundStyle(.black)
					.padding()
				
				VStack{
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
		}
	}
}


struct ReorderingPlayerView: View {
	@EnvironmentObject var gameStatusData: GameStatusData
	@Binding var isReorderingViewShown: Bool
	@State var isAlertShown: Bool = false
	let viewColor: Color = Color(red: 0.2, green: 0.2, blue: 0.2)
	let highlightColor: Color = Color(red: 0.8, green: 0.5, blue: 0.6)
	let lineWidth: CGFloat = 6
	let baseColor: Color = Color(red: 0.05, green: 0.05, blue: 0.1)
	
	var body: some View{
		ZStack{
			Color.black.opacity(0.6)
				.ignoresSafeArea()
			Rectangle()
				.foregroundStyle(.clear)
				.frame(height: gameStatusData.fullScreenSize.height/30)
			VStack{
				Rectangle()
					.foregroundStyle(.clear)
					.frame(height: gameStatusData.fullScreenSize.height/8)
				ZStack{
					Rectangle()
						.fill(viewColor)
					
					VStack{
						VStack{
							ZStack{
								HStack{  // EditButton
									Spacer()
									EditButton()
										.foregroundColor(.blue)
										.font(.title2)
									Rectangle()
										.fill(.clear)
										.frame(width: 10, height: 10)
								}
								HStack{
									Rectangle()
										.fill(.clear)
										.frame(width: 10, height: 10)
									Button(action: {
										gameStatusData.players_CONFIG.append(Player(player_order: gameStatusData.players_CONFIG.count, role: .villager, player_name: "プレイヤー\(gameStatusData.players_CONFIG.count+1)"))
									}) {
										Image(systemName: "person.badge.plus")
											.font(.title)
											.padding(4)
									}
									.myButtonBounce()
									.bouncingUI(interval: 3)
									Spacer()
								}
								HStack{
									
									Spacer()
									VStack{
										Text("プレイヤー編集画面")
											.font(.title2)
											.padding(4)
											.border(Color(red: 0.8, green: 0.8, blue: 0.8, opacity: 1.0), width: 2)
											.padding(lineWidth)
										
										HStack{
											Text("合計人数:")
												.foregroundStyle(.white)
											Text("\(gameStatusData.players_CONFIG.count)人")
												.foregroundStyle(highlightColor)
										}
										.font(.title2)
									}
									
									Spacer()
									Rectangle()
										.fill(.clear)
										.frame(width: 10, height: 10)
								}
							}
							Rectangle()
								.fill(.clear)
								.frame(height: lineWidth*3)
						}
						.background(baseColor)
						
						List {
							HStack{
								Text("プレイ順序")
									.foregroundStyle(.white)
									.frame(maxWidth: gameStatusData.fullScreenSize.width, alignment: .leading)
									.font(.title2)
								Text("プレイヤー名")
									.foregroundStyle(.white)
									.frame(maxWidth: gameStatusData.fullScreenSize.width, alignment: .leading)
									.font(.title2)
							}
							.listRowBackground(viewColor)
							.padding(lineWidth)
							
							ForEach(gameStatusData.players_CONFIG.indices, id: \.self) { index in
								HStack {
									Text("\(gameStatusData.players_CONFIG[index].player_order+1)番目")
										.foregroundStyle(.white)
										.frame(maxWidth: gameStatusData.fullScreenSize.width, alignment: .leading)
										.font(.title2)
									TextField("プレイヤー名", text: $gameStatusData.players_CONFIG[index].player_name)
										.foregroundStyle(.blue)
										.textFieldStyle(RoundedBorderTextFieldStyle())
										.autocorrectionDisabled()
										.frame(maxWidth: gameStatusData.fullScreenSize.width, alignment: .trailing)
								}
								.padding()
							}
							.onMove { indices, newOffset in
								gameStatusData.players_CONFIG.move(fromOffsets: indices, toOffset: newOffset)
								gameStatusData.updatePlayerOrder()
							}
							.onDelete(perform: confirmDelete)
							.listRowBackground(viewColor)
						}
						.listStyle(PlainListStyle())
						.alert("プレイヤーを4名以下にすることはできません", isPresented: $isAlertShown) {
							Button("OK", role: .cancel) {
							}
						}
						
						HStack{
							Spacer()
							Button(action: {
								isReorderingViewShown = false
								let _ = print(isReorderingViewShown)}){
									Image(systemName: "checkmark.circle")
										.font(.largeTitle)
								}
								.myButtonBounce()
								.bouncingUI(interval: 3)
								.padding(8)
							Rectangle()
								.fill(.clear)
								.frame(width: 10, height: 10)
						}
						.background(baseColor)
					}
				}
				.cornerRadius(18)
				.frame(width: gameStatusData.fullScreenSize.width-2*lineWidth)
				
				Rectangle()
					.foregroundStyle(.clear)
					.frame(height: gameStatusData.fullScreenSize.height/40)
			}
		}
	}
	func confirmDelete(at offsets: IndexSet) {
		if gameStatusData.players_CONFIG.count >= 5 {
			deleteItems(at: offsets)
		} else {
			isAlertShown = true
		}
		gameStatusData.updatePlayerOrder()
	}
	
	func deleteItems(at offsets: IndexSet) {
		gameStatusData.players_CONFIG.remove(atOffsets: offsets)
		
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



struct HorizontalWheelPickerView: UIViewRepresentable {
	@Binding var selection: Int
	let content = Array(0...59)
	let textTimeUnit: String
	
	func makeUIView(context: Context) -> UICollectionView {
		let layout = UICollectionViewFlowLayout()
		layout.scrollDirection = .horizontal
		layout.minimumLineSpacing = 10
		layout.itemSize = CGSize(width: 80, height: 80) // セルのサイズを指定
		
		let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
		collectionView.dataSource = context.coordinator
		collectionView.delegate = context.coordinator
		collectionView.register(LabelCell.self, forCellWithReuseIdentifier: "cell")
		collectionView.backgroundColor = .clear
		collectionView.showsHorizontalScrollIndicator = false
		
		return collectionView
	}
	
	func updateUIView(_ uiView: UICollectionView, context: Context) {
		let indexPath = IndexPath(item: selection, section: 0)
		uiView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
	}
	
	func makeCoordinator() -> Coordinator {
		Coordinator(self)
	}
	
	class Coordinator: NSObject, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
		var parent: HorizontalWheelPickerView
		
		init(_ parent: HorizontalWheelPickerView) {
			self.parent = parent
		}
		
		func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
			return parent.content.count
		}
		
		func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
			let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! LabelCell
			let value = parent.content[indexPath.item]
			cell.label.text = "\(value) \(parent.textTimeUnit)"
			return cell
		}
		
		func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
			parent.selection = indexPath.item
		}
	}
	
	class LabelCell: UICollectionViewCell {
		let label = UILabel()
		
		override init(frame: CGRect) {
			super.init(frame: frame)
			label.textAlignment = .center
			label.font = UIFont.systemFont(ofSize: 20)
			label.textColor = .white
			label.adjustsFontSizeToFitWidth = true
			contentView.addSubview(label)
			label.translatesAutoresizingMaskIntoConstraints = false
			NSLayoutConstraint.activate([
				label.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
				label.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
				label.widthAnchor.constraint(equalTo: contentView.widthAnchor),
				label.heightAnchor.constraint(equalTo: contentView.heightAnchor)
			])
		}
		
		required init?(coder: NSCoder) {
			fatalError("init(coder:) has not been implemented")
		}
	}
}
