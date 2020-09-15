//  Created by Gagandeep Singh on 15/9/20.

import SwiftUI
import CoreData

final class CardsListViewModel: ObservableObject {
    private let context: NSManagedObjectContext
    private var temporaryItemID: UUID?

    init(context: NSManagedObjectContext = .mainContext) {
        self.context = context
    }

    var newItemURL: URL? {
        didSet {
            if let url = newItemURL {
                addItem(url: url)
            }
        }
    }
    var hasTemporaryItem: Bool { temporaryItemID != nil }

    func addItem(url: URL) {
        let item = Countdown(image: url.absoluteString)
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
