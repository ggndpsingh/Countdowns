//  Created by Gagandeep Singh on 15/9/20.

import SwiftUI
import CoreData
import WidgetKit

final class CardsListViewModel: ObservableObject {
    private let context: NSManagedObjectContext
    private var flippedCardID: UUID?
    private var temporaryItemID: UUID?

    init(context: NSManagedObjectContext) {
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
        try? context.save()
    }

    func deleteItem(id: UUID) {
        if let item = CountdownObject.fetch(with: id, in: context) {
            context.delete(item)
        }
        try? context.save()
        WidgetCenter.shared.reloadAllTimelines()
    }
}
