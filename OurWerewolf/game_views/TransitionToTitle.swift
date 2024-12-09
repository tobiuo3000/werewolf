//
//  TransitionToTitle.swift
//  werewolf_ver5
//
//  Created by Masanori Sudo on 2024/12/09.
//

import SwiftUI


struct toTitleView: View{
	@EnvironmentObject var gameStatusData: GameStatusData
	private let delay: Double = 1.4
	
	var body: some View{
		TransitionLoopBackGround(offset: CGSize(width: 0,
												height: 0))
		.onAppear(){
			DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
				gameStatusData.game_status = .titleScreen
			}
		}
	}
}


