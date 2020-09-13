//  Created by Gagandeep Singh on 4/9/20.

import Foundation

struct CountdownCalculator {
    static let shared = CountdownCalculator()

    let dateToCountdownFomatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy HH:mm:ss"
        return formatter
    }()

    func countdown(for date: Date, size: CountdownSize, trimmed: Bool = true) -> [DateComponent] {
        let components = dateComponents(for: date, trimmed: trimmed)

        switch size {
        case .full:
            return components
        case .medium:
            return Array(components.prefix(4))
        case .small:
            return Array(components.prefix(2))
        }
    }

    private func dateComponents(for date: Date, trimmed: Bool = true) -> [DateComponent] {
        guard date > Date() else { return [] }
        let now = Date()
        let years = now.diff(until: date).year!
        let months = now.diff(until: date).month!
        let days = now.diff(until: date).day!
        let hours = now.diff(until: date).hour!
        let minutes = now.diff(until: date).minute!
        let seconds = now.diff(until: date).second!

        let components: [DateComponent] = [
            .year(years),
            .month(months),
            .day(days),
            .hour(hours),
            .minute(minutes),
            .second(seconds)
        ]

        return trimmed ? components.byTrimmingAllDateZeros() : components
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

    func byTrimmingAllDateZeros() -> Self {
        return filter {
            switch $0 {
            case .year, .month, .day:
                return $0.value != 0
            case .hour, .minute, .second:
                return true
            }
        }
    }
}

enum CountdownSize {
    case full
    case medium
    case small
}
