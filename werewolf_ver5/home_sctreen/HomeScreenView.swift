import SwiftUI

/*
 画像解像度の目安
 →iphone16 pro maxは1320*2868(9:19.6)
*/


struct OffsetProxy: View {
	var body: some View {
		GeometryReader { proxy in
			Color.clear
				.preference(key: OffsetKey.self, value: proxy.frame(in: .global).minX)
		}
	}
}


struct OffsetKey: PreferenceKey {
	static var defaultValue: CGFloat = 0
	
	static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
		value = nextValue()
	}
}


struct LoopTransitionBackGround: View{
	@EnvironmentObject var gameStatusData: GameStatusData
	@State var offset: CGSize
	@State private var opacity: Double = 1.0
	@State private var count: Int = 0
	
	var body: some View{
		HStack{}
		.onAppear(){
			if count<1 {
				startScrolling()
				count = 1
			}
		}
		
		ZStack{
			HStack(spacing: 0){
				ForEach(0...12, id: \.self){ _ in
					Image(gameStatusData.currentTheme.transitionBackground)
						.resizable()
						.ignoresSafeArea()
						.frame(width: gameStatusData.fullScreenSize.width,
							   height: gameStatusData.fullScreenSize.height)
						.offset(offset)
				}
			}
			
			Rectangle()
				.fill(Color.black)
				.opacity(opacity)
				.ignoresSafeArea()
		}
	}
	
	func startScrolling() {
		withAnimation(Animation.easeIn(duration: 1.4).repeatForever(autoreverses: false)) {
			offset.width =  -gameStatusData.fullScreenSize.width*12
		}
		withAnimation(Animation.easeInOut(duration: 0.4)) {
			opacity = 0
		}
		DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
			withAnimation(.easeInOut(duration: 0.4)) {
				opacity = 1.0
			}
		}
	}
}


struct HomeScreenView: View {
	@EnvironmentObject var gameStatusData: GameStatusData
	@State var currentTab = 1  // decide first appearance tab
	@State var offsetTab0: CGFloat
	@State private var offsetTab1: CGFloat = 0
	@State var offsetTab2: CGFloat
	@State var threeOffSetTab: CGFloat
	@State private var showingSettings = false
	@State private var iconOffsetTab0: CGFloat = 3
	@State private var iconOffsetTab1: CGFloat = 3
	@State private var iconOffsetTab2: CGFloat = 3
	var thresholdIcon: CGFloat
	@State var iconSize0: CGFloat = 30
	@State var iconSize1: CGFloat = 30
	@State var iconSize2: CGFloat = 30
	
	
	var body: some View {
		ZStack{
			VStack(spacing: 0){
				HomeScreenMenu(showingSettings: $showingSettings)
				
				TabView(selection: $currentTab) {
					GameSettingView()
						.tag(0)
						.overlay(
							OffsetProxy()
						)
						.onPreferenceChange(OffsetKey.self) { offset in
							self.offsetTab0 = offset
							calcOffsetThreeTab(threeOffset: $threeOffSetTab)
							calcIconOffset(arg_iconOffsetTab0: $iconOffsetTab0, arg_iconOffsetTab1: $iconOffsetTab1, arg_iconOffsetTab2: $iconOffsetTab2, arg_iconSize0: $iconSize0, arg_iconSize1: $iconSize1, arg_iconSize2: $iconSize2, arg_tabOffsetTab0: $offsetTab0, arg_tabOffsetTab1: $offsetTab1, arg_tabOffsetTab2: $offsetTab2)
						}
					
					BeforeGameView(beforeGameViewOffset: $offsetTab1)
						.tag(1)
						.overlay(
							OffsetProxy()
						)
						.onPreferenceChange(OffsetKey.self) { offset in
							self.offsetTab1 = offset
							calcOffsetThreeTab(threeOffset: $threeOffSetTab)
							calcIconOffset(arg_iconOffsetTab0: $iconOffsetTab0, arg_iconOffsetTab1: $iconOffsetTab1, arg_iconOffsetTab2: $iconOffsetTab2, arg_iconSize0: $iconSize0, arg_iconSize1: $iconSize1, arg_iconSize2: $iconSize2, arg_tabOffsetTab0: $offsetTab0, arg_tabOffsetTab1: $offsetTab1, arg_tabOffsetTab2: $offsetTab2)
						}
					
					Theme_Config()
						.tag(2)
						.overlay(
							OffsetProxy()
						)
						.onPreferenceChange(OffsetKey.self) { offset in
							self.offsetTab2 = offset
							calcOffsetThreeTab(threeOffset: $threeOffSetTab)
							calcIconOffset(arg_iconOffsetTab0: $iconOffsetTab0, arg_iconOffsetTab1: $iconOffsetTab1, arg_iconOffsetTab2: $iconOffsetTab2, arg_iconSize0: $iconSize0, arg_iconSize1: $iconSize1, arg_iconSize2: $iconSize2, arg_tabOffsetTab0: $offsetTab0, arg_tabOffsetTab1: $offsetTab1, arg_tabOffsetTab2: $offsetTab2)
						}
				}
				.tabViewStyle(.page(indexDisplayMode: .never))
				.animation(.easeInOut, value: currentTab)
				
				ScrollBarView(currentTab: $currentTab, threeOffSetTab: $threeOffSetTab, iconOffsetTab0: $iconOffsetTab0,
							  iconOffsetTab1: $iconOffsetTab1, iconOffsetTab2: $iconOffsetTab2,
							  iconSize0: $iconSize0, iconSize1: $iconSize1, iconSize2: $iconSize2)
					.frame(height: 50)
			}
			.disabled(showingSettings)
			
			if showingSettings == true{
				Color.black.opacity(0.4)
				Rectangle()
					.frame(width: 300, height: 300)
					.foregroundColor(.white)
					.cornerRadius(20)
				SettingsView(showingSettings: $showingSettings)
			}
		}
	}
	
