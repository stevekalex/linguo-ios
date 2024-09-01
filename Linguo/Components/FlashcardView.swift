//
//  FlashcardView.swift
//  Linguo
//
//  Created by Steve Alex on 29/08/2024.
//

import Foundation
import SwiftUI

struct FlashcardView: View {
   @State var flashcard: FlashcardData
   @Binding var flashcards: [FlashcardData]
   @Binding var showFlashcardView: Bool
   @State private var showAnswer = false

   func resetFlashcard() {
        flashcards.remove(at: 0)

        if (flashcards.isEmpty) {
            showFlashcardView = false
        } else {
            flashcard = flashcards[0]
        }

        showAnswer = false
   }

   var body: some View {
        VStack {
            HStack {
                if (flashcard.promptImage != nil) {
                    Image(uiImage: flashcard.promptImage!)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(maxWidth: UIScreen.main.bounds.width - 75, maxHeight: 150)
                        .clipped()

                } else  {
                    Text(flashcard.promptString!)
                }
            }
            .onTapGesture {
                print("Tapped")
                showAnswer = true
            }
    
            if (showAnswer) {
                HStack {
                    Text(flashcard.answer)
                }

                HStack {
                    Button("Again") {
                        resetFlashcard()
                    }
                    Button("Hard") {
                        resetFlashcard()
                    }
                    Button("Good") {
                        resetFlashcard()
                    }
                    Button("Easy") {
                        resetFlashcard()
                    }
                }
            }
        }
   }
}
