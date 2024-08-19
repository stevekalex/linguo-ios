
import SwiftUI
import MijickCameraView

struct CustomCameraView: MCameraView {
    @ObservedObject var cameraManager: MijickCameraView.CameraManager
    let namespace: Namespace.ID
    let closeControllerAction: () -> ()


    var body: some View {
        VStack(spacing: 0) {
            createNavigationBar()
            createCameraView()
            createCaptureButton()
        }
    }
}

private extension CustomCameraView {
    func createNavigationBar() -> some View {
        Text("This is a Custom Camera View")
            .padding(.top, 12)
            .padding(.bottom, 12)
    }
    func createCaptureButton() -> some View {
        Button(action: captureOutput) { Text("Click to capture") }
            .padding(.top, 12)
            .padding(.bottom, 12)
    }
}

struct CameraView: View {
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
        MCameraController(manager: manager)
            .onImageCaptured { data in
                print("IMAGE CAPTURED")
            }
            .afterMediaCaptured { $0
                .closeCameraController(true)
                .custom { print("Media object has been successfully captured") }
            }
            .onCloseController {
                print("CLOSE THE CONTROLLER")
            }
    }

}
