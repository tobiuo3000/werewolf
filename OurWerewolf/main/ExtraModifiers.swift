import SwiftUI
import AVFoundation




struct ViewSizePreferenceKey: PreferenceKey {
	static var defaultValue: CGSize = .zero
	static func reduce(value: inout CGSize, nextValue: () -> CGSize) {
		value = nextValue()
	}
}

struct TextBackgroundModifier: ViewModifier {
	@EnvironmentObject var gameStatusData: GameStatusData
	var outerSquare: CGFloat
	var innerSquare: CGFloat
	
	func body(content: Content) -> some View {
		ZStack{
			content
				.padding(outerSquare)
				.background(.white)
				.cornerRadius(gameStatusData.currentTheme.cornerRadius)
			content
				.foregroundColor(.white)
				.padding(innerSquare)
				.background(
					Color(red: 0.3, green: 0.4, blue: 0.5)
				)
				.cornerRadius(gameStatusData.currentTheme.cornerRadius)
			
			//.allowsHitTesting(false)
		}
	}
}


struct ButtonAnimationModifier: ViewModifier {
	@State private var isPressed = false
	
	func body(content: Content) -> some View {
		ZStack{
			content
				.scaleEffect(isPressed ? 0.8 : 1.0) // タップ状態に基づくスケール変更
				.animation(.easeInOut(duration: 0.2), value: isPressed) // アニメーションの適用
				.simultaneousGesture(DragGesture(minimumDistance: 0)
					.onChanged({ _ in isPressed = true }) // ボタンを押している間は収縮させる
					.onEnded({ _ in isPressed = false }) // ボタンから手を離したら元に戻す
				)
		}
	}
}


struct TextFrameSimple: ViewModifier {
	@EnvironmentObject var gameStatusData: GameStatusData
	
	func body(content: Content) -> some View {
		ZStack{
			content
				.foregroundColor(.white)
				.padding(10)
				.background(Color(red: 0.0, green: 0.0, blue: 0.0, opacity: 0.8))
				.border(Color(red: 0.8, green: 0.6, blue: 0.24, opacity: 1.0), width: 2)
		}
	}
}

struct InactiveButtonDesign: ViewModifier {
	@EnvironmentObject var gameStatusData: GameStatusData
	
	func body(content: Content) -> some View {
		HStack{
			ZStack{
				content
					.padding(12)
					.background(.white)
					.strikethrough(true, color: .white)  // 横棒を赤色で表示
					.cornerRadius(gameStatusData.currentTheme.cornerRadius)
				content
					.foregroundColor(.white)
					.padding(10)
					.background(
						Color(.gray)
					)
					.cornerRadius(gameStatusData.currentTheme.cornerRadius)
			}
		}
	}
}


struct TextFrameDesignProxy: ViewModifier {
	@EnvironmentObject var GameStatusData: GameStatusData
	
	func body(content: Content) -> some View {
		content
			.font(.title2)
			.textFrameSimple()
	}
}




struct HomeCardAnimation: ViewModifier {
	@EnvironmentObject var gameStatusData: GameStatusData
	@EnvironmentObject var gameProgress: GameProgress
	@State var hasAppeared: Bool = false  // restricting continuous execution
	@State var isFirstAppearance: Bool = true  // restricting continuous execution
	@State var offset_x: CGFloat
	@State var offset_y: CGFloat
	@State var isPlayerInfoView: Bool
	var imageIndex: Int
	var UIspeed: CGFloat
	
	func body(content: Content) -> some View {
		let viewOffsetThreshold1: CGFloat = (gameStatusData.fullScreenSize.width * 2 / 4)
		let viewOffsetThreshold2: CGFloat = (gameStatusData.fullScreenSize.width * 3 / 4)
		let viewOffsetThreshold3: CGFloat = (gameStatusData.fullScreenSize.width * 5 / 4)
		let viewOffsetThreshold4: CGFloat = (gameStatusData.fullScreenSize.width * 6 / 4)
		ZStack{
			content
				.onAppear(){
					if isFirstAppearance{
						performAnimation(imageIndex: imageIndex)
						hasAppeared = true
						isFirstAppearance = false
					}
				}
				.offset(x: offset_x, y: offset_y)
				.onChange(of: gameStatusData.threeOffSetTab){ new_offset in
					if (viewOffsetThreshold2 < new_offset && new_offset < viewOffsetThreshold3) && !hasAppeared {
						performAnimation(imageIndex: imageIndex)
						hasAppeared = true
					}else if ((new_offset < viewOffsetThreshold1 || viewOffsetThreshold4 < new_offset) && hasAppeared) {
						dissapeatingAnimation(imageIndex: imageIndex)
						hasAppeared = false
						
					}
				}
				.onChange(of: gameProgress.game_start_flag){ _ in
					if isPlayerInfoView == true {
						dissapeatingAnimation(imageIndex: imageIndex)
					}
				}
		}
	}
	
