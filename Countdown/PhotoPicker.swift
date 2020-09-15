//  Created by Gagandeep Singh on 16/9/20.

import SwiftUI
import  UnsplashPhotoPicker

struct PhotoPicker: UIViewControllerRepresentable {
    @Binding var imageURL: URL?

    func makeUIViewController(context: Context) -> UnsplashPhotoPicker {
        let picker = UnsplashPhotoPicker(
            configuration: .init(
                accessKey: "wDof0appRIkX10bAvr82b9EWzg8E6NMG0W8qY6NUMcE",
                secretKey: "KRarbE5ghU6sJY630_aVf_00rh1x7LFGLIJbamdR2Qo"))
        picker.photoPickerDelegate = context.coordinator
        picker.title = "Select Photo"
        return picker
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    func updateUIViewController(_ uiViewController: UnsplashPhotoPicker, context: Context) {}

    class Coordinator: NSObject, UnsplashPhotoPickerDelegate {
        func unsplashPhotoPicker(_ photoPicker: UnsplashPhotoPicker, didSelectPhotos photos: [UnsplashPhoto]) {
            parent.imageURL = photos.first?.urls[.regular]
        }

        func unsplashPhotoPickerDidCancel(_ photoPicker: UnsplashPhotoPicker) { }

        let parent: PhotoPicker

        init(_ parent: PhotoPicker) {
            self.parent = parent
        }
    }
}
