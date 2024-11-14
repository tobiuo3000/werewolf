import SwiftUI

struct CardGalleryView: View {
	@EnvironmentObject var gameStatusData: GameStatusData
	@Binding var threeOffSetTab: CGFloat
	@Binding var showAllText: Bool
	private let spacing: CGFloat = 8
	private let numberOfColumn: CGFloat = 4
	
	var body: some View{
		let imageFrameWidth: CGFloat =  CGFloat(gameStatusData.fullScreenSize.width / (numberOfColumn + 1)) // SCREEN WIDTH: 393
		let imageFrameHeight: CGFloat = CGFloat(imageFrameWidth * (88/63))
		let numberOfImagesInRow: Int = Int(gameStatusData.fullScreenSize.width / (imageFrameWidth + spacing))
		let numberOfRows: Int = (gameStatusData.players_CONFIG.count + numberOfImagesInRow - 1) / numberOfImagesInRow
		VStack{
			HStack{
				Spacer()
				ScrollView{
					VStack(alignment: .leading, spacing: spacing) {
						ForEach(0..<numberOfRows, id: \.self) { rowIndex in
							HStack(spacing: spacing) {
								ForEach(0..<numberOfImagesInRow, id: \.self) { columnIndex in
									CardViewWithFlipping(showAllText: $showAllText, threeOffSetTab: $threeOffSetTab, rowIndex: rowIndex, numberOfImagesInRow: numberOfImagesInRow, columnIndex: columnIndex, imageFrameWidth: imageFrameWidth, imageFrameHeight: imageFrameHeight)
								}
							}
						}
					}
				}
				Spacer()
			}
			.padding()
		}
		
	}
}

struct CardViewWithFlipping: View{
	@EnvironmentObject var gameStatusData: GameStatusData
	@State var cardScale: CGFloat = 1.0
	@State var isCardFlipped: Bool = false
	@Binding var showAllText: Bool
	@Binding var threeOffSetTab: CGFloat
	
	let rowIndex: Int
	let numberOfImagesInRow: Int
	let columnIndex: Int
	let imageFrameWidth: CGFloat
	let imageFrameHeight: CGFloat
	
	var body: some View{
		let imageIndex = rowIndex * numberOfImagesInRow + columnIndex
		let conditionVil = imageIndex < gameStatusData.villager_Count_CONFIG
		let tmpTrainee = gameStatusData.villager_Count_CONFIG + gameStatusData.trainee_Count_CONFIG
		let conditionTrainee = gameStatusData.villager_Count_CONFIG <= imageIndex && imageIndex < tmpTrainee
		let tmpSeer = tmpTrainee + gameStatusData.seer_Count_CONFIG
		let conditionSeer = (tmpTrainee <= imageIndex) && (imageIndex < tmpSeer)
		let tmpMedium = tmpSeer + gameStatusData.medium_Count_CONFIG
		let conditionMedium = (tmpSeer <= imageIndex) && (imageIndex < tmpMedium)
		let tmpHunter = tmpMedium + gameStatusData.hunter_Count_CONFIG
		let conditionHunter = (tmpMedium <= imageIndex) && (imageIndex < tmpHunter)
		let tmpMadman = tmpHunter + gameStatusData.madman_Count_CONFIG
		let conditionMadman = (tmpHunter <= imageIndex) && (imageIndex < tmpMadman)
		let tmpWerewolf = tmpMadman + gameStatusData.werewolf_Count_CONFIG
		let conditionWerewolf = (tmpMadman <= imageIndex) && (imageIndex < tmpWerewolf)
		
		
		VStack{
			if conditionVil{
				CardView(showAllText: $showAllText, isCardFlipped: $isCardFlipped, role: Role.villager, imageWidth: imageFrameWidth, imageHeight: imageFrameHeight)
			}else if conditionTrainee{
				CardView(showAllText: $showAllText, isCardFlipped: $isCardFlipped, role: Role.trainee, imageWidth: imageFrameWidth, imageHeight: imageFrameHeight)
			}else if conditionSeer{
				CardView(showAllText: $showAllText, isCardFlipped: $isCardFlipped, role: Role.seer, imageWidth: imageFrameWidth, imageHeight: imageFrameHeight)
			}else if conditionMedium{
				CardView(showAllText: $showAllText, isCardFlipped: $isCardFlipped, role: Role.medium, imageWidth: imageFrameWidth, imageHeight: imageFrameHeight)
			}else if conditionHunter{
				CardView(showAllText: $showAllText, isCardFlipped: $isCardFlipped, role: Role.hunter, imageWidth: imageFrameWidth, imageHeight: imageFrameHeight)
			}else if conditionMadman{
				CardView(showAllText: $showAllText, isCardFlipped: $isCardFlipped, role: Role.madman, imageWidth: imageFrameWidth, imageHeight: imageFrameHeight)
			}else if conditionWerewolf{
				CardView(showAllText: $showAllText, isCardFlipped: $isCardFlipped, role: Role.werewolf, imageWidth: imageFrameWidth, imageHeight: imageFrameHeight)
			}
		}
		.scaleEffect(cardScale)
		.cardAnimationLToR(screenWidth: gameStatusData.fullScreenSize.width, threeOffSetTab: $threeOffSetTab, imageIndex: imageIndex)
		.cardFlippedAndPiled(isCardFlipped: $isCardFlipped, cardScale: $cardScale, imageIndex: imageIndex)
	}
}

struct CardView: View {
	@EnvironmentObject var gameStatusData: GameStatusData
	@State private var shake: Bool = false
	@State private var showText = false
	@Binding var showAllText: Bool
	@Binding var isCardFlipped: Bool
	var role: Role
	var imageWidth: CGFloat
	var imageHeight: CGFloat
	
	var body: some View {
		ZStack{
			if isCardFlipped == false{
				Image(role.image_name)
					.resizable()
					.frame(width: imageWidth, height: imageHeight)
					.onTapGesture {
						withAnimation {
							showText.toggle()
						}
					}
				if showText == true{
					VStack{
						Spacer()
						Text(role.japaneseName)
							.textFrameDesignProxy()
					}
				}
				Color.clear.frame(width: 0, height: 0)
					.onChange(of: showAllText){ _ in
						showText = showAllText
					}
			}else{
				Image(gameStatusData.currentTheme.cardBackSide)
					.resizable()
					.frame(width: imageWidth, height: imageHeight)
			}
		}
		.myButtonBounce()
	}
}

