//  Created by Gagandeep Singh on 20/9/20.

import UIKit
import Combine

class ImageLoader: ObservableObject {
    @Published var image: UIImage?
    private let url: URL?
    private var cache: ImageCache = .shared
    private var cancellable: AnyCancellable?

    init(urlString: String?) {
        self.url = {
            guard let string = urlString else { return nil }
            return URL(string: string)
        }()
    }

    func load() {
        guard let url = self.url else { return }
        if let image = cache[url.absoluteString] {
            self.image = image
            return
        }

        cancellable = URLSession.shared.dataTaskPublisher(for: url)
            .map { UIImage(data: $0.data) }
            .replaceError(with: nil)
            .handleEvents(receiveOutput: { [weak self] in self?.cache($0, for: url.absoluteString) })
            .receive(on: DispatchQueue.main)
            .assign(to: \.image, on: self)
    }

    private func cache(_ image: UIImage?, for key: String) {
        image.map { cache[key] = $0 }
    }

    func loadSynchronously() -> UIImage? {
        guard let url = self.url else { return nil }
        if let image = cache[url.absoluteString] {
            return image
        }

        guard
            let data = try? Data(contentsOf: url),
            let image = UIImage(data: data)
        else { return nil }

        cache(image, for: url.absoluteString)
        return image
    }
}
