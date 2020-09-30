//  Created by Gagandeep Singh on 30/9/20.

import SwiftUI

struct RoundButton: View {
    let action: () -> Void
    let image: String
    let color: Color

    var body: some View {
        Button(action: action) {
            ButtonImage(image, color: color)
        }
        .buttonStyle(SquishableButtonStyle(fadeOnPress: true))
    }

    struct ButtonImage: View {
        private let image: String
        private let color: Color

        init(_ image: String, color: Color) {
            self.image = image
            self.color = color
        }

        var body: some View {
            Image(systemName: image)
                .font(Font.system(size: 16, weight: .bold, design: .monospaced))
                .imageScale(.large)
                .frame(width: 44, height: 44)
                .background(Blur(style: .systemThickMaterial))
                .clipShape(Circle())
                .foregroundColor(color)
        }
    }
}

struct RoundButton_Previews: PreviewProvider {
    static var previews: some View {
        RoundButton(action: {}, image: "pencil", color: .secondaryLabel)
            .background(Color.secondaryLabel)
            .frame(width: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, height: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
            .previewLayout(.sizeThatFits)
    }
}
