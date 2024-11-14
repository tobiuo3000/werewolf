//
//  AudioPlaying.swift
//  werewolf_ver5
//
//  Created by Masanori Sudo on 2024/11/14.
//

import SwiftUI
import AVFoundation

struct AudioPlayer: View {
   
	private let kirakiraSound = try!  AVAudioPlayer(data: NSDataAsset(name: "SE_kirakira01")!.data)
	
	private func playSound(){
		kirakiraSound.stop()
		kirakiraSound.currentTime = 0.0
		kirakiraSound.play()
	}
	
	var body: some View {
		Button(action: {
			playSound()//追加④　メソッド発動
		}) {
			Text("効果音再生")
				.font(.title)
		}
	}
}

