//  Created by Gagandeep Singh on 15/9/20.

import SwiftUI
import CoreData

final class CardBackViewModel: ObservableObject {
    @Published var countdown: Countdown
    private let remindersManager = RemindersManager()
    let countdownsManager: CountdownsManager

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

    var title: String {
        get { countdown.title }
        set { countdown.title = newValue }
    }

    var date: Date {
        get { countdown.date }
        set { countdown.date = newValue }
    }

    var hasReminder: Bool {
        get { remindersManager.reminderExists(for: countdown.id) }
        set { newValue ? addReminder() : removeReminder() }
    }

    var hasChanges: Bool {
        countdownsManager.objectHasChange(countdown: countdown)
    }

    private func addReminder() {
        remindersManager.addReminder(for: countdown) {
            self.objectWillChange.send()
        }
    }

    private func removeReminder() {
        remindersManager.removeReminder(id: countdown.id)
        objectWillChange.send()
    }
}
