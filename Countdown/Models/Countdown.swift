//  Created by Gagandeep Singh on 6/9/20.

import Foundation
import CloudKit
import CoreData

extension CountdownItem {
    var date: Date { date_ ?? .now }
    var title: String { title_ ?? "" }

    var hasEnded: Bool { date <= .now }

    func components(size: CountdownSize = .medium, trimmed: Bool = true) -> [DateComponent] {
        return CountdownCalculator.shared.countdown(for: date, size: size, trimmed: trimmed)
    }

    var dateString: String {
        DateFormatter.localizedString(from: date, dateStyle: .medium, timeStyle: .short)
    }
}

extension CountdownItem {
    static func create(
        in context: NSManagedObjectContext,
        title: String,
        date: Date,
        image: String?) throws {
        
        let item = CountdownItem(context: context)
        item.title_ = title
        item.date_ = date
        item.image = image
        try context.save()
    }

    static func create(
        date: Date,
        title: String,
        image: String?) -> CountdownItem {
        let context = PersistenceController.inMemory.container.viewContext
        let item = CountdownItem(context: context)
        item.title_ = title
        item.date_ = date
        item.image = image
        try? context.save()
        return item
    }

    func delete(
        in context: NSManagedObjectContext) {
        context.delete(self)
    }
}

extension CountdownItem {
    enum Key: String {
        case title
        case date
    }
}
