//
//  Deck.swift
//  Linguo
//
//  Created by Steve Alex on 15/08/2024.

import Foundation
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage
import SwiftUI

struct FlashcardData: Codable {
    let promptImageUrl: String
    let answer: String
    let lastReviewDate: Date
    let nextReviewDate: Date
}

@MainActor
class FlashcardService: ObservableObject {
    func createFlashcard(currentDeckId: String, prompt: UIImage, answer: String, lastReviewDate: Date, nextReviewDate: Date) async throws -> String {
        print("Create new flashcard!")

        let db = Firestore.firestore()
        let fileStorage = Storage.storage().reference()
        
        guard let imageData = prompt.jpegData(compressionQuality: 0.8) else {
          throw NSError(domain: "ImageConversionError", code: 0, userInfo: nil)
        }
        
        print("Image Data => \(imageData)")
        
        let imageRef = fileStorage.child("\(currentDeckId)/\(UUID().uuidString).jpg")
        
        print("Image Ref => \(imageRef)")

        
        let uploadTask = try await imageRef.putDataAsync(imageData, metadata: nil)
        let downloadURL = try await imageRef.downloadURL()
        
        print("downloadURL => \(downloadURL)")
        
        let flashcardData: [String: Any] = [
            "promptImageUrl": downloadURL.absoluteString,
            "answer": answer,
            "lastReviewDate": lastReviewDate,
            "nextReviewDate": nextReviewDate,
            "deckId": currentDeckId
        ]
        
        let docRef = db.collection("flashcards").document()
        try await docRef.setData(flashcardData)
        return docRef.documentID

    }
}
