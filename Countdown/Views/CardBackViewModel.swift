//  Created by Gagandeep Singh on 15/9/20.

import SwiftUI
import CoreData

final class CardBackViewModel: ObservableObject {
    @Published var countdown: Countdown
    var allDay: Bool {
        didSet {
            allDay
                ? countdown.date.setTimeToZero()
                : countdown.date.setTimeToNow()
        }
    }

    init(id: UUID) {
        let countdown = Countdown(objectID: id) ?? .init()
        self.countdown = countdown
        self.allDay = countdown.date.isMidnight
    }

    internal init(countdown: Countdown) {
        self.countdown = countdown
        allDay = countdown.date.isMidnight
    }
}
