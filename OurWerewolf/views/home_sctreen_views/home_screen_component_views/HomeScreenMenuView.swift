//
//  HomeScreenMenuView.swift
//  werewolf_ver5
//
//  Created by Masanori Sudo on 2024/12/17.
//

import SwiftUI


struct HomeScreenMenu: View {
	@EnvironmentObject var gameStatusData: GameStatusData
	@EnvironmentObject var gameProgress: GameProgress
	@State var isGearPushed = false
	@State var isAlertShown = false
	@State var gearImageName = "gearshape"
	@Binding var showingSettings: Bool
	let highlightColor: Color = Color(red: 0.8, green: 0.5, blue: 0.6)
	
	var body: some View{
		VStack(spacing:0){
			HStack(alignment: .center){
				Button(action: {
					isAlertShown = true
				}){
					HStack(spacing: 2){
						Image(systemName: "arrowshape.turn.up.left")
							.font(.title2)
						Text("TITLE")
							.font(.title)
					}
					.frame(height: 30)
					.fontWeight(.semibold)
					.foregroundColor(.blue)
				}
				.alert("タイトルに戻りますか？", isPresented: $isAlertShown){
					Button("はい"){
						gameStatusData.game_status = .toTitleScreen
						isAlertShown = false
					}
					Button("いいえ", role:.cancel){}
				}
				Spacer()
				
				HStack(spacing: 1){
					Text("プレイヤー数：")
						.foregroundStyle(.white)
					Text("\(gameStatusData.players_CONFIG.count)")
						.foregroundStyle(highlightColor)
					Text("人")
						.foregroundStyle(.white)
				}
				.fontWeight(.semibold)
				.font(.title3)
				
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
}

