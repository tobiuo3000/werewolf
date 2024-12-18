import SwiftUI
import CoreData
import AVFoundation


/*
 画像解像度の目安
 →iphone16 pro maxは1320*2868(9:19.6)
 */


enum AppTheme: String, CaseIterable {
	case std_theme, simple_theme, theme3 // planning to make more themes availavle
	
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
		case .std_theme: return 18
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


enum SoundTheme{
	case only_BGM, only_ENV, mixed
	
	var titleScreen: String{
		switch self {
		case .only_BGM: return "title_BGM"
		case .only_ENV: return "title_ENV"
		case .mixed: return  "title_MIXED"
		}
	}
	var homeScreen: String{
		switch self {
		case .only_BGM: return "title_BGM"
		case .only_ENV: return "title_ENV"
		case .mixed: return  "title_MIXED"
		}
	}
	var gameScreen: String{
		switch self {
		case .only_BGM: return "discussion_BGM"
		case .only_ENV: return "discussion_ENV"
		case .mixed: return  "discussion_MIXED"
		}
	}
	var werewolfWinScreen: String{
		switch self {
		case .only_BGM: return "wolfWin_BGM"
		case .only_ENV: return "wolfWin_ENV"
		case .mixed: return  "wolfWin_MIXED"
		}
	}
	var villagerWinScreen: String{
		switch self {
		case .only_BGM: return "vilWin_BGM"
		case .only_ENV: return "vilWin_ENV"
		case .mixed: return  "vilWin_MIXED"
		}
	}
}


enum Role: String {
	case noRole
	case villager
	case werewolf
	case seer
	case hunter
	case medium
	case madman
	case trainee
	
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
			return "card_hunter"
		case .medium:
			return "card_medium"
		case .madman:
			return "card_madman"
		case .trainee:
			return "card_trainee_only_sweat"
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
		case .trainee:
			return "見習い占"
		}
	}
}


enum gameStatus{
	case titleScreen, homeScreen, gameScreen, gameOverScreen, toTitleScreen
}


class Player: Identifiable, NSCopying, ObservableObject {
	var id: UUID
	var player_order: Int
	var player_name: String
	var role_name: Role
	var isAlive: Bool
	var isInspectedBySeer: Bool
	var voteCount: Int
	var werewolvesTargetCount: Int
	var suspectedCount: Int
	
	init(player_order: Int, role: Role, player_name: String, isAlive: Bool = true, isInspectedBySeer: Bool = false, voteCount: Int = 0, werewolvesTargetCount: Int = 0, suspectedCount: Int = 0) {
		self.id = UUID()
		self.player_order = player_order
		self.role_name = role
		self.player_name = player_name
		self.isAlive = isAlive
		self.isInspectedBySeer = isInspectedBySeer
		self.voteCount = voteCount
		self.werewolvesTargetCount = werewolvesTargetCount
		self.suspectedCount = suspectedCount
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
	var werewolvesTarget: Player?
	var mostSuspectedPlayer: Player?
	var hunterTarget: Player?
	var seerTarget: Player?
	
	init(day: Int) {
		self.id = UUID()
		self.day = day
	}
	
	func copy(with zone: NSZone? = nil) -> Any {
		let copy = DailyLog(day: self.day)
		return copy
	}
}








