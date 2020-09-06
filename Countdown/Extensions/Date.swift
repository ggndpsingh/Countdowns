//  Created by Gagandeep Singh on 6/9/20.

import Foundation

extension Date {
    static var now: Date { .init() }
}

extension Date {
    func diff(until date: Date) -> DateComponents {
        Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: self, to: date)
    }

    var displayString: String {
        DateFormatter.localizedString(from: self, dateStyle: .medium, timeStyle: .short)
    }
}
