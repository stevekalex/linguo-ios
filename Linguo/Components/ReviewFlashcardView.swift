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
    @State private var flashcard: FlashcardData?;
    @State private var showFlashcardView = false
    @State private var currentIndex: Int = 0
    
    func getFlashCardData(deckId: String, reviewDate: Date) async {
        do {
            let fetchedFlashcards = try await flashcardServce.getFlashcards(deckId: deckId, reviewDate: reviewDate);
            self.flashcards = fetchedFlashcards
            self.flashcard = fetchedFlashcards[0]
            self.showFlashcardView = true // Set showFlashcardView to true after retrieving flashcards
        } catch {
            print("Error loading flashcards")
        }
    }
    
    var body: some View {
        VStack {
            if showFlashcardView {
                VStack {
                    if (flashcard!.promptImage != nil) {
                        Image(uiImage: flashcard!.promptImage!)
                            .resizable()
                            .scaledToFit()

                    } else  {
                        Text(flashcard!.promptString!)
                    }
                }
                .onTapGesture {
                    print("Tapped")
                    flashcards.remove(at: 0)
                    
                    if ($flashcards.isEmpty) {
                        showFlashcardView = false
                    } else {
                        flashcard = flashcards[0]
                    }
                }
            }
        }
        .onAppear {
            Task {
                try await getFlashCardData(deckId: deckId, reviewDate: Date())
            }
        }
    }
}

//struct ReviewFlashcardView_Previews: PreviewProvider {
//    static var previews: some View {
//        ReviewFlashcardView(deckId: "123")
//    }
//}
