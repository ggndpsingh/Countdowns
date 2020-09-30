//  Created by Gagandeep Singh on 15/9/20.

import SwiftUI
import CoreData

final class CardsListViewModel: NSObject, ObservableObject {
    private let manager: CountdownsManager
    private var temporaryItemID: UUID?
    @Published var scrollToItem: UUID?

    init(context: NSManagedObjectContext) {
        manager = .init(context: context)
        super.init()
    }

    var hasTemporaryItem: Bool { temporaryItemID != nil }

    func isTemporaryItem(id: UUID?) -> Bool {
        id == temporaryItemID
    }

    func didSelectImage(_ image: UIImage?) -> UUID? {
        guard temporaryItemID == nil, let image = image else { return nil }
//
//        if let id = flippedCardID {
//            manager.updateImage(image, for: id)
//        } else {
        temporaryItemID = manager.createNewObject(with: image)
        return temporaryItemID
//        }
    }

    func handleDone(countdown: Countdown, shouldSave: Bool) {
//        if countdown.id == temporaryItemID,
//           (!shouldSave || !manager.objectHasChange(countdown: countdown)) {
//            temporaryItemID = nil
//            return deleteItem(id: countdown.id)
//        }

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
