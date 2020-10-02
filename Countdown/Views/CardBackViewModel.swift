//  Created by Gagandeep Singh on 15/9/20.

import SwiftUI
import CoreData

final class CardBackViewModel: ObservableObject {
    @Published var countdown: Countdown
    private let remindersManager = RemindersManager()
    private let countdownsManager: CountdownsManager
    let isNew: Bool

    init(countdown: Countdown, isNew: Bool, countdownsManager: CountdownsManager) {
        self.countdown = countdown
        self.isNew = isNew
        self.countdownsManager = countdownsManager
    }

    var allDay: Int {
        get { NSNumber(booleanLiteral: countdown.date.isMidnight).intValue }
        set {
            NSNumber(value: newValue).boolValue
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

    var canSave: Bool {
        countdown.title.count >= 3
        && countdownsManager.objectHasChange(countdown: countdown)
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
