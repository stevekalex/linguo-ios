
import SwiftUI
import MijickCameraView

struct CustomCameraView: MCameraView {
    @ObservedObject var cameraManager: MijickCameraView.CameraManager
    let namespace: Namespace.ID
    let closeControllerAction: () -> ()


    var body: some View {
        VStack(spacing: 0) {
            createCameraView()
            createCaptureButton()
        }
    }
}
private extension CustomCameraView {

    func createCaptureButton() -> some View {
        
        Button(action: captureOutput) {
            Circle()
                .stroke(Color.white, lineWidth: 5)
                .frame(width: 75, height: 75)
                .padding(.top)
        }
        .padding()
    }
}

struct CustomCameraPreview: MCameraPreview {
    let capturedMedia: MijickCameraView.MCameraMedia
    let namespace: Namespace.ID
    let retakeAction: () -> ()
    let acceptMediaAction: () -> ()


    var body: some View {
        VStack(spacing: 0) {
            Spacer()
            createContentView()
            Spacer()
            createButtons()
        }
    }
}
private extension CustomCameraPreview {
    func createContentView() -> some View { ZStack {
        if let image = capturedMedia.image { createImageView(image) }
        else { EmptyView() }

    }}
    func createButtons() -> some View {
        HStack(spacing: 24) {
            createRetakeButton()
            createSaveButton()
        }
    }
}
private extension CustomCameraPreview {
    func createImageView(_ image: UIImage) -> some View {
        Image(uiImage: image)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .ignoresSafeArea()
    }
    func createRetakeButton() -> some View {
        Button(action: retakeAction) { Text("Retake") }
    }
    func createSaveButton() -> some View {
        Button(action: acceptMediaAction) {
            Text("Save")
        }
            
    }
}

struct CameraView: View {
    @State var currentDeckId: String
    @State private var showCamera = true
    @State private var image: UIImage = UIImage()

    @ObservedObject private var manager: CameraManager = .init(
        outputType: .photo,
        cameraPosition: .back,
        resolution: .hd4K3840x2160,
        frameRate: 25,
        flashMode: .off,
        isGridVisible: true,
        focusImageColor: .yellow,
        focusImageSize: 92
    )
   
    var body: some View {
        if showCamera {
            MCameraController(manager: manager)
                .cameraScreen(CustomCameraView.init)
                .mediaPreviewScreen(CustomCameraPreview.init)
                .onImageCaptured { data in
                    image = data
                    showCamera = false
                    print("IMAGE HAS BEEN CAPTURED")
                }
                .afterMediaCaptured { $0
                    .closeCameraController(true)
                    .custom { print("Media object has been successfully captured") }
                }
                .onCloseController {
                    print("CLOSE THE CONTROLLER")
                }
        } else {
            ImagePreviewView(currentDeckId: currentDeckId, uiImage: image)
        }
    }

}
