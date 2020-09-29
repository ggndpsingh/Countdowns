//  Created by Gagandeep Singh on 4/9/20.

import Foundation
import WidgetKit

struct CountdownCalculator {
    static func countdown(for date: Date, trimmed: Bool = true) -> [DateComponent] {
        return Array(dateComponents(for: date, trimmed: trimmed).prefix(4))
    }

    static func dateComponents(for countdownDate: Date, comparisonDate: Date = Date(), trimmed: Bool = true) -> [DateComponent] {
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

    static func components(for widgetFamily: WidgetFamily, countdownDate: Date, comparisonDate: Date) -> [DateComponent] {
        let components = dateComponents(for: countdownDate, comparisonDate: comparisonDate, trimmed: false)
        let noSeconds = components.filter {
            if case .second = $0 { return false}
            return true
        }

        let interval = comparisonDate.timeIntervalSince(countdownDate)
        if (0...60).contains(interval) {
            return [noSeconds.last!]
        }

        switch widgetFamily {
        case .systemLarge, .systemMedium:
            return Array(noSeconds.byTrimmingLeadingZeros().prefix(4))
        case .systemSmall:
            return Array(noSeconds.byTrimmingLeadingZeros().prefix(2))
        @unknown default:
            return Array(noSeconds.byTrimmingLeadingZeros().prefix(2))
        }
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
}

enum CountdownSize {
    case full
    case medium
    case small
    case widget
}
