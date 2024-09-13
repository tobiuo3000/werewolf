
import SwiftUI


struct NightTime: View {
	@EnvironmentObject var gameStatusData: GameStatusData
	@EnvironmentObject var gameProgress: GameProgress
	
	@Binding var TempView: GameView_display_status
	@State var players_index: Int
	@State private var survivors_index: Int = 0
	@State private var actionDone: Bool = false
	@State var temp_action_target: Player?
	@State private var temp_action_done: Bool = false
	@State var werewolf_target: Player?
	var survivors_list: [Int]
	
	var body: some View {
		VStack{
			if actionDone == false{
				Text("\(gameProgress.players[players_index].player_name)さん\n夜の行動時間です")
					.textFrameDesignProxy()
				if gameProgress.players[players_index].role_name == Role.villager{
					Text("あなたは特にやることがないので\n怪しまれないように適当に画面タップとかをして下さい")
						.textFrameDesignProxy()
					Button("行動を終える") {
						actionDone = true
					}.padding()
					
				}else if gameProgress.players[players_index].role_name == Role.seer{
					Text("あなたは占い師です\n占いたい人を一人選択してください")
						.textFrameDesignProxy()
					
					if temp_action_done == true{
						Text("\(temp_action_target!.player_name)さんの役職は...\n\(temp_action_target!.role_name.japaneseName)です")
							.textFrameDesignProxy()
						Button("行動を終える") {
							temp_action_done = false
							actionDone = true
						}.padding()
						
					}else{
						ForEach(gameProgress.players.filter { $0.isAlive && $0.id != gameProgress.players[players_index].id}) { player in
							Button(player.player_name) {
								temp_action_target = player
								temp_action_done = true
							}.padding()
						}
					}
				}else if gameProgress.players[players_index].role_name == Role.werewolf{
					
					if temp_action_done == true{
						Text("\(temp_action_target!.player_name)さんを今晩襲撃します")
							.textFrameDesignProxy()
						Button("行動を終える") {
							temp_action_done = false
							actionDone = true
						}.padding()
					}else{
						Text("あなたは人狼です\n今晩襲う相手を一人選択してください")
							.textFrameDesignProxy()
						ScrollView {
							ForEach(gameProgress.players.filter { $0.isAlive && $0.id != gameProgress.players[players_index].id}) { player in
								Button(player.player_name) {
									temp_action_target = player
									werewolf_target = player
									temp_action_done = true
								}
								.padding()
							}
						}
					}
				}
				
			}else if actionDone == true{
				if survivors_index+1 < gameProgress.get_num_survivors(){
					Text("次のプレイヤーに携帯を渡してください\n次のプレイヤー：「\(gameProgress.players[survivors_list[survivors_index+1]].player_name)」")
						.textFrameDesignProxy()
				}else{
					Text("恐怖の夜が明け、朝が来ます")
						.textFrameDesignProxy()
				}
				
				Button("端末を渡した") {
					actionDone = false
					let _ = print("\(survivors_index)\n\(gameProgress.get_num_survivors())")
					if survivors_index+1 == gameProgress.get_num_survivors(){
						gameProgress.murder_target(target_id: temp_action_target!.id)
						TempView = .After_night
					}else{
						survivors_index += 1
						players_index = survivors_list[survivors_index]
						
					}
				}.padding()
			}
		}
		.frame(maxWidth: .infinity, maxHeight: .infinity)
		.background(Color.black)
		
	}
}

















