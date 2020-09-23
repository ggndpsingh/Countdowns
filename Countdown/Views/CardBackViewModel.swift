//  Created by Gagandeep Singh on 15/9/20.

import SwiftUI
import CoreData

final class CardBackViewModel: ObservableObject {
    private let remindersManager = RemindersManager()
    let countdownsManager: CountdownsManager
    @Published var countdown: Countdown

    internal init(countdown: Countdown, countdownsManager: CountdownsManager) {
        self.countdown = countdown
        self.countdownsManager = countdownsManager
    }

    var allDay: Bool {
        get { countdown.date.isMidnight }
        set {
            newValue
                ? countdown.date.setTimeToZero()
                : countdown.date.setTimeToNow()
        }
    }

    var hasReminder: Bool {
        get { remindersManager.reminderExists(for: countdown.id) }
        set { newValue ? addReminder() : removeReminder() }
    }

    private func addReminder() {
        remindersManager.addReminder(for: countdown) { _ in
            objectWillChange.send()
        }
    }

    private func removeReminder() {
        remindersManager.removeReminder(id: countdown.id)
        objectWillChange.send()
    }
}
