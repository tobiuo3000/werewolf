import SwiftUI
import AVKit

class PlayerUIView: UIView {
	private var player: AVPlayer?
	private var playerLayer: AVPlayerLayer?
	
	// 初期化時に動画のURLを受け取る
	init(frame: CGRect, url: URL) {
		super.init(frame: frame)
		setupPlayer(url: url)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	// プレイヤーの設定
	private func setupPlayer(url: URL) {
		self.player = AVPlayer(url: url)
		self.playerLayer = AVPlayerLayer(player: player)
		self.playerLayer?.frame = self.bounds
		self.playerLayer?.videoGravity = .resizeAspectFill
		if let playerLayer = self.playerLayer {
			self.layer.addSublayer(playerLayer)
		}
	}
	
	// ビューのサイズが変更された時にレイヤーのサイズも更新
	override func layoutSubviews() {
		super.layoutSubviews()
		playerLayer?.frame = self.bounds
		playerLayer?.position = CGPoint(x: self.bounds.midX, y: self.bounds.midY)
	}
	
	// 再生
	func play() {
		player?.play()
	}
	
	// 一時停止
	func pause() {
		player?.pause()
	}
	
	private func addLooping() {
		NotificationCenter.default.addObserver(self,
											   selector: #selector(loopVideo),
											   name: .AVPlayerItemDidPlayToEndTime,
											   object: self.player?.currentItem)
	}
	
	@objc private func loopVideo() {
		self.player?.seek(to: .zero)
		self.player?.play()
	}
	
	// リソースの解放
	deinit {
		NotificationCenter.default.removeObserver(self)
		player?.pause()
		player = nil
	}
}

struct VideoPlayerView: UIViewRepresentable {
	var videoFileName: String
	var videoFileType: String
	var isPlaying: Bool = true
	
	func makeUIView(context: Context) -> UIView {
		let path = Bundle.main.path(forResource: videoFileName, ofType: videoFileType)!
		let url = URL(fileURLWithPath: path)
		return PlayerUIView(frame: .zero, url: url)
	}
	
	func updateUIView(_ uiView: UIView, context: Context) {
		guard let playerView = uiView as? PlayerUIView else { return }
		if isPlaying {
			playerView.play()
		} else {
			playerView.pause()
		}
	}
	
	func makeCoordinator() -> Coordinator {
		Coordinator(self)
	}
	
	class Coordinator {
		var parent: VideoPlayerView
		
		init(_ parent: VideoPlayerView) {
			self.parent = parent
		}
	}
}

