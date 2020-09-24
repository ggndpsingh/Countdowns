//  Created by Gagandeep Singh on 21/9/20.

import WidgetKit
import SwiftUI

struct WidgetCountdownMedium: View {
    let title: String
    let image: String
    let components: [DateComponent]

    var body: some View {
        ZStack {
            WidgetBackground(image: image)

            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(Font.system(size: 22, weight: .regular, design: .default))
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
            .foregroundColor(.white)
            .padding()

            HStack(spacing: 8) {
                ForEach(components, id: \.self) {
                    ComponentView(component: $0)
                        .foregroundColor(.white)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .offset(y: 8)
        }
        .cornerRadius(24)
    }
}

struct CountdownWidgetMedium_Previews: PreviewProvider {
    static var previews: some View {
        let countdown = Countdown.placeholder
        WidgetCountdownMedium(title: countdown.title, image: countdown.image, components: CountdownCalculator.dateComponents(for: countdown.date, comparisonDate: Date(), trimmed: true))
            .previewContext(WidgetPreviewContext(family: .systemMedium))
    }
}
