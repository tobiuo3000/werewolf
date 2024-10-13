import SwiftUI
import SwiftData


/*
 画像解像度の目安
 →iphone16 pro maxは1320*2868(9:19.6)
*/



enum AppTheme: String, CaseIterable {
	case std_theme, simple_theme, theme3 // テーマを追加していく
	
	var backgroundImage: String {
		switch self {
		case .std_theme: return "std_"
		case .simple_theme: return "Theme2_Background"
		case .theme3: return "Theme3_Background"
		}
	}
	
	var textBackgroundImage: String {
		switch self {
		case .std_theme: return "std_sentence_background"
		case .simple_theme: return "Theme2_TextBackground"
		case .theme3: return "Theme3_TextBackground"
		}
	}
	
	var titleScreenBackground: String {
		switch self {
		case .std_theme: return "std_theme_title_background"
		case .simple_theme: return "Theme2_TitleScreen"
		case .theme3: return "Theme3_TitleScreen"
		}
	}
	
	var transitionBackground: String {
		switch self {
		case .std_theme: return "large_dark_forest"
		case .simple_theme: return "Theme2_TitleScreen"
		case .theme3: return "Theme3_TitleScreen"
		}
	}
	
	var loghouseBackground: String {
		switch self {
		case .std_theme: return "loghouse"
		case .simple_theme: return "Theme2_TitleScreen"
		case .theme3: return "Theme3_TitleScreen"
		}
	}
	
	var cardBackSide: String {
		switch self {
		case .std_theme: return "card_backside"
		case .simple_theme: return "Theme2_TitleScreen"
		case .theme3: return "Theme3_TitleScreen"
		}
	}
	
	var cornerRadius: CGFloat {
		switch self {
		case .std_theme: return 20
		case .simple_theme: return 20
		case .theme3: return 0
		}
	}
	
	var textFrame_simple: String{
		switch self {
		case .std_theme: return "std_text_frame_simple"
		case .simple_theme: return "std_text_frame_gorgeous"
		case .theme3: return "std_text_frame_gorgeous"
		}
	}
	
	var textFrame_gorgeous: String{
		switch self {
		case .std_theme: return "std_text_frame_gorgeous"
		case .simple_theme: return "std_text_frame_gorgeous"
		case .theme3: return "std_text_frame_gorgeous"
		}
		
	}
}



enum Role {
	case noRole
	case villager
	case werewolf
	case seer
	case hunter
	case medium
	case madman
	
	var image_name: String {
		switch self {
		case .noRole:
			return "role_unknown_image"
		case .villager:
			return "card_villager"
		case .werewolf:
			return "card_werewolf"
		case .seer:
			return "card_seer"
		case .hunter:
			return "temp_hunter"
		case .medium:
			return "temp_medium"
		case .madman:
			return "role_madman_image"
		}
	}
	
	// 役職の日本語名を返すcomputed property
	var japaneseName: String {
		switch self {
		case .noRole:
			return "役職未定"
		case .villager:
			return "村人"
		case .werewolf:
			return "人狼"
		case .seer:
			return "占い師"
		case .hunter:
			return "狩人"
		case .medium:
			return "霊媒師"
		case .madman:
			return "狂人"
		}
	}
	
}


enum gameStatus{
	case titleScreen, homeScreen, gameScreen, gameOverScreen, toTitleScreen
}

class Player: Identifiable, NSCopying {
	var id: UUID
	var player_order: Int  // id starts from 0 (ex: 0, 1, 2, 3, 4...)
	var player_name: String
	var role_name: Role
	var isAlive: Bool
	var voteCount: Int
	
	init(player_order: Int, role: Role, player_name: String, isAlive: Bool = true, voteCount: Int = 0) {
		self.id = UUID()
		self.player_order = player_order
		self.role_name = role
		self.player_name = player_name
		self.isAlive = isAlive
		self.voteCount = voteCount
	}
	
	func copy(with zone: NSZone? = nil) -> Any {
		let copy = Player(player_order: self.player_order, role: self.role_name, player_name: self.player_name)
			return copy
		}
}


class DailyLog: Identifiable, NSCopying{
	var id: UUID
	var day: Int
	var murderedPlayer: Player?
	var executedPlayer: Player?
	
	init(day: Int) {
		self.id = UUID()
		self.day = day
	}
	
	func copy(with zone: NSZone? = nil) -> Any {
		let copy = DailyLog(day: self.day)
			return copy
		}
}


class GameStatusData: ObservableObject {
	@Published var game_status: gameStatus = .titleScreen
	@Published var players_CONFIG: [Player] = []
	@Published var roundNumber_CONFIG: Int = 0
	@Published var view_status_CONFIG: Int = 0
	@Published var discussion_minutes_CONFIG: Int = 2
	@Published var discussion_seconds_CONFIG: Int = 0
	@Published var discussion_time_CONFIG: Int = 0
	@Published var villager_Count_CONFIG: Int = 0
	@Published var werewolf_Count_CONFIG: Int = 1
	@Published var seer_Count_CONFIG: Int = 0
	@Published var medium_Count_CONFIG: Int = 0
	@Published var hunter_Count_CONFIG: Int = 0
	@Published var max_werewolf_CONFIG: Int = 1
	@Published var is_player_with_role_max: Bool = false
	@Published var currentTheme: AppTheme = .std_theme
	@Published var textSize: CGSize = .zero
	@Published var titleTextSize: CGSize = .zero
	@Published var fullScreenSize: CGSize = .zero
	@Published var cardSize: CGSize = CGSize(width: 630, height: 880)
	
