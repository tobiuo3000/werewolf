//
//  AudioPlaying.swift
//  werewolf_ver5
//
//  Created by Masanori Sudo on 2024/11/14.
//

import SwiftUI
import AVFoundation

struct AudioPlayerView: View {
	@EnvironmentObject var gameStatusData: GameStatusData
	var videoFileName: String
	let instanceForSound: AVAudioPlayer
	
	init(videoFileName: String) {
		self.videoFileName = videoFileName
		instanceForSound = try!  AVAudioPlayer(data: NSDataAsset(name: videoFileName)!.data)
	}
	
	private func playSound(){
		instanceForSound.stop()
		instanceForSound.currentTime = 0.0
		instanceForSound.play()
	}
	
	private func stopSound(){
		instanceForSound.stop()
	}
	
	var body: some View {
		VStack{
		}
		.onAppear(){
			playSound()
		}
		.onDisappear {
			stopSound()
		}
	}
}

