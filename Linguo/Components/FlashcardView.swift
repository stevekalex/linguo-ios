import Foundation
import SwiftUI

struct FlashcardView: View {
   @StateObject private var flashcardServce = FlashcardService()
   @State var flashcard: FlashcardData
   @Binding var flashcards: [FlashcardData]
   @Binding var showFlashcardView: Bool
   @State private var showAnswer = false
    

   func resetFlashcard(rating: Rating) async {
       do {
           try await flashcardServce.updateCardSchedule(flashcard: flashcard, rating: rating)
           
           print("Rating => \(rating)")
           
           flashcards.remove(at: 0)

            if (flashcards.isEmpty) {
                showFlashcardView = false
            } else {
                flashcard = flashcards[0]
            }

            showAnswer = false
       } catch {
           print("Error updating card schedule: \(error)")
       }
   }

   var body: some View {
        VStack {
            HStack {
                if (flashcard.promptImage != nil) {
                    Image(uiImage: flashcard.promptImage!)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .clipped()
                        .frame(maxWidth: UIScreen.main.bounds.width - 75, maxHeight: 225)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.white, lineWidth: 2)
                        )
                } else  {
                    Text(flashcard.promptString!)
                        .font(.custom("Avenir Next", size: 14))
                        .frame(maxWidth: UIScreen.main.bounds.width - 75, maxHeight: 225)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.white, lineWidth: 2)
                        )
                }
            }
            .onTapGesture {
                print("Tapped")
                showAnswer = true
            }
            .padding(.top, 65)
            
            Spacer()
    
            if (showAnswer) {
                VStack {
                    ScrollView {
                        Text(flashcard.answer)
                            .font(.custom("Avenir Next", size: 14))
                    }
                    .padding(12)
                    .frame(maxWidth: UIScreen.main.bounds.width - 75, maxHeight: 225)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.white, lineWidth: 3)
                    )
                    .padding(.bottom, 40)
                    
                    HStack {
                        Button(action: {
                            Task {
                                await resetFlashcard(rating: Rating.again)
                            }
                        }) {
                            Text("Again")
                                .foregroundColor(.red)
                                .padding()
                                .background(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(.red, lineWidth: 1)
                                )
                        }

                        Button(action: {
                            Task {
                                await resetFlashcard(rating: Rating.hard) }
                            }) {
                            Text("Hard")
                                .foregroundColor(.orange)
                                .padding()
                                .background(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(.orange, lineWidth: 1)
                                )
                        }

                        Button(action: {
                            Task {
                                await resetFlashcard(rating: Rating.good) }
                            }) {
                            Text("Good")
                                .foregroundColor(.green)
                                .padding()
                                .background(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(.green, lineWidth: 1)
                                )
                        }

                        Button(action: {
                            Task {
                                await resetFlashcard(rating: Rating.easy) }
                            }) {
                            Text("Easy")
                                .foregroundColor(.blue)
                                .padding()
                                .background(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(.blue, lineWidth: 1)
                                )
                        }
                    }

                }
                .padding(.bottom, 20)
                
                Spacer()

            }
        }
   }
}
//
//struct FlashcardView_Previews: PreviewProvider {
//    static var previews: some View {
//        FlashcardView(flashcard: FlashcardData(id: "id", promptImage: nil, promptString: "This is my prompt", answer: "This is my answer", lastReviewDate: Date(), nextReviewDate: Date()))
//    }
//}
//
