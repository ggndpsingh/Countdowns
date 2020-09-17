//  Created by Gagandeep Singh on 16/9/20.

import SwiftUI
import Combine

struct ImageView: View {
    @ObservedObject var imageLoader: ImageLoader
    private let path: String

    init(path: String) {
        imageLoader = .init(url: URL(string: path)!)
        self.path = path
        imageLoader.load()
    }

    var body: some View {
        Group {
            if let image = imageLoader.image {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } else {
                Color.secondarySystemBackground
            }
        }
    }
}

class ImageLoader: ObservableObject {
    @Published var image: UIImage?
    private let url: URL
    private var cache: ImageCache = .shared
    private var cancellable: AnyCancellable?

    init(url: URL) {
        self.url = url
    }

    func load() {
        if let image = cache[url.absoluteString] {
            self.image = image
            return
        }

        cancellable = URLSession.shared.dataTaskPublisher(for: url)
            .map { UIImage(data: $0.data) }
            .replaceError(with: nil)
            .handleEvents(receiveOutput: { [weak self] in self?.cache($0) })
            .receive(on: DispatchQueue.main)
            .assign(to: \.image, on: self)
    }

    private func cache(_ image: UIImage?) {
        image.map { cache[url.absoluteString] = $0 }
    }
}

struct ImageCache {
    static let shared = ImageCache()
    private let cache = NSCache<NSString, UIImage>()

    private func getImage(for key: String) -> UIImage? {
        cache.object(forKey: key as NSString)
    }

    private func cacheImage(_ image: UIImage?, for key: String) {
        guard let image = image else {
             return cache.removeObject(forKey: key as NSString)
        }

        cache.setObject(image, forKey: key as NSString)
    }

    subscript(_ key: String) -> UIImage? {
        get { getImage(for: key) }
        set { cacheImage(newValue, for: key) }
    }
}
