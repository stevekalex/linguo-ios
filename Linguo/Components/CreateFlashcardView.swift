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
    @State var displayCamera: Bool = false
    @State var image: UIImage? = nil
    @State private var toast: Toast? = nil
    
    @StateObject private var flashCardService = FlashcardService()
    
    var body: some View {
        NavigationLink(destination: CameraView(deckId: deckId, displayCamera: $displayCamera, image: $image), isActive: $displayCamera) {
            EmptyView()
        }
        
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
                    
                    if (image != nil) {
                        Image(uiImage: image!)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                        
                    } else {
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
            .toolbar {
                ToolbarItemGroup(placement: .keyboard) {
                    Spacer()
                    Button(action: {
                        displayCamera = true
                        hideKeyboard()
                        print("Take picture")
                    }, label: {
                        Image(systemName: "camera.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .foregroundColor(.blue)
                    })
                    Button(action: {print("Access photo library picture")}, label: {
                        Image(systemName: "photo.on.rectangle")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .foregroundColor(.blue)
                    })
                }
            }
        }
        .navigationBarItems(trailing: Button(action: {
            print("Create flashcard!")
            toast = Toast(style: .success, message: "Saved.", width: 160)
            // TODO - create popup + with success message + wipe out state
            Task {

                if (image != nil) {
                    try await flashCardService.createFlashcard(
                        deckId: deckId,
                        prompt: image,
                        answer: answer
                    )
                } else {
                    try await flashCardService.createFlashcard(
                        deckId: deckId,
                        prompt: prompt,
                        answer: answer
                    )
                }

                prompt = ""
                answer = ""
                image = nil
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
