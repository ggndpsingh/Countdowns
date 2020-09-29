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

    var type: DateComponentType {
        switch self {
        case .day:
            return .day
        case .month:
            return .month
        case .year:
            return .year
        case .hour:
            return .hour
        case .minute:
            return .minute
        case .second:
            return .second
        }
    }

    private var isSingular: Bool {
        return value == 1
    }

    var value: Int {
        switch self {
        case .day(let value), .month(let value), .year(let value),
        .hour(let value), .minute(let value), .second(let value):
            return abs(value)
        }
    }

    var valueString: String {
        value < 10 ? "0" + String(value) : String(value)
    }

    var label: String {
        switch self {
        case .day:
            return isSingular ? "day" : "days"
        case .month:
            return isSingular ? "Month" : "months"
        case .year:
            return isSingular ? "year" : "years"
        case .hour:
            return isSingular ? "hour" : "hours"
        case .minute:
            return isSingular ? "minute" : "minutes"
        case .second:
            return isSingular ? "second" : "seconds"
        }
    }
}

enum DateComponentType {
    case year
    case month
    case day
    case hour
    case minute
    case second
}
