//  Created by Gagandeep Singh on 21/9/20.

import WidgetKit
import SwiftUI

struct WidgetCountdownMedium: View {
    let title: String
    let hasEnded: Bool
    let components: [DateComponent]

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(Font.system(size: 24, weight: .medium, design: .default))
                .shadow(color: Color.black.opacity(0.4), radius: 2, x: 0.5, y: 0.5)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .foregroundColor(.white)
        .padding()

        CountdownContainer(hasEnded: hasEnded) {
            HStack(spacing: 8) {
                ForEach(components, id: \.self) {
                    ComponentView(component: $0)
                        .foregroundColor(.white)
                }
            }
        }
        .offset(y: 8)
    }
}

#if DEBUG
struct CountdownWidgetMedium_Previews: PreviewProvider {
    static var previews: some View {
        let countdown = Countdown.placeholder
        ZStack {
            CardBackground(image: countdown.image)
            WidgetCountdownMedium(title: countdown.title, hasEnded: true, components: CountdownCalculator.dateComponents(for: countdown.date, comparisonDate: Date(), trimmed: true))
        }
        .previewContext(WidgetPreviewContext(family: .systemMedium))
    }
}
#endif
