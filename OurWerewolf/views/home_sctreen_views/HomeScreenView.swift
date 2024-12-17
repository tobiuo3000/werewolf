import SwiftUI

/*
 画像解像度の目安
 →iphone16 pro maxは1320*2868(9:19.6)
 */

struct HomeScreenView: View {
	@EnvironmentObject var gameStatusData: GameStatusData
	@State var currentTab = 1  // decide first appearance tab
	@State var offsetTab0: CGFloat
	@State private var offsetTab1: CGFloat = 0
	@State var offsetTab2: CGFloat
	@State private var showingSettings = false
	@State private var iconOffsetTab0: CGFloat = 3
	@State private var iconOffsetTab1: CGFloat = 3
	@State private var iconOffsetTab2: CGFloat = 3
	@State var iconSize0: CGFloat = 30
	@State var iconSize1: CGFloat = 30
	@State var iconSize2: CGFloat = 30
	var thresholdIcon: CGFloat
	
	var body: some View {
		AudioPlayerView()
			.onAppear(){  // to init iconSize Variables
				iconSize0 = gameStatusData.fullScreenSize.height/20
				iconSize1 = gameStatusData.fullScreenSize.height/20
				iconSize2 = gameStatusData.fullScreenSize.height/20
			}
		
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
							calcOffsetThreeTab()
							calcIconOffset(arg_iconOffsetTab0: $iconOffsetTab0, arg_iconOffsetTab1: $iconOffsetTab1, arg_iconOffsetTab2: $iconOffsetTab2, arg_iconSize0: $iconSize0, arg_iconSize1: $iconSize1, arg_iconSize2: $iconSize2, arg_tabOffsetTab0: $offsetTab0, arg_tabOffsetTab1: $offsetTab1, arg_tabOffsetTab2: $offsetTab2)
						}
					
					BeforeGameView()
						.tag(1)
						.overlay(
							OffsetProxy()
						)
						.onPreferenceChange(OffsetKey.self) { offset in
							self.offsetTab1 = offset
							calcOffsetThreeTab()
							calcIconOffset(arg_iconOffsetTab0: $iconOffsetTab0, arg_iconOffsetTab1: $iconOffsetTab1, arg_iconOffsetTab2: $iconOffsetTab2, arg_iconSize0: $iconSize0, arg_iconSize1: $iconSize1, arg_iconSize2: $iconSize2, arg_tabOffsetTab0: $offsetTab0, arg_tabOffsetTab1: $offsetTab1, arg_tabOffsetTab2: $offsetTab2)
						}
					
					Theme_Config()
						.tag(2)
						.overlay(
							OffsetProxy()
						)
						.onPreferenceChange(OffsetKey.self) { offset in
							self.offsetTab2 = offset
							calcOffsetThreeTab()
							calcIconOffset(arg_iconOffsetTab0: $iconOffsetTab0, arg_iconOffsetTab1: $iconOffsetTab1, arg_iconOffsetTab2: $iconOffsetTab2, arg_iconSize0: $iconSize0, arg_iconSize1: $iconSize1, arg_iconSize2: $iconSize2, arg_tabOffsetTab0: $offsetTab0, arg_tabOffsetTab1: $offsetTab1, arg_tabOffsetTab2: $offsetTab2)
						}
				}
				.tabViewStyle(.page(indexDisplayMode: .never))
				.animation(.easeInOut, value: currentTab)
			}
			.disabled(showingSettings)
			.disabled(gameStatusData.isReorderingViewShown)
			
			if gameStatusData.isReorderingViewShown == false {
				ScrollBarView(currentTab: $currentTab, iconOffsetTab0: $iconOffsetTab0,
							  iconOffsetTab1: $iconOffsetTab1, iconOffsetTab2: $iconOffsetTab2,
							  iconSize0: $iconSize0, iconSize1: $iconSize1, iconSize2: $iconSize2)
				.position(CGPoint(x: Int(gameStatusData.fullScreenSize.width/2),
								  y: Int(gameStatusData.fullScreenSize.height/32*31)+5))  // 5 is for adjustment
			}
			
			if showingSettings == true{
				SettingsView(showingSettings: $showingSettings)
			}
			if gameStatusData.isReorderingViewShown == true {
				ReorderingPlayerView()  // wanna fix in this View
				
			}
		}
	}
	
	func calcOffsetThreeTab() {
		if self.offsetTab0 >= 0{
			gameStatusData.threeOffSetTab = 0
		} else if self.offsetTab0 < 0 && self.offsetTab1 >= 0 {
			gameStatusData.threeOffSetTab = -(self.offsetTab0)
		} else if self.offsetTab1 < 0 && self.offsetTab2 >= 0 {
			gameStatusData.threeOffSetTab = (gameStatusData.fullScreenSize.width) - self.offsetTab1
		} else {
			gameStatusData.threeOffSetTab = (2*(gameStatusData.fullScreenSize.width))
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
	
	func _calcIconOffset(iconOffset: Binding<CGFloat>, tabOffset: Binding<CGFloat>){
		if (-self.thresholdIcon <= tabOffset.wrappedValue) && (tabOffset.wrappedValue <= self.thresholdIcon) {
			iconOffset.wrappedValue = (abs(tabOffset.wrappedValue)/self.thresholdIcon)*6 - 6
			// positive num: up, negative: down
			// thresholdIcon: gameStatusData.fullScreenSize.width/6
		} else {
			iconOffset.wrappedValue = 3
		}
	}
	
	func _calcIconSize(iconSize: Binding<CGFloat>, tabOffset: Binding<CGFloat>){
		if (-self.thresholdIcon <= tabOffset.wrappedValue) && (tabOffset.wrappedValue <= self.thresholdIcon) {
			iconSize.wrappedValue = 30 + 14 - (abs(tabOffset.wrappedValue)/self.thresholdIcon)*14  // positive num: up, negative: down
		} else {
			iconSize.wrappedValue = 30
		}
	}
}




