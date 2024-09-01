import Foundation
import SwiftUI
private let fonts = Fonts.init()


struct DeckListView: View {
    @StateObject private var deckService = DeckService()
    @State private var showPopup: Bool = false

    private let buttonSize: CGFloat = 24
    private let deckFontSize: CGFloat = 16

    var body: some View {
        NavigationView {
            VStack {
                List {
                    ForEach(deckService.decks) { deck in
                        NavigationLink(destination: DeckDetailView(deck: deck)) {
                            DeckRowView(deck: deck)
                        }
                    }
                }
                .navigationTitle("Decks")
                .navigationBarTitleDisplayMode(.inline)
                .font(fonts.main(deckFontSize))
                .navigationBarItems(trailing: Button(action: {
                    showPopup = true
                } ) {
                    Image(systemName: "plus")
                        .resizable()
                        .padding(6)
                        .frame(width: buttonSize, height: buttonSize)
                        .background(Color.blue)
                        .clipShape(Circle())
                        .foregroundColor(.white)
                } )
            }
            .blur(radius: showPopup ? 7 : 0)
        }
        .popupNavigationView(show: $showPopup) {
            CreateDeckView(showPopup: $showPopup)
        }
        .environmentObject(deckService)
    }
}

struct DeckRowView: View {
    let deck: IDeck
    private let deckFontSize: CGFloat = 18
    private let reviewedCardsFontSize: CGFloat = 14

    var body: some View {
        HStack {
            Text(deck.name)
                .font(fonts.main(deckFontSize))
            Spacer()
            Text(String(deck.reviewedToday))
                .foregroundStyle(.green)
                .font(fonts.header(reviewedCardsFontSize))

            Text(String(deck.reviewCardsRemaining))
                .foregroundStyle(.red)
                .font(fonts.header(reviewedCardsFontSize))
        }
    }
}

struct DeckListView_Previews: PreviewProvider {
    static var previews: some View {
        DeckListView()
            .environmentObject(DeckService())
    }
}
