//  Created by Gagandeep Singh on 16/9/20.

import SwiftUI
import  UnsplashPhotoPicker

struct PhotoPicker: UIViewControllerRepresentable {
    typealias SelectionHandler = (UIImage?) -> Void
    let selectionHandler: SelectionHandler

    init(selectionHandler: @escaping SelectionHandler) {
        self.selectionHandler = selectionHandler
    }

    func makeUIViewController(context: Context) -> UIViewController {
        let picker = PhotoPickerViewController()
        picker.photoPickerDelegate = context.coordinator
        picker.title = "Select Photo"
        return picker
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}

    class Coordinator: NSObject, PhotoPickerViewControllerDelegate {
        var parent: PhotoPicker

        init(_ parent: PhotoPicker) {
            self.parent = parent
        }

        func photoPickerViewController(_ viewController: PhotoPickerViewController, didFinishWith image: UIImage?) {
            parent.selectionHandler(image)
        }
    }
}

extension UIImage {

    /// Resize image from given size.
    ///
    /// - Parameter dimension: min width or height of image output
    /// - Returns: Resized image.
    func resize(to dimension: CGFloat) -> UIImage {
        // no need to resize
        guard min(size.width, size.height) > dimension else { return self }
        guard let cgImage = cgImage, let colorSpace = cgImage.colorSpace else { return self }

        var newSize: CGSize!
        let aspectRatio = size.width / size.height

        if aspectRatio > 1 {
            // Landscape image
            newSize = CGSize(width: dimension * aspectRatio, height: dimension)
        } else {
            // Portrait image
            newSize = CGSize(width: dimension, height: dimension / aspectRatio)
        }

        let width = Int(newSize.width)
        let height = Int(newSize.height)
        let bitsPerComponent = cgImage.bitsPerComponent
        let bytesPerRow = cgImage.bytesPerRow
        let bitmapInfo = cgImage.bitmapInfo

        guard let context = CGContext(data: nil, width: width, height: height,
                                      bitsPerComponent: bitsPerComponent,
                                      bytesPerRow: bytesPerRow, space: colorSpace,
                                      bitmapInfo: bitmapInfo.rawValue) else { return self }
        context.interpolationQuality = .high
        let rect = CGRect(origin: CGPoint.zero, size: newSize)
        context.draw(cgImage, in: rect)

        return context.makeImage().flatMap { UIImage(cgImage: $0) } ?? self
    }
}

extension UIImage {

    /// Fix image orientaton to protrait up
    func fixedOrientation() -> UIImage {
        guard imageOrientation != UIImage.Orientation.up else {
            return self
        }

        guard let cgImage = self.cgImage else {
            return self
        }

        guard let colorSpace = cgImage.colorSpace, let ctx = CGContext(data: nil, width: Int(size.width), height: Int(size.height), bitsPerComponent: cgImage.bitsPerComponent, bytesPerRow: 0, space: colorSpace, bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue) else {
            return self
        }

        var transform: CGAffineTransform = CGAffineTransform.identity

        switch imageOrientation {
        case .down, .downMirrored:
            transform = transform.translatedBy(x: size.width, y: size.height)
            transform = transform.rotated(by: CGFloat.pi)
        case .left, .leftMirrored:
            transform = transform.translatedBy(x: size.width, y: 0)
            transform = transform.rotated(by: CGFloat.pi / 2.0)
        case .right, .rightMirrored:
            transform = transform.translatedBy(x: 0, y: size.height)
            transform = transform.rotated(by: CGFloat.pi / -2.0)
        case .up, .upMirrored:
            break
        @unknown default:
            break
        }

        // Flip image one more time if needed to, this is to prevent flipped image
        switch imageOrientation {
        case .upMirrored, .downMirrored:
            transform = transform.translatedBy(x: size.width, y: 0)
            transform = transform.scaledBy(x: -1, y: 1)
        case .leftMirrored, .rightMirrored:
            transform = transform.translatedBy(x: size.height, y: 0)
            transform = transform.scaledBy(x: -1, y: 1)
        case .up, .down, .left, .right:
            break
        @unknown default:
            break
        }

        ctx.concatenate(transform)

        switch imageOrientation {
        case .left, .leftMirrored, .right, .rightMirrored:
            ctx.draw(cgImage, in: CGRect(x: 0, y: 0, width: size.height, height: size.width))
        default:
            ctx.draw(cgImage, in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
            break
        }

        guard let newCGImage = ctx.makeImage() else { return self }
        return UIImage.init(cgImage: newCGImage, scale: 1, orientation: .up)
    }
}
