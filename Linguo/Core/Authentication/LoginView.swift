//
//  LoginView.swift
//  Linguo
//
//  Created by Steve Alex on 12/08/2024.

import SwiftUI

struct LoginView: View {
    @State private var email = ""
    @State private var password = ""
    
    var body: some View {
        NavigationStack {
            VStack {
                VStack {
                    HStack (alignment: .bottom, content: {
                        Text("Welcome to")
                            .font(.custom("Avenir Next Bold", size: 25))
                            .frame(alignment: .bottomLeading)
                            .padding(.bottom, 10)
                        
                        Image("linguo-logo")
                            .resizable()
                            .frame(width: 100, height: 100)
                            .padding(.bottom, -27)
                        
                            
                    })
                    .padding(.top, 100)
                    
                    Text("Linguo")
                        .font(.custom("Avenir Next Bold", size: 79))
                        .padding(.top, -20)
                        .foregroundColor(Color(.systemBlue))
                }

                
                VStack(spacing: 18) {
                    InputView(text: $email,
                              title: "Email Address",
                              placeholder: "timothy@chalamet.com")
                    .autocapitalization(/*@START_MENU_TOKEN@*/.none/*@END_MENU_TOKEN@*/)
                    
                    InputView(text: $password,
                              title: "Password",
                              placeholder: "************")
                }
                .padding([.leading, .trailing], 80)
                
                Button (action: {}) {
                    Text("SIGN IN")
                        .font(.custom("Avenir Next Bold", size: 18))
                        .fontWeight(.semibold)
                        .frame(width: UIScreen.main.bounds.width - 172, height: 48)
                        .foregroundColor(.white)
                        .background(LinearGradient(gradient: Gradient(colors: [.teal, .blue]), startPoint: .leading, endPoint: .trailing))
                        .cornerRadius(40)
                        .padding(.top, 30)
                }
                NavigationLink {} label: {
                    Text("Forgot password")
                        .foregroundColor(.black)
                        .font(.custom("Avenir Next", size: 14))
                        .padding(.top, 15)
                }
                
                
                Spacer()
                
                NavigationLink {
                    RegistrationView()
                } label: {
                    HStack(spacing: 2) {
                        Text("Don't have an account?")
                            .foregroundColor(.black)
                        
                        Text("Sign up")
                            .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                            .foregroundColor(Color(.systemBlue))
                            
                    }
                    .font(.custom("Avenir Next", size: 14))
                }
                .padding(.bottom, 40)
            }
        }
    }
    
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
