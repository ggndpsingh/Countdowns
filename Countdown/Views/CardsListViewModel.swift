//  Created by Gagandeep Singh on 15/9/20.

import SwiftUI
import CoreData

class FetchedObjectsViewModel: NSObject, ObservableObject {

    private let fetchedResultsController: NSFetchedResultsController<CountdownObject>

    var delegate: NSFetchedResultsControllerDelegate? {
        get { fetchedResultsController.delegate }
        set { fetchedResultsController.delegate = newValue }
    }

    init(context: NSManagedObjectContext) {
        let request = CountdownObject.createFetchRequest()
        request.sortDescriptors = [NSSortDescriptor(keyPath: \CountdownObject.date, ascending: true)]
        fetchedResultsController = .init(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        super.init()
        withAnimation(.spring()) {
            try? fetchedResultsController.performFetch()
        }
    }

    var fetchedObjects: [CountdownObject] {
        return fetchedResultsController.fetchedObjects ?? []
    }
}

final class CardsListViewModel: NSObject, ObservableObject, NSFetchedResultsControllerDelegate {
    private let manager: CountdownsManager
    private let controller: FetchedObjectsViewModel
    private var temporaryItemID: UUID?
    @Published var flippedCardID: UUID?

    @Published var scrollToItem: UUID?

    init(context: NSManagedObjectContext) {
        manager = .init(context: context)
        controller = .init(context: context)
        super.init()
        controller.delegate = self

        for family: String in UIFont.familyNames
                {
                    print(family)
                    for names: String in UIFont.fontNames(forFamilyName: family)
                    {
                        print("== \(names)")
                    }
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

    func didSelectImage(url: URL?) {
        guard let url = url else { return }

        if let id = flippedCardID, let object = manager.getObject(by: id) {
            var countdown = Countdown(object: object)
            countdown.image = url.absoluteString
            manager.updateObject(for: countdown)
        } else {
            temporaryItemID = manager.createNewObject(with: url)
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

    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        objectWillChange.send()
    }

    var fetchedObjects: [CountdownObject] {
        return controller.fetchedObjects
    }

    var countdowns: [Countdown] {
        return fetchedObjects.map(Countdown.init).sorted {

            if isTemporaryItem(id: $0.id) {
                return true
            }

            return $0.date < $1.date
        }
    }
}
