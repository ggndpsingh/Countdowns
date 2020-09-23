//  Created by Gagandeep Singh on 23/9/20.

import UserNotifications

class RemindersManager: ObservableObject {
    func addReminder(for countdown: Countdown, completion: @escaping () -> Void) {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
            DispatchQueue.main.async {
                if success {
                    let content = UNMutableNotificationContent()
                    content.title = countdown.title
                    content.subtitle = countdown.dateString
                    content.sound = UNNotificationSound.defaultCritical

                    let trigger = UNCalendarNotificationTrigger(dateMatching: Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: countdown.date), repeats: false)

                    let request = UNNotificationRequest(identifier: countdown.id.uuidString, content: content, trigger: trigger)

                    UNUserNotificationCenter.current().add(request)
                }
                completion()
            }
        }
    }

    func removeReminder(id: UUID) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [id.uuidString])
    }

    func reminderExists(for id: UUID) -> Bool {
        UNUserNotificationCenter.current().hasPendingNotification(with: id.uuidString)
    }
}
