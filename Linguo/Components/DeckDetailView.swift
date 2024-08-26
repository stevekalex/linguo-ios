//
//  DeckDetailView.swift
//  Linguo
//
//  Created by Steve Alex on 16/08/2024.
//

import Foundation
//
//  File.swift
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
            Text(deck.name)
                .font(.custom("Avenir Next Bold", size: 34))
                .fontWeight(.bold)
                .frame(width: UIScreen.main.bounds.width - 75)
            
            VStack (alignment: .leading) {
                Text("Language: \(deck.language)")
                Text("Reviewed Today: \(deck.reviewedToday)")
                Text("Remaining: \(deck.reviewCardsRemaining)")
            }
            
            HStack {
                NavigationLink(destination: CameraView(currentDeckId: deck.id))
                {
                    Text("Create ➕")
                        .font(.custom("Avenir Next Bold", size: 18))
                        .fontWeight(.semibold)
                        .frame(width: UIScreen.main.bounds.width - 250, height: 48)
                        .foregroundColor(.white)
                        .background(LinearGradient(gradient: Gradient(colors: [.green, .mint]), startPoint: .leading, endPoint: .trailing))
                        .cornerRadius(40)
                        .padding(.top, 30)
                }
                
                NavigationLink(destination: ReviewFlashcardView(deckId: deck.id))
                {
                    Text("Review ♻️")
                        .font(.custom("Avenir Next Bold", size: 18))
                        .fontWeight(.semibold)
                        .frame(width: UIScreen.main.bounds.width - 250, height: 48)
                        .foregroundColor(.white)
                        .background(LinearGradient(gradient: Gradient(colors: [.blue, .indigo]), startPoint: .leading, endPoint: .trailing))
                        .cornerRadius(40)
                        .padding(.top, 30)
                }
            }
        }
    }
}
