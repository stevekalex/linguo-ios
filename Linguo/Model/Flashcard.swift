//
//  AuthViewModel.swift
//  Linguo
////
////  Created by Steve Alex on 14/08/2024.
////
import FirebaseAuth
import FirebaseFirestore
import Foundation

@MainActor
class FlashcardModel: ObservableObject {
//    @Published var userSession: FirebaseAuth.User?
//    @Published var currentUser: User?
//
//    init() {
//        self.userSession = Auth.auth().currentUser
//        
//        Task {
//            await fetchUser()
//        }
//    }
    
    func createFlashcard(name: String, language: String) {
        let result = try await Auth.auth().createUser(withEmail: email, password: password)

    }

}
