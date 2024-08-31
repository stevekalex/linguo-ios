//
//  ReviewFlashcardView.swift
//  Linguo
//
//  Created by Steve Alex on 16/08/2024.
//

import Foundation
import SwiftUI
import FirebaseStorage

struct FlashcardReviewSessionView: View {
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
            self.showFlashcardView = true
        } catch {
            print("Error loading flashcards")
        }
    }
    
    var body: some View {
        VStack {
            if showFlashcardView {
                FlashcardView(
                    flashcard: flashcard!,
                    flashcards: $flashcards,
                    showFlashcardView: $showFlashcardView
                )
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
