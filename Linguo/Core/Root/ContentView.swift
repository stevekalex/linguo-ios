//
//  ContentView.swift
//  Linguo
//
//  Created by Steve Alex on 12/08/2024.
//

import SwiftUI
import SwiftData
import Firebase

struct ContentView: View {
    @EnvironmentObject var viewModel: AuthViewModel

    var body: some View {
        Group {
            if viewModel.userSession != nil {
                DeckListView()
            } else {
                LoginView()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        DeckListView()
    }
}
