import SwiftUI



struct Theme_Config: View {
	@EnvironmentObject var gameStatusData: GameStatusData
	@State var isExplanationViewShown: Bool = false
	@State var selectedRole: Role = .villager
	
	var body: some View {
		ZStack{
			Color.black
				.opacity(0.6)
			
			FadingScrollView{
				Color.clear
					.frame(height:20)
				ZStack{
					Text("役職紹介")
						.padding()
						.font(.system(.largeTitle, design: .serif))
						.fontWeight(.bold)
						.foregroundStyle(.black)
						.background(){
							Image(gameStatusData.currentTheme.textBackgroundImage)
								.aspectRatio(contentMode: .fill)
						}
						.cornerRadius(20.0)
						.clipped()
				}
				Text(" ")
					.font(.largeTitle)
				
				Color.clear
					.frame(height:10)
				CardPreview(selectedRole: $selectedRole, isExplanationViewShown: $isExplanationViewShown)
			}
			if isExplanationViewShown == true{
				ExplanationsView(isExplanationViewShown: $isExplanationViewShown, role: selectedRole)
			}
		}
	}
}

struct CardPreview: View{
	@EnvironmentObject var gameStatusData: GameStatusData
	@State var showAllText = false
	@Binding var selectedRole: Role
	@Binding var isExplanationViewShown: Bool
	private let OccupiedByCard: CGFloat = (3/4)
	private let CardRatio: CGFloat = (88/63)
	
	var body: some View {
		let imageFrameWidth: CGFloat =  CGFloat(gameStatusData.fullScreenSize.width*(2/3))
		let imageFrameHeight: CGFloat = CGFloat(imageFrameWidth * CardRatio)
		ZStack{
			HStack{
				Spacer()
				VStack{
					ThemeConfigScreen_CardView(role: Role.villager, imageWidth: imageFrameWidth, imageHeight: imageFrameHeight, isExplanationViewShown: $isExplanationViewShown, selectedRole: $selectedRole)
					
					ThemeConfigScreen_CardView(role: Role.werewolf, imageWidth: imageFrameWidth, imageHeight: imageFrameHeight, isExplanationViewShown: $isExplanationViewShown, selectedRole: $selectedRole)
					
					ThemeConfigScreen_CardView(role: Role.seer, imageWidth: imageFrameWidth, imageHeight: imageFrameHeight, isExplanationViewShown: $isExplanationViewShown, selectedRole: $selectedRole)
					
					ThemeConfigScreen_CardView(role: Role.hunter, imageWidth: imageFrameWidth, imageHeight: imageFrameHeight, isExplanationViewShown: $isExplanationViewShown, selectedRole: $selectedRole)
					
					ThemeConfigScreen_CardView(role: Role.medium, imageWidth: imageFrameWidth, imageHeight: imageFrameHeight, isExplanationViewShown: $isExplanationViewShown, selectedRole: $selectedRole)
					
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
	@Binding var isExplanationViewShown: Bool
	@Binding var selectedRole: Role
	
	var body: some View {
		VStack{
			Image(self.role.image_name)
				.resizable()
				.frame(width: imageWidth, height: imageHeight)
				.shadow(color: Color.gray, radius: 0, x: 3, y: 3)
			
			HStack{
				Text(self.role.japaneseName)
					.font(.title)
					.fontWeight(.bold)
					.textFrameDesignProxy()
				
				Button(action: {
					isExplanationViewShown = true
					selectedRole = self.role
				}) {
					Image(systemName: "info.circle")
						.font(.title)
						.foregroundColor(.blue)
						.opacity(0.9)
				}
				.myButtonBounce()
			}
			.padding()
		}
	}
}

struct ExplanationsView: View{
	@Binding var isExplanationViewShown: Bool
	var role: Role
	var body: some View{
		ZStack{
			Color.black.opacity(0.4)
			
			VStack{
				Rectangle()
					.fill(.clear)
					.frame(height: 50)
				
				Spacer()
				ExplanationsRole(isExplanationViewShown: $isExplanationViewShown, role: self.role)
				Spacer()
				Rectangle()
					.fill(.clear)
					.frame(height: 50)
			}
		}
	}
}

struct ExplanationsRole: View {
	@Binding var isExplanationViewShown: Bool
	var role: Role
	
	var body: some View {
		VStack{
			ZStack{
				Text("\(role.japaneseName)")
					.font(.system(.title, design: .rounded))
					.fontWeight(.heavy)
				
				
				HStack{
					Spacer()
					Button(action: {
						isExplanationViewShown = false
					}) {
						Image(systemName: "xmark.octagon")
							.font(.title)
							.foregroundColor(.blue)
					}
					.myButtonBounce()
					Rectangle()
						.fill(.clear)
						.frame(width: 10, height: 10)
				}
			}
			VStack(alignment: .leading){
				if role == .villager{
					Text("")
					Text("特別な能力を持たない一般市民です")
					Text("ゲームの目的は、人狼を見つけ出し村を守ることです")
					Text("昼の議論で怪しい人物を見つけ")
						.lineLimit(nil)
					Text("人狼と思われるプレイヤーを処刑するように投票します")
					Text("夜には何もできませんが推理で勝利に貢献します")
					
				}else if role == .seer{
					Text("")
					Text("毎晩他のプレイヤー1人を占い")
					Text("そのプレイヤーが")
						.lineLimit(nil)
					Text("「村人」か「人狼」かを知ることができます")
					Text("村を守るために重要な情報を持つ役職です")
					Text("人狼に狙われないように、慎重に行動しましょう")
				}else if role == .hunter{
					Text("")
					Text("毎晩1人のプレイヤーを選んで守ることができます")
					Text("守られたプレイヤーは")
						.lineLimit(nil)
					Text("人狼からの襲撃を防ぐことができます")
					Text("自分が生き延びるために護衛先を慎重に選び")
					Text("村の勝利に貢献しましょう")
				}else if role == .medium{
					Text("")
					Text("昼のターンで処刑されたプレイヤーが")
					Text("「村人」か「人狼」だったのかを知ることができます")
					Text("処刑した人物が")
						.lineLimit(nil)
					Text("正しかったのか、間違っていたのかを確認し")
					Text("議論を有利に進めることで")
					Text("村の勝利に貢献しましょう")
				}else if role == .werewolf{
					Text("")
					Text("目的は村人を騙し全滅させることです")
					Text("夜時間に村人を1人選んで襲撃します")
					Text("昼の議論では正体を隠し")
					Text("あたかも村人の一員であるかのようにふるまい")
					Text("投票から逃れましょう")
				}
			}
		}
		.textFrameSimple()
	}
}


