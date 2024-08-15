//
//  Extensions.swift
//  Linguo
//
//  Created by Steve Alex on 15/08/2024.
//

import Foundation
import SwiftUI

extension View {
    func popupNavigationView<Content: View>(
        horizontalPadding: CGFloat = 40, show: Binding<Bool>, @ViewBuilder content: @escaping ()->Content) -> some View {
        
        return self
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
            .overlay {
                if show.wrappedValue {
                    GeometryReader{proxy in
                        let size = proxy.size
                        
                        Color.primary
                            .opacity(0.15)
                            .ignoresSafeArea()
                        
                        
                        NavigationView{
                            content()
                        }
                        .frame(width: size.width - horizontalPadding, height: size.height / 1.7, alignment: .center)
                        .cornerRadius(15)
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                    }
                }
            }
    }
}
