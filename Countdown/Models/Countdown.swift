//  Created by Gagandeep Singh on 6/9/20.

import UIKit
import CloudKit
import CoreData
import UserNotifications

struct Countdown: Identifiable, Equatable {
    var id: UUID
    var date: Date
    var title: String
    var image: UIImage?

    init(id: UUID = .init(), date: Date = Date(), title: String = "", image: UIImage? = nil) {
        self.id = id
        self.date = date
        self.title = title
        self.image = image
    }

    init(object: CountdownObject) {
        id = object.id ?? .init()
        date = object.date ?? .init()
        title = object.title ?? ""
        image = {
            guard let imageData = object.image else { return nil }
            return UIImage(data: imageData)
        }()
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
        .init(id: .init(), date: .christmas, title: "Christmas 🎄", image: UIImage(named: "test"))
    }()
}

#if DEBUG
extension Countdown {
    static let preview: Countdown = .init(date: Date().addingTimeInterval(3600 * 3600).bySettingTimeToZero(), title: "This is a test title for", image: UIImage(named: "test"))
}
#endif
