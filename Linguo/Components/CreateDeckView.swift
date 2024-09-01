import SwiftUI

struct CreateDeckView: View {
    @Binding var showPopup: Bool
    @State var newDeckName = ""
    @State var newDeckLanguage = ""
    let languages = ["Spanish", "Italian", "French", "English", "Malayalam", "Hindi"]
    

    var body: some View {
        Form {
            DeckDetailsSection(newDeckName: $newDeckName, newDeckLanguage: $newDeckLanguage, languages: languages)
            CreateDeckButtonSection(showPopup: $showPopup, newDeckName: newDeckName, newDeckLanguage: newDeckLanguage)
        }
        .navigationBarItems(leading: Button(action: {
            showPopup = false
        } ) {
            Image(systemName: "chevron.backward")
            Text("Back")
        } )
        .navigationTitle("Create Deck")
        .navigationBarTitleDisplayMode(.inline)

    }
}

struct DeckDetailsSection: View {
    @Binding var newDeckName: String
    @Binding var newDeckLanguage: String
    let languages: [String]

    var body: some View {
        Section() {
            TextField("Deck Name", text: $newDeckName)
            Picker("Language", selection: $newDeckLanguage) {
                ForEach(languages, id: \.self) { language in
                    Text(language).tag(language)
                }
            }
        }
    }
}       

struct CreateDeckButtonSection: View {
    @EnvironmentObject var deckService: DeckService
    @Binding var showPopup: Bool
    let newDeckName: String
    let newDeckLanguage: String

    var body: some View {
        Section {
            GeometryReader { geometry in
                HStack {
                    Spacer()
                    Button("Create Deck") {
                        print("Create Deck")
                        showPopup = false
                        Task {
                            await deckService.createNewDeck(
                                name: newDeckName,
                                language: newDeckLanguage,
                                reviewedToday: 0,
                                reviewCardRemaining: 0
                            )
                        }
                    }
                    .frame(maxWidth: geometry.size.width / 2, maxHeight: .infinity)
                    Spacer()
                }
            }
        }
    }
}

struct CreateDeckView_Previews: PreviewProvider {
    static var previews: some View {
        CreateDeckView(showPopup: .constant(true))
            .environmentObject(DeckService())
    }
}

