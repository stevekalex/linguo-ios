//
//  CreateFlashcardView.swift
//  Linguo
//
//  Created by Steve Alex on 16/08/2024.

import Foundation
import SwiftUI
import AVFoundation

struct CreateFlashcardView: View {
    var body: some View {
        CameraView()
    }
}

struct CameraView: View {
    @StateObject var camera = CameraModel()
    var body: some View {
        ZStack {
            Color.black
                .ignoresSafeArea(.all, edges: .all)
            
            VStack {
                Spacer()
                
                HStack {
                    if camera.isTaken {
                        HStack {
                            Spacer()
                            Button(action: {}, label: {
                                Image(systemName: "arrow.triangle.2.circlepath.camera")
                                    .foregroundColor(.black)
                                    .padding(.vertical, 10)
                                    .padding(.horizontal, 20)
                                    .background(Color.white)
                                    .clipShape(Circle())

                            })
                        }
                        .padding(.trailing, 10)
                        Spacer()
                    } else {
                        Button(action: { camera.isTaken.toggle()}, label: {
                            ZStack {
                                Circle()
                                    .stroke(Color.white, lineWidth: 5)
                                    .frame(width: 75, height: 75, alignment: .center)
                            }
                        })
                    }
                }
            }
        }
        .onAppear(perform: {
            camera.checkPermissions()
        })
    }
}

class CameraModel: ObservableObject {
    @Published var isTaken = false
    @Published var session = AVCaptureSession()
    @Published var alert = false
    @Published var output = AVCapturePhotoOutput()
    
    func checkPermissions() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
          setUp()
          return
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { (status) in
                if status {
                    self.setUp()
                }
            }
        case .denied:
            self.alert.toggle()
            return
            
        default:
          return
        }
    }
    
    func setUp() {
        do {
            self.session.beginConfiguration()
            let device = AVCaptureDevice.default(.builtInDualCamera, for: .video, position: .back)
            
            let input = try AVCaptureDeviceInput(device: device!)
            
            if self.session.canAddInput(input) {
                self.session.addInput((input))
            }
            
            if self.session.canAddOutput(self.output) {
                self.session.addOutput(self.output)
            }
            
            self.session.commitConfiguration()
        } catch {
            print(error.localizedDescription)
        }
    }
}

struct CameraPreview: UIViewRepresentable {
    @ObservedObject var camera: CameraModel

    func updateUIView(_ uiView: UIViewType, context: Context) {
        // No need to update the preview layer here, it's handled in makeUIView
    }

    func makeUIView(context: Context) -> UIView {
        let view = UIView(frame: UIScreen.main.bounds)
//
//        camera.preview = AVCaptureVideoPreviewLayer(session: camera.session)
//
//        camera.preview.frame = view.frame
//        camera.preview.videoGravity = .resizeAspectFill
//        view.layer.addSublayer(camera.preview)

        return view

    }
}



struct CreateFlashcardView_Previews: PreviewProvider {
    static var previews: some View {
        CreateFlashcardView()
    }
}