	private func performAnimation(imageIndex: Int) {
		let basical_delay = CGFloat(0.1)
		let delay = CGFloat(imageIndex) * 0.05 + basical_delay
		let amplitude = (gameStatusData.fullScreenSize.width / (30+CGFloat(imageIndex)))
		if hasAppeared == false{
			DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
				withAnimation(.linear(duration: 0.15*UIspeed)) {
					if isPlayerInfoView{
						offset_y = amplitude
					}else{
						offset_x = amplitude
					}
				}
			}
			
			DispatchQueue.main.asyncAfter(deadline: .now() + 0.15*UIspeed + delay) {
				withAnimation(.linear(duration: 0.05*UIspeed)) {
					if isPlayerInfoView{
						offset_y = -(amplitude/2)
					}else{
						offset_x = -(amplitude/2)
					}
				}
			}
			
			DispatchQueue.main.asyncAfter(deadline: .now() + 0.20*UIspeed + delay) {
				withAnimation(.linear(duration: 0.05*UIspeed)) {
					offset_x = 0
					if isPlayerInfoView{
						offset_y = 0
					}else{
						offset_x = 0
					}
				}
			}
		}
	}
	
	private func dissapeatingAnimation(imageIndex: Int) {
		let delay = CGFloat(imageIndex) * 0.05
		if hasAppeared == true{
			DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
				withAnimation(.linear(duration: 0.30*UIspeed)) {
					if isPlayerInfoView{
						offset_y = -(gameStatusData.fullScreenSize.height)
					}else{
						offset_x = -(gameStatusData.fullScreenSize.width)
					}
				}
			}
		}
	}
}

struct CardFlippingWhenAssigningRole: ViewModifier{
	@Binding var isCardFlipped: Bool
	@Binding var isCardTapped: Bool
	@Binding var isRoleNameShown: Bool
	@Binding var isRoleNameChecked: Bool
	@Binding var cardScale: CGFloat
	@Binding var textScale: CGFloat
	@Binding var textOpacity: CGFloat
	@Binding var isTapAllowed: Bool
	
	func body(content: Content) -> some View {
		content
			.rotation3DEffect(Angle(degrees: isCardFlipped ? 0 : 180), axis: (x: 0, y: 1, z: 0))
			.onTapGesture {
				if isTapAllowed{
					isTapAllowed = false
					withAnimation(.easeInOut(duration: 0.1)) {
						cardScale = 0.8 // 最初に小さくバウンド
					}
					withAnimation(.easeInOut(duration: 0.1).delay(0.1)) {
						cardScale = 1.0 // 最初に小さくバウンド
					}
					DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
						withAnimation(.easeInOut(duration: 0.3)){
							self.isCardFlipped.toggle()
						}
					}
					DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
						withAnimation(.easeInOut(duration: 0.3)) {
							if isCardFlipped{
								self.cardScale = 1.2 // 拡大
							}else{
								self.cardScale = 1.0 // 拡大
							}
							self.isCardTapped.toggle()
						}
					}
					withAnimation(.easeOut(duration: 0.3).delay(0.8)){
						if isRoleNameShown {
							textScale = 0.0
							textOpacity = 0.0
						} else {
							textScale = 1.0
							textOpacity = 1.0
						}
						self.isRoleNameShown.toggle()
						self.isRoleNameChecked = true
					}
					DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
						self.isTapAllowed = true
					}
				}
			}
	}
}


struct CardFlippedAndRtoL: ViewModifier{
	@EnvironmentObject var gameProgress: GameProgress
	@State var card_offset: CGSize = CGSize(width: 0, height: 0)
	@Binding var isCardFlipped: Bool
	@Binding var cardScale: CGFloat
	var imageIndex: Int
	
	func body(content: Content) -> some View {
		ZStack{
			content
				.offset(card_offset)
				.rotation3DEffect(Angle(degrees: isCardFlipped ? 180 : 360), axis: (x: 0, y: 1, z: 0))
				.onChange(of: gameProgress.game_start_flag){ _ in
					performAnimation(imageIndex: imageIndex)
				}
		}
	}
	
