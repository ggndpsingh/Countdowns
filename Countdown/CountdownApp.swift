//
//  CountdownApp.swift
//  Countdown
//
//  Created by Gagandeep Singh on 6/9/20.
//

import SwiftUI

@main
struct CountdownApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
