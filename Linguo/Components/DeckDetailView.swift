//
//  DeckDetailView.swift
//  Linguo
//
//  Created by Steve Alex on 16/08/2024.
//

import Foundation
import SwiftUI

struct DeckDetailView: View {
    var deck: IDeck

    var body: some View {
        VStack {
            Spacer()
            
            VStack (alignment: .leading) {
                HStack {
                    Text(deck.name)
                        .font(.custom("Avenir Next Bold", size: 34))
                        .fontWeight(.bold)
                    
                    Text(String(deck.reviewedToday))
                        .foregroundStyle(.green)
                        .font(.custom("Avenir Next Bold", size: 34))

                    
                    Text(String(deck.reviewCardsRemaining))
                        .foregroundStyle(.red)
                        .font(.custom("Avenir Next Bold", size: 34))
                }
                .truncationMode(.tail)
                .frame(width: UIScreen.main.bounds.width - 75)
                .padding(.top, 10)
                .padding([.leading, .trailing], 8)
            }
        
            HStack {
                NavigationLink(destination: CreateFlashcardView(deckId: deck.id, language: deck.language))
                {
                    Text("Create ➕")
                        .font(Fonts.main(18))
                        .fontWeight(.semibold)
                        .frame(width: UIScreen.main.bounds.width - 250, height: 48)
                        .foregroundColor(.white)
                        .background(LinearGradient(gradient: Gradient(colors: [.green, .mint]), startPoint: .leading, endPoint: .trailing))
                        .cornerRadius(40)
                        .padding(.top, 30)
                }
                
                NavigationLink(destination: FlashcardReviewSessionView(deckId: deck.id))
                {
                    Text("Review ♻️")
                        .font(Fonts.main(18))
                        .fontWeight(.semibold)
                        .frame(width: UIScreen.main.bounds.width - 250, height: 48)
                        .foregroundColor(.white)
                        .background(LinearGradient(gradient: Gradient(colors: [.blue, .indigo]), startPoint: .leading, endPoint: .trailing))
                        .cornerRadius(40)
                        .padding(.top, 30)
                }
            }
            .padding(.bottom, 50)
            
            Spacer()
        }
    }
}
