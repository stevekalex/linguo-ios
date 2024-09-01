//
//  ComponentView.swift
//  Linguo
//
//  Created by Steve Alex on 13/08/2024.
//

import SwiftUI

struct CreateDeckView: View {
    @EnvironmentObject var deckService: DeckService
    @Binding var showPopup: Bool
    @State var newDeckName = ""
    @State var newDeckLanguage = ""
    let languages = ["Spanish", "Italian", "French", "English", "Malayalam", "Hindi"]
    

    var body: some View {
        Form {
            Section {
                VStack {
                    TextField(
                        "Deck Name",
                        text: $newDeckName
                    )
                    Picker("Language", selection: $newDeckLanguage) {
                        Text("Language").tag(nil as String?)
                        ForEach(languages, id: \.self) { item in
                            Text(item)
                        }
                    }
                    .pickerStyle(.menu)
                }
            }
            
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

struct CreateDeckView_Previews: PreviewProvider {
    static var previews: some View {
        CreateDeckView(showPopup: .constant(true))
            .environmentObject(DeckService())
    }
}

