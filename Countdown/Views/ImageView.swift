//  Created by Gagandeep Singh on 16/9/20.

import SwiftUI
import Combine

struct ImageView: View {
    @ObservedObject var provider: ImageProvider
    private let path: String

    init(path: String) {
        provider = ImageProvider()
        self.path = path
        provider.load(at: path)
    }

    var body: some View {
        Group {
            if let image = provider.image {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } else {
                Color.yellow
            }
        }
        .onDisappear(perform: provider.cancel)
    }
}

class ImageProvider: ObservableObject {
    @Published var image: UIImage?
    private var cancellable: AnyCancellable?
    private let loader = ImageLoader(cache: ImageCache())

    func load(at path: String) {
        guard let url = URL(string: path) else { return }
        cancellable = loader.load(at: url) { result in
            self.image = result.1
        }
    }

    func cancel() {
        cancellable?.cancel()
    }
}

class ImageLoader {
    private var cache: ImageCache

    init(cache: ImageCache) {
        self.cache = cache
    }

    func load(at url: URL, completion: @escaping ((String, UIImage?)) -> Void) -> AnyCancellable? {
        if let image = cache[url.absoluteString] {
            completion((url.absoluteString, image))
            return nil
        }

        return URLSession.shared.dataTaskPublisher(for: url)
            .map { UIImage(data: $0.data) }
            .replaceError(with: nil)
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { image in
                self.cache(image, url: url)
                completion((url.absoluteString, image))
            })
    }

    private func cache(_ image: UIImage?, url: URL) {
        image.map { cache[url.absoluteString] = $0 }
    }
}

protocol ProvidesImageCache {
    subscript(_ path: String) -> UIImage? { get set }
}

struct ImageCache: ProvidesImageCache {
    private let cache = NSCache<NSString, UIImage>()

    subscript(_ key: String) -> UIImage? {
        get {
            cache.object(forKey: key as NSString)
        }
        set {
            if newValue == nil {
                 cache.removeObject(forKey: key as NSString)
            } else {
                cache.setObject(newValue!, forKey: key as NSString)
            }
        }
    }
}
