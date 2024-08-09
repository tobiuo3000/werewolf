import SwiftUI



struct Theme_Config: View {
	@EnvironmentObject var gameStatusData: GameStatusData
	
	var body: some View {
		ZStack{
			Color.black
			
			ScrollView{
				ZStack{
					
					
					VStack(spacing: 0){
						ForEach(0..<2) { _ in
							Image(gameStatusData.currentTheme.textBackgroundImage)  // BACKGROUND SHEEPSKIN
								.resizable()
								.frame(maxWidth: .infinity, maxHeight:.infinity)
								.allowsHitTesting(false)
								.clipped()
						}
					}
					
					
					VStack{
						Color.clear
							.frame(height:20)
						Text("役 職 一 覧")
							.font(.system(.largeTitle, design: .serif))
						
						Color.clear
							.frame(height:10)
						CardPreview()
						Text("下部のビュー")
							.foregroundColor(.white)
					}
				}
				
			}
		}
	}
}

struct CardPreview: View{
	@EnvironmentObject var gameStatusData: GameStatusData
	@State var showAllText = false
	private let OccupiedByCard: CGFloat = (3/4)
	private let CardRatio: CGFloat = (88/63)
	
	
	
	var body: some View {
		GeometryReader { geometry in
			let imageFrameWidth: CGFloat =  CGFloat(geometry.size.width * OccupiedByCard)
			let imageFrameHeight: CGFloat = CGFloat(imageFrameWidth * CardRatio)
			HStack{
				Spacer()
				VStack{
					ThemeConfigScreen_CardView(role: Role.villager, imageWidth: imageFrameWidth, imageHeight: imageFrameHeight)
					Text(Role.villager.japaneseName)
						.textFrameDesignProxy()
					ThemeConfigScreen_CardView(role: Role.seer, imageWidth: imageFrameWidth, imageHeight: imageFrameHeight)
					Text(Role.seer.japaneseName)
						.textFrameDesignProxy()
					ThemeConfigScreen_CardView(role: Role.werewolf, imageWidth: imageFrameWidth, imageHeight: imageFrameHeight)
					Text(Role.werewolf.japaneseName)
						.textFrameDesignProxy()
					
				}
				
				Spacer()
			}
			
		}
	}
}


struct ThemeConfigScreen_CardView: View {
	var role: Role
	var imageWidth: CGFloat
	var imageHeight: CGFloat
	
	var body: some View {
		Image(role.image_name)
			.resizable()
			.frame(width: imageWidth, height: imageHeight)
			.shadow(color: Color.gray, radius: 0, x: 3, y: 3)
	}
}



