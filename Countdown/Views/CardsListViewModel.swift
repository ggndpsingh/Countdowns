//  Created by Gagandeep Singh on 15/9/20.

import SwiftUI
import CoreData

final class CardsListViewModel: ObservableObject {
    private let context: NSManagedObjectContext
    private var flippedCardID: UUID?
    private var temporaryItemID: UUID?

    init(context: NSManagedObjectContext = .mainContext) {
        self.context = context

//        for i in 0..<100 {
//            let countdown = Countdown(id: .init(), date: Date.now.addingTimeInterval(TimeInterval(3600 * i)), title: "Countdown \(i)", image: "https://images.unsplash.com/photo-1600017751108-6df9a5a7334e?ixlib=rb-1.2.1&q=80&fm=jpg&crop=entropy&cs=tinysrgb&w=1080&fit=max&ixid=eyJhcHBfaWQiOjE2NjI1MX0")
//            CountdownObject.create(from: countdown, in: context)
//        }
//        do {
//            try context.save()
//        } catch {
//            print(error)
//        }
    }

    var newItemURL: URL? {
        didSet {
            if let url = newItemURL {
                addItem(url: url)
            }
        }
    }
    var hasTemporaryItem: Bool { temporaryItemID != nil }

    func isCardFlipped(id: UUID) -> Bool {
        temporaryItemID != id && flippedCardID == id
    }

    func flipCard(id: UUID) {
        flippedCardID = id
        objectWillChange.send()
    }

    func addItem(url: URL) {
        let item = Countdown(image: url.absoluteString)
        CountdownObject.create(from: item, in: context)
        do {
            try context.save()
        } catch {
            print(error)
        }
        temporaryItemID = item.id
        flippedCardID = item.id
    }

    func isTemporaryItem(id: UUID) -> Bool {
        id == temporaryItemID
    }

    func handleDone(countdown: Countdown) {
        guard let existing = CountdownObject.fetch(with: countdown.id, in: context) else { return }
        flippedCardID = nil

        if let temp = temporaryItemID, countdown.id == temp {
            if countdown == .init(object: existing) {
                deleteItem(id: countdown.id)
                temporaryItemID = nil
                return
            }
        }
        temporaryItemID = nil

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
