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
    @State private var showFlashcardView: Bool = false
    @State private var currentIndex: Int = 0
    
    @State private var shouldAnimate = false
    
    func getFlashCardData(deckId: String, reviewDate: Date) async {
        do {
            let fetchedFlashcards = try await flashcardServce.getFlashcards(deckId: deckId, reviewDate: reviewDate);
            self.flashcards = fetchedFlashcards
            if (self.flashcards.count > 0) {
                self.flashcard = self.flashcards[0]
                self.showFlashcardView = true
            }
                    } catch {
            print("Error loading flashcards: \(error.localizedDescription)")
        }
    }
    
    var body: some View {
        VStack {
            if showFlashcardView, let currentFlashcard = flashcard {
                FlashcardView(
                    flashcard: currentFlashcard,
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
            } else {
                HStack {
                    Circle()
                        .fill(Color.blue)
                        .frame(width: 20, height: 20)
                        .scaleEffect(shouldAnimate ? 1.0 : 0.5)
                        .animation(Animation.easeInOut(duration: 0.5).repeatForever())
                    Circle()
                        .fill(Color.blue)
                        .frame(width: 20, height: 20)
                        .scaleEffect(shouldAnimate ? 1.0 : 0.5)
                        .animation(Animation.easeInOut(duration: 0.5).repeatForever().delay(0.3))
                    Circle()
                        .fill(Color.blue)
                        .frame(width: 20, height: 20)
                        .scaleEffect(shouldAnimate ? 1.0 : 0.5)
                        .animation(Animation.easeInOut(duration: 0.5).repeatForever().delay(0.6))
                }
                .onAppear {
                    self.shouldAnimate = true
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