	init() {
		// UIWindowSceneから画面サイズを取得して保存
		if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
			if let mainWindow = windowScene.windows.first {
				self.fullScreenSize = mainWindow.bounds.size
			}
		}
		self.players_CONFIG = self.makePlayerList(playersNum: 4)
	}
	
	func changeTheme(to theme: AppTheme) {
		currentTheme = theme
	}
	
	func update_role_CONFIG(){
		self.calc_max_roles()
		self.calc_vil_count()
	}
	
	func calc_max_roles(){
		let num_player_with_role: Int =
		self.werewolf_Count_CONFIG + self.seer_Count_CONFIG + self.medium_Count_CONFIG + self.hunter_Count_CONFIG
		self.max_werewolf_CONFIG = self.players_CONFIG.count / 2 - 1
		self.is_player_with_role_max = (self.players_CONFIG.count - num_player_with_role <= 0)
	}
	
	func calc_vil_count(){
		let num_villager_with_role = self.werewolf_Count_CONFIG + self.seer_Count_CONFIG + self.hunter_Count_CONFIG + self.medium_Count_CONFIG
		self.villager_Count_CONFIG = self.players_CONFIG.count - num_villager_with_role
	}
	
	func init_player_CONFIG(){
		self.players_CONFIG = []
	}
	
	func calcDiscussionTime(){
		self.discussion_time_CONFIG = self.discussion_seconds_CONFIG + 60 * self.discussion_minutes_CONFIG
	}
	
	func updatePlayerOrder() {
			for index in players_CONFIG.indices {
				players_CONFIG[index].player_order = index
			}
		}
	
	func makePlayerList(playersNum: Int)->[Player]{
		var tempPlayersList: [Player] = []
		for order in 0...playersNum-1 {
			let player = Player(player_order: order, role: Role.villager, player_name: "プレイヤー\(order)", isAlive: true)
			tempPlayersList.append(player)
		}
		return tempPlayersList
	}
}





class GameProgress: ObservableObject {
	@Published var players: [Player] = []
	@Published var diary: [DailyLog] = []
	@Published var day_currrent_game: Int = 0
	@Published var roundNumber: Int = 0
	@Published var discussion_time: Int = 10
	@Published var game_start_flag: Bool = false
	@Published var stage: String = "夜時間" // 例: "夜時間", "議論時間"など
	@Published var game_result: Int = 0
	
	func game_Result() {
		let werewolvesAlive = self.players.filter { $0.role_name == .werewolf && $0.isAlive }.count
		let villagersAlive = self.players.filter { $0.role_name != .werewolf && $0.isAlive }.count
		
		if werewolvesAlive == 0 {
			game_result = 2 // Villager Win
		} else if werewolvesAlive >= villagersAlive {
			game_result = 1 // werewolf Win
		} else {
			game_result = 0 // CONTINUE
		}
	}
	
	func init_player(){
		self.players = []
	}
	
	func get_player_from_UUID(targetPlayerID: UUID) -> Player{
		return self.players.first(where: { $0.id == targetPlayerID })!
	}
	
	func get_diary_from_day(target_day: Int) -> DailyLog{
		return self.diary.first(where: { $0.day == target_day })!
	}
	
	func get_num_survivors()->Int{
		let num_survivors = self.players.filter { $0.isAlive }.count
		return num_survivors
	}
	
	func get_survivors_list() -> [Int] {
		return self.players.filter { $0.isAlive }.map { $0.player_order }.sorted()
	}
	
	func get_hightst_vote() -> Player?{
		let highestVotePlayer: Player? = self.players.max(by: { $0.voteCount < $1.voteCount })
		return highestVotePlayer
	}
	
	func reset_vote_count() {
		for order in self.players.indices {
			self.players[order].voteCount = 0
		}
	}
	
	func sentence_to_death(suspect_id: UUID) {
		get_player_from_UUID(targetPlayerID: suspect_id).isAlive = false
	}
	
	func try_murdering(target: Player, hunter_target: Player?) -> Bool{
		guard let hunter_target = hunter_target else{
			let _ = print("1")
			let _ = print(target)
			target.isAlive = false
			return true
		}
		
		if target.id == hunter_target.id{
			let _ = print("2")
			return false
		}else{
			let _ = print("3")
			let _ = print(target)
			target.isAlive = false
			return true
		}
	}
	
	func assignRoles(wolfNum:Int, seerNum:Int, mediumNum:Int, hunterNum:Int) {
		// プレイヤーのインデックスの配列を作成
		var indexes = Array(self.players.indices)
		
		// ランダムに人狼を選ぶ
		for _ in 0..<wolfNum {
			if let randomIndex = indexes.randomElement() {
				self.players[randomIndex].role_name = .werewolf
				indexes.removeAll { $0 == randomIndex } // 選んだプレイヤーをリストから削除
			}
		}
		
		for _ in 0..<seerNum {
			if let randomIndex = indexes.randomElement() {
				self.players[randomIndex].role_name = .seer
				indexes.removeAll { $0 == randomIndex } // 選んだプレイヤーをリストから削除
			}
		}
		
		for _ in 0..<mediumNum {
			if let randomIndex = indexes.randomElement() {
				self.players[randomIndex].role_name = .medium
				indexes.removeAll { $0 == randomIndex } // 選んだプレイヤーをリストから削除
			}
		}
		
		for _ in 0..<hunterNum {
			if let randomIndex = indexes.randomElement() {
				self.players[randomIndex].role_name = .hunter
				indexes.removeAll { $0 == randomIndex } // 選んだプレイヤーをリストから削除
			}
		}
	}
}








