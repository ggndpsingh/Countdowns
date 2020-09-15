//  Created by Gagandeep Singh on 6/9/20.

import Foundation
import CloudKit
import CoreData

struct Countdown: Identifiable, Equatable {
    let id: UUID
    var date: Date
    var title: String
    var image: String?

    init(object: CountdownObject) {
        id = object.id ?? .init()
        date = object.date ?? .init()
        title = object.title ?? ""
        image = object.image
    }

    init?(objectID id: UUID) {
        guard let object = CountdownObject.fetch(with: id) else { return nil }
        self.init(object: object)
    }

    init(id: UUID = .init(), date: Date = Date(), title: String = "", image: String? = nil) {
        self.id = id
        self.date = date
        self.title = title
        self.image = "sweden"
    }
}

extension Countdown {
    var hasEnded: Bool { date <= .now }

    func components(size: CountdownSize = .medium, trimmed: Bool = true) -> [DateComponent] {
        return CountdownCalculator.shared.countdown(for: date, size: size, trimmed: trimmed)
    }

    var dateString: String {
        DateFormatter.localizedString(from: date, dateStyle: .medium, timeStyle: .short)
    }
}

extension CountdownObject {
    static func fetch(with id: UUID, in context: NSManagedObjectContext = .mainContext) -> CountdownObject? {
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
        item.image = countdown.image
    }

    func update(from countdown: Countdown) {
        date = countdown.date
        title = countdown.title
        image = countdown.image
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
