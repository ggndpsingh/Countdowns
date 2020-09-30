//  Created by Gagandeep Singh on 30/9/20.

import SwiftUI

struct LibraryPicker: UIViewControllerRepresentable {
    typealias SelectionHandler = (UIImage?) -> Void
    let selectionHandler: SelectionHandler

    init(selectionHandler: @escaping SelectionHandler) {
        self.selectionHandler = selectionHandler
    }

    func makeUIViewController(context: Context) -> UIViewController {
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.delegate = context.coordinator
        return picker
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}

    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        var parent: LibraryPicker

        init(_ parent: LibraryPicker) {
            self.parent = parent
        }

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            picker.dismiss(animated: true, completion: nil)
            let image = info[.originalImage] as? UIImage
            didFinish(with: image)
        }

        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            picker.dismiss(animated: true, completion: nil)
            didFinish(with: nil)
        }

        private func didFinish(with image: UIImage?) {
            guard let image = image else { return parent.selectionHandler(nil) }

            let resized = image.fixedOrientation().resize(to: 600)
            if let data = resized.jpegData(compressionQuality: 0.7) {
                parent.selectionHandler(UIImage(data: data))
            }
        }
    }
}
