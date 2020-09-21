//  Created by Gagandeep Singh on 20/9/20.

import SwiftUI

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
