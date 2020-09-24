//  Created by Gagandeep Singh on 20/9/20.

import UIKit
import Combine

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

    func loadSynchronously() -> UIImage? {
        if let image = cache[url.absoluteString] {
            return image
        }

        guard
            let data = try? Data(contentsOf: url),
            let image = UIImage(data: data)
        else { return nil }

        cache[url.absoluteString] = image
        return image
    }
}
