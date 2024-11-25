//
//  AudioPlaying.swift
//  werewolf_ver5
//
//  Created by Masanori Sudo on 2024/11/14.
//

import SwiftUI
import AVFoundation


class AudioPlayerManager: ObservableObject {
	var instanceForSound: AVAudioPlayer?
	
	@objc func myInit(fileName: String) {
		do {
			instanceForSound = try AVAudioPlayer(data: NSDataAsset(name: fileName)!.data)
			instanceForSound?.setVolume(0.05, fadeDuration: 0.01)
			instanceForSound?.numberOfLoops = -1
		} catch {
			print("Failed to initialize AVAudioPlayer: \(error)")
		}
		
		NotificationCenter.default.addObserver(self, selector: #selector(playSound), name: UIApplication.willEnterForegroundNotification, object: nil)
	}
	
	@objc func setSoundFile(fileName: String) {
		do {
			instanceForSound = try AVAudioPlayer(data: NSDataAsset(name: fileName)!.data)
			instanceForSound?.setVolume(0.05, fadeDuration: 0.01)
			instanceForSound?.numberOfLoops = -1
		} catch {
			print("Failed to initialize AVAudioPlayer: \(error)")
		}
	}
	
	@objc private func playSound() {
		instanceForSound?.play()
	}
	
	deinit {
		NotificationCenter.default.removeObserver(self, name: UIApplication.willEnterForegroundNotification, object: nil)
	}
}


struct AudioPlayerView: View {
	@StateObject private var audioManager = AudioPlayerManager()
	@EnvironmentObject var gameStatusData: GameStatusData
	@EnvironmentObject var gameProgress: GameProgress  // to distinguish win/lose
	@State var videoFileName: String = " "
	
	private func audioInit(){
		audioManager.myInit(fileName: videoFileName)
		audioManager.instanceForSound?.play()
	}
	
	private func playSound(){
		audioManager.instanceForSound?.play()
	}
	
	private func stopSound(){
		audioManager.instanceForSound?.stop()
	}
	
	private func detectAndSetAFilename(){
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
	
	private func setFilenameToManager(){
		audioManager.setSoundFile(fileName: videoFileName)
	}
	
	var body: some View {
		if gameStatusData.soundMuted == false{
			VStack{
			}
			.onAppear(){
				detectAndSetAFilename()
				audioInit()
			}
			.onChange(of: gameStatusData.soundMuted){ new in
				if new == true{
					stopSound()
				}else{
					stopSound()
					detectAndSetAFilename()
					setFilenameToManager()
					playSound()
				}
			}
			.onChange(of: gameStatusData.soundTheme){ new in
				stopSound()
				detectAndSetAFilename()
				setFilenameToManager()
				playSound()
			}
			.onChange(of: gameStatusData.game_status){ new in
				stopSound()
				detectAndSetAFilename()
				setFilenameToManager()
				playSound()
			}
			.onDisappear {
				stopSound()
			}
		}
	}
}


struct ButtonSEStruct {
	var videoFileName: String
	var instanceForSound: AVAudioPlayer!
	
	init(videoFileName: String = "buttonPushed") {
		self.videoFileName = videoFileName
		do{
			instanceForSound = try AVAudioPlayer(data: NSDataAsset(name: videoFileName)!.data)
		}
		catch{
			let _ = print("file not found error")
		}
	}
	
	func playSound(){
		let _ = print("button sound")
		
	}
	
	func stopSound(){
		instanceForSound.stop()
	}
}



