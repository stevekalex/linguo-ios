//
//  CreateFlashCardView.swift
//  Linguo
//
//  Created by Steve Alex on 26/08/2024.

import SwiftUI

extension View {
    func hideKeyboard() {
        let resign = #selector(UIResponder.resignFirstResponder)
        UIApplication.shared.sendAction(resign, to: nil, from: nil, for: nil)
    }
}

struct CreateFlashcardView: View {
    @State var deckId: String
    @State var prompt: String = ""
    @State var answer: String = ""
    @State private var toast: Toast? = nil
    @StateObject private var flashCardService = FlashcardService()

    var body: some View {
        GeometryReader { geometry in
            VStack {
                Text("Create")
                    .frame(alignment: .top)
                    .font(.custom("Avenir Next Bold", size: 34))
                    .fontWeight(.bold)
                    .frame(width: geometry.size.width - 75)
                    .padding(.top, geometry.safeAreaInsets.top - 50)
                
                
                VStack {
                    Text("Front")
                        .frame(alignment: .leading)
                        .font(.custom("Avenir Next", size: 20))
                        .fontWeight(.bold)
                        .frame(width: UIScreen.main.bounds.width - 75)
                    
                    TextField("", text: $prompt, axis: .vertical)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.white, lineWidth: 3)
                        )
                        .frame(width: UIScreen.main.bounds.width - 75)
                        .lineLimit(5, reservesSpace: true)
                        .multilineTextAlignment(.leading)
                        .font(.custom("Avenir Next", size: 14))
                        .padding(.bottom, 20)
                }
                
                VStack {
                    Text("Back")
                        .frame(alignment: .leading)
                        .font(.custom("Avenir Next", size: 20))
                        .fontWeight(.bold)
                        .frame(width: UIScreen.main.bounds.width - 75)
                    
                    TextField("", text: $answer, axis: .vertical)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.white, lineWidth: 3)
                        )
                        .frame(width: UIScreen.main.bounds.width - 75)
                        .lineLimit(6, reservesSpace: true)
                        .multilineTextAlignment(.leading) // Align text to the left
                        .font(.custom("Avenir Next", size: 14)) // Set custom font and size
                }
            }
            .frame(width: geometry.size.width)
        }
        .navigationBarItems(trailing: Button(action: {
            print("Create flashcard!")
            toast = Toast(style: .success, message: "Saved.", width: 160)
            // TODO - create popup + with success message + wipe out state
            Task {
                try await flashCardService.createFlashcard(
                    deckId: deckId,
                    prompt: prompt,
                    answer: answer
                )
                prompt = ""
                answer = ""
            }
        
        } ) {
            Text("Save")
                .foregroundColor(Color.blue)
        } )
        .onTapGesture {
            hideKeyboard()
        }
        .toastView(toast: $toast)
    }
}

struct CreateFlashcardView_Previews: PreviewProvider {
    static var previews: some View {
        CreateFlashcardView(deckId: "deck_id")
    }
}
