//
//  LoginView.swift
//  Linguo
//
//  Created by Steve Alex on 12/08/2024.

import SwiftUI

struct InputView: View {
    @Binding var text: String
    let title: String
    let placeholder: String
    var isSecureField = false
    var body: some View {
        VStack (alignment: .leading, spacing: 8, content: {

            if isSecureField {
                SecureField(placeholder, text: $text)
                    .font(.custom("Avenir", size: 14))
            } else {
                TextField(placeholder, text: $text)
                    .font(.custom("Avenir", size: 14))
            }
            
            Divider()
        })
    }
}

struct InputView_Previews: PreviewProvider {
    static var previews: some View {
        InputView(text: .constant(""), title: "Email Address", placeholder: "tom@hardy.com")
    }
}
