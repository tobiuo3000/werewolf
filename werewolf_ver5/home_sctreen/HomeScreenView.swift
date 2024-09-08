import SwiftUI

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
		withAnimation(Animation.easeInOut(duration: 0.2)) {
			opacity = 0
		}
		DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
			withAnimation(.easeInOut(duration: 0.4)) {
				opacity = 1.0
			}
		}
	}
}

/*
struct UIGatheringHomeScreen: View{
	
	var body: some View{
		
	}
}
*/

struct BeforeHomeScreen: View {
	@EnvironmentObject var gameStatusData: GameStatusData
	@State var isAnimeDone: Bool = false
	
	var body: some View {
		ZStack {
			LoopTransitionBackGround(offset: CGSize(width: 0,
													height: 0))
			
		}
	}
}


struct HomeScreenView: View {
	@EnvironmentObject var gameStatusData: GameStatusData
	@State var currentTab = 0
	@State private var offset1: CGFloat = 100
	@State private var offset2: CGFloat = 100
	@State private var offset3: CGFloat = 100
	@State var showingSettings = false
	var thresholdIcon: CGFloat
	
	var iconOffset1: CGFloat {
		if (-thresholdIcon <= offset1) && (offset1 <= thresholdIcon) {
			return (abs(offset1)/thresholdIcon)*15 - 15
		} else {
			return 0
		}
	}
	var iconOffset2: CGFloat {
		if (-thresholdIcon <= offset2) && (offset2 <= thresholdIcon) {
			return (abs(offset2)/thresholdIcon)*15 - 15
		} else {
			return 0
		}
	}
	var iconOffset3: CGFloat {
		if (-thresholdIcon <= offset3) && (offset3 <= thresholdIcon) {
			return (abs(offset3)/thresholdIcon)*15 - 15
		} else {
			return 0
		}
	}
	
	
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
							self.offset1 = offset
						}
					
					BeforeGameView(beforeGameViewOffset: $offset2)
						.tag(1)
						.overlay(
							OffsetProxy()
						)
						.onPreferenceChange(OffsetKey.self) { offset in
							self.offset2 = offset
						}
					
					Theme_Config()
						.tag(2)
						.overlay(
							OffsetProxy()
						)
						.onPreferenceChange(OffsetKey.self) { offset in
							self.offset3 = offset
						}
				}
				.tabViewStyle(.page(indexDisplayMode: .never))
				.animation(.easeInOut, value: currentTab)
				
				ScrollBarView(currentTab: $currentTab, offset1: $offset1, offset2: $offset2, offset3: $offset3, iconOffset1: iconOffset1, iconOffset2: iconOffset2, iconOffset3: iconOffset3)
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
	@Binding var offset1: CGFloat
	@Binding var offset2: CGFloat
	@Binding var offset3: CGFloat
	var iconOffset1: CGFloat
	var iconOffset2: CGFloat
	var iconOffset3: CGFloat
	
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
			
			
			if -(gameStatusData.fullScreenSize.width/2) < offset1 {  // -392.66 < offset < 392.66
				
				Rectangle()
					.fill(Color(red: 0.5, green: 0.5, blue: 0.8))
					.frame(width: (gameStatusData.fullScreenSize.width/3), height: 50)
				//.position(x: (GameStatusData.fullScreenSize.width / 4))
					.offset(x: -(gameStatusData.fullScreenSize.width/3) - (offset1/3))
				
			}else if -(gameStatusData.fullScreenSize.width/2) < offset2{
				Rectangle()
					.fill(Color(red: 0.5, green: 0.5, blue: 0.8))
					.frame(width: (gameStatusData.fullScreenSize.width/3), height: 50)
				//.position(x: (GameStatusData.fullScreenSize.width / 4))
					.offset(x: -(offset2/3))
			}else{
				Rectangle()
					.fill(Color(red: 0.5, green: 0.5, blue: 0.8))
					.frame(width: (gameStatusData.fullScreenSize.width/3), height: 50)
				//.position(x: (GameStatusData.fullScreenSize.width / 4))
					.offset(x: (gameStatusData.fullScreenSize.width/3) - (offset3/3))
			}
			Image(systemName: "square.and.pencil")
				.resizable()
				.foregroundColor(.white)
				.frame(width: 30, height: 30)
				.offset(x: -(gameStatusData.fullScreenSize.width/6)*2, y: iconOffset1)
			Image(systemName: "gamecontroller")
				.resizable()
				.foregroundColor(.white)
				.frame(width: 30, height: 30)
				.offset(y: iconOffset2)
			Image(systemName: "gamecontroller")
				.resizable()
				.foregroundColor(.white)
				.frame(width: 30, height: 30)
				.offset(x: (gameStatusData.fullScreenSize.width/6)*2 ,y: iconOffset3)
		}
		.uiAnimationRToL(animationFlag: $gameProgress.game_start_flag, delay: 0.4)
	}
}

