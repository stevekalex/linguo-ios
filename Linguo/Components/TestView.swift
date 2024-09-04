//
//  TestView.swift
//  Linguo
//
//  Created by Steve Alex on 01/09/2024.
//

import Foundation
import SwiftUI

struct TestView: View {
    @State var prompt = ""
    
    var body: some View {
        VStack {
            TextField("Enter text", text: $prompt)
                .padding(25)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.black, lineWidth: 3)
                )
                .frame(width: UIScreen.main.bounds.width - 75)
                .lineLimit(6, reservesSpace: true)
                .font(.custom("Avenir Next", size: 14))
        }
    }
}

struct TestView_Previews: PreviewProvider {
    static var previews: some View {
        TestView()
    }
}
