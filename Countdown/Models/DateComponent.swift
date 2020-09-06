//  Created by Gagandeep Singh on 6/9/20.

import Foundation

enum DateComponent: Hashable {
    case year(Int)
    case month(Int)
    case day(Int)
    case hour(Int)
    case minute(Int)
    case second(Int)

    private func formatString(is24HourFormat: Bool = true) -> String {
        switch self {
        case .day:
            return "dd"
        case .month:
            return is24HourFormat ? "MM" : "mm"
        case .year:
            return "yyyy"
        case .hour:
            return "hh"
        case .minute:
            return "mm"
        case .second:
            return "ss"
        }
    }

    private var isSingular: Bool {
        return value == 1
    }

    var value: Int {
        switch self {
        case .day(let value), .month(let value), .year(let value),
        .hour(let value), .minute(let value), .second(let value):
            return value
        }
    }

    var label: String {
        switch self {
        case .day:
            return isSingular ? "Day" : "Days"
        case .month:
            return isSingular ? "Month" : "Months"
        case .year:
            return isSingular ? "Year" : "Years"
        case .hour:
            return isSingular ? "Hour" : "Hours"
        case .minute:
            return isSingular ? "Minute" : "Minutes"
        case .second:
            return isSingular ? "Second" : "Seconds"
        }
    }
}
