//  Created by Gagandeep Singh on 20/9/20.

import CoreData

extension CountdownObject {
    @nonobjc public class func createFetchRequest() -> NSFetchRequest<CountdownObject> {
        return NSFetchRequest<CountdownObject>(entityName: "Commit")
    }

    static func fetchAll(in context: NSManagedObjectContext) -> [CountdownObject] {
        let request = NSFetchRequest<CountdownObject>(entityName: "CountdownObject")
        return (try? context.fetch(request)) ?? []
    }

    static func fetch(with id: UUID, in context: NSManagedObjectContext) -> CountdownObject? {
        let request = NSFetchRequest<CountdownObject>(entityName: "CountdownObject")
        request.predicate = NSPredicate(format: "%K == %@", "id", id as CVarArg)

        do {
            let result = try context.fetch(request)
            return result.first
        } catch {
            fatalError("Failed to fetch employees: \(error)")
        }
    }

    static func create(from countdown: Countdown, in context: NSManagedObjectContext) {
        let item = CountdownObject(context: context)
        item.id = countdown.id
        item.date = countdown.date
        item.title = countdown.title
        item.imageURL = countdown.image
    }

    func update(from countdown: Countdown) {
        date = countdown.date
        title = countdown.title
        imageURL = countdown.image
    }

    func delete(
        in context: NSManagedObjectContext) {
        context.delete(self)
    }
}

extension CountdownObject {
    enum Key: String {
        case title
        case date
    }
}
