

import SwiftUI
import AVFoundation


class GameStatusData: ObservableObject {
	@Published var game_status: gameStatus = .titleScreen
	var players_CONFIG: [Player]
	@Published var view_status_CONFIG: Int = 0
	@Published var discussion_minutes_CONFIG: Int {
		didSet {
			UserDefaults.standard.set(discussion_minutes_CONFIG, forKey: "discussion_minutes_CONFIG")
		}
	}
	@Published var discussion_seconds_CONFIG: Int {
		didSet {
			UserDefaults.standard.set(discussion_seconds_CONFIG, forKey: "discussion_seconds_CONFIG")
		}
	}
	@Published var discussion_time_CONFIG: Int = 0
	@Published var num_player_with_role: Int = 0
	@Published var villager_Count_CONFIG: Int {
		didSet {
			UserDefaults.standard.set(villager_Count_CONFIG, forKey: "villager_Count_CONFIG")
		}
	}
	@Published var werewolf_Count_CONFIG: Int = 1 {
		didSet {
			UserDefaults.standard.set(werewolf_Count_CONFIG, forKey: "werewolf_Count_CONFIG")
		}
	}
	@Published var seer_Count_CONFIG: Int = 0 {
		didSet {
			UserDefaults.standard.set(seer_Count_CONFIG, forKey: "seer_Count_CONFIG")
		}
	}
	@Published var medium_Count_CONFIG: Int = 0 {
		didSet {
			UserDefaults.standard.set(medium_Count_CONFIG, forKey: "medium_Count_CONFIG")
		}
	}
	@Published var hunter_Count_CONFIG: Int = 0 {
		didSet {
			UserDefaults.standard.set(hunter_Count_CONFIG, forKey: "hunter_Count_CONFIG")
		}
	}
	@Published var madman_Count_CONFIG: Int = 0 {
		didSet {
			UserDefaults.standard.set(madman_Count_CONFIG, forKey: "madman_Count_CONFIG")
		}
	}
	@Published var trainee_Count_CONFIG: Int = 0 {
		didSet {
			UserDefaults.standard.set(trainee_Count_CONFIG, forKey: "trainee_Count_CONFIG")
		}
	}
	@Published var trainee_Probability: Int = 60 {
		didSet {
			UserDefaults.standard.set(trainee_Probability, forKey: "trainee_Probability")
		}
	}
	@Published var _Count_CONFIG: Int = 0
	@Published var max_werewolf_CONFIG: Int = 1
	@Published var max_trainee_CONFIG: Int = 1
	@Published var existsPlayerWithoutRole: Bool = true
	@Published var currentTheme: AppTheme = .std_theme {
		didSet {
			UserDefaults.standard.set(currentTheme, forKey: "currentTheme")
		}
	}
	
	@Published var textSize: CGSize = .zero
	@Published var titleTextSize: CGSize = .zero
	@Published var fullScreenSize: CGSize = .zero
	@Published var cardSize: CGSize = CGSize(width: 630, height: 880)
	
	@Published var isAnimeShown: Bool {
		didSet {
			UserDefaults.standard.set(isAnimeShown, forKey: "isAnimeShown")
		}
	}
	@Published var isConsecutiveProtectionAllowed: Bool {
		didSet {
			UserDefaults.standard.set(isConsecutiveProtectionAllowed, forKey: "isConsecutiveProtectionAllowed")
		}
	}
	@Published var isFirstNightRandomSeer: Bool {
		didSet {
			UserDefaults.standard.set(isFirstNightRandomSeer, forKey: "isFirstNightRandomSeer")
		}
	}
	@Published var isVoteCountVisible: Bool {
		didSet {
			UserDefaults.standard.set(isVoteCountVisible, forKey: "isVoteCountVisible")
		}
	}
	@Published var isCardRoleImageShown: Bool = true
	@Published var requiresRunoffVote: Bool {
		didSet {
			UserDefaults.standard.set(requiresRunoffVote, forKey: "requiresRunoffVote")
		}
	}
	@Published var highlightColor: Color = Color(red: 0.8, green: 0.5, blue: 0.6)
	@Published var soundTheme: SoundTheme {
		didSet {
			UserDefaults.standard.set(soundTheme, forKey: "soundTheme")
		}
	}
	@Published var soundMuted: Bool {
		didSet {
			UserDefaults.standard.set(soundMuted, forKey: "soundMuted")
		}
	}
	@Published var isReorderingViewShown = false
	@Published var threeOffSetTab: CGFloat = 0
	@Published var isBGMPlayed: Bool {
		didSet {
			UserDefaults.standard.set(isBGMPlayed, forKey: "isBGMPlayed")
		}
	}
	@Published var isENVPlayed: Bool {
		didSet {
			UserDefaults.standard.set(isENVPlayed, forKey: "isENVPlayed")
		}
	}
	@Published var instanceForSound: AVAudioPlayer!
	
	init() {
		// UIWindowSceneから画面サイズを取得して保存
		if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
			if let mainWindow = windowScene.windows.first {
				self.fullScreenSize = mainWindow.bounds.size
			}
		}
		
