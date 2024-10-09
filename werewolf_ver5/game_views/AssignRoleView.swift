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
	@State var cardScale: CGFloat = 1.0
	@State var textScale: CGFloat = 0
	@State var textOpacity: CGFloat = 0.0
	@State var isTapAllowed: Bool = true
	
	var body: some View {
		ZStack{
			TempTexts(TempView: $TempView, Temp_index_num: $Temp_index_num, isPlayerConfirmationDone: $isPlayerConfirmationDone, isRoleNameShown: $isRoleNameShown, isRoleNameChecked: $isRoleNameChecked, cardScale: $cardScale, textScale: $textScale, textOpacity: $textOpacity)
			
			ZStack{
				if isCardFlipped == false{
					Image(gameStatusData.currentTheme.cardBackSide)
						.resizable()
						.frame(width: (gameStatusData.fullScreenSize.height/gameStatusData.cardSize.height)*gameStatusData.cardSize.width/2,
							   height: gameStatusData.fullScreenSize.height/2)
						.scaleEffect(cardScale)
				}else{
					Image(gameProgress.players[Temp_index_num].role_name.image_name)
						.resizable()
						.frame(width: (gameStatusData.fullScreenSize.height/gameStatusData.cardSize.height)*gameStatusData.cardSize.width/2,
							   height: gameStatusData.fullScreenSize.height/2)
						.scaleEffect(cardScale)
				}
			}
			.cardFlippedWhenAssigningRole(isCardFlipped: $isCardFlipped, isCardTapped: $isCardTapped,
										  isRoleNameShown: $isRoleNameShown, isRoleNameChecked: $isRoleNameChecked,
										  cardScale: $cardScale, textScale: $textScale,
										  textOpacity: $textOpacity, isTapAllowed: $isTapAllowed)
		}
	}
}


struct TempTexts: View {
	@EnvironmentObject var gameStatusData: GameStatusData
	@EnvironmentObject var gameProgress: GameProgress
	@Binding var TempView: GameView_display_status
	@Binding var Temp_index_num: Int
	@Binding var isPlayerConfirmationDone: Bool
	@Binding var isRoleNameShown: Bool
	@Binding var isRoleNameChecked: Bool
	@Binding var cardScale: CGFloat
	@Binding var textScale: CGFloat
	@Binding var textOpacity: CGFloat
	
	var body: some View{
		VStack(spacing: 0){
			ZStack{
				if isRoleNameShown == true{
					Text("「\(gameProgress.players[Temp_index_num].player_name)」さん\n役職： \(gameProgress.players[Temp_index_num].role_name.japaneseName)")
						.textFrameDesignProxy()
						.opacity(textOpacity)
				}else{
					Text("「\(gameProgress.players[Temp_index_num].player_name)」さん\n役職： \(gameProgress.players[Temp_index_num].role_name.japaneseName)")
						.foregroundStyle(Color(.clear))
				}
			}
			
			Spacer()
			
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
}
