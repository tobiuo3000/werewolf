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
	@EnvironmentObject var gameProgress: GameProgress  // to distinguish win/lose
	@State var videoFileName: String = " "
	@State var instanceForSound: AVAudioPlayer!
	
	private func playSound(){
		instanceForSound.stop()
		instanceForSound.currentTime = 0.0
		instanceForSound.play()
		instanceForSound.numberOfLoops = -1
	}
	
	private func continuePlayingSound(){
		instanceForSound.stop()
		instanceForSound.play()
		instanceForSound.numberOfLoops = -1
	}
	
	private func stopSound(){
		instanceForSound.stop()
	}
	
	private func detectsFilename(){
		if gameStatusData.game_status == .titleScreen{
			self.videoFileName = gameStatusData.soundTheme.titleScreen
		}else if gameStatusData.game_status == .homeScreen{
			self.videoFileName = gameStatusData.soundTheme.homeScreen
		}else if gameStatusData.game_status == .gameScreen{
			self.videoFileName = gameStatusData.soundTheme.gameScreen
		}else if gameStatusData.game_status == .gameOverScreen{
			if gameProgress.game_result == 1{
				self.videoFileName = gameStatusData.soundTheme.werewolfWinScreen
			}else{
				self.videoFileName = gameStatusData.soundTheme.villagerWinScreen
			}
		}
		let _ = print("file name: \(videoFileName)")
	}
	
	var body: some View {
		if gameStatusData.soundMuted == false{
			VStack{
			}
			.onAppear(){
				detectsFilename()
				do {
					instanceForSound = try AVAudioPlayer(data: NSDataAsset(name: videoFileName)!.data)
				} catch {
					print("Failed to initialize AVAudioPlayer: \(error)")
				}
				NotificationCenter.default.addObserver(forName: UIApplication.willEnterForegroundNotification, object: nil, queue: .main) { _ in
					instanceForSound?.play()
				}
				instanceForSound.setVolume(0.05, fadeDuration: 0.4)
				playSound()
			}
			.onChange(of: gameStatusData.soundMuted){ new in
				if new == true{
					stopSound()
				}else{
					playSound()
				}
			}
			.onChange(of: gameStatusData.soundTheme){ new in
				stopSound()
				detectsFilename()
				instanceForSound = try!  AVAudioPlayer(data: NSDataAsset(name: videoFileName)!.data)
				instanceForSound.setVolume(0.35, fadeDuration: 0.4)
				continuePlayingSound()
			}
			.onDisappear {
				stopSound()
				NotificationCenter.default.removeObserver(self, name: UIApplication.willEnterForegroundNotification, object: nil)
			}
		}
	}
}

