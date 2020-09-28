//  Created by Gagandeep Singh on 21/9/20.

import WidgetKit
import SwiftUI

struct WidgetCountdownLarge: View {
    let title: String
    let components: [DateComponent]

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(Font.system(size: 24, weight: .regular, design: .default))
                .shadow(color: Color.black.opacity(0.4), radius: 2, x: 0.5, y: 0.5)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .foregroundColor(.white)
        .padding()

        HStack(spacing: 8) {
            ForEach(components, id: \.self) {
                ComponentView(component: $0)
                    .foregroundColor(.white)
            }
        }.frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct WidgetBackground: View {
    let image: UIImage?

    var body: some View {
        Group {
            if let image = self.image {
                GeometryReader { geometry in
                    Image(uiImage: image)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: geometry.size.width, height: geometry.size.height, alignment: .center)
                        .overlay(Rectangle().fill(Color.black.opacity(0.4)))
                }
            } else {
                Color.pastels.randomElement()
            }
        }
    }
}

#if DEBUG
struct CountdownWidgetLarge_Previews: PreviewProvider {
    static var previews: some View {
        let countdown = Countdown.placeholder
        WidgetCountdownLarge(title: countdown.title, components: CountdownCalculator.dateComponents(for: countdown.date, comparisonDate: Date(), trimmed: true))
            .previewContext(WidgetPreviewContext(family: .systemLarge))
    }
}

#endif
