//  Created by Gagandeep Singh on 15/9/20.

import SwiftUI
import CoreData

final class CardsListViewModel: ObservableObject {
    private let context: NSManagedObjectContext
    private var temporaryItemID: UUID?

    init(context: NSManagedObjectContext = .mainContext) {
        self.context = context

        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
            if success {
                print("All set!")
            } else if let error = error {
                print(error.localizedDescription)
            }
        }
    }

    var hasTemporaryItem: Bool { temporaryItemID != nil }

    func addItem() {
        let item = Countdown()
        CountdownObject.create(from: item, in: context)
        do {
            try context.save()
        } catch {
            print(error)
        }
        temporaryItemID = item.id
    }

    func isTemporaryItem(id: UUID) -> Bool {
        id == temporaryItemID
    }

    func handleCancel(for itemID: UUID) {
        if temporaryItemID == itemID {
            deleteItem(id: itemID)
            temporaryItemID = nil
        }
    }

    func handleDone(countdown: Countdown) {
        temporaryItemID = nil
        guard let existing = CountdownObject.fetch(with: countdown.id, in: context) else { return }
        existing.update(from: countdown)

        do {
            try context.save()
        } catch {
            print(error)
        }

        let content = UNMutableNotificationContent()
        content.title = countdown.title
        content.subtitle = "Its here!"
        content.sound = UNNotificationSound.defaultCritical

        // show this notification five seconds from now
        let trigger = UNCalendarNotificationTrigger(dateMatching: Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: countdown.date), repeats: false)

        // choose a random identifier
        let request = UNNotificationRequest(identifier: countdown.id.uuidString, content: content, trigger: trigger)

        // add our notification request
        UNUserNotificationCenter.current().add(request)
    }

    func deleteItem(id: UUID) {
        withAnimation {
            do {
                if let item = CountdownObject.fetch(with: id, in: context) {
                    context.delete(item)
                }
                try context.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}
