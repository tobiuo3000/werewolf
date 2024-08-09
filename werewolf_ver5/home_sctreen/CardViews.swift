import SwiftUI

struct CardGalleryView: View {
	@EnvironmentObject var gameStatusData: GameStatusData
	@Binding var beforeGameViewOffset: CGFloat
	@Binding var showAllText: Bool
	@Binding var gameStartFlag: Bool
	private let spacing: CGFloat = 8
	private let numberOfColumn: CGFloat = 4
	
	var body: some View{
		GeometryReader { geometry in
			let imageFrameWidth: CGFloat =  CGFloat(geometry.size.width / (numberOfColumn + 1)) // SCREEN WIDTH: 393
			let imageFrameHeight: CGFloat = CGFloat(imageFrameWidth * (88/63))
			let numberOfImagesInRow: Int = Int(geometry.size.width / (imageFrameWidth + spacing))
			let numberOfRows: Int = (gameStatusData.players_CONFIG.count + numberOfImagesInRow - 1) / numberOfImagesInRow
			VStack{
				HStack{
					Spacer()
					ScrollView{
						VStack(alignment: .leading, spacing: spacing) {
							ForEach(0..<numberOfRows, id: \.self) { rowIndex in
								HStack(spacing: spacing) {
									ForEach(0..<numberOfImagesInRow, id: \.self) { columnIndex in
										CardFlippingAnimation(showAllText: $showAllText, gameStartFlag: $gameStartFlag, beforeGameViewOffset: $beforeGameViewOffset, rowIndex: rowIndex, numberOfImagesInRow: numberOfImagesInRow, columnIndex: columnIndex, imageFrameWidth: imageFrameWidth, imageFrameHeight: imageFrameHeight)
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
}

struct CardFlippingAnimation: View{
	@EnvironmentObject var gameStatusData: GameStatusData
	@State var cardScale: CGFloat = 1.0
	@State var isCardFlipped: Bool = false
	@Binding var showAllText: Bool
	@Binding var gameStartFlag: Bool
	@Binding var beforeGameViewOffset: CGFloat
	
	let rowIndex: Int
	let numberOfImagesInRow: Int
	let columnIndex: Int
	let imageFrameWidth: CGFloat
	let imageFrameHeight: CGFloat
	
	var body: some View{
		let imageIndex = rowIndex * numberOfImagesInRow + columnIndex
		let conditionVil = imageIndex < gameStatusData.villager_Count_CONFIG
		let conditionWerewolf = (gameStatusData.villager_Count_CONFIG <= imageIndex) && (imageIndex < gameStatusData.villager_Count_CONFIG + gameStatusData.werewolf_Count_CONFIG)
		let conditionSeer = (gameStatusData.villager_Count_CONFIG + gameStatusData.werewolf_Count_CONFIG <= imageIndex) && (imageIndex < gameStatusData.villager_Count_CONFIG + gameStatusData.werewolf_Count_CONFIG + gameStatusData.seer_Count_CONFIG)
		
		VStack{
				if conditionVil{
					CardView(showAllText: $showAllText, isCardFlipped: $isCardFlipped, role: Role.villager, imageWidth: imageFrameWidth, imageHeight: imageFrameHeight)
				}else if conditionWerewolf{
					CardView(showAllText: $showAllText, isCardFlipped: $isCardFlipped, role: Role.werewolf, imageWidth: imageFrameWidth, imageHeight: imageFrameHeight)
				}else if conditionSeer{
					CardView(showAllText: $showAllText, isCardFlipped: $isCardFlipped, role: Role.seer, imageWidth: imageFrameWidth, imageHeight: imageFrameHeight)
				}
		}
		.scaleEffect(cardScale)
		.cardAnimationLToR(beforeGameViewOffset: $beforeGameViewOffset, imageIndex: imageIndex)
		.cardFlippedAndPiled(gameStartFlag: $gameStartFlag, isCardFlipped: $isCardFlipped, cardScale: $cardScale, imageIndex: imageIndex)
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
					.myButtonBounce()
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
	}
}

