//  Created by Gagandeep Singh on 15/9/20.

import SwiftUI

struct CardBackground: View {
    let imageURL: String?

    var body: some View {
        Group {
            if let url = imageURL {
                ImageView(path: url)
                    .cornerRadius(24)
                    .contentShape(
                        RoundedRectangle(cornerRadius: 24)
                    )
                    .clipped(antialiased: false)
            } else {
                Color.pastels.randomElement()!
                    .cornerRadius(24)
                    .contentShape(
                        RoundedRectangle(cornerRadius: 24)
                    )
            }
        }
    }
}

struct CardBackground_Previews: PreviewProvider {
    static var previews: some View {
        CardBackground(imageURL: nil)
            .frame(width: 400, height: 400, alignment: .center)
            .previewLayout(.sizeThatFits)
    }
}
