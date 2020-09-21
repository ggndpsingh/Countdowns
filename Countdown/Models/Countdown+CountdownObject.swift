//  Created by Gagandeep Singh on 20/9/20.

import Foundation
import CoreData

extension Countdown {
    init?(objectID id: UUID, in context: NSManagedObjectContext) {
        guard let object = CountdownObject.fetch(with: id, in: context) else { return nil }
        self.init(object: object)
    }

    init(object: CountdownObject) {
        id = object.id ?? .init()
        date = object.date ?? .init()
        title = object.title ?? ""
        image = object.imageURL ?? "https://images.unsplash.com/photo-1460388052839-a52677720738?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=400"
    }

    func components(size: CountdownSize = .medium, trimmed: Bool = true) -> [DateComponent] {
        return CountdownCalculator.countdown(for: date, size: size, trimmed: trimmed)
    }
}
