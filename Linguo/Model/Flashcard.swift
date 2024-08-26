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

struct FlashcardData: Identifiable {
    let id: String
    let promptImageUrl: String
    let image: UIImage
    let answer: String
    let lastReviewDate: Date
    let nextReviewDate: Date
}

@MainActor
class FlashcardService: ObservableObject {
    func getFlashcards(deckId: String, reviewDate: Date) async throws -> [FlashcardData]  {
        print("GET FLASHCARDS")
        let db = Firestore.firestore()
        let query = db.collection("flashcards").whereField("deckId", isEqualTo: deckId)
        let querySnapshot = try await query.getDocuments()
        
        var flashcards: [FlashcardData] = []
        
        for document in querySnapshot.documents {
            let data = document.data()
            let image = await getImageData(imageUrl: data["promptImageUrl"] as? String ?? "")
            flashcards.append(
                FlashcardData(
                    id: document.documentID,
                    promptImageUrl: data["promptImageUrl"] as? String ?? "",
                    image: image,
                    answer: data["answer"] as? String ?? "",
                    lastReviewDate: data["lastReviewDate"] as? Date ?? Date(),
                    nextReviewDate: data["nextReviewDate"] as? Date ?? Date()
                )
            )
        }
        
        return flashcards
    }
    
    
    func getImageData(imageUrl: String) async -> UIImage {
        let storageRef = Storage.storage().reference(forURL: imageUrl)
        let defaultImage: UIImage = UIImage()
        
        do {
             // Fetch data asynchronously
             let data = try await storageRef.data(maxSize: 11795930)
             print("DATA =>")
             print(data)
             // Attempt to create a UIImage from the fetched data
             if let image = UIImage(data: data) {
                 print("GOT IMAGE")
                 return image
             } else {
                 print("UNABLE TO IMAGE")
                 return defaultImage
             }
         } catch {
             // If an error occurs, return the default image
             print("Error fetching image: \(error)")
             return defaultImage
         }
    }
    
    func createFlashcard<T: Equatable>(deckId: String, prompt: T, answer: String) async throws -> String {
        print("PROMPT >>")
        print(prompt)
        var flashcardData: [String: Any] = [:]
        let db = Firestore.firestore()
        
        if let stringPrompt = prompt as? String {
            flashcardData = [
                "promptImageUrl": "",
                "promptString": prompt,
                "answer": answer,
                "lastReviewDate": Date(),
                "nextReviewDate": Date(),
                "deckId": deckId
            ]
        } else if let imagePrompt = prompt as? UIImage {
            // TODO - refactor this into another method to store image
            let fileStorage = Storage.storage().reference()
            guard let imageData = imagePrompt.jpegData(compressionQuality: 0.8) else {
              throw NSError(domain: "ImageConversionError", code: 0, userInfo: nil)
            }
            
            let imageRef = fileStorage.child("\(deckId)/\(UUID().uuidString).jpg")
        
            let uploadTask = try await imageRef.putDataAsync(imageData, metadata: nil)
            let downloadURL = try await imageRef.downloadURL()
                    
            flashcardData = [
                "promptImageUrl": downloadURL.absoluteString,
                "promptString": "",
                "answer": answer,
                "lastReviewDate": Date(),
                "nextReviewDate": Date(),
                "deckId": deckId
            ]
        }
        
        let docRef = db.collection("flashcards").document()
        try await docRef.setData(flashcardData)
            
        return docRef.documentID
    }
}
