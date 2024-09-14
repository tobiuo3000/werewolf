
import SwiftUI


struct NightTime: View {
	@EnvironmentObject var gameStatusData: GameStatusData
	@EnvironmentObject var gameProgress: GameProgress
	
	@Binding var TempView: GameView_display_status
	@State var players_index: Int
	@State private var survivors_index: Int = 0
	@State private var isActionDone: Bool = false
	@State private var seer_target: Player?
	@State private var werewolf_target: Player?
	@State private var isTargetConfirmed: Bool = false
	@State private var isAlertShown: Bool = false
	var survivors_list: [Int]
	
	var body: some View {
		VStack{
			if isActionDone == false {
				HStack{
					Text("\(gameProgress.players[players_index].player_name)さん\n夜の行動時間です")
						.textFrameDesignProxy()
					if gameProgress.players[players_index].role_name == Role.villager{
						Text("あなたは特にやることがないので\n怪しまれないように適当に画面タップとかしてて下さい")
							.textFrameDesignProxy()
						
					}else if gameProgress.players[players_index].role_name == Role.seer{
						Text("あなたは占い師です\n占いたい人を一人選択してください")
							.textFrameDesignProxy()
						
						if isTargetConfirmed == true{
							Text("\(seer_target!.player_name)さんの役職は...\n\(seer_target!.role_name.japaneseName)です")
								.textFrameDesignProxy()
							
						}else{
							ForEach(gameProgress.players.filter { $0.isAlive && $0.id != gameProgress.players[players_index].id}) { player in
								Button(player.player_name) {
									seer_target = player.copy() as? Player
									isTargetConfirmed = true
								}.padding()
							}
						}
					}else if gameProgress.players[players_index].role_name == Role.werewolf{
						
						if isTargetConfirmed == true{
							Text("\(werewolf_target!.player_name)さんを今晩襲撃します")
								.textFrameDesignProxy()
						}else{
							Text("あなたは人狼です\n今晩襲う相手を一人選択してください")
								.textFrameDesignProxy()
							ScrollView {
								ForEach(gameProgress.players.filter { $0.isAlive && $0.id != gameProgress.players[players_index].id}) { player in
									Button(player.player_name) {
										werewolf_target = player.copy() as? Player
										isTargetConfirmed = true
									}
									.padding()
								}
							}
						}
					}
					
					Button("行動を終える") {
						isTargetConfirmed = false
						isActionDone = true
					}.padding()
						.alert("この設定でゲームスタートしますか？", isPresented: $isAlertShown){
							Button("ゲームスタート"){
								isTargetConfirmed = false
								isActionDone = true
							}
						}
					Button("キャンセル", role: .cancel){
					}
				}
			}else if isActionDone == true {
				if survivors_index+1 < gameProgress.get_num_survivors(){
					Text("次のプレイヤーに携帯を渡してください\n次のプレイヤー：「\(gameProgress.players[survivors_list[survivors_index+1]].player_name)」")
						.textFrameDesignProxy()
				}else{
					Text("恐怖の夜が明け、朝が来ます")
						.textFrameDesignProxy()
				}
				
				Button("端末を渡した") {
					isActionDone = false
					let _ = print("\(survivors_index)\n\(gameProgress.get_num_survivors())")
					if survivors_index+1 == gameProgress.get_num_survivors(){
						gameProgress.murder_target(target_id: werewolf_target!.id)
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

















