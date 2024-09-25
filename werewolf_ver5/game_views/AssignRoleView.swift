import SwiftUI




struct AssignRole: View{
	@EnvironmentObject var gameStatusData: GameStatusData
	@EnvironmentObject var gameProgress: GameProgress
	@Binding var TempView: GameView_display_status
	@State var Temp_index_num: Int = 0
	@State var isPlayerConfirmationDone = false
	
	var body: some View {
		if isPlayerConfirmationDone == false {
			BeforeOnePlayerRole(TempView: $TempView, Temp_index_num: $Temp_index_num, 
								isPlayerConfirmationDone: $isPlayerConfirmationDone)
		} else if isPlayerConfirmationDone == true {
			OnePlayerRole(TempView: $TempView, Temp_index_num: $Temp_index_num, 
						  isPlayerConfirmationDone: $isPlayerConfirmationDone)
		}
	}
}


struct BeforeOnePlayerRole: View{
	@EnvironmentObject var gameStatusData: GameStatusData
	@EnvironmentObject var gameProgress: GameProgress
	@Binding var TempView: GameView_display_status
	@Binding var Temp_index_num: Int
	
	@State private var isAlertShown = false
	@Binding var isPlayerConfirmationDone: Bool
	
	var body: some View {
		Text("次のプレイヤーに携帯を渡してください\n次のプレイヤー：「\(gameProgress.players[Temp_index_num].player_name)」")
			.textFrameDesignProxy()
		
		Button("次へ") {
			isAlertShown = true
		}
		.myTextBackground()
		.myButtonBounce()
		.alert("\(gameProgress.players[Temp_index_num].player_name)さんですか？", isPresented: $isAlertShown){
			Button("はい"){
				isPlayerConfirmationDone = true
				isAlertShown = false
			}
			Button("いいえ", role:.cancel){}
		}
	}
}

struct OnePlayerRole: View {
	@EnvironmentObject var gameStatusData: GameStatusData
	@EnvironmentObject var gameProgress: GameProgress
	@Binding var TempView: GameView_display_status
	@Binding var Temp_index_num: Int
	@Binding var isPlayerConfirmationDone: Bool
	
	@State private var isCardTapped = false
	@State private var isRoleNameChecked = false
	@State private var isCardFlipped = false
	@State private var isRoleNameShown = false
	@State private var cardScale: CGFloat = 0.5
	@State private var textScale: CGFloat = 0
	@State private var textOpacity: CGFloat = 0.0
	
	var body: some View {
		VStack{
			if isRoleNameShown == true{
				Text("「\(gameProgress.players[Temp_index_num].player_name)」さん\n役職： \(gameProgress.players[Temp_index_num].role_name.japaneseName)")
					.textFrameDesignProxy()
					.scaleEffect(textScale)
					.opacity(textOpacity)
					.frame(height: 20)
			}else{
				Color(.clear)
					.frame(height: 20)
			}
			
			Color(.clear)
				.frame(height: 2)
			
			ZStack{
				if isCardFlipped == false{
					Image(gameStatusData.currentTheme.cardBackSide)
						.resizable()
						.aspectRatio(contentMode: .fill)
						.scaleEffect(cardScale)
				}else{
					Image(gameProgress.players[Temp_index_num].role_name.image_name)
						.resizable()
						.aspectRatio(contentMode: .fill)
						.scaleEffect(cardScale)
				}
			}
			.cardFlippedWhenAssigningRole(isCardFlipped: $isCardFlipped, isCardTapped: $isCardTapped,  
										  isRoleNameShown: $isRoleNameShown, isRoleNameChecked: $isRoleNameChecked,
										  cardScale: $cardScale, textScale: $textScale,
										  textOpacity: $textOpacity)
		}
		
		Color(.clear)
			.frame(height: 2)
		
		if isRoleNameChecked{
			Button("役職を確認した"){
				if Temp_index_num+1 < gameProgress.players.count {
					Temp_index_num = Temp_index_num + 1
					isPlayerConfirmationDone = false
				}else{
					TempView = .Before_discussion
				}
				
			}
			.myTextBackground()
			.myButtonBounce()
		}
	}
}


