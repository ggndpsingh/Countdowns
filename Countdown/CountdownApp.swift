//  Created by Gagandeep Singh on 6/9/20.

import SwiftUI

@main
struct CountdownApp: App {
    @Environment(\.scenePhase) private var scenePhase
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            CardsListView(viewModel: .init(context: persistenceController.container.viewContext))
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
        .onChange(of: scenePhase) { phase in
            if phase == .background {
               print("Background")
            }
        }
    }
}
