//  Created by Gagandeep Singh on 24/9/20.

import SwiftUI
import Combine

struct CountdownsManagerKey: EnvironmentKey {
    static let defaultValue: CountdownsManager = CountdownsManager(context: PersistenceController.shared.container.viewContext)
}

extension EnvironmentValues {
    var countdownsManager: CountdownsManager {
        get { self[CountdownsManagerKey.self] }
        set { self[CountdownsManagerKey.self] = newValue }
    }
}

struct TimerKey: EnvironmentKey {
    static let defaultValue = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
}

extension EnvironmentValues {
    var timer: Publishers.Autoconnect<Timer.TimerPublisher> {
        get { self[TimerKey.self] }
        set { self[TimerKey.self] = newValue }
    }
}