	func calcOffsetThreeTab(threeOffset: Binding<CGFloat>) {
		if self.offsetTab0 >= 0{
			threeOffset.wrappedValue = 0
		} else if self.offsetTab0 < 0 && self.offsetTab1 >= 0 {
			threeOffset.wrappedValue = -(self.offsetTab0)
		} else if self.offsetTab1 < 0 && self.offsetTab2 >= 0 {
			threeOffset.wrappedValue = (gameStatusData.fullScreenSize.width) - self.offsetTab1
		} else {
			threeOffset.wrappedValue = (2*(gameStatusData.fullScreenSize.width))
		}
	}
	
	func _calcIconOffset(iconOffset: Binding<CGFloat>, tabOffset: Binding<CGFloat>){
		if (-self.thresholdIcon <= tabOffset.wrappedValue) && (tabOffset.wrappedValue <= self.thresholdIcon) {
			iconOffset.wrappedValue = (abs(tabOffset.wrappedValue)/self.thresholdIcon)*6 - 6  // positive num: up, negative: down
		} else {
			iconOffset.wrappedValue = 3
		}
	}
	
	func calcIconOffset(arg_iconOffsetTab0: Binding<CGFloat>,
						arg_iconOffsetTab1: Binding<CGFloat>,
						arg_iconOffsetTab2: Binding<CGFloat>,
						arg_iconSize0: Binding<CGFloat>,
						arg_iconSize1: Binding<CGFloat>,
						arg_iconSize2: Binding<CGFloat>,
						arg_tabOffsetTab0: Binding<CGFloat>,
						arg_tabOffsetTab1: Binding<CGFloat>,
						arg_tabOffsetTab2: Binding<CGFloat>){
		_calcIconOffset(iconOffset: arg_iconOffsetTab0, tabOffset: arg_tabOffsetTab0)
		_calcIconOffset(iconOffset: arg_iconOffsetTab1, tabOffset: arg_tabOffsetTab1)
		_calcIconOffset(iconOffset: arg_iconOffsetTab2, tabOffset: arg_tabOffsetTab2)
		_calcIconSize(iconSize: arg_iconSize0, tabOffset: arg_tabOffsetTab0)
		_calcIconSize(iconSize: arg_iconSize1, tabOffset: arg_tabOffsetTab1)
		_calcIconSize(iconSize: arg_iconSize2, tabOffset: arg_tabOffsetTab2)
	}
	
	func _calcIconSize(iconSize: Binding<CGFloat>, tabOffset: Binding<CGFloat>){
		if (-self.thresholdIcon <= tabOffset.wrappedValue) && (tabOffset.wrappedValue <= self.thresholdIcon) {
			iconSize.wrappedValue = 30 + 14 - (abs(tabOffset.wrappedValue)/self.thresholdIcon)*14  // positive num: up, negative: down
		} else {
			iconSize.wrappedValue = 30
		}
	}
	
}


struct SettingsView: View {
	@EnvironmentObject var gameStatusData: GameStatusData
	@Binding var showingSettings: Bool
	
	var body: some View{
		VStack{
			Text("これがテスト")
			Button(action: {
				showingSettings = false
			})
			{
				Image(systemName: "xmark.octagon")
					.resizable()
					.frame(width: 30, height: 30)
			}
		}
	}
}


struct HomeScreenMenu: View{
	@EnvironmentObject var gameStatusData: GameStatusData
	@EnvironmentObject var gameProgress: GameProgress
	@State var isGearPushed = false
	@State var isAlertShown = false
	@State var gearImageName = "gearshape"
	@Binding var showingSettings: Bool
	
