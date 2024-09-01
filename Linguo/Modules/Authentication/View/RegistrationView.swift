//
//  RegistrationView.swift
//  Linguo
//
//  Created by Steve Alex on 13/08/2024.
//
import SwiftUI

struct RegistrationView: View {
    @State private var email = ""
    @State private var fullname = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @EnvironmentObject var viewModel: AuthViewModel
        
    var body: some View {
        VStack {
            VStack {
                HStack (alignment: .bottom, content: {
                    Text("Sign Up to")
                        .font(.custom("Avenir Next Bold", size: 25))
                        .frame(alignment: .bottomLeading)
                        .padding(.bottom, 10)
                        .foregroundColor(Color(.white))

                    
                    Image("linguo-logo")
                        .resizable()
                        .frame(width: 100, height: 100)
                        .padding(.bottom, -27)
                })
                
                Text("Linguo")
                    .font(.custom("Avenir Next Bold", size: 79))
                    .padding(.top, -20)
                    .foregroundColor(Color(.systemBlue))
                
            }
            .padding(.top, -150)
            
            VStack(spacing: 18) {
                InputView(text: $email,
                          title: "Email Address",
                          placeholder: "timothy@chalamet.com")
                .autocapitalization(/*@START_MENU_TOKEN@*/.none/*@END_MENU_TOKEN@*/)
                
                InputView(text: $fullname,
                          title: "Full Name",
                          placeholder: "Full Name")
                
                InputView(text: $password,
                          title: "Password",
                          placeholder: "Password")
                
                InputView(text: $confirmPassword,
                          title: "Confirm Password",
                          placeholder: "Confirm Password")
            }
            .padding([.leading, .trailing], 80)
            
            Button {
                Task {
                    try await viewModel.createUser(
                        withEmail: email,
                        password: password,
                        fullname: fullname
                    )
                }
            } label: {
                HStack {
                    Text("SIGN UP")
                        .font(.custom("Avenir Next Bold", size: 18))
                        .fontWeight(.semibold)
                        .frame(width: UIScreen.main.bounds.width - 172, height: 48)
                        .foregroundColor(.white)
                        .background(LinearGradient(gradient: Gradient(colors: [.teal, .blue]), startPoint: .leading, endPoint: .trailing))
                        .cornerRadius(40)
                        .padding(.top, 30)
                }
            }
        }
    }
}

struct RegistrationView_Previews: PreviewProvider {
    static var previews: some View {
        RegistrationView()
    }
}
