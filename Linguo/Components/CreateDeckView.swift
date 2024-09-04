import SwiftUI

struct CreateDeckView: View {
    @Binding var showPopup: Bool
    @State var newDeckName = ""
    @State var newDeckLanguage = SupportedLanguages.allLanguages[0]
    @State private var showAlert = false

    var body: some View {
        Form {
            DeckDetailsSection(newDeckName: $newDeckName, newDeckLanguage: $newDeckLanguage)
            CreateDeckButtonSection(showPopup: $showPopup, newDeckName: newDeckName, newDeckLanguage: newDeckLanguage, showAlert: $showAlert)
        }
        .navigationBarItems(leading: Button(action: {
            showPopup = false
        } ) {
            Image(systemName: "chevron.backward")
            Text("Back")
        } )
        .navigationTitle("Create Deck")
        .navigationBarTitleDisplayMode(.inline)
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Error"), message: Text("Deck name cannot be empty"), dismissButton: .default(Text("OK")))
        }
    }
}

struct DeckDetailsSection: View {
    @Binding var newDeckName: String
    @Binding var newDeckLanguage: String

    var body: some View {
        Section() {
            TextField("Deck Name", text: $newDeckName)
            Picker("Language", selection: $newDeckLanguage) {
                ForEach(SupportedLanguages.allLanguages, id: \.self) { language in
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
    @Binding var showAlert: Bool

    var body: some View {
        Section {
            GeometryReader { geometry in
                HStack {
                    Spacer()
                    Button("Create Deck") {
                        if newDeckName.isEmpty {
                            showAlert = true
                        } else {
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

