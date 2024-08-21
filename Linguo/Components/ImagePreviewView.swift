//
//  ImagePreviewView.swift
//  Linguo
//
//  Created by Steve Alex on 19/08/2024.
//


import Foundation
import SwiftUI
import FirebaseStorage

struct ImagePreviewView: View {
    @StateObject private var flashcardServce = FlashcardService()
    @State var currentDeckId: String
    @State var uiImage: UIImage
    
    
    func saveFlashcard() async {
        do {
            print("SAVE FLASHCARD")

            try await flashcardServce.createFlashcard(
                currentDeckId: currentDeckId,
                prompt: uiImage,
                answer: "Here is an answer",
                lastReviewDate: Date(),
                nextReviewDate: Date()
            )
        } catch {
            print("ERROR CREATING FLASHCARD")
        }
        
    }
    
    var body: some View {
        Image(uiImage: uiImage)
            .resizable()
            .aspectRatio(contentMode: .fit)
        
        Button(action: {
            Task {
                await saveFlashcard()
            }
            }, label: {
                Text("Create Flashcard")
            })
    }
}

//struct ImagePreviewView_Previews: PreviewProvider {
//    static var previews: some View {
//        ImagePreviewView()
//    }
//}
