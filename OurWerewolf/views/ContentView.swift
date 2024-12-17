
import SwiftUI
import CoreData

struct ContentView: View {
	@EnvironmentObject var gameStatusData: GameStatusData
	@Environment(\.managedObjectContext) private var viewContext
	@State private var isFirstAppearance = true
	
	@FetchRequest (sortDescriptors: []) var players_CONFIG_saved: FetchedResults<PlayerEntity>
	
	var body: some View {
		GeometryReader{ proxy_ContentView in
			VStack{  // closure for .onAppear()
				if gameStatusData.game_status == .titleScreen{
					GameStartView()
				}else if gameStatusData.game_status == .toTitleScreen{
					toTitleView()
				}else if gameStatusData.game_status == .homeScreen{
					BeforeHomeScreen()
				}else if gameStatusData.game_status == .gameScreen{
					ZStack{
						Rectangle()
							.fill(.black)
							.ignoresSafeArea()
						if gameStatusData.isAnimeShown == true {
							LoopVideoPlayerView(videoFileName: "Table", videoFileType: "mp4")
						}else{
							Image("still_Table")
								.resizable()
								.scaledToFill()
								.ignoresSafeArea()
								.frame(width: gameStatusData.fullScreenSize.width,
									   height: gameStatusData.fullScreenSize.height)
								.clipped()
						}
						ScrollView{
						}	
						GameView()
					}
				}else if gameStatusData.game_status == .gameOverScreen{
					GameOverView()
				}
			}
			
			.onAppear{
				gameStatusData.fullScreenSize = proxy_ContentView.size
				gameStatusData.threeOffSetTab = gameStatusData.fullScreenSize.width
				let _ = print("SCREEN SIZE: \(gameStatusData.fullScreenSize)")
				
				if isFirstAppearance {
					do {
						gameStatusData.players_CONFIG = try loadPlayers(context: viewContext)
					} catch {
						print("Failed to load: \(error)")
					}
					
					isFirstAppearance = false
				}
			}
		}
	}


	func loadPlayers(context: NSManagedObjectContext) throws -> [Player] {
		return players_CONFIG_saved.compactMap { entity in
			let name = entity.player_name as? String ?? "error"
			let roleRaw = entity.role_name as? String ?? "error"
			let role = Role(rawValue: roleRaw)!
			let player_order = Int(entity.player_order)
			let isAlive = entity.isAlive
			let isInspectedBySeer = entity.isInspectedBySeer
			let voteCount = entity.voteCount
			let werewolvesTargetCount = entity.werewolvesTargetCount
			let suspectedCount = entity.suspectedCount
			
			return Player(player_order: player_order, role: role, player_name: name)
		}
	}


}



