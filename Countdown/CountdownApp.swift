//  Created by Gagandeep Singh on 6/9/20.

import SwiftUI

@main
struct CountdownApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    private let persistenceController = PersistenceController.shared
    private let countdownsManager = CountdownsManagerKey.defaultValue
    @Environment(\.scenePhase) private var scenePhase

    var body: some Scene {
        WindowGroup {
            SomeView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .environment(\.countdownsManager, countdownsManager)
        }
        .onChange(of: scenePhase) { phase in
            if phase == .background {
               print("Background")
            }
        }
    }
}
