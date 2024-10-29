import SwiftUI
import AVKit
import Combine


class LoopingVideoManager: NSObject, ObservableObject {
	private var queuePlayer: AVQueuePlayer!
	private var playerLooper: AVPlayerLooper!
	private var playerItem: AVPlayerItem!
	
	init(url: URL) {
		super.init()  // 'self'を使用する前に'super.init()'を呼び出す
		
		// AVAudioSessionの設定を追加
		do {
			try AVAudioSession.sharedInstance().setCategory(.playback, mode: .moviePlayback, options: [])
			try AVAudioSession.sharedInstance().setActive(true)
			print("AVAudioSessionの設定に成功しました")
		} catch {
			print("AVAudioSessionの設定に失敗しました: \(error)")
		}
		
		// 既存のplayerItemの初期化など
		self.playerItem = AVPlayerItem(url: url)
		queuePlayer = AVQueuePlayer(items: [self.playerItem])
		queuePlayer.isMuted = false
		playerLooper = AVPlayerLooper(player: queuePlayer, templateItem: self.playerItem)
		
		// AVPlayerItemのステータスを監視
		playerItem.addObserver(self, forKeyPath: "status", options: [.old, .new], context: nil)
		
		NotificationCenter.default.addObserver(forName: UIApplication.willEnterForegroundNotification, object: nil, queue: .main) { [weak self] _ in
			self?.queuePlayer.play()  // フォアグラウンドに戻ったときに再生再開
		}
	}
	
	deinit {
		playerItem.removeObserver(self, forKeyPath: "status")
		NotificationCenter.default.removeObserver(self)
	}
	
	override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
		if keyPath == "status" {
			switch playerItem.status {
			case .readyToPlay:
				print("動画の再生準備ができました")
			case .failed:
				if let error = playerItem.error {
					print("動画の読み込みに失敗しました: \(error.localizedDescription)")
				} else {
					print("動画の読み込みに失敗しました: 不明なエラー")
				}
			default:
				break
			}
		}
	}
	
	func getPlayer() -> AVQueuePlayer {
		return queuePlayer
	}
}


struct LoopingPlayerUIView: UIViewRepresentable {
	var player: AVQueuePlayer
	
	func makeUIView(context: Context) -> UIView {
		let view = UIView()
		
		let _ = print("makeUIView called")
		// AVPlayerLayerを作成してビューに追加
		let playerLayer = AVPlayerLayer(player: player)
		playerLayer.videoGravity = .resizeAspectFill
		playerLayer.frame = view.bounds
		
		view.layer.addSublayer(playerLayer)
		
		return view
	}
	
	func updateUIView(_ uiView: UIView, context: Context) {
		print("updateUIView called")
		// ビューが更新されたときにプレイヤーのフレームを更新
		if let playerLayer = uiView.layer.sublayers?.first as? AVPlayerLayer {
			playerLayer.frame = uiView.bounds  // フレームを親ビューのサイズに合わせる
			playerLayer.player = player
		}
	}
}


struct LoopingVideoView: View {
	@StateObject private var videoManager: LoopingVideoManager
	
	init(url: URL) {
		_videoManager = StateObject(wrappedValue: LoopingVideoManager(url: url))
	}
	
	var body: some View {
		LoopingPlayerUIView(player: videoManager.getPlayer())
			.onAppear {
				let _ = print("LoopingPlayerUIView appear")
				videoManager.getPlayer().play()  // 自動的に再生開始
			}
			.onDisappear {
				videoManager.getPlayer().pause()  // ビューが消えたときに停止
			}
	}
}


struct LoopVideoPlayerView: View {
	@EnvironmentObject var gameStatusData: GameStatusData
	var videoFileName: String
	var videoFileType: String
	var isPlaying: Bool = true
	var isScaledToFill: Bool
	
	init(videoFileName: String, videoFileType: String, isScaledToFill: Bool = true) {
		self.videoFileName = videoFileName
		self.videoFileType = videoFileType
		self.isScaledToFill = isScaledToFill
	}
	
	var body: some View {
		if isScaledToFill {
			let _ = print("scaledtofill")
			LoopingVideoView(url: makeUIView())
				.scaledToFit()
				.position(x: gameStatusData.fullScreenSize.width / 2,
						  y: gameStatusData.fullScreenSize.height / 2)
		} else {
			LoopingVideoView(url: makeUIView())
		}
	}
	
	func makeUIView() -> URL {
		if let path = Bundle.main.path(forResource: videoFileName, ofType: videoFileType){
			let url = URL(fileURLWithPath: path)
			let _ = print("video URL: \(url)")
			return url
		}else{
			let _ = print("file: \(videoFileName), type: \(videoFileType)")
			return URL(fileURLWithPath: "nil")
		}
	}
}




/*
 make 2nd version player
 */

/*
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
 */
