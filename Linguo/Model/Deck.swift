//
//  Deck.swift
//  Linguo
//
//  Created by Steve Alex on 15/08/2024.

import Foundation
import FirebaseAuth
import FirebaseFirestore
import SwiftUI

struct IDeck: Identifiable, Encodable{
    let id: String
    let name: String
    let language: String
    let reviewedToday: Int
    let reviewCardsRemaining: Int
}

@MainActor
class DeckService: ObservableObject {
    @EnvironmentObject var viewModel: AuthViewModel

    @Published private(set) var decks: [IDeck] = []
    
    init() {
        Task {
            do {
                let decks = await getDecks()
                DispatchQueue.main.async {
                    self.decks = decks
                }
            } catch {
                print("Error fetching decks")
            }
            
        }
    }
    
    func getDecks() async -> [IDeck] {
        let userId = Auth.auth().currentUser?.uid
        let db = Firestore.firestore()
        var decks: [IDeck] = []

        do {
            let query = db.collection("decks")
                .whereField("userId", isEqualTo: userId)

            print(query)

            let querySnapshot = try await query.getDocuments()
            
            for document in querySnapshot.documents {
                let data = document.data()
                print("DATA")
                print(data)
                decks.append(IDeck(
                    id: document.documentID,
                    name: data["name"] as? String ?? "",
                    language: data["language"] as? String ?? "",
                    reviewedToday: data["reviewedToday"] as? Int ?? 0,
                    reviewCardsRemaining: data["reviewCardsRemaining"] as? Int ?? 0
                ))
            }
            
            return decks
            print(querySnapshot.documents)
        } catch {
            print("UNABLE TO GET DECKS")
        }
        
        return decks
    }


    func createNewDeck(name: String, language: String, reviewedToday: Int, reviewCardRemaining: Int) async {
        print("Create new deck")
        let newDeck: [String: Any] = [
            "name": name,
            "language": language,
            "reviewedToday": reviewedToday,
            "reviewCardsRemaining": reviewCardRemaining,
            "userId": Auth.auth().currentUser?.uid
        ]
        
        do {
            try await Firestore.firestore().collection("decks").addDocument(data: newDeck)
            decks.append(IDeck(id: "3", name: name, language: language, reviewedToday: reviewedToday, reviewCardsRemaining: reviewCardRemaining))
        } catch let error {
            print("Error adding deck: \(error)")
        }
    }
}
