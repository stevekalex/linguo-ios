//
//  Deck.swift
//  Linguo
//
//  Created by Steve Alex on 15/08/2024.

import Foundation
import FirebaseAuth
import FirebaseFirestore

struct IDeck: Identifiable, Encodable{
    let id: Int
    let name: String
    let language: String
    let reviewedToday: Int
    let reviewCardsRemaining: Int
}

@MainActor
class DeckService: ObservableObject {
    @Published private(set) var decks: [IDeck] = [
        IDeck(id: 1, name: "Spanish Vocabulary (Intermediate)", language: "Spanish", reviewedToday: 0, reviewCardsRemaining: 10),
        IDeck(id: 2, name: "Spanish Conversation (Beginner)", language: "Spanish", reviewedToday: 5, reviewCardsRemaining: 4),
    ]


    func createNewDeck(name: String, language: String, reviewedToday: Int, reviewCardRemaining: Int) async {
        print("Create new deck")
        let newDeck: [String: Any] = [
            "name": name,
            "language": language,
            "reviewedToday": reviewedToday,
            "reviewCardsRemaining": reviewCardRemaining
        ]
        
        do {
            try await Firestore.firestore().collection("decks").addDocument(data: newDeck)
            decks.append(IDeck(id: 3, name: name, language: language, reviewedToday: reviewedToday, reviewCardsRemaining: reviewCardRemaining))
        } catch let error {
            print("Error adding deck: \(error)")
        }
    }
}
