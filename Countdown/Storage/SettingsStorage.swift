//  Created by Gagandeep Singh on 9/10/20.

import SwiftUI

final class SettingsStorage: Storage {
    enum Key: String {
        case showSeconds
    }

    lazy var showSeconds = Binding(
        get: { self.value(for: .showSeconds) ?? true },
        set: { self.set($0, for: .showSeconds) }
    )
}
