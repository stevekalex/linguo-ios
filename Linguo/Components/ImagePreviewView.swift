//
//  ImagePreviewView.swift
//  Linguo
//
//  Created by Steve Alex on 19/08/2024.
//

import Foundation
import SwiftUI

struct ImagePreviewView: View {
    @State var uiImage: UIImage
    
    var body: some View {
        Image(uiImage: uiImage)
            .resizable()
            .aspectRatio(contentMode: .fit)
    }
}

//struct ImagePreviewView_Previews: PreviewProvider {
//    static var previews: some View {
//        ImagePreviewView()
//    }
//}
