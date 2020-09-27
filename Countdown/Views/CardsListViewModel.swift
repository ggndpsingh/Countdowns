//  Created by Gagandeep Singh on 15/9/20.

import SwiftUI
import CoreData

final class CardsListViewModel: NSObject, ObservableObject {
    private let manager: CountdownsManager
    private var temporaryItemID: UUID?
    @Published var flippedCardID: UUID?

    @Published var scrollToItem: UUID?

    init(context: NSManagedObjectContext) {
        manager = .init(context: context)
        super.init()

        for family in UIFont.familyNames.sorted() {
            let names = UIFont.fontNames(forFamilyName: family)
            print("Family: \(family) Font names: \(names)")
        }
    }

    var hasTemporaryItem: Bool { temporaryItemID != nil }

    func isCardFlipped(id: UUID) -> Bool {
        temporaryItemID != id && flippedCardID == id
    }

    func isTemporaryItem(id: UUID) -> Bool {
        id == temporaryItemID
    }

    func flipCard(id: UUID) {
        guard temporaryItemID == nil else { return }
        flippedCardID = id
        objectWillChange.send()
    }

    func didSelectImage(_ image: UIImage?) {
        guard temporaryItemID == nil, let image = image else { return }

        if let id = flippedCardID {
            manager.updateImage(image, for: id)
        } else {
            temporaryItemID = manager.createNewObject(with: image)
        }
    }

    func handleDone(countdown: Countdown, shouldSave: Bool) {
        flippedCardID = nil

        if
            countdown.id == temporaryItemID,
            (!shouldSave || !manager.objectHasChange(countdown: countdown))
        {
            temporaryItemID = nil
            return deleteItem(id: countdown.id)
        }

        temporaryItemID = nil

        guard shouldSave else {
            return objectWillChange.send()
        }
        manager.updateObject(for: countdown)
    }

    func deleteItem(id: UUID) {
        manager.deleteObject(with: id)
    }
}
