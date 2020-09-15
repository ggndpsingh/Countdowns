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

    @Published var reminder: Bool {
        didSet {
            reminder ? addReminder() : removeReminder()
        }
    }

    init(id: UUID) {
        let countdown = Countdown(objectID: id) ?? .init()
        self.countdown = countdown
        self.allDay = countdown.date.isMidnight
        self.reminder = countdown.hasReminder
    }

    internal init(countdown: Countdown) {
        self.countdown = countdown
        allDay = countdown.date.isMidnight
        reminder = countdown.hasReminder
    }

    func addReminder() {
        let countdown = self.countdown
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
            DispatchQueue.main.async {
                if success {
                    let content = UNMutableNotificationContent()
                    content.title = countdown.title
                    content.subtitle = countdown.dateString
                    content.sound = UNNotificationSound.defaultCritical

                    // show this notification five seconds from now
                    let trigger = UNCalendarNotificationTrigger(dateMatching: Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: countdown.date), repeats: false)

                    // choose a random identifier
                    let request = UNNotificationRequest(identifier: countdown.id.uuidString, content: content, trigger: trigger)

                    // add our notification request
                    UNUserNotificationCenter.current().add(request)
                } else {
                    self.reminder = false
                }
            }
        }
    }

    func removeReminder() {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [countdown.id.uuidString])
    }
}
