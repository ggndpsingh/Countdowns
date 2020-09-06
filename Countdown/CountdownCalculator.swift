//  Created by Gagandeep Singh on 4/9/20.

import Foundation

struct CountdownCalculator {
    static let shared = CountdownCalculator()

    let dateToCountdownFomatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy HH:mm:ss"
        return formatter
    }()

    func countdown(for date: Date) -> [DateComponent] {
        guard date > Date() else { return [] }
        let now = Date()
        let years = now.diff(until: date).year!
        let months = now.diff(until: date).month!
        let days = now.diff(until: date).day!
        let hours = now.diff(until: date).hour!
        let minutes = now.diff(until: date).minute!
        let seconds = now.diff(until: date).second!

        var components: [DateComponent] = [
            .year(years),
            .month(months),
            .day(days),
            .hour(hours),
            .minute(minutes),
            .second(seconds)
        ]

        while components.first?.value == 0 {
            components.remove(at: 0)
        }

        return components
    }
}
