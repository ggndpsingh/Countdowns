//  Created by Gagandeep Singh on 24/9/20.

import SwiftUI

struct CountdownsManagerKey: EnvironmentKey {
    static let defaultValue: CountdownsManager = CountdownsManager(context: PersistenceController.shared.container.viewContext)
}

extension EnvironmentValues {
    var countdownsManager: CountdownsManager {
        get { self[CountdownsManagerKey.self] }
        set { self[CountdownsManagerKey.self] = newValue }
    }
}
