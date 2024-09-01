//
//  LinguoApp.swift
//  Linguo
//
//  Created by Steve Alex on 12/08/2024.
//

import SwiftUI
import SwiftData
import FirebaseCore

@main
struct LinguoApp: App {
    @StateObject var viewModel = AuthViewModel()

    
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(viewModel)
        }
    }
}

