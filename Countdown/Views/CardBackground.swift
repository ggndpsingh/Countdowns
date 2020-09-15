//  Created by Gagandeep Singh on 15/9/20.

import SwiftUI

struct CardBackground: View {
    let image: String?
    let blur: Bool
    let size: CGSize

    var body: some View {
        if let image = image {
            ZStack {
                Image(image)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: size.width, height: size.height, alignment: .center)
                    .clipped()
                    .cornerRadius(24)
                    .overlay(
                        Group {
                            if blur {
                                Blur(style: .systemThinMaterial)
                            } else {
                                RoundedRectangle(cornerRadius: 24)
                                    .stroke(Color.purple, lineWidth: 0)
                            }
                        }
                    )
            }
        } else {
            RoundedRectangle(cornerRadius: 24)
                .fill(Color.yellow)
                .frame(width: size.width, height: size.height, alignment: .center)
        }
    }
}


struct CardBackground_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            CardBackground(image: nil, blur: false, size: .init(width: 300, height: 300))
            CardBackground(image: "sweden", blur: false, size: .init(width: 300, height: 300))
            CardBackground(image: "sweded", blur: true, size: .init(width: 300, height: 300))
        }
    }
}
