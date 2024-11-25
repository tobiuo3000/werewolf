//
//  GlobalmenuHomeScreen.swift
//  werewolf_ver5
//
//  Created by Masanori Sudo on 2024/11/25.
//

import SwiftUI

struct ScrollBarView: View{
	@EnvironmentObject var gameStatusData: GameStatusData
	@EnvironmentObject var gameProgress: GameProgress
	@Binding var currentTab: Int
	@Binding var iconOffsetTab0: CGFloat
	@Binding var iconOffsetTab1: CGFloat
	@Binding var iconOffsetTab2: CGFloat
	@Binding var iconSize0: CGFloat
	@Binding var iconSize1: CGFloat
	@Binding var iconSize2: CGFloat
	@State var isBounced: Bool = true
	let triangleConst:CGFloat = 46
	let intervalTriangle: CGFloat = 0.8
	
	var body: some View{
		//let _ = print("\(threeOffSetTab), SIZE(\(gameStatusData.fullScreenSize.width))")
		
		ZStack{
			HStack(spacing: 0){
				Rectangle()
					.fill(Color(red: 0.2, green: 0.2, blue: 0.2))
					.frame(width: gameStatusData.fullScreenSize.width/3, height: gameStatusData.fullScreenSize.height/16)
					.onTapGesture {
						currentTab = 0
					}
				Rectangle()
					.fill(Color(red: 0.2, green: 0.2, blue: 0.2))
					.frame(width: gameStatusData.fullScreenSize.width/3, height: gameStatusData.fullScreenSize.height/16)
					.onTapGesture {
						currentTab = 1
					}
				Rectangle()
					.fill(Color(red: 0.2, green: 0.2, blue: 0.2))
					.frame(width: gameStatusData.fullScreenSize.width/3, height: gameStatusData.fullScreenSize.height/16)
					.onTapGesture {
						currentTab = 2
					}
			}
			
			Rectangle()
				.fill(Color(red: 0.5, green: 0.5, blue: 0.8))
				.frame(width: (gameStatusData.fullScreenSize.width/3), height: gameStatusData.fullScreenSize.height/16)
				.offset(x: (gameStatusData.threeOffSetTab/3) - (gameStatusData.fullScreenSize.width/3))
			
			ZStack{  // for code readability
				if iconSize0 != 30 {
					Image(systemName: "arrowtriangle.right.fill")
						.foregroundColor(.white)
						.offset(x: -(gameStatusData.fullScreenSize.width/6)*2+triangleConst, y: iconOffsetTab0)
						.flickeringUI(interval: intervalTriangle)
				}
				Image(systemName: iconSize0 == 30 ? "square.and.pencil.circle" : "square.and.pencil.circle.fill")
					.foregroundColor(.white)
					.font(.system(size: iconSize0))
					.offset(x: -(gameStatusData.fullScreenSize.width/6)*2, y: iconOffsetTab0)
			}
			
			ZStack{  // for code readability
				if iconSize1 != 30 {
					Image(systemName: "arrowtriangle.backward.fill")
						.foregroundColor(.white)
						.offset(x: -triangleConst, y: iconOffsetTab0-8)
						.flickeringUI(interval: intervalTriangle)
					Image(systemName: "arrowtriangle.right.fill")
						.foregroundColor(.white)
						.offset(x: +triangleConst, y: iconOffsetTab0-8)
						.flickeringUI(interval: intervalTriangle)
				}
				Image(iconSize1 == 30 ? "wolf_tabIcon" : "wolf_tabIcon_fill")
					.resizable()
					.frame(width: iconSize1*(1.2), height: iconSize1*(1.2))  // 1.4 to make adjustments to the image size
					.offset(x: 0, y: iconOffsetTab1)
			}
			
			ZStack{  // for code readability
				if iconSize2 != 30 {
					Image(systemName: "arrowtriangle.backward.fill")
						.foregroundColor(.white)
						.offset(x: (gameStatusData.fullScreenSize.width/6)*2-triangleConst, y: iconOffsetTab2)
						.flickeringUI(interval: intervalTriangle)
				}
				Image(systemName: iconSize2 == 30 ? "text.book.closed" : "text.book.closed.fill")
					.foregroundColor(.white)
					.font(.system(size: iconSize2))
					.offset(x: (gameStatusData.fullScreenSize.width/6)*2 ,y: iconOffsetTab2)
			}
		}
		.uiAnimationRToL(animationFlag: $gameProgress.game_start_flag, delay: 0.4)

	}
}

