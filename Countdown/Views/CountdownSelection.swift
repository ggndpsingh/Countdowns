//  Created by Gagandeep Singh on 3/10/20.

import SwiftUI

final class CountdownSelection: ObservableObject {
    static let shared = CountdownSelection()
    @Published var id: Countdown.ID?
    var isNew: Bool = false

    init() {
        print("here")
    }

    var isActive: Bool { id != nil }

    func select(_ id: Countdown.ID, isNew: Bool) {
        self.id = id
        self.isNew = isNew
    }

    func deselect() {
        id = nil
        isNew = false
    }
}