	private func performAnimation(imageIndex: Int) {
		let delay = CGFloat(imageIndex) * 0.05
		let first_duration = CGFloat(0.1)
		let second_duration = CGFloat(0.2)
		let duration_untill_flipping = CGFloat(0.3)
		let duration_before_RtoL = 1.0
		let duration_RtoL = 0.60
		withAnimation(.easeInOut(duration: first_duration + delay)) {
			cardScale = 1.2 // 最初に小さくバウンド
		}
		withAnimation(.easeInOut(duration: first_duration).delay(first_duration + delay)) {
			cardScale = 1.0 // 最初に小さくバウンド
		}
		withAnimation(.easeInOut(duration: duration_untill_flipping).delay(second_duration + delay)){
			self.isCardFlipped.toggle()
		}
		withAnimation(.easeInOut(duration: duration_RtoL).delay(duration_before_RtoL + delay)){
			self.card_offset = CGSize(width: 400, height: 0)
		}
	}
}


struct CardFlipping: ViewModifier{
	@EnvironmentObject var gameStatusData: GameStatusData
	@EnvironmentObject var gameProgress: GameProgress
	@Binding var isCardFlipped: Bool
	@Binding var cardScale: CGFloat
	var imageIndex: Int
	
	func body(content: Content) -> some View {
		ZStack{
			
			content
				.rotation3DEffect(Angle(degrees: isCardFlipped ? 180 : 360), axis: (x: 0, y: 1, z: 0))
				.onChange(of: gameProgress.game_start_flag){ _ in
					performAnimation(imageIndex: imageIndex)
				}
			
		}
	}
	
	private func performAnimation(imageIndex: Int) {
		let delay = CGFloat(imageIndex) * 0.05
		let first_duration = CGFloat(0.1)
		let second_duration = CGFloat(0.2)
		let duration_untill_flipping = CGFloat(0.3)
		withAnimation(.easeInOut(duration: first_duration + delay)) {
			cardScale = 1.2 // 最初に小さくバウンド
		}
		withAnimation(.easeInOut(duration: first_duration).delay(first_duration + delay)) {
			cardScale = 1.0 // 最初に小さくバウンド
		}
		withAnimation(.easeInOut(duration: duration_untill_flipping).delay(second_duration + delay)){
			self.isCardFlipped.toggle()
		}
	}
}


struct UIAnimationRToL: ViewModifier {
	@Binding var animationFlag: Bool
	@State var offset: CGFloat = 0
	var delay: CGFloat
	
	func body(content: Content) -> some View {
		ZStack{
			content
				.offset(x: offset, y: 0)
				.onChange(of: animationFlag){ _ in
					if animationFlag == true{
						performAnimation()
					}
				}
		}
	}
	
	private func performAnimation() {
		if animationFlag == true{
			DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
				withAnimation(.linear(duration: 0.2)) {
					offset = -500
				}
			}
		}
	}
}

struct UIAnimationLToR: ViewModifier {
	@Binding var animationFlag: Bool
	@State var offset: CGFloat = -500
	var delay: CGFloat = 0
	
	func body(content: Content) -> some View {
		ZStack{
			content
				.offset(x: offset, y: 0)
				.onChange(of: animationFlag){ _ in
					if animationFlag == true{
						performAnimation()
					}
				}
		}
	}
	
	private func performAnimation() {
		if animationFlag == true{
			DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
				withAnimation(.linear(duration: 0.2)) {
					offset = 0
				}
			}
		}
	}
}


struct BouncingUI: ViewModifier {
	@State private var isBouncing = false
	@State var offset: CGFloat = 0
	let duration: CGFloat
	let interval: CGFloat
	
	func body(content: Content) -> some View {
		let timer = Timer.publish(every: interval, on: .main, in: .common).autoconnect()
		
		content
			.offset(y: offset)
			.onReceive(timer) { _ in
				isBouncing.toggle()
				performAnimation()
			}
	}
	
	private func performAnimation() {
		if isBouncing{
			withAnimation(.easeOut(duration: duration/2)) {
				offset = -10
			}
			DispatchQueue.main.asyncAfter(deadline: .now() + (duration)) {
				withAnimation(.easeIn(duration: duration)) {
					offset = 5
				}
			}
			DispatchQueue.main.asyncAfter(deadline: .now() + (duration*2)) {
				withAnimation(.easeOut(duration: duration/4)) {
					offset = -3
				}
			}
			DispatchQueue.main.asyncAfter(deadline: .now() + (duration*9/4)) {
				withAnimation(.linear(duration: duration/6)) {
					offset = 0
				}
			}
		}
	}
}


struct FloatingUI: ViewModifier {
	@State private var isBouncing = false
	@State var offset: CGFloat = 5
	let duration: CGFloat = 1
	
	func body(content: Content) -> some View {
		let timer = Timer.publish(every: duration, on: .main, in: .common).autoconnect()
		content
			.offset(y: offset)
			.onReceive(timer) { _ in
				isBouncing.toggle()
				performAnimation()
			}
	}
	
