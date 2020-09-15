//  Created by Gagandeep Singh on 6/9/20.

import Foundation

extension Date {
    static var now: Date { .init() }

    var isMidnight: Bool {
        let components = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: self)
        return components.hour == 0
            && components.minute == 0
            && components.second == 0
    }
}

extension Date {
    func diff(until date: Date) -> DateComponents {
        Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: self, to: date)
    }

    var displayString: String {
        DateFormatter.localizedString(from: self, dateStyle: .medium, timeStyle: .short)
    }
}

extension Date {
    mutating func setTimeToZero() {
        self = bySettingTimeToZero()
    }

    mutating func setTimeToNow() {
        self = bySettingTimeToNow()
    }

    func bySettingTimeToZero() -> Date {
        var components = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: self)
        components.hour = 0
        components.minute = 0
        components.second = 0
        return Calendar.current.date(from: components) ?? self
    }

    func bySettingTimeToNow() -> Date {
        let now = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: Date())
        var components = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: self)
        components.hour = now.hour
        components.minute = now.minute
        components.second = now.second
        return Calendar.current.date(from: components) ?? self
    }
}
