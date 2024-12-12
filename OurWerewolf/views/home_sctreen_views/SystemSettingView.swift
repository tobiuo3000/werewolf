//
//  SystemSettingView.swift
//  werewolf_ver5
//
//  Created by Masanori Sudo on 2024/11/20.
//

import SwiftUI


struct SettingsView: View {
	@EnvironmentObject var gameStatusData: GameStatusData
	@EnvironmentObject var gameProgress: GameProgress
	@Binding var showingSettings: Bool
	let viewColor: Color = Color(red: 0.1, green: 0.1, blue: 0.1)
	
	
	func controllSounds(){
		if gameStatusData.isBGMPlayed == true && gameStatusData.isENVPlayed == true{
			gameStatusData.soundMuted = false
			gameStatusData.soundTheme = .mixed
		}else if gameStatusData.isBGMPlayed == true && gameStatusData.isENVPlayed == false{
			gameStatusData.soundMuted = false
			gameStatusData.soundTheme = .only_BGM
		}else if gameStatusData.isBGMPlayed == false && gameStatusData.isENVPlayed == true{
			gameStatusData.soundMuted = false
			gameStatusData.soundTheme = .only_ENV
		}else{
			gameStatusData.soundMuted = true
		}
		let _ = print("current theme: \(gameStatusData.soundTheme)")
	}
	
	var body: some View{
		ZStack{  // for darken background View
			Color.black.opacity(0.4)
			VStack{
				Rectangle()
					.fill(.clear)
					.frame(height: gameStatusData.fullScreenSize.height/4)
				
				HStack{
					Rectangle()
						.fill(.clear)
						.frame(width: gameStatusData.fullScreenSize.width/16)
					ZStack{
						
						VStack{
							ZStack{
								Text("アプリ設定画面")
									.font(.title)
									.foregroundColor(.white)
									.padding()
								HStack{
									Spacer()
									Button(action: {
										showingSettings = false
									})
									{
										Image(systemName: "xmark.octagon")
											.font(.largeTitle)
									}
									.padding()
								}
							}
							Spacer()
							Toggle(isOn: $gameStatusData.isBGMPlayed) {
								Text("BGMを流す")
									.font(.title2)
									.foregroundColor(.white)
							}
							.padding()
							.onChange(of: gameStatusData.isBGMPlayed){ new in
								controllSounds()
							}
							
							Toggle(isOn: $gameStatusData.isENVPlayed) {
								Text("環境音を流す")
									.font(.title2)
									.foregroundColor(.white)
							}
							.padding()
							.onChange(of: gameStatusData.isENVPlayed){ new in
								controllSounds()
							}
							
							Toggle(isOn: $gameStatusData.isAnimeShown) {
								Text("背景アニメを動かす")
									.font(.title2)
									.foregroundColor(.white)
							}
							.padding()
							Spacer()
						}
					}  // ZStack closure
					.background(viewColor)
					.cornerRadius(20)
					
					Rectangle()
						.fill(.clear)
						.frame(width: gameStatusData.fullScreenSize.width/16)
				}
				Rectangle()
					.fill(.clear)
					.frame(height: gameStatusData.fullScreenSize.height/4)
			}
		}
	}
}

