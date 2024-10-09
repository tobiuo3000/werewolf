import SwiftUI





struct ViewSizePreferenceKey: PreferenceKey {
	static var defaultValue: CGSize = .zero
	static func reduce(value: inout CGSize, nextValue: () -> CGSize) {
		value = nextValue()
	}
}

struct TextBackgroundModifier: ViewModifier {
	@EnvironmentObject var GameStatusData: GameStatusData
	
	func body(content: Content) -> some View {
		ZStack{
			content
				.padding(12)
				.background(.white)
				.cornerRadius(GameStatusData.currentTheme.cornerRadius)
			content
				.foregroundColor(.white)
				.padding(10)
				.background(
					Color(red: 0.5, green: 0.6, blue: 0.8)
				)
			
				.cornerRadius(GameStatusData.currentTheme.cornerRadius)
			
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
	@EnvironmentObject var GameStatusData: GameStatusData
	
	func body(content: Content) -> some View {
		ZStack{
			content
				.foregroundColor(.white)
				.padding(10)
				.background(Color(red: 0.0, green: 0.0, blue: 0.0, opacity: 0.5))
				.border(Color(red: 0.8, green: 0.6, blue: 0.24, opacity: 1.0), width: 2)
			
			
		}
	}
}


struct TextFrameDesignProxy: ViewModifier {
	@EnvironmentObject var GameStatusData: GameStatusData
	
	func body(content: Content) -> some View {
		content
			.textFrameSimple()
	}
}




struct CardAnimationLToR: ViewModifier {
	@EnvironmentObject var gameStatusData: GameStatusData
	@State var hasAppeared: Bool = false  // restricting continuous execution
	@State var isFirstAppearance: Bool = true  // restricting continuous execution
	@State var offset: CGFloat
	@Binding var threeOffSetTab: CGFloat
	var imageIndex: Int
	
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
				.offset(x: offset, y: 0)
				.onChange(of: threeOffSetTab){new_value in
					if (viewOffsetThreshold2 < threeOffSetTab && threeOffSetTab < viewOffsetThreshold3) && !hasAppeared {
						performAnimation(imageIndex: imageIndex)
						hasAppeared = true
					}else if ((threeOffSetTab < viewOffsetThreshold1 || viewOffsetThreshold4 < threeOffSetTab) && hasAppeared) {
						dissapeatingAnimation(imageIndex: imageIndex)
						hasAppeared = false
						
					}
				}
		}
	}
	
	private func performAnimation(imageIndex: Int) {
		let delay = CGFloat(imageIndex) * 0.05
		let amplitude = (gameStatusData.fullScreenSize.width / (30+CGFloat(imageIndex)))
		if hasAppeared == false{
			DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
				withAnimation(.linear(duration: 0.15)) {
					offset = amplitude
				}
			}
			
			DispatchQueue.main.asyncAfter(deadline: .now() + 0.15 + delay) {
				withAnimation(.linear(duration: 0.05)) {
					offset = -(amplitude/2)
				}
			}
			
			DispatchQueue.main.asyncAfter(deadline: .now() + 0.20 + delay) {
				withAnimation(.linear(duration: 0.05)) {
					offset = 0
				}
			}
		}
	}
	
	private func dissapeatingAnimation(imageIndex: Int) {
		let delay = CGFloat(imageIndex) * 0.05
		if hasAppeared == true{
			DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
				withAnimation(.linear(duration: 0.30)) {
					offset = -(gameStatusData.fullScreenSize.width)
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
					withAnimation(.easeInOut(duration: 0.1).delay(0.2)) {
						cardScale = 1.0 // 最初に小さくバウンド
					}
					withAnimation(.easeInOut(duration: 0.3).delay(0.4)){
						self.isCardFlipped.toggle()
					}
					withAnimation(.easeInOut(duration: 0.3).delay(0.8)) {
						if isCardTapped {
							cardScale = 1.0 // 元のサイズに戻す
						} else {
							cardScale = 1.2 // 拡大
						}
						self.isCardTapped.toggle()
					}
					withAnimation(.easeOut(duration: 0.3).delay(1.1)){
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
					DispatchQueue.main.asyncAfter(deadline: .now() + 1.6) {
						isTapAllowed = true
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
				.onChange(of: gameProgress.game_start_flag){new_value in
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
					offset = -400
				}
			}
		}
	}
}

struct UIAnimationLToR: ViewModifier {
	@Binding var animationFlag: Bool
	@State var offset: CGFloat = -400
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







extension View {
	func myButtonBounce() -> some View {
		self.modifier(ButtonAnimationModifier())
	}
	
	func myTextBackground() -> some View {
		self.modifier(TextBackgroundModifier())
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
	
	func cardAnimationLToR(screenWidth: CGFloat, threeOffSetTab: Binding<CGFloat>, imageIndex: Int) -> some View {
		self.modifier(CardAnimationLToR(offset: -screenWidth, threeOffSetTab: threeOffSetTab, imageIndex: imageIndex))
	}
	
	func uiAnimationRToL(animationFlag: Binding<Bool>, delay: CGFloat) -> some View {
		self.modifier(UIAnimationRToL(animationFlag: animationFlag, delay: delay))
	}
	
	func uiAnimationLToR(animationFlag: Binding<Bool>, delay: CGFloat = 0) -> some View {
		self.modifier(UIAnimationRToL(animationFlag: animationFlag, delay: delay))
	}
}

