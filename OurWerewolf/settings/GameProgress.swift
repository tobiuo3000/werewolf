//
//  GameProgressData.swift
//  werewolf_ver5
//
//  Created by Masanori Sudo on 2024/12/17.
//

import SwiftUI


class GameProgress: ObservableObject {
	@Published var players: [Player] = []
	@Published var diary: [DailyLog] = []
	@Published var highestVotePlayers: [Player] = []
	@Published var highestWerewolvesTargets: [Player] = []
	@Published var highestSuspectedPlayers: [Player] = []
	@Published var day_current_game: Int = 0
	@Published var discussion_time: Int = 10
	@Published var game_start_flag: Bool = false
	@Published var game_result: Int = 0
	@Published var stageView: GameView_display_status = GameView_display_status.Show_player_role
	
	func init_gameProgress() {
		stageView = .Show_player_role
		players.removeAll()
		diary.removeAll()
		diary.append(DailyLog(day: 0))
		day_current_game = 0
	}
	
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
		self.players.removeAll()
	}
	
	func remove_HighestVotePlayers(){
		self.highestVotePlayers.removeAll()
	}
	
	func remove_HighestSuspectedPlayers(){
		self.highestSuspectedPlayers.removeAll()
	}
	
	func remove_HighestWerewolvesTargets(){
		self.highestWerewolvesTargets.removeAll()
	}
	
	func get_player_from_UUID(targetPlayerID: UUID) -> Player{
		return self.players.first(where: { $0.id == targetPlayerID })!
	}
	
	func get_diary_cur_day() -> DailyLog{
		let _ = print("get_diary_cur_day() called")
		return self.diary.first(where: { $0.day == self.day_current_game })!
	}
	
	func get_diary_from_day(target_day: Int) -> DailyLog{
		let _ = print("get_diary_from_day() called")
		return self.diary.first(where: { $0.day == target_day })!
	}
	
	func get_num_survivors()->Int{
		let num_survivors = self.players.filter { $0.isAlive }.count
		return num_survivors
	}
	
	func get_survivors_list() -> [Int] {
		return self.players.filter { $0.isAlive }.map { $0.player_order }.sorted()
	}
	
	func get_list_highest_vote() -> [Player]{
		let maxCount = self.players.map({ $0.voteCount }).max()
		let highestPlayers = self.players.filter { $0.voteCount == maxCount }
		return highestPlayers
	}
	
	func get_list_highest_suspected() -> [Player?]{
		let maxCount = self.players.map({ $0.suspectedCount }).max()
		let highestPlayers = self.players.filter { $0.suspectedCount == maxCount }
		return highestPlayers
	}
	
	func choose_one_random_suspected(highestList: [Player?]) -> Player?{
		if highestList.isEmpty{
			return nil
		}else{
			let chosenPlayer = highestList.randomElement()
			return chosenPlayer!
		}
	}
	
	func get_one_random_vil_side() -> Player{
		let PlayersExceptWerewolf = self.players.filter {$0.role_name != Role.werewolf}
		return PlayersExceptWerewolf.randomElement()!
	}
	
	func get_list_highest_werewolvesTarget() -> [Player]{
		let maxCount = self.players.map({ $0.werewolvesTargetCount }).max()
		let highestPlayers = self.players.filter { $0.werewolvesTargetCount == maxCount }
		return highestPlayers
	}
	
	func choose_one_random_player(highestList: [Player]) -> Player?{
		let chosenPlayer = highestList.randomElement()
		return chosenPlayer
	}
	
	func reset_vote_count() {
		for order in self.players.indices {
			self.players[order].voteCount = 0
		}
	}
	
	func reset_werewolvesTarget_count() {
		for order in self.players.indices {
			self.players[order].werewolvesTargetCount = 0
		}
	}
	
	func reset_suspected_count() {
		for order in self.players.indices {
			self.players[order].suspectedCount = 0
		}
	}
	
	func sentence_to_death(suspect_id: UUID) {
		get_player_from_UUID(targetPlayerID: suspect_id).isAlive = false
	}
	
	func try_murdering(target: Player, hunter_target: Player?) -> Bool{
		guard let hunter_target = hunter_target else{
			target.isAlive = false
			return true
		}
		
		if target.id == hunter_target.id{
			return false
		}else{
			target.isAlive = false
			return true
		}
	}
	
	func assignRoles(wolfNum:Int, traineeNum:Int, seerNum:Int, mediumNum:Int, hunterNum:Int, madmanNum:Int) {
		// プレイヤーのインデックスの配列を作成
		var indexes = Array(self.players.indices)
		
		// ランダムに人狼を選ぶ
		for _ in 0..<wolfNum {
			if let randomIndex = indexes.randomElement() {
				self.players[randomIndex].role_name = .werewolf
				indexes.removeAll { $0 == randomIndex } // 選んだプレイヤーをリストから削除
			}
		}
		
		for _ in 0..<traineeNum {
			if let randomIndex = indexes.randomElement() {
				self.players[randomIndex].role_name = .trainee
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
		
		for _ in 0..<madmanNum {
			if let randomIndex = indexes.randomElement() {
				self.players[randomIndex].role_name = .madman
				indexes.removeAll { $0 == randomIndex } // 選んだプレイヤーをリストから削除
			}
		}
	}
}



