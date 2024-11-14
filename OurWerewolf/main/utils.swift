//
//  utils.swift
//  werewolf_ver5
//
//  Created by Masanori Sudo on 2024/10/29.
//


import Foundation
import SwiftUI

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


struct RoleStepper: View {
	@EnvironmentObject var gameStatusData: GameStatusData
	@Binding var value: Int
	var lowerBound: Int
	var upperBound: Int
	var step: Int = 1
	var isIndependentDisable: Bool = false
	@State private var isButtonDisabled = false
	
	var body: some View {
		HStack {
			HStack{
				if value > lowerBound{  // working
					Button(action: {
						if value > lowerBound{
							value -= step
						}
					}) {
						Image(systemName: "minus")
							.font(.title)
					}
				}else{  // disabled
					Image(systemName: "minus")
						.font(.title)
						.opacity(0.3)
				}
				
				Text("|")
					.font(.title)
					.opacity(0.12)
					.padding(4)
				
				if isIndependentDisable == false{  // condition for player_num Dependent Disable
					if (value < upperBound && gameStatusData.existsPlayerWithoutRole){  // working
						Button(action: {
							if value < upperBound{
								value += step
							}
						}) {
							Image(systemName: "plus")
								.font(.title)
						}
					}else{  // disabled
						Image(systemName: "plus")
							.font(.title)
							.opacity(0.3)
					}
				}else{  // condition for Independent Disable
					if (value < upperBound){  // working
						Button(action: {
							if value < upperBound{
								value += step
							}
						}) {
							Image(systemName: "plus")
								.font(.title)
						}
					}else{  // disabled
						Image(systemName: "plus")
							.font(.title)
							.opacity(0.3)
					}
				}
			}
			.padding(8)
			.foregroundStyle(.white)
			.background(.white.opacity(0.1))
			.cornerRadius(10)
		}
	}
	
	func buttonTapped() {  // not used
		isButtonDisabled = true  // ボタンを無効化
		DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
			isButtonDisabled = false
		}
	}
}




struct OffsetPreferenceKey: PreferenceKey {
	static var defaultValue = CGFloat.zero
	
	static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
		value = nextValue()
	}
}


struct FadingScrollView<Content: View>: View {
	@EnvironmentObject var gameStatusData: GameStatusData
	@State private var offset: CGFloat = 0
	@State private var scrollViewHeight: CGFloat = .zero
	@State private var scrollViewDefaultY: CGFloat = .zero
	@State private var topFadeOpacity: CGFloat = 0
	@State private var bottomFadeOpacity: CGFloat = 1.0
	@State private var normalizedOffset: CGFloat = 1.0
	let axes: Axis.Set
	let showsIndicators: Bool
	@ViewBuilder var content: Content
	//let perform: (CGFloat) -> Void
	let fadeHeight: CGFloat
	
	init(
		fadeHeight: CGFloat = 40,
		axes: Axis.Set = .vertical,
		showsIndicators: Bool = true,
		@ViewBuilder content: () -> Content, perform: @escaping (CGFloat) -> Void = { _ in }
	) {
		self.fadeHeight = fadeHeight
		self.axes = axes
		self.showsIndicators = showsIndicators
		self.content = content()
		//self.perform = perform
	}
	
	var body: some View {
		GeometryReader { geo in
			ZStack {
				ScrollView(axes, showsIndicators: showsIndicators) {
					ZStack {
						VStack{
							Text("")  // making space
							content
							Text("")  // making space
						}
						// スクロールオフセットを取得するためのGeometryReader
						GeometryReader { proxy in
							Color.clear.preference(
								key: OffsetPreferenceKey.self,
								value: proxy.frame(in: .named("scrollViewCoordinateSpace")).minY
							)
						}
						.frame(height: 0) // 高さを0にしてレイアウトに影響を与えない
					}
				}
				.coordinateSpace(name: "scrollViewCoordinateSpace") // カスタム座標空間を定義
				.onPreferenceChange(OffsetPreferenceKey.self) { value in
					self.offset = value
					// self.perform(value)
					self.updateFadeOpacities()
				}
				
				// フェード効果のオーバーレイ
				VStack {
					LinearGradient(gradient: Gradient(colors: [Color.black.opacity(0.8), Color.clear]),
								   startPoint: .top,
								   endPoint: .bottom)
					.frame(height: fadeHeight)
					.opacity(topFadeOpacity)
					
					Spacer()
					
					LinearGradient(gradient: Gradient(colors: [Color.black.opacity(0.8), Color.clear]),
								   startPoint: .bottom,
								   endPoint: .top)
					.frame(height: fadeHeight)
					.opacity(bottomFadeOpacity)
				}
				.allowsHitTesting(false)
			}
			.onAppear {
				self.scrollViewHeight = geo.size.height
				self.scrollViewDefaultY = geo.frame(in: .global).minY
			}
		}
	}
	
	
	func updateFadeOpacities() {
		// スクロールオフセットに基づいてフェードの不透明度を更新
		/*
		 let _ = print("hi")
		 let _ = print(self.scrollViewHeight)
		 let _ = print(offset)
		 let _ = print(self.scrollViewDefaultY)
		 let _ = print(maxOffset)
		 */
		let maxOffset = self.scrollViewHeight - (offset - self.scrollViewDefaultY)
		let threshold = fadeHeight  // use fadeHeight as threshold
		
		
		
		if maxOffset > 0 {
			normalizedOffset = (offset - self.scrollViewDefaultY) / threshold
			topFadeOpacity = min(max(1 - normalizedOffset, 0), 1)  // range 0...1
			bottomFadeOpacity = min(max(normalizedOffset, 0), 1)
		} else {
			topFadeOpacity = 0
			bottomFadeOpacity = 1
		}
	}
}
