//  Created by Gagandeep Singh on 9/10/20.

import SwiftUI
import Combine

struct SettingsKey: EnvironmentKey {
    static let defaultValue = SettingsStorage()
}

extension EnvironmentValues {
    var settings: SettingsStorage {
        get { self[SettingsKey.self] }
        set { self[SettingsKey.self] = newValue }
    }
}
