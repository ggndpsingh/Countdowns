//  Created by Gagandeep Singh on 5/10/20.

import SwiftUI
import UIKit
import UnsplashPhotoPicker

protocol PhotoPickerViewControllerDelegate: AnyObject {
    func photoPickerViewController(_ viewController: PhotoPickerViewController, didFinishWith image: UIImage?)
}

final class PhotoPickerViewController: UITabBarController {
    weak var photoPickerDelegate: PhotoPickerViewControllerDelegate?

    init() {
        super.init(nibName: nil, bundle: nil)
        tabBar.isTranslucent = false
        navigationController?.navigationBar.isTranslucent = false
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewControllers = [unsplashPicker(), imagePicker()]
    }

    private func imagePicker() -> UIViewController {
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.delegate = self
        picker.navigationBar.isTranslucent = false
        picker.tabBarItem = UITabBarItem(title: "Library", image: UIImage(systemName: "photo.on.rectangle"), selectedImage: UIImage(systemName: "photo.fill.on.rectangle.fill"))
        return picker
    }

    private func unsplashPicker() -> UIViewController {
        let picker = UnsplashPhotoPicker(
            configuration: .init(
                accessKey: "wDof0appRIkX10bAvr82b9EWzg8E6NMG0W8qY6NUMcE",
                secretKey: "KRarbE5ghU6sJY630_aVf_00rh1x7LFGLIJbamdR2Qo"))
        picker.navigationBar.isTranslucent = false
        picker.photoPickerDelegate = self
        picker.viewControllers.first?.tabBarItem = UITabBarItem(title: "Unsplash", image: UIImage(named: "unsplash"), selectedImage: UIImage(named: "unsplash.fill"))
        return picker
    }
}

extension PhotoPickerViewController: UnsplashPhotoPickerDelegate {
    func unsplashPhotoPicker(_ photoPicker: UnsplashPhotoPicker, didSelectPhotos photos: [UnsplashPhoto]) {
        guard let url = photos.first?.urls[.regular] else { return }
        downloadImage(at: url)
    }

    func unsplashPhotoPickerDidCancel(_ photoPicker: UnsplashPhotoPicker) {
        photoPickerDelegate?.photoPickerViewController(self, didFinishWith: nil)
    }
}

extension PhotoPickerViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        let image = info[.originalImage] as? UIImage
        didFinish(with: image)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
        photoPickerDelegate?.photoPickerViewController(self, didFinishWith: nil)
    }
}

extension PhotoPickerViewController {
    private func downloadImage(at url: URL) {
        ImageLoader.shared.getImage(at: url) { [weak self] image in
            self?.didFinish(with: image)
        }
    }

    private func didFinish(with image: UIImage?) {
        var finalImage = image

        let resized = image?.fixedOrientation().resize(to: 600)
        if let data = resized?.jpegData(compressionQuality: 0.7), let img = UIImage(data: data) {
            finalImage = img
        }

        photoPickerDelegate?.photoPickerViewController(self, didFinishWith: finalImage)
    }
}

extension UIView {
    func asImage(rect: CGRect) -> UIImage {
        let renderer = UIGraphicsImageRenderer(bounds: rect)
        return renderer.image { rendererContext in
            layer.render(in: rendererContext.cgContext)
        }
    }
}
