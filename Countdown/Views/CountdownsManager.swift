//  Created by Gagandeep Singh on 23/9/20.

import SwiftUI
import CoreData
import WidgetKit

struct CountdownsManager {
    let context: NSManagedObjectContext

    init(context: NSManagedObjectContext) {
        self.context = context
    }

    func createNewObject(with imageURL: URL) -> UUID? {
        let countdown = CountdownObject(context: context)
        countdown.id = UUID()
        countdown.date = Date()
        countdown.imageURL = imageURL.absoluteString
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

    func updateObject(for countdown: Countdown) {
        guard let object = getObject(by: countdown.id) else { return }
        object.date = countdown.date
        object.title = countdown.title
        object.imageURL = countdown.image
        try? context.save()
        reloadWidgets()
    }

    func deleteObject(with id: UUID) {
        guard let object = getObject(by: id) else { return }
        context.delete(object)
        try? context.save()
        reloadWidgets()
    }

    func objectHasChange(countdown: Countdown) -> Bool {
        guard let object = getObject(by: countdown.id) else { return false }
        return countdown != Countdown(object: object)
    }

    private func reloadWidgets() {
        WidgetCenter.shared.reloadAllTimelines()
    }
}
