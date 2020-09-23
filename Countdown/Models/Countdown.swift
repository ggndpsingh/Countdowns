//  Created by Gagandeep Singh on 6/9/20.

import Foundation
import CloudKit
import CoreData
import UserNotifications

struct Countdown: Identifiable, Equatable, Codable {
    var id: UUID
    var date: Date
    var title: String
    var image: String

    init(id: UUID = .init(), date: Date = Date(), title: String = "", image: String = "https://images.unsplash.com/photo-1460388052839-a52677720738?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=400") {
        self.id = id
        self.date = date
        self.title = title
        self.image = image
    }
}

extension Countdown {
    var hasEnded: Bool { date <= .now }

    var dateString: String {
        DateFormatter.localizedString(from: date, dateStyle: .medium, timeStyle: date.isMidnight ? .none : .short)
    }
}

extension Countdown {
    static let placeholder: Countdown = {
        .init(id: .init(), date: .christmas, title: "Christmas 🎄", image: "https://images.unsplash.com/photo-1460388052839-a52677720738?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=400")
    }()
}
