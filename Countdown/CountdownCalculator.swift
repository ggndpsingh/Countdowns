//  Created by Gagandeep Singh on 4/9/20.

import Foundation
import WidgetKit

struct CountdownCalculator {
    static let dateToCountdownFomatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy HH:mm:ss"
        return formatter
    }()

    static func countdown(for date: Date, size: CountdownSize, trimmed: Bool = true) -> [DateComponent] {
        let components = dateComponents(for: date, trimmed: trimmed)

        switch size {
        case .full:
            return components
        case .medium:
            return Array(components.prefix(4))
        case .small:
            return Array(components.prefix(2))
        case .widget:
            return Array(components.prefix(1))
        }
    }

    static func dateComponents(for countdownDate: Date, comparisonDate: Date = Date(), trimmed: Bool = true) -> [DateComponent] {
        guard countdownDate > comparisonDate else { return [] }
        let years = comparisonDate.diff(until: countdownDate).year!
        let months = comparisonDate.diff(until: countdownDate).month!
        let days = comparisonDate.diff(until: countdownDate).day!
        let hours = comparisonDate.diff(until: countdownDate).hour!
        let minutes = comparisonDate.diff(until: countdownDate).minute!
        let seconds = comparisonDate.diff(until: countdownDate).second!

        let components: [DateComponent] = [
            .year(years),
            .month(months),
            .day(days),
            .hour(hours),
            .minute(minutes),
            .second(seconds)
        ]

        return trimmed ? components.byTrimmingLeadingZeros() : components
    }
}

extension Array where Element == DateComponent {
    func byTrimmingLeadingZeros() -> Self {
        var mutable = self
        while mutable.first?.value == 0 {
            mutable.remove(at: 0)
        }
        return mutable
    }

    func filtered(for family: WidgetFamily) -> Self {
        let noSeconds = self.filter {
            if case .second = $0 { return false}
            return true
        }

        switch family {
        case .systemLarge, .systemMedium:
            return Array(noSeconds.prefix(4))
        case .systemSmall:
            return Array(noSeconds.prefix(2))
        @unknown default:
            return Array(noSeconds.prefix(2))
        }
    }
}

enum CountdownSize {
    case full
    case medium
    case small
    case widget
}
