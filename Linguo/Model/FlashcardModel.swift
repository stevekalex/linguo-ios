//
//  Deck.swift
//  Linguo
//
//  Created by Steve Alex on 15/08/2024.

import Foundation
import Firebase
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage
import SwiftUI

struct FlashcardData: Identifiable {
    let id: String
    let promptImage: UIImage?
    let promptString: String?
    let answer: String
    var due: Date
    var lastReview: Date
    var stability: Double
    var difficulty: Double
    var elapsedDays: Double
    var scheduledDays: Double
    var reps: Int
    var lapses: Int
    var status: Status
}

@MainActor
class FlashcardService: ObservableObject {
    func getFlashcards(deckId: String, reviewDate: Date) async throws -> [FlashcardData]  {
        print("GET FLASHCARDS")
        let db = Firestore.firestore()
        let query = db.collection("flashcards").whereField("deckId", isEqualTo: deckId).whereField("nextReviewDate", isLessThan: Date())
        let querySnapshot = try await query.getDocuments()
        
        print(querySnapshot)
        print("querySnapshot")
        
        var flashcards: [FlashcardData] = []
        
        for document in querySnapshot.documents {
            let data = document.data()
            var image: UIImage?
            
            if (data["promptImageUrl"] as? String != "") {
                image = await getImageData(imageUrl: data["promptImageUrl"] as? String ?? "")
            }

            var lastReview: Date
            
            if let lastReviewTimestamp = data["lastReview"] as? Timestamp {
                let seconds = lastReviewTimestamp.seconds
                let nanoseconds = lastReviewTimestamp.nanoseconds

                // Convert seconds and nanoseconds to a Date object
                lastReview = Date(timeIntervalSince1970: Double(seconds) + Double(nanoseconds) / 1_000_000_000)
            } else {
                lastReview = Date()
            }
            
            var due: Date
            
            if let dueTimestamp = data["due"] as? Timestamp {
                let seconds = dueTimestamp.seconds
                let nanoseconds = dueTimestamp.nanoseconds

                // Convert seconds and nanoseconds to a Date object
                due = Date(timeIntervalSince1970: Double(seconds) + Double(nanoseconds) / 1_000_000_000)
            } else {
                due = Date()
            }
            
            flashcards.append(
                FlashcardData(
                    id: document.documentID,
                    promptImage: image ?? nil,
                    promptString: data["promptString"] as? String ?? "",
                    answer: data["answer"] as? String ?? "",
                    due: due,
                    lastReview: lastReview,
                    stability: data["stability"] as? Double ?? Double(),
                    difficulty: data["difficulty"] as? Double ?? 0.0,
                    elapsedDays: data["elapsedDays"] as? Double ?? 0.0,
                    scheduledDays: data["scheduledDays"] as? Double ?? 0.0,
                    reps: Int(data["reps"] as? Double ?? 0.0),
                    lapses: data["lapses"] as? Int ?? 0,
                    status: Status(rawValue: data["status"] as? String ?? "learning") as? Status ?? Status.learning
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
             let data = try await storageRef.data(maxSize: 11795930) // TODO - make this more appropriate or compress image before storing
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
        
        let card = Card()
        
        if let stringPrompt = prompt as? String {
            flashcardData = [
                "promptImageUrl": "",
                "promptString": stringPrompt,
                "answer": answer,
                "lastReviewDate": Date(),
                "nextReviewDate": Date(),
                "deckId": deckId,
                "stability": card.stability,
                "difficulty": card.difficulty,
                "elapsedDays": card.elapsedDays,
                "scheduledDays": card.scheduledDays,
                "reps": card.reps,
                "lapses": card.lapses,
                "status": String(describing: card.status)
                
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
                "deckId": deckId,
                "stability": card.stability,
                "difficulty": card.difficulty,
                "elapsedDays": card.elapsedDays,
                "scheduledDays": card.scheduledDays,
                "reps": card.reps,
                "lapses": card.lapses,
                "status": String(describing: card.status)
            ]
        }
        
        print("flashcardData =>")
        print(flashcardData)
        
        let docRef = db.collection("flashcards").document()
        try await docRef.setData(flashcardData)
            
        return docRef.documentID
    }
    
    func updateCardSchedule(flashcard: FlashcardData, rating: Rating) async throws {
        let card = Card(
             due: flashcard.due,
             stability: flashcard.stability,
             difficulty: flashcard.difficulty,
             elapsedDays: flashcard.elapsedDays,
             scheduledDays: flashcard.scheduledDays,
             reps: flashcard.reps,
             lapses: flashcard.lapses,
             status: flashcard.status,
             lastReview: flashcard.due
        )
        let updateCard = getCardUpdateState(card: card, rating: rating)
        
        
        let db = Firestore.firestore()
        let docRef = db.document("flashcards/\(flashcard.id)")

        do {
            try await docRef.updateData([
                "due":  updateCard.due,
                "stability":  updateCard.stability,
                "difficulty":  updateCard.difficulty,
                "elapsedDays":  updateCard.elapsedDays,
                "scheduledDays":  updateCard.scheduledDays,
                "reps": updateCard.reps,
                "lapses":  updateCard.lapses,
                "status":  String(describing: updateCard.status),
                "lastReview": updateCard.lastReview,
                "nextReviewDate": updateCard.due
            ])
            print("Document updated successfully")
        } catch {
            print("Error updating document: \(error)")
        }
    }
    
    private func getCardUpdateState(card: Card, rating: Rating) -> Card {
        let now = Date()
        let srs = SRS()
        var schedulingCards = srs.repeat(card: card, now: now)
        return schedulingCards[rating]!.card
    }
    
}