		// Load UserDefautl Variavles
		discussion_minutes_CONFIG = UserDefaults.standard.object(forKey: "discussion_minutes_CONFIG") as? Int ?? 2
		discussion_seconds_CONFIG = UserDefaults.standard.object(forKey: "discussion_seconds_CONFIG") as? Int ?? 0
		villager_Count_CONFIG = UserDefaults.standard.object(forKey: "villager_Count_CONFIG") as? Int ?? 0
		werewolf_Count_CONFIG = UserDefaults.standard.object(forKey: "werewolf_Count_CONFIG") as? Int ?? 0
		madman_Count_CONFIG = UserDefaults.standard.object(forKey: "madman_Count_CONFIG") as? Int ?? 0
		seer_Count_CONFIG = UserDefaults.standard.object(forKey: "seer_Count_CONFIG") as? Int ?? 0
		trainee_Count_CONFIG = UserDefaults.standard.object(forKey: "trainee_Count_CONFIG") as? Int ?? 0
		hunter_Count_CONFIG = UserDefaults.standard.object(forKey: "hunter_Count_CONFIG") as? Int ?? 0
		medium_Count_CONFIG = UserDefaults.standard.object(forKey: "medium_Count_CONFIG") as? Int ?? 0
		trainee_Probability = UserDefaults.standard.object(forKey: "trainee_Probability") as? Int ?? 80
		currentTheme = UserDefaults.standard.object(forKey: "currentTheme") as? AppTheme ?? .std_theme
		isAnimeShown = UserDefaults.standard.object(forKey: "isAnimeShown") as? Bool ?? true
		isConsecutiveProtectionAllowed = UserDefaults.standard.object(forKey: "isConsecutiveProtectionAllowed") as? Bool ?? false
		isFirstNightRandomSeer = UserDefaults.standard.object(forKey: "isFirstNightRandomSeer") as? Bool ?? true
		isVoteCountVisible = UserDefaults.standard.object(forKey: "isVoteCountVisible") as? Bool ?? false
		requiresRunoffVote = UserDefaults.standard.object(forKey: "requiresRunoffVote") as? Bool ?? true
		soundTheme = UserDefaults.standard.object(forKey: "soundTheme") as? SoundTheme ?? .mixed
		soundMuted = UserDefaults.standard.object(forKey: "soundMuted") as? Bool ?? false
		isBGMPlayed = UserDefaults.standard.object(forKey: "isBGMPlayed") as? Bool ?? true
		isENVPlayed = UserDefaults.standard.object(forKey: "isENVPlayed") as? Bool ?? true
		do{
			instanceForSound = try AVAudioPlayer(data: NSDataAsset(name: "buttonPushed")!.data)
		}
		catch{
			let _ = print("file not found error")
		}
		
		players_CONFIG = []
		for order in 0...5-1 {
			let player = Player(player_order: order, role: Role.villager, player_name: "プレイヤー\(order+1)", isAlive: true)
			players_CONFIG.append(player)
		}
	}
	
	func changeTheme(to theme: AppTheme) {
		currentTheme = theme
	}
	
	func update_role_CONFIG(){
		self.calc_max_roles()
		self.calc_roles_count()
		
	}
	
	func modify_role_num(){
		if self.villager_Count_CONFIG < 0{
			//  no use
		}
	}
	
	func calc_max_roles(){
		let num_player_with_role: Int =
		self.werewolf_Count_CONFIG + self.seer_Count_CONFIG + self.medium_Count_CONFIG + self.hunter_Count_CONFIG + self.madman_Count_CONFIG + self.trainee_Count_CONFIG
		self.max_werewolf_CONFIG = self.players_CONFIG.count / 2 - 1
		self.max_trainee_CONFIG = self.players_CONFIG.count - (self.werewolf_Count_CONFIG + self.seer_Count_CONFIG + self.medium_Count_CONFIG + self.hunter_Count_CONFIG + self.madman_Count_CONFIG)
		self.existsPlayerWithoutRole = (self.players_CONFIG.count - num_player_with_role > 0)
	}
	
	func calc_roles_count(){
		self.num_player_with_role = self.werewolf_Count_CONFIG + self.seer_Count_CONFIG + self.hunter_Count_CONFIG + self.medium_Count_CONFIG + self.madman_Count_CONFIG + self.trainee_Count_CONFIG
		self.villager_Count_CONFIG = self.players_CONFIG.count - self.num_player_with_role
	}
	
	func init_player_CONFIG(){
		self.players_CONFIG.removeAll()
	}
	
	func calcDiscussionTime(){
		self.discussion_time_CONFIG = self.discussion_seconds_CONFIG + 60 * self.discussion_minutes_CONFIG
	}
	
	func traineeCheckIfWerewolf(player: Player)-> Bool {
		let res_prob = (Double.random(in: 0..<1))
		let res_prob_int:Int = Int(res_prob*100)
		let isSuccessful = res_prob_int < self.trainee_Probability
		if isSuccessful {  // when check_result is True
			if player.role_name == .werewolf{
				return true
			}else{
				return false
			}
		}else{  //  when check_result is False
			if player.role_name == .werewolf{
				return false
			}else{
				return true
			}
		}
	}
	
	func updatePlayerOrder() {
		for index in players_CONFIG.indices {
			players_CONFIG[index].player_order = index
		}
	}
	
	func makePlayerList(playersNum: Int)->[Player]{
		var tempPlayersList: [Player] = []
		for order in 0...playersNum-1 {
			let player = Player(player_order: order, role: Role.villager, player_name: "プレイヤー\(order+1)", isAlive: true)
			tempPlayersList.append(player)
		}
		return tempPlayersList
	}
	
	func buttonSE(videoFileName: String = "buttonPushed"){
		if videoFileName != "buttonPushed"{
			do{
				instanceForSound = try AVAudioPlayer(data: NSDataAsset(name: videoFileName)!.data)
			}
			catch{
				let _ = print("file not found error")
			}
		}
		instanceForSound.play()
	}
}

