//  Created by Gagandeep Singh on 4/9/20.

import Foundation
import WidgetKit

struct CountdownCalculator {
    static func countdown(for date: Date, trimmed: Bool = true, size: CountdownSize) -> [DateComponent] {
        switch size {
        case .medium:
            return Array(dateComponents(for: date, trimmed: trimmed).prefix(4))
        case .full:
            return dateComponents(for: date, trimmed: trimmed)
        case .small, .widget:
            return Array(dateComponents(for: date, trimmed: trimmed).prefix(2))
        }

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

extension Date {
    func yearsUntil(_ date: Date) -> Int {
        Calendar.current.dateComponents([.year], from: self, to: date).year ?? 0
    }

    func monthsUntil(_ date: Date) -> Int {
        Calendar.current.dateComponents([.month], from: self, to: date).month ?? 0
    }

    func weeksUntil(_ date: Date) -> Int {
        Calendar.current.dateComponents([.weekOfYear], from: self, to: date).weekOfYear ?? 0
    }

    func daysUntil(_ date: Date) -> Int {
        Calendar.current.dateComponents([.day], from: self, to: date).day ?? 0
    }

    func hoursUntil(_ date: Date) -> Int {
        Calendar.current.dateComponents([.hour], from: self, to: date).hour ?? 0
    }

    func minutesUntil(_ date: Date) -> Int {
        Calendar.current.dateComponents([.minute], from: self, to: date).minute ?? 0
    }

    func secondsUntil(_ date: Date) -> Int {
        Calendar.current.dateComponents([.second], from: self, to: date).second ?? 0
    }

    func periodUntil(_ date: Date) -> Period {
        if yearsUntil(date) > 0 {
            return .moreThanAYear
        }

        let months = monthsUntil(date)
        if months >= 3 {
            return .months(months)
        }

        let weeks = weeksUntil(date)
        if weeks > 2 {
            return .weeks(weeks)
        }

        let days = daysUntil(date)
        if days > 2 {
            return .days(days)
        } else if days == 2 {
            return .twoDays
        } else if days == 1 {
            return .tomorrow
        }

        let hours = hoursUntil(date)
        if hours > 1 {
            return .hours(hours)
        }

        let minutes = minutesUntil(date)
        if minutes > 2 {
            return .minutes(minutes)
        }

        return .seconds(secondsUntil(date))
    }
}

enum Period: CustomStringConvertible {
    case moreThanAYear
    case months(Int)
    case weeks(Int)
    case days(Int)
    case twoDays
    case tomorrow
    case hours(Int)
    case minutes(Int)
    case seconds(Int)

    var description: String {
        switch self {
        case .moreThanAYear:
            return "More than a year to go"
        case .months(let value):
            return "\(value) months away"
        case .weeks(let value):
            return "\(value) weeks to go"
        case .days(let value):
            return "Only \(value) days left"
        case .twoDays:
            return "Two days to go"
        case .tomorrow:
            return "It's tomorrow!"
        case .hours(let value):
            return "In just \(value) hours"
        case .minutes(let value):
            return "\(value) minutes!"
        case .seconds(let value):
            return "\(value)"
        }
    }
}
