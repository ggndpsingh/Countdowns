//  Created by Gagandeep Singh on 15/9/20.

import SwiftUI

struct CardBackground: View {
    let imageURL: String?
    let blur: Bool
    let size: CGSize

    var body: some View {
        ImageView(path: imageURL!)
            .frame(width: size.width, height: size.height, alignment: .center)
            .cornerRadius(24)
            .contentShape(
                RoundedRectangle(cornerRadius: 24)
            )
            .clipped(antialiased: false)
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
}


struct CardBackground_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            CardBackground(imageURL: "https://upload.wikimedia.org/wikipedia/commons/thumb/e/eb/Apple_park_cupertino_2019.jpg/480px-Apple_park_cupertino_2019.jpg", blur: false, size: .init(width: 300, height: 300))
        }
    }
}
