//  Created by Gagandeep Singh on 6/9/20.

import Foundation
import CloudKit
import CoreData

extension CountdownItem {
    var date: Date { date_ ?? .now }
    var title: String { title_ ?? "" }

    var hasEnded: Bool { date <= .now }

    var components: [DateComponent] {
        return CountdownCalculator.shared.countdown(for: date)
    }

    var dateString: String {
        DateFormatter.localizedString(from: date, dateStyle: .medium, timeStyle: .short)
    }
}

extension CountdownItem {
    static func create(
        in context: NSManagedObjectContext,
        title: String,
        date: Date) throws {
        
        let item = CountdownItem(context: context)
        item.title_ = title
        item.date_ = date
        try context.save()
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
