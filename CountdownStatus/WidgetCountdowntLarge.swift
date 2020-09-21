//  Created by Gagandeep Singh on 21/9/20.

import WidgetKit
import SwiftUI

struct WidgetCountdownLarge: View {
    let title: String
    let date: String
    let image: String
    let components: [DateComponent]

    var body: some View {
        ZStack {
            GeometryReader { geometry in
                Group {
                    if let data = try? Data(contentsOf: URL(string: image)!), let image = UIImage(data: data) {
                        Image(uiImage: image)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .overlay(Rectangle().fill(Color.black.opacity(0.4)))
                    } else {
                        Color.secondarySystemBackground
                    }
                }

                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(Font.system(size: 24, weight: .regular, design: .default))
                    Text(date)
                        .font(Font.system(size: 12, weight: .regular, design: .rounded))
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
        .cornerRadius(24)
    }
}

struct CountdownWidgetLarge_Previews: PreviewProvider {
    static var previews: some View {
        let countdown = Countdown.placeholder
        WidgetCountdownLarge(title: countdown.title, date: countdown.dateString, image: countdown.image, components: CountdownCalculator.dateComponents(for: countdown.date, comparisonDate: Date(), trimmed: true))
            .previewContext(WidgetPreviewContext(family: .systemLarge))
    }
}
