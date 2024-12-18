//
//  DiscussionTimeViews.swift
//  werewolf_ver5
//
//  Created by Masanori Sudo on 2024/10/28.
//

import SwiftUI


struct Before_discussion: View{
	@EnvironmentObject var gameStatusData: GameStatusData
	@EnvironmentObject var gameProgress: GameProgress
	private let columns: [GridItem] = Array(repeating: .init(.flexible()), count: 2)
	@State var isAlertShown: Bool = false
	let highlightColor: Color = Color(red: 0.8, green: 0.5, blue: 0.6)
	
	var body: some View{
		VStack{
			ListSurviversView()
			
			Spacer()
			Button("議論開始") {
				gameStatusData.buttonSE()
				isAlertShown = true
			}
			.myTextBackground()
			.myButtonBounce()
			.alert("\(gameStatusData.discussion_minutes_CONFIG)分\(gameStatusData.discussion_seconds_CONFIG)秒間の議論が開始します", isPresented: $isAlertShown){
				Button("議論を開始する"){
					gameProgress.reset_suspected_count()
					gameProgress.discussion_time = gameStatusData.discussion_time_CONFIG
					gameProgress.stageView = .Discussion_time
					let _ = print(gameProgress.get_diary_cur_day())
					let _ = print(gameProgress.get_diary_cur_day().day)
					let _ = print(gameProgress.get_diary_cur_day().id)
					if let p1 = gameProgress.get_diary_cur_day().executedPlayer {
						print("executed: \(p1)")
					}
					if let p2 = gameProgress.get_diary_cur_day().murderedPlayer {
						print("executed: \(p2)")
					}
				}
				Button("キャンセル", role: .cancel){
				}
			}
		}
	}
}


struct Discussion_time: View{
	@EnvironmentObject var gameStatusData: GameStatusData
	@EnvironmentObject var gameProgress: GameProgress
	@State var discussion_time: Int
	@State var isAlertShown: Bool = false
	
	var body: some View{
		VStack{
			Text("議論時間")
				.textFrameDesignProxy()
				.font(.title2)
			Spacer()
			Text("残り時間: \(discussion_time) 秒")
				.font(.largeTitle)
				.foregroundStyle(.white)
				.onAppear {
					Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
						if gameProgress.stageView != .Discussion_time {
							timer.invalidate()
						}
						
						if discussion_time > 0 {
							discussion_time -= 1
						} else {
							timer.invalidate()
							gameProgress.stageView = .Vote_time
						}
					}
				}
				.padding()
				.background(Color(red: 0.3, green: 0.3, blue: 0.4))
				.cornerRadius(20)
			HStack{
				Text("議論時間に１分追加: ")
					.foregroundStyle(.white)
					.font(.title3)
				Button(action: {
					discussion_time = discussion_time + 60
				}) {
					Image(systemName: "plus.app")
						.font(.title2)
						.foregroundColor(.blue)
				}
				.myButtonBounce()
			}
			.padding()
			Spacer()
			
			Button("議論終了") {
				gameStatusData.buttonSE()
				isAlertShown = true
			}
			.myTextBackground()
			.myButtonBounce()
			.alert("投票を開始しますか？", isPresented: $isAlertShown){
				Button("次へ"){
					gameProgress.stageView = .Vote_time
				}
				Button("キャンセル", role: .cancel){
				}
			}
			
			Rectangle()
				.fill(.clear)
				.frame(width: 40, height: 40)
		}
	}
}

