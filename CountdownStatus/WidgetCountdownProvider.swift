//  Created by Gagandeep Singh on 21/9/20.

import WidgetKit
import SwiftUI

struct WidgetCountdownProvider: View {
    let family: WidgetFamily
    let title: String
    let date: Date
    let entryDate: Date
    let image: String

    var components: [DateComponent] {
        CountdownCalculator.dateComponents(for: date, comparisonDate: entryDate, trimmed: true)
    }


    var body: some View {
        switch family {
        case .systemLarge:
            return AnyView(WidgetCountdownLarge(title: title, date: date.displayString, image: image, components: components.filtered(for: .systemLarge)))
        case .systemMedium:
            return AnyView(WidgetCountdownMedium(title: title, image: image, components: components.filtered(for: .systemMedium)))
        case .systemSmall:
            return AnyView(WidgetCountdownSmall(title: title, image: image, components: components.filtered(for: .systemSmall)))
        @unknown default:
            return AnyView(WidgetCountdownLarge(title: title, date: date.displayString, image: image, components: components.filtered(for: .systemLarge)))
        }
    }
}
