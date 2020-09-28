//  Created by Gagandeep Singh on 21/9/20.

import WidgetKit
import SwiftUI

struct WidgetCountdownSmall: View {
    let title: String
    let components: [DateComponent]

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(Font.system(size: 18, weight: .regular, design: .default))
                .shadow(color: Color.black.opacity(0.4), radius: 1.5, x: 0.5, y: 0.5)
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

#if DEBUG
struct CountdownWidgetSmall_Previews: PreviewProvider {
    static var previews: some View {
        let countdown = Countdown.placeholder
        WidgetCountdownSmall(title: countdown.title, components: CountdownCalculator.dateComponents(for: countdown.date, comparisonDate: Date(), trimmed: true).filtered(for: .systemSmall))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
#endif
