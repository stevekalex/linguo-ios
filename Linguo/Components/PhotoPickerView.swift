//
//  PhotoPickerView.swift
//  Linguo
//
//  Created by Steve Alex on 28/08/2024.
//

import Foundation
import PhotosUI
import SwiftUI

struct PhotoPickerView: View {
   @Binding var image: UIImage?
   @State private var selectedPhotos: [PhotosPickerItem] = []
   @State private var errorMessage: String?
   
   private var photoPickerSection: some View {
        Section {
            PhotosPicker(selection: $selectedPhotos, maxSelectionCount: 1, matching: .images) {
                Image(systemName: "photo.on.rectangle")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .foregroundColor(.blue)
                Label("Select a photo", systemImage: "photo.on.rectangle")
            }
            .onChange(of: selectedPhotos) { _ in
                loadSelectedPhotos()
            }
        }
    }
    
    private func loadSelectedPhotos() {
        image = nil
        errorMessage = nil
        
        Task {
            await withTaskGroup(of: (UIImage?, Error?).self) { taskGroup in
                for photoItem in selectedPhotos {
                    taskGroup.addTask {
                        do {
                            if let imageData = try await photoItem.loadTransferable(type: Data.self),
                               let image = UIImage(data: imageData) {
                                return (image, nil)
                            }
                            return (nil, nil)
                        } catch {
                            return (nil, error)
                        }
                    }
                }
                
                for await result in taskGroup {
                    if let error = result.1 {
                        errorMessage = "Failed to load one or more images."
                        break
                    } else if let pickedImage = result.0 {
                        image = pickedImage
//                        images.append(image)
                    }
                }
            }
        }
    }

    var body: some View {
        PhotosPicker(selection: $selectedPhotos, maxSelectionCount: 1, matching: .images) {
            Image(systemName: "photo.on.rectangle")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .foregroundColor(.blue)
        }
        .onChange(of: selectedPhotos) { _ in
            loadSelectedPhotos()
        }
    }
}
