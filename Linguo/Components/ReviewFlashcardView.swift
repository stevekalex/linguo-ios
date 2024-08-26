//
//  ReviewFlashcardView.swift
//  Linguo
//
//  Created by Steve Alex on 16/08/2024.
//

import Foundation
import SwiftUI
import FirebaseStorage

struct ReviewFlashcardView: View {
    @State var deckId: String
    @StateObject private var flashcardServce = FlashcardService()
    @State private var flashcards: [FlashcardData] = []
    
    func getFlashCardData(deckId: String, reviewDate: Date) async {
        do {
            let fetchedFlashcards = try await flashcardServce.getFlashcards(deckId: deckId, reviewDate: reviewDate)
            self.flashcards = fetchedFlashcards // Update the state variable
        } catch {
            print("Error loading flashcards")
        }
    }
    
    var body: some View {
        VStack {
            Text("deckId \(deckId)")
            Text("Review flashcard view")
            ForEach(flashcards) { flashcard in
                Image(uiImage: flashcard.image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)
                Text(flashcard.answer)
            }
        }
        .onAppear {
            Task {
                await getFlashCardData(deckId: deckId, reviewDate: Date())
            }
        }
    }
}

struct ReviewFlashcardView_Previews: PreviewProvider {
    static var previews: some View {
        ReviewFlashcardView(deckId: "123")
    }
}