	var body: some View{
		HStack{
			Button(action: {
				isAlertShown = true
			})
			{
				Text("TITLE")
					.frame(height: 30)
					.font(.title)
			}
			.textFrameSimple()
			.alert("タイトルに戻りますか？", isPresented: $isAlertShown){
				Button("はい"){
					gameStatusData.game_status = .titleScreen
					isAlertShown = false
				}
				Button("いいえ", role:.cancel){}
			}
			
			Spacer()
			
			Button(action: {
				showingSettings = true
			}){
				Image(systemName: gearImageName)
					.resizable()
					.frame(width: 30, height: 30)
			}
			.simultaneousGesture(LongPressGesture().onChanged { _ in
				gearImageName = "gearshape.fill"
			})
			.simultaneousGesture(TapGesture().onEnded {
				gearImageName = "gearshape"
			})
		}
		.padding()
		.background(Color(red: 0.0, green: 0.0, blue: 0.0, opacity: 0.5))
		.uiAnimationRToL(animationFlag: $gameProgress.game_start_flag, delay: 0.2)
		
		Rectangle()  // a bar below TITLE, CONFIG UI
			.foregroundColor(Color(red: 0.95, green: 0.9, blue: 0.80, opacity: 1.0))
			.frame(height: 2)
			.uiAnimationRToL(animationFlag: $gameProgress.game_start_flag, delay: 0.1)
		
	}
}


struct ScrollBarView: View{
	@EnvironmentObject var gameStatusData: GameStatusData
	@EnvironmentObject var gameProgress: GameProgress
	@Binding var currentTab: Int
	@Binding var threeOffSetTab: CGFloat
	@Binding var iconOffsetTab0: CGFloat
	@Binding var iconOffsetTab1: CGFloat
	@Binding var iconOffsetTab2: CGFloat
	@Binding var iconSize0: CGFloat
	@Binding var iconSize1: CGFloat
	@Binding var iconSize2: CGFloat
	
	var body: some View{
		ZStack{
			HStack(spacing: 0){
				Rectangle()
					.fill(Color(red: 0.2, green: 0.2, blue: 0.2))
					.frame(width: gameStatusData.fullScreenSize.width/3, height: 50)
					.onTapGesture {
						currentTab = 0
					}
				Rectangle()
					.fill(Color(red: 0.2, green: 0.2, blue: 0.2))
					.frame(width: gameStatusData.fullScreenSize.width/3, height: 50)
					.onTapGesture {
						currentTab = 1
					}
				Rectangle()
					.fill(Color(red: 0.2, green: 0.2, blue: 0.2))
					.frame(width: gameStatusData.fullScreenSize.width/3, height: 50)
					.onTapGesture {
						currentTab = 2
					}
			}
			
			Rectangle()
				.fill(Color(red: 0.5, green: 0.5, blue: 0.8))
				.frame(width: (gameStatusData.fullScreenSize.width/3), height: 50)
				.offset(x: (threeOffSetTab/3) - (gameStatusData.fullScreenSize.width/3))
			let _ = print("\(threeOffSetTab), SIZE(\(gameStatusData.fullScreenSize.width))")
			
			Image(systemName: iconSize0 == 30 ? "square.and.pencil.circle" : "square.and.pencil.circle.fill")
				.foregroundColor(.white)
				.font(.system(size: iconSize0))
				.offset(x: -(gameStatusData.fullScreenSize.width/6)*2, y: iconOffsetTab0)
			Image(systemName: iconSize1 == 30 ? "gamecontroller" : "gamecontroller.fill")
				.foregroundColor(.white)
				.font(.system(size: iconSize1))
				.offset(y: iconOffsetTab1)
			Image(systemName: iconSize2 == 30 ? "text.book.closed" : "text.book.closed.fill")
				.foregroundColor(.white)
				.font(.system(size: iconSize2))
				.offset(x: (gameStatusData.fullScreenSize.width/6)*2 ,y: iconOffsetTab2)
		}
		.uiAnimationRToL(animationFlag: $gameProgress.game_start_flag, delay: 0.4)
	}
}


struct BeforeHomeScreen: View {
	@EnvironmentObject var gameStatusData: GameStatusData
	@State var isAnimeDone: Bool = false
	private let delay: Double = 1.4
	
	var body: some View {
		ZStack {
			if isAnimeDone == false{
				LoopTransitionBackGround(offset: CGSize(width: 0,
														height: 0))
				.onAppear(){
					startScrolling()
				}
			}else{
				ZStack{
					Rectangle()
						.foregroundColor(.black)
						.ignoresSafeArea()
					Image(gameStatusData.currentTheme.loghouseBackground)
						.resizable()
						.scaledToFit()
						.ignoresSafeArea()
						.frame(width: gameStatusData.fullScreenSize.width,
							   height: gameStatusData.fullScreenSize.height)
						.clipped()
					HomeScreenView(offsetTab0: -gameStatusData.fullScreenSize.width,
								   offsetTab2: gameStatusData.fullScreenSize.width,
								   threeOffSetTab: gameStatusData.fullScreenSize.width,
								   thresholdIcon: gameStatusData.fullScreenSize.width/6)
				}
			}
		}
	}
	
	func startScrolling() {
		DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
				isAnimeDone = true
			}
	}
}
