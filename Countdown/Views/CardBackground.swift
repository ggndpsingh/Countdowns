//  Created by Gagandeep Singh on 15/9/20.

import SwiftUI

struct CardBackground: View {
    let image: UIImage?

    var body: some View {
        Group {
            if let image = self.image {
                GeometryReader { geometry in
                    Image(uiImage: image)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: geometry.size.width, height: geometry.size.height, alignment: .center)
                        .cornerRadius(16)
                        .contentShape(
                            RoundedRectangle(cornerRadius: 24)
                        )
                        .clipped(antialiased: false)
                        .overlay(Rectangle().fill(Color.black.opacity(0.3)))
                }
            } else {
                Color.pastels.randomElement()!
                    .cornerRadius(16)
                    .contentShape(
                        RoundedRectangle(cornerRadius: 24)
                    )
            }
        }
    }
}

struct CardBackground_Previews: PreviewProvider {
    static var previews: some View {
        CardBackground(image: UIImage(named: "test"))
//            .frame(width: 400, height: 400, alignment: .center)
//            .previewLayout(.sizeThatFits)
    }
}
