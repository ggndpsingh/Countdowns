//  Created by Gagandeep Singh on 15/9/20.

import SwiftUI
import CoreData

final class CardBackViewModel: ObservableObject {
    private var viewContext: NSManagedObjectContext
    @Published var countdown: Countdown

    var allDay: Bool {
        get { countdown.date.isMidnight }
        set {
            newValue
                ? countdown.date.setTimeToZero()
                : countdown.date.setTimeToNow()
        }
    }

    var changesMade: Bool {
        guard let original = CountdownObject.fetch(with: countdown.id, in: viewContext) else { return false }
        return countdown != .init(object: original)
    }

    var reminder: Bool {
        get { countdown.hasReminder }
        set { newValue ? addReminder() : removeReminder() }
    }

    init(id: UUID, context: NSManagedObjectContext) {
        self.viewContext = context
        let countdown = Countdown(objectID: id, in: context) ?? .init()
        self.countdown = countdown
    }

    internal init(countdown: Countdown, context: NSManagedObjectContext) {
        self.viewContext = context
        self.countdown = countdown
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
                    self.objectWillChange.send()
                } else {
                    self.reminder = false
                }
            }
        }
    }

    func removeReminder() {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [countdown.id.uuidString])
        objectWillChange.send()
    }
}
