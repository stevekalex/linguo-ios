//
//  CreateFlashCardView.swift
//  Linguo
//
//  Created by Steve Alex on 26/08/2024.

import SwiftUI
import PhotosUI

extension View {
    func hideKeyboard() {
        let resign = #selector(UIResponder.resignFirstResponder)
        UIApplication.shared.sendAction(resign, to: nil, from: nil, for: nil)
    }
}

struct CreateFlashcardView: View {
    @State var deckId: String
    @State var language: String
    @State var prompt: String = ""
    @State var promptIsFocused: Bool = false
    @State var image: UIImage? = nil
    @State var answer: String = ""
    @State var answerIsFocused = false
    @State var displayCamera: Bool = false
    @State private var toast: Toast? = nil
    @StateObject private var flashCardService = FlashcardService()
    
    var body: some View {
        NavigationLink(destination: CameraView(deckId: deckId, displayCamera: $displayCamera, image: $image), isActive: $displayCamera) {
            EmptyView()
        }
        
        GeometryReader { geometry in
            VStack {
                HeaderView(geometry: geometry)
                ScrollView {
                    FrontView(prompt: $prompt, promptIsFocused: $promptIsFocused, answerIsFocused: $answerIsFocused, image: $image)
                    BackView(answer: $answer, promptIsFocused: $promptIsFocused, answerIsFocused: $answerIsFocused)
                }
            }
            .frame(width: geometry.size.width)
            .toolbar {
                ToolbarItemGroup(placement: .keyboard) {
                    if promptIsFocused && !answerIsFocused {
                        Spacer()
                        CameraButton(displayCamera: $displayCamera)
                        PhotoPickerView(image: $image)
                    }

                    if answerIsFocused && !promptIsFocused {
                        if image != nil && answer.isEmpty {
                            Spacer()
                            ClassifyImageButton(image: $image, answer: $answer, language: $language)
                        }
                        
                        if !prompt.isEmpty && answer.isEmpty {
                            Spacer()
                            TranslateTextButton(prompt: $prompt, answer: $answer, language: $language)
                        }
                    }
                }
            }
        }
        .navigationBarItems(trailing: SaveButton(flashCardService: flashCardService, deckId: deckId, prompt: $prompt, answer: $answer, image: $image, toast: $toast))
        .onTapGesture {
            hideKeyboard()
        }
        .toastView(toast: $toast)
    }
}

struct HeaderView: View {
    var geometry: GeometryProxy
    
    var body: some View {
        Text("Create")
            .frame(alignment: .top)
            .font(.custom("Avenir Next Bold", size: 34))
            .fontWeight(.bold)
            .frame(width: geometry.size.width - 75)
            .padding(.top, 10)
    }
}

struct FrontView: View {
    @Binding var prompt: String
    @Binding var promptIsFocused: Bool
    @Binding var answerIsFocused: Bool
    @Binding var image: UIImage?
    
    var body: some View {
        VStack {
            Text("Front")
                .frame(alignment: .leading)
                .font(.custom("Avenir Next", size: 20))
                .fontWeight(.bold)
                .frame(width: UIScreen.main.bounds.width - 75)
                .padding(.trailing, 200)
            
            if let image = image {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(maxWidth: UIScreen.main.bounds.width - 75, maxHeight: 300)
                    .clipped()
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.white, lineWidth: 2)
                    )
            } else {
                TextEditor(text: $prompt)
                    .padding(20)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.white, lineWidth: 2)
                    )
                    .multilineTextAlignment(/*@START_MENU_TOKEN@*/.leading/*@END_MENU_TOKEN@*/)
                    .frame(width: UIScreen.main.bounds.width - 75, height: 125)
                    .lineLimit(6, reservesSpace: true)
                    .font(.custom("Avenir Next", size: 14))
                    .onTapGesture {
                        withAnimation {
                            answerIsFocused = false
                            promptIsFocused = true
                        }
                    }
            }
        }
        .padding(.top, 15)
    }
}

struct BackView: View {
    @Binding var answer: String
    @Binding var promptIsFocused: Bool
    @Binding var answerIsFocused: Bool
    
    var body: some View {
        VStack {
            Text("Back")
                .frame(alignment: .leading)
                .font(.custom("Avenir Next", size: 20))
                .fontWeight(.bold)
                .frame(width: UIScreen.main.bounds.width - 75)
                .padding(.trailing, 200)
            
            TextEditor(text: $answer)
                .padding(20)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.white, lineWidth: 2)
                )
                .frame(width: UIScreen.main.bounds.width - 75, height: 125)
                .lineLimit(6, reservesSpace: true)
                .font(.custom("Avenir Next", size: 14))
                .onTapGesture {
                    withAnimation {
                        answerIsFocused = true
                        promptIsFocused = false
                    }
                }
        }
        .padding(.top, 15)

    }
}

struct CameraButton: View {
    @Binding var displayCamera: Bool
    
    var body: some View {
        Button(action: {
            displayCamera = true
            hideKeyboard()
        }, label: {
            Image(systemName: "camera.fill")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .foregroundColor(.blue)
        })
    }
}

struct ClassifyImageButton: View {
    @Binding var image: UIImage?
    @Binding var answer: String
    @Binding var language: String
    
    var body: some View {
        Button(action: {
            Task {
                if let image = image {
                    let imageLabel = await classifyAndTranslateImage(image: image, language: language)
                    answer = imageLabel
                }
            }
        }, label: {
            Image(systemName: "questionmark.circle.fill")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .foregroundColor(.blue)
        })
    }
}

struct TranslateTextButton: View {
    @Binding var prompt: String
    @Binding var answer: String
    @Binding var language: String
    
    var body: some View {
        Button(action: {
            Task {
                let translatedText = await translateText(text: prompt, language: language)
                answer = translatedText
            }
        }, label: {
            Image(systemName: "questionmark.circle.fill")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .foregroundColor(.blue)
        })
    }
}

struct SaveButton: View {
    var flashCardService: FlashcardService
    var deckId: String
    @Binding var prompt: String
    @Binding var answer: String
    @Binding var image: UIImage?
    @Binding var toast: Toast?
    
    var body: some View {
        Button(action: {
            print("Create flashcard!")
            toast = Toast(style: .success, message: "Saved.", width: 160)
            Task {
                do {
                    if let image = image {
                        try await flashCardService.createFlashcard(deckId: deckId, prompt: image, answer: answer)
                    } else {
                        try await flashCardService.createFlashcard(deckId: deckId, prompt: prompt, answer: answer)
                    }
                    prompt = ""
                    answer = ""
                    image = nil
                } catch {
                    // Handle error
                }
            }
        }) {
            Text("Save")
                .foregroundColor(Color.blue)
        }
    }
}

struct CreateFlashcardView_Previews: PreviewProvider {
    static var previews: some View {
        CreateFlashcardView(deckId: "deck_id", language: "Malayalam")
    }
}