	private func performAnimation() {
		if isBouncing{
			withAnimation(.easeInOut(duration: duration/2)) {
				offset = -5
			}
			DispatchQueue.main.asyncAfter(deadline: .now() + (duration/2)) {
				withAnimation(.easeOut(duration: duration/2)) {
					offset = 5
				}
			}
		}
	}
}


struct  FlickeringUI: ViewModifier {
	@State private var isBouncing = false
	@State var opacity: CGFloat = 1.0
	@State var size: CGFloat = 1.1
	let duration: CGFloat = 2
	let interval: CGFloat
	
	func body(content: Content) -> some View {
		let timer = Timer.publish(every: interval, on: .main, in: .common).autoconnect()
		content
			.opacity(opacity)
			.scaleEffect(size)
			.onReceive(timer) { _ in
				isBouncing.toggle()
				performAnimation()
			}
	}
	
	private func performAnimation() {
		if isBouncing{
			withAnimation(.easeInOut(duration: duration*2/3)) {
				opacity = 0.5
				size = 1.0
			}
			DispatchQueue.main.asyncAfter(deadline: .now() + (duration/2)) {
				withAnimation(.easeInOut(duration: duration/3)) {
					opacity = 1.0
					size = 1.1
				}
			}
		}
	}
}


extension View {
	func myButtonBounce() -> some View {
		self.modifier(ButtonAnimationModifier())
	}
	
	func myTextBackground(outerSquare: CGFloat = 12, innerSquare: CGFloat = 10) -> some View {
		self.modifier(TextBackgroundModifier(outerSquare: outerSquare, innerSquare: innerSquare))
	}
	
	func myInactiveButton() -> some View {
		self.modifier(InactiveButtonDesign())
	}
	
	func textFrameSimple() -> some View {
		self.modifier(TextFrameSimple())
	}
	
	func textFrameDesignProxy() -> some View {
		self.modifier(TextFrameDesignProxy())
	}
	
	func cardFlippedWhenAssigningRole(isCardFlipped: Binding<Bool>, isCardTapped: Binding<Bool>, isRoleNameShown: Binding<Bool>, isRoleNameChecked: Binding<Bool>, cardScale: Binding<CGFloat>, textScale: Binding<CGFloat>, textOpacity: Binding<CGFloat>, isTapAllowed: Binding<Bool>) -> some View {
		self.modifier(CardFlippingWhenAssigningRole(isCardFlipped: isCardFlipped, isCardTapped: isCardTapped, isRoleNameShown: isRoleNameShown, isRoleNameChecked: isRoleNameChecked, cardScale: cardScale, textScale: textScale, textOpacity: textOpacity, isTapAllowed: isTapAllowed))
	}
	
	func cardFlippedAndPiled(isCardFlipped: Binding<Bool>, cardScale: Binding<CGFloat>, imageIndex: Int) -> some View {
		self.modifier(CardFlippedAndRtoL(isCardFlipped: isCardFlipped, cardScale: cardScale, imageIndex: imageIndex))
	}
	
	func cardFlipping(isCardFlipped: Binding<Bool>, cardScale: Binding<CGFloat>, imageIndex: Int) -> some View {
		self.modifier(CardFlipping(isCardFlipped: isCardFlipped, cardScale: cardScale, imageIndex: imageIndex))
	}
	
	func homeCardAnimation(screenWidth: CGFloat, screenHeight: CGFloat = 0, imageIndex: Int, isPlayerInfoView: Bool = false, UIspeed: CGFloat = 1.0) -> some View {
		self.modifier(HomeCardAnimation(offset_x: -screenWidth, offset_y: -screenHeight, isPlayerInfoView: isPlayerInfoView, imageIndex: imageIndex, UIspeed: UIspeed))
	}
	
	func uiAnimationRToL(animationFlag: Binding<Bool>, delay: CGFloat) -> some View {
		self.modifier(UIAnimationRToL(animationFlag: animationFlag, delay: delay))
	}
	
	func uiAnimationLToR(animationFlag: Binding<Bool>, delay: CGFloat = 0) -> some View {
		self.modifier(UIAnimationRToL(animationFlag: animationFlag, delay: delay))
	}
	
	func bouncingUI(duration: CGFloat = 0.2, interval: CGFloat = 5) -> some View {
		self.modifier(BouncingUI(duration: duration, interval: interval))
	}
	
	func floatingUI() -> some View {
		self.modifier(FloatingUI())
	}
	
	func flickeringUI(interval: CGFloat = 2) -> some View {
		self.modifier(FlickeringUI(interval: interval))
	}
}

