import SwiftUI
import AVKit
import Combine

class LoopingVideoManager: ObservableObject {
	private var queuePlayer: AVQueuePlayer!
	private var playerLooper: AVPlayerLooper!
	
	init(url: URL) {
		let playerItem = AVPlayerItem(url: url)
		queuePlayer = AVQueuePlayer(items: [playerItem])
		queuePlayer.isMuted = true
		playerLooper = AVPlayerLooper(player: queuePlayer, templateItem: playerItem)
		
		NotificationCenter.default.addObserver(forName: UIApplication.willEnterForegroundNotification, object: nil, queue: .main) { [weak self] _ in
			self?.queuePlayer.play()  // Safely restart playback on foreground
		}
	}
	
	func getPlayer() -> AVQueuePlayer {
		return queuePlayer
	}
}

struct LoopingVideoView: View {
	@StateObject private var videoManager: LoopingVideoManager
	
	init(url: URL) {
		_ = try? AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback, mode: .default, options: .mixWithOthers)  // to disable menu_player_UI
		_videoManager = StateObject(wrappedValue: LoopingVideoManager(url: url))
	}
	
	var body: some View {
		VideoPlayer(player: videoManager.getPlayer())
			.onAppear {
				videoManager.getPlayer().play()  // Automatically start video
			}
			.onDisappear {
				videoManager.getPlayer().pause()  // Pause video on disappear
			}
	}
}

struct LoopVideoPlayerView: View {
	@EnvironmentObject var gameStatusData: GameStatusData
	var videoFileName: String
	var videoFileType: String
	var isPlaying: Bool = true
	var isScaledToFill: Bool
	
	init(videoFileName: String, videoFileType: String,  isScaledToFill: Bool = true) {
		self.videoFileName = videoFileName
		self.videoFileType = videoFileType
		self.isScaledToFill = isScaledToFill
	}
	
	var body: some View{
		if isScaledToFill{
			LoopingVideoView(url: makeUIView())
				.scaledToFill()
				.position(x: gameStatusData.fullScreenSize.width/2,
						  y: gameStatusData.fullScreenSize.height/2)
		}else{
			LoopingVideoView(url: makeUIView())
		}
	}
	
	func makeUIView() -> URL {
		let path = Bundle.main.path(forResource: videoFileName, ofType: videoFileType)!
		let url = URL(fileURLWithPath: path)
		return url
	}
}

