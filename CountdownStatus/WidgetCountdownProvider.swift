//  Created by Gagandeep Singh on 21/9/20.

import WidgetKit
import SwiftUI

struct WidgetCountdownProvider: View {
    let family: WidgetFamily
    let title: String
    let hasEnded: Bool
    let date: Date
    let entryDate: Date
    let image: UIImage?

    var components: [DateComponent] {
        CountdownCalculator.components(for: family, countdownDate: date, comparisonDate: entryDate)
    }

    var body: some View {
        ZStack {
            CardBackground(image: image)
            countdown
        }
    }

    private var countdown: AnyView {
        switch family {
        case .systemLarge:
            return AnyView(WidgetCountdownLarge(title: title, hasEnded: hasEnded, components: components))
        case .systemMedium:
            return AnyView(WidgetCountdownMedium(title: title, hasEnded: hasEnded, components: components))
        case .systemSmall:
            return AnyView(WidgetCountdownSmall(title: title, hasEnded: hasEnded, components: components))
        @unknown default:
            return AnyView(WidgetCountdownLarge(title: title, hasEnded: hasEnded, components: components))
        }
    }
}
