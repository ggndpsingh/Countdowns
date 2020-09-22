//  Created by Gagandeep Singh on 21/9/20.

import WidgetKit
import SwiftUI

struct WidgetCountdownSmall: View {
    let title: String
    let image: String
    let components: [DateComponent]

    var body: some View {
        ZStack {
            GeometryReader { geometry in
                Group {
                    if let data = try? Data(contentsOf: URL(string: image)!), let image = UIImage(data: data) {
                        HStack(alignment: .top) {
                            Image(uiImage: image)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .overlay(Rectangle().fill(Color.black.opacity(0.4)))
                        }
                    } else {
                        Color.secondarySystemBackground
                    }
                }

                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(Font.system(size: 20, weight: .regular, design: .default))
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                .foregroundColor(.white)
                .padding()

                HStack(spacing: 8) {
                    ForEach(components, id: \.self) {
                        ComponentView(component: $0).foregroundColor(.white)
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .offset(y: 8)
            }
        }
        .cornerRadius(24)
    }
}

struct CountdownWidgetSmall_Previews: PreviewProvider {
    static var previews: some View {
        let countdown = Countdown.placeholder
        WidgetCountdownSmall(title: countdown.title, image: countdown.image, components: CountdownCalculator.dateComponents(for: countdown.date, comparisonDate: Date(), trimmed: true).filtered(for: .systemSmall))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}