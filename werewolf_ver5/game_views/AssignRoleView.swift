import SwiftUI


struct AssignRole: View{
	@EnvironmentObject var gameStatusData: GameStatusData
	@EnvironmentObject var gameProgress: GameProgress
	@State var Temp_index_num: Int = 0
	@State var isPlayerConfirmationDone = false
	
	var body: some View {
		if isPlayerConfirmationDone == false {
			BeforeOnePlayerRole(Temp_index_num: $Temp_index_num,
								isPlayerConfirmationDone: $isPlayerConfirmationDone)
		} else if isPlayerConfirmationDone == true {
			OnePlayerRoleShown(Temp_index_num: $Temp_index_num,
						  isPlayerConfirmationDone: $isPlayerConfirmationDone)
		}
	}
}


struct BeforeOnePlayerRole: View{
	@EnvironmentObject var gameStatusData: GameStatusData
	@EnvironmentObject var gameProgress: GameProgress
	@Binding var Temp_index_num: Int
	@State private var isAlertShown = false
	@Binding var isPlayerConfirmationDone: Bool
	let highlightColor: Color = Color(red: 0.8, green: 0.5, blue: 0.6)
	
	var body: some View {
		VStack{
			Spacer()
			if Temp_index_num != 0{
				VStack{
					Text("次のプレイヤーに携帯を渡してください：")
					HStack{
						Text("「")
						Text("\(gameProgress.players[Temp_index_num].player_name)")
							.foregroundStyle(highlightColor)
						Text("」")
					}
					.font(.title2)
				}
				.textFrameSimple()
			}else{
				VStack(alignment: .center){
					Text("役職割り当てを行います")
					HStack{
						Text("\(gameProgress.players[Temp_index_num].player_name)")
							.foregroundStyle(highlightColor)
						Text("さんが")
					}
					Text("「次へ」を押してください")
				}
				.textFrameDesignProxy()
			}
			
			Spacer()
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
			
			Rectangle()
				.fill(.clear)
				.frame(width: 40, height: 40)
		}
	}
}
/*
if gameProgress.players[Temp_index_num].role_name == Role.seer{
	if gameStatusData.isFirstNightRandomSeer{
		VStack{
			Text("初日ランダム占い結果：")
				.foregroundStyle(highlightColor)
			Text("\(tmpPlayer.player_name)")
			Text("は人狼ではありません")
		}
		.textFrameDesignProxy()
		.onAppear(){
			tmpPlayer = gameProgress.get_one_random_vil_side()
		}
	}
}else if gameProgress.players[Temp_index_num].role_name == Role.trainee{
	VStack{
		Text("初日ランダム占い結果：")
			.foregroundStyle(highlightColor)
		Text("\(tmpPlayer.player_name)")
		HStack{
				if gameStatusData.traineeCheckIfWerewolf(player: tmpPlayer){
					Text("人狼")
						.foregroundStyle(highlightColor)
					Text("です")
				}else{
					Text("人狼ではありません")
				}
		}
	}
	.textFrameDesignProxy()
	.onAppear(){
		tmpPlayer = gameProgress.choose_one_random_player(highestList: gameProgress.players)!
		
	}
}
*/

struct OnePlayerRoleShown: View {
	@EnvironmentObject var gameStatusData: GameStatusData
	@EnvironmentObject var gameProgress: GameProgress
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
			TempTexts(Temp_index_num: $Temp_index_num, isPlayerConfirmationDone: $isPlayerConfirmationDone, isRoleNameShown: $isRoleNameShown, isRoleNameChecked: $isRoleNameChecked, cardScale: $cardScale, textScale: $textScale, textOpacity: $textOpacity)
			
			ZStack{
				ZStack{  // for Modifier
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
				if isCardFlipped == false{
					VStack{
						Text("”tap here”")
							.font(.headline)
								.fontWeight(.bold)
							.foregroundStyle(.white)
						Rectangle()
							.fill(.clear)
							.frame(width: 5, height: 5)
						Image(systemName: "hand.tap.fill")
							.font(.largeTitle)
							.foregroundStyle(.white)
					}
					.flickeringUI(interval: 1)
					
				}
			}
		}
	}
}


struct TempTexts: View {
	@EnvironmentObject var gameStatusData: GameStatusData
	@EnvironmentObject var gameProgress: GameProgress
	@Binding var Temp_index_num: Int
	@Binding var isPlayerConfirmationDone: Bool
	@Binding var isRoleNameShown: Bool
	@State private var isAlertShown: Bool = false
	@Binding var isRoleNameChecked: Bool
	@Binding var cardScale: CGFloat
	@Binding var textScale: CGFloat
	@Binding var textOpacity: CGFloat
	let highlightColor: Color = Color(red: 0.8, green: 0.5, blue: 0.6)
	@State var tmpPlayer: Player = Player(player_order: 1000, role: .noRole, player_name: "tmp_no_name")  // to avoid nil
	
	var body: some View{
			VStack(spacing: 0){
				ZStack(alignment: .center){
					if isRoleNameShown == true{
						VStack(alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/){
							Text("「\(gameProgress.players[Temp_index_num].player_name)」さん")
							Text("役職： \(gameProgress.players[Temp_index_num].role_name.japaneseName)")
							
							
						}
						.textFrameDesignProxy()
						.opacity(textOpacity)
					}else{
						VStack(alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/){
							Text("「\(gameProgress.players[Temp_index_num].player_name)」さん")
							Text("役職： \(gameProgress.players[Temp_index_num].role_name.japaneseName)")
							Text(" ")
						}
						.foregroundStyle(Color(.clear))
					}
				}
				
				
				Text(" ")
					.font(.title)
				
				if isRoleNameChecked{
					Button("役職を確認した"){
						isAlertShown = true
					}
					.myTextBackground()
					.myButtonBounce()
					.alert("役職を確認しましたか？", isPresented: $isAlertShown){
						Button("はい"){
							if Temp_index_num+1 < gameProgress.players.count {
								Temp_index_num = Temp_index_num + 1
								isPlayerConfirmationDone = false
							}else{
								gameProgress.day_current_game = gameProgress.day_current_game + 1
								gameProgress.stageView = .Morning_time
								gameProgress.diary.append(DailyLog(day: gameProgress.day_current_game))
							}
							isAlertShown = false
							
						}
						Button("いいえ", role:.cancel){}
					}
					
					Rectangle()
						.fill(.clear)
						.frame(width: 40, height: 40)
				}
			}
	}
}
