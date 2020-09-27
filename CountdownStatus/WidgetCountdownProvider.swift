//  Created by Gagandeep Singh on 21/9/20.

import WidgetKit
import SwiftUI

struct WidgetCountdownProvider: View {
    let family: WidgetFamily
    let title: String
    let date: Date
    let entryDate: Date
    let image: UIImage?

    var components: [DateComponent] {
        CountdownCalculator.dateComponents(for: date, comparisonDate: entryDate, trimmed: true)
    }

    var body: some View {
        ZStack {
            WidgetBackground(image: image)
            countdown
        }
    }

    private var countdown: AnyView {
        switch family {
        case .systemLarge:
            return AnyView(WidgetCountdownLarge(title: title, components: components.filtered(for: .systemLarge)))
        case .systemMedium:
            return AnyView(WidgetCountdownMedium(title: title, components: components.filtered(for: .systemMedium)))
        case .systemSmall:
            return AnyView(WidgetCountdownSmall(title: title, components: components.filtered(for: .systemSmall)))
        @unknown default:
            return AnyView(WidgetCountdownLarge(title: title, components: components.filtered(for: .systemLarge)))
        }
    }
}
