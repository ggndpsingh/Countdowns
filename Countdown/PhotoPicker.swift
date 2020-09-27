//  Created by Gagandeep Singh on 16/9/20.

import SwiftUI
import  UnsplashPhotoPicker

struct PhotoPicker: UIViewControllerRepresentable {
    typealias SelectionHandler = (UIImage?) -> Void
    let selectionHandler: SelectionHandler

    init(selectionHandler: @escaping SelectionHandler) {
        self.selectionHandler = selectionHandler
    }

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

    private func downloadImage(at url: URL) {
        ImageLoader.shared.getImage(at: url) { image in
            selectionHandler(image)
        }
    }

    class Coordinator: NSObject, UnsplashPhotoPickerDelegate {
        func unsplashPhotoPicker(_ photoPicker: UnsplashPhotoPicker, didSelectPhotos photos: [UnsplashPhoto]) {
            guard let url = photos.first?.urls[.regular] else { return }
            parent.downloadImage(at: url)
        }

        func unsplashPhotoPickerDidCancel(_ photoPicker: UnsplashPhotoPicker) { }

        var parent: PhotoPicker

        init(_ parent: PhotoPicker) {
            self.parent = parent
        }
    }
}
