//  Created by Gagandeep Singh on 15/9/20.

import SwiftUI
import CoreData

final class CardsListViewModel: ObservableObject {
    let manager: CountdownsManager
    private var flippedCardID: UUID?
    private var temporaryItemID: UUID?

    init(context: NSManagedObjectContext) {
        manager = .init(context: context)
    }

    var hasTemporaryItem: Bool { temporaryItemID != nil }

    func isCardFlipped(id: UUID) -> Bool {
        temporaryItemID != id && flippedCardID == id
    }

    func isTemporaryItem(id: UUID) -> Bool {
        id == temporaryItemID
    }

    func flipCard(id: UUID) {
        flippedCardID = id
        objectWillChange.send()
    }

    func addItem(imageURL: URL?) {
        guard let url = imageURL else { return }
        temporaryItemID = manager.createNewObject(with: url)
    }

    func handleDone(countdown: Countdown) {
        flippedCardID = nil

        if countdown.id == temporaryItemID, !manager.objectHasChange(countdown: countdown) {
            temporaryItemID = nil
            return deleteItem(id: countdown.id)
        }

        temporaryItemID = nil
        manager.updateObject(for: countdown)
    }

    func deleteItem(id: UUID) {
        manager.deleteObject(with: id)
    }
}
