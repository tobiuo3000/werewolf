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
	@EnvironmentObject var GameStatusData: GameStatusData
	@State var animationFlag: Bool = false
	@State var offset: CGFloat = -400
	@Binding var viewOffset: CGFloat
	var imageIndex: Int
	let viewOffsetThreshold: CGFloat = 300
	
	func body(content: Content) -> some View {
		ZStack{
			content
				.offset(x: offset, y: 0)
				.onChange(of: viewOffset){new_value in
					if abs(viewOffset) < viewOffsetThreshold {
						performAnimation(imageIndex: imageIndex)
						animationFlag = false
						
					}else{
						animationFlag = true
						offset = -400
					}
				}
		}
	}
	
	private func performAnimation(imageIndex: Int) {
		let delay = CGFloat(imageIndex) * 0.05
		if animationFlag == true{
			DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
				withAnimation(.linear(duration: 0.1)) {
					offset = 10
				}
			}
			
			DispatchQueue.main.asyncAfter(deadline: .now() + 0.1 + delay) {
				withAnimation(.linear(duration: 0.1)) {
					offset = -10
				}
			}
			
			DispatchQueue.main.asyncAfter(deadline: .now() + 0.2 + delay) {
				withAnimation(.linear(duration: 0.1)) {
					offset = 0
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
	
	func body(content: Content) -> some View {
		content
			.rotation3DEffect(Angle(degrees: isCardFlipped ? 0 : 180), axis: (x: 0, y: 1, z: 0))
			.onTapGesture {
				withAnimation(.easeInOut(duration: 0.1)) {
					cardScale = 0.4 // 最初に小さくバウンド
				}
				withAnimation(.easeInOut(duration: 0.1).delay(0.2)) {
					cardScale = 0.5 // 最初に小さくバウンド
				}
				withAnimation(.easeInOut(duration: 0.3).delay(0.4)){
					self.isCardFlipped.toggle()
				}
				withAnimation(.easeInOut(duration: 0.3).delay(0.8)) {
					if isCardTapped {
						cardScale = 0.5 // 元のサイズに戻す
					} else {
						cardScale = 0.8 // 2倍の大きさに拡大
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
	
	func cardFlippedWhenAssigningRole(isCardFlipped: Binding<Bool>, isCardTapped: Binding<Bool>, isRoleNameShown: Binding<Bool>, isRoleNameChecked: Binding<Bool>, cardScale: Binding<CGFloat>, textScale: Binding<CGFloat>, textOpacity: Binding<CGFloat>) -> some View {
		self.modifier(CardFlippingWhenAssigningRole(isCardFlipped: isCardFlipped, isCardTapped: isCardTapped, isRoleNameShown: isRoleNameShown, isRoleNameChecked: isRoleNameChecked, cardScale: cardScale, textScale: textScale, textOpacity: textOpacity))
	}
	
	func cardFlippedAndPiled(isCardFlipped: Binding<Bool>, cardScale: Binding<CGFloat>, imageIndex: Int) -> some View {
		self.modifier(CardFlippedAndRtoL(isCardFlipped: isCardFlipped, cardScale: cardScale, imageIndex: imageIndex))
	}
	
	func cardAnimationLToR(beforeGameViewOffset: Binding<CGFloat>, imageIndex: Int) -> some View {
		self.modifier(CardAnimationLToR(viewOffset: beforeGameViewOffset, imageIndex: imageIndex))
	}
	
	func uiAnimationRToL(animationFlag: Binding<Bool>, delay: CGFloat) -> some View {
		self.modifier(UIAnimationRToL(animationFlag: animationFlag, delay: delay))
	}
	
	func uiAnimationLToR(animationFlag: Binding<Bool>, delay: CGFloat = 0) -> some View {
		self.modifier(UIAnimationRToL(animationFlag: animationFlag, delay: delay))
	}
}

