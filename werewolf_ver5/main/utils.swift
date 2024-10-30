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
	@Binding var value: Int
	var range: ClosedRange<Int>
	var step: Int = 1
	
	var body: some View {
		HStack {
			HStack{
				if value > range.lowerBound{  // working
					Button(action: {
						value -= step
					}) {
						Image(systemName: "minus")
							.font(.title2)
					}
				}else{  // disabled
					Button(action: {
					}) {
						Image(systemName: "minus")
							.font(.title2)
					}
					.disabled(/*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/)
					.opacity(0.3)
				}
				
				Text("|")
					.font(.title2)
					.opacity(0.12)
					.padding(4)
				
				if (value < range.upperBound){  // working
					Button(action: {
						value += step
					}) {
						Image(systemName: "plus")
							.font(.title2)
					}
				}else{  // disabled
					Button(action: {
					}) {
						Image(systemName: "plus")
							.font(.title2)
					}
					.disabled(true)
					.opacity(0.3)
				}
			}
			.padding(8)
			.foregroundStyle(.white)
			.background(.white.opacity(0.1))
			.cornerRadius(10)
		}
	}
}




struct ScrollViewWithOffset<Content: View>: UIViewRepresentable {
	var content: Content
	@Binding var offset: CGPoint
	let axis: Axis.Set
	
	init(offset: Binding<CGPoint>, axis: Axis.Set = .vertical, @ViewBuilder content: () -> Content) {
		self._offset = offset
		self.axis = axis
		self.content = content()
	}
	
	func makeCoordinator() -> Coordinator {
		Coordinator(parent: self)
	}
	
	func makeUIView(context: Context) -> UIScrollView {
		let scrollView = UIScrollView()
		
		// デリゲートを設定
		scrollView.delegate = context.coordinator
		
		// スクロール方向の設定
		scrollView.showsVerticalScrollIndicator = false
		scrollView.showsHorizontalScrollIndicator = false
		scrollView.alwaysBounceVertical = axis == .vertical
		scrollView.alwaysBounceHorizontal = axis == .horizontal
		
		// SwiftUIのコンテンツを追加
		let hostedView = UIHostingController(rootView: content).view!
		hostedView.translatesAutoresizingMaskIntoConstraints = false
		scrollView.addSubview(hostedView)
		hostedView.backgroundColor = .clear  // 背景を透明に設定
		
		// コンテンツの制約を設定
		NSLayoutConstraint.activate([
			hostedView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
			hostedView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
			hostedView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
			hostedView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
			hostedView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor)
		])
		
		return scrollView
	}
	
	func updateUIView(_ uiView: UIScrollView, context: Context) {
		// 何もしない
	}
	
	class Coordinator: NSObject, UIScrollViewDelegate {
		var parent: ScrollViewWithOffset
		
		init(parent: ScrollViewWithOffset) {
			self.parent = parent
		}
		
		func scrollViewDidScroll(_ scrollView: UIScrollView) {
			DispatchQueue.main.async {
				self.parent.offset = scrollView.contentOffset
			}
		}
	}
}


struct FadingScrollView<Content: View>: View {
	@EnvironmentObject var gameStatusData: GameStatusData
	let content: Content
	let axis: Axis.Set
	let fadeHeight: CGFloat
	
	@State private var offset: CGPoint = .zero
	@State private var contentSize: CGSize = .zero
	@State private var scrollViewSize: CGSize = .zero
	@State private var topFadeOpacity: CGFloat = 0
	@State private var bottomFadeOpacity: CGFloat = 1.0
	
	init(axis: Axis.Set = .vertical, fadeHeight: CGFloat = 60, @ViewBuilder content: () -> Content) {
		self.axis = axis
		self.fadeHeight = fadeHeight
		self.content = content()
	}
	
	var body: some View {
		ZStack(alignment: .topLeading) {
			ScrollViewWithOffset(offset: $offset, axis: axis) {
				content
					.background(
						GeometryReader { proxy in
							Color.clear
								.onAppear {
									self.contentSize = proxy.size
								}
						}
					)
			}
			.background(
				GeometryReader { proxy in
					Color.clear
						.onAppear {
							self.scrollViewSize = proxy.size
						}
				}
			)
			.onChange(of: offset) { _ in
				shouldShowTopFade()
				shouldShowBottomFade()
			}
			
			// フェード効果のオーバーレイ
			VStack {
					LinearGradient(gradient: Gradient(colors: [Color.black.opacity(0.8), Color.clear]),
								   startPoint: .top,    // start地点
								   endPoint: .bottom)
					.frame(height: fadeHeight)
					.opacity(topFadeOpacity)
				
				Spacer()
				
					LinearGradient(gradient: Gradient(colors: [Color.black.opacity(0.8), .white.opacity(0)]),
								   startPoint: .bottom,    // start地点
								   endPoint: .top)
					.frame(height: fadeHeight)
					.opacity(bottomFadeOpacity)
			}
		}
	}
	
	func shouldShowTopFade() {
		if offset.y > 0{
			if topFadeOpacity < 1.0{
				topFadeOpacity = offset.y / 180
			}
		} else {
			topFadeOpacity = 0
		}
	}
	
	func shouldShowBottomFade() {
		if contentSize.height - scrollViewSize.height - offset.y > 0{
			if bottomFadeOpacity < 1.0{
				bottomFadeOpacity = contentSize.height - scrollViewSize.height - offset.y / 180
			}
		} else {
			bottomFadeOpacity = 0
		}
	}
}
