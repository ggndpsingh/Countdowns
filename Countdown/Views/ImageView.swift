//  Created by Gagandeep Singh on 16/9/20.

import SwiftUI

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

