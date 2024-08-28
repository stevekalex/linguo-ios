//
//  DeckView.swift
//  Linguo
//
//  Created by Steve Alex on 15/08/2024.
//

import Foundation
import SwiftUI

struct DeckListView: View {
    @StateObject private var deckService = DeckService()
    @State private var showPopup: Bool = false

    var body: some View {
        NavigationView {
            VStack {
                List {
                    ForEach(deckService.decks) { deck in
                        NavigationLink(destination: DeckDetailView(deck: deck))
                        {
                            HStack () {
                                Text(deck.name)
                                Spacer()
                                Text(String(deck.reviewedToday))
                                    .foregroundStyle(.green)
                                    .font(.custom("Avenir Next Bold", size: 16))
                                
                                Text(String(deck.reviewCardsRemaining))
                                    .foregroundStyle(.red)
                                    .font(.custom("Avenir Next Bold", size: 16))
                            }
                        }
                    }
                }
                .navigationTitle("Decks")
                .navigationBarTitleDisplayMode(.inline)
                .font(.custom("Avenir Next", size: 16))
                .navigationBarItems(trailing: Button(action: {
                    showPopup = true
                } ) {
                    Image(systemName: "plus")
                        .resizable()
                        .padding(6)
                        .frame(width: 24, height: 24)
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

struct DeckListView_Previews: PreviewProvider {
    static var previews: some View {
        DeckListView()
            .environmentObject(DeckService())
    }
}
