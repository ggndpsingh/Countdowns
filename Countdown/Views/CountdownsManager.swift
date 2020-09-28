//  Created by Gagandeep Singh on 23/9/20.

import SwiftUI
import CoreData
import WidgetKit

struct CountdownsManager {
    let context: NSManagedObjectContext

    init(context: NSManagedObjectContext) {
        self.context = context
    }

    func createNewObject(with image: UIImage) -> UUID? {
        let countdown = CountdownObject(context: context)
        countdown.id = UUID()
        countdown.date = Date()
        countdown.image = image.pngData()

        try? context.save()
        return countdown.id
    }

    func getObject(by id: UUID) -> CountdownObject? {
        let request = CountdownObject.createFetchRequest()
        request.predicate = NSPredicate(format: "%K == %@", "id", id as CVarArg)
        return try? context.fetch(request).first
    }

    func getAllObjects() -> [CountdownObject] {
        let request = CountdownObject.createFetchRequest()
        return (try? context.fetch(request)) ?? []
    }

    func getPendingObjects() -> [CountdownObject] {
        let request = CountdownObject.createFetchRequest()
        request.predicate = NSPredicate(format: "date > %@", Date() as CVarArg)
        return (try? context.fetch(request)) ?? []
    }

    func updateObject(for countdown: Countdown) {
        guard let object = getObject(by: countdown.id) else { return }
        context.perform {
            object.date = countdown.date
            object.title = countdown.title
            object.image = countdown.image?.pngData()
            try? context.save()
        }
        reloadWidgets()
    }

    func updateImage(_ image: UIImage, for id: UUID) {
        context.perform {
            guard let object = getObject(by : id) else { return }
            object.image = image.pngData()
            try? context.save()
            reloadWidgets()
        }
    }

    func deleteObject(with id: UUID) {
        guard let object = getObject(by: id) else { return }
        context.delete(object)
        try? context.save()
        reloadWidgets()
    }

    func objectHasChange(countdown: Countdown) -> Bool {
        guard let object = getObject(by: countdown.id) else { return false }
        let original = Countdown(object: object)
        return countdown.title != original.title ||
            countdown.date != original.date
    }

    private func reloadWidgets() {
        WidgetCenter.shared.reloadAllTimelines()
    }
}

extension CountdownsManager {
    var canAddCountdown: Bool { getAllObjects().count < 5 }
}
