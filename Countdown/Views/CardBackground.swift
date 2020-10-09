//  Created by Gagandeep Singh on 15/9/20.

import SwiftUI

struct CardBackground: View {
    private let image: UIImage?
    private let squareEdges: Bool

    init(image: UIImage?, squareEdges: Bool = false) {
        self.image = image
        self.squareEdges = squareEdges
    }

    var body: some View {
        Group {
            if let image = self.image {
                GeometryReader { geometry in
                    Image(uiImage: image)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: geometry.size.width, height: geometry.size.height, alignment: .center)
                        .clipped(antialiased: false)
                        .overlay(Rectangle().fill(Color.black.opacity(0.2)))
                        .modifier(CardCornerRadius(squareEdges: squareEdges))
                }
            } else {
                Color.pastels.randomElement()
                    .modifier(CardCornerRadius(squareEdges: squareEdges))
            }
        }
    }
}

struct CardCornerRadius: ViewModifier {
    let squareEdges: Bool

    func body(content: Content) -> some View {
        Group {
            if squareEdges {
                content
            } else {
                content
                .cornerRadius(16)
                .contentShape(
                    RoundedRectangle(cornerRadius: 16)
                )
            }
        }
    }
}

#if DEBUG
struct CardBackground_Previews: PreviewProvider {
    static var previews: some View {
        CardBackground(image: .randomSample)
    }
}
#endif
