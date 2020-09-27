//  Created by Gagandeep Singh on 6/9/20.

import WidgetKit
import CoreData

final class PersistenceController {
    static let shared = PersistenceController()
    static let inMemory = PersistenceController(inMemory: true)

    let container: NSPersistentCloudKitContainer

    init(inMemory: Bool = false) {        
        container = NSPersistentCloudKitContainer(name: "Countdown")

        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        } else {
            container.viewContext.automaticallyMergesChangesFromParent = true
            container.viewContext.mergePolicy = NSMergeByPropertyStoreTrumpMergePolicy

            let cloud = NSPersistentStoreDescription(url: .storeURL(for: "group.com.deepgagan.CountdownGroup", databaseName: "Cloud"))
            let options = NSPersistentCloudKitContainerOptions(containerIdentifier: "iCloud.com.deepgagan.Countdown")
//            options.databaseScope = .public
            cloud.cloudKitContainerOptions = options
            container.persistentStoreDescriptions = [cloud]
        }

        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.

                /*
                Typical reasons for an error here include:
                * The parent directory does not exist, cannot be created, or disallows writing.
                * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                * The device is out of space.
                * The store could not be migrated to the current model version.
                Check the error message to determine what the actual problem was.
                */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
    }
}

public extension URL {
    /// Returns a URL for the given app group and database pointing to the sqlite database.
    static func storeURL(for appGroup: String, databaseName: String) -> URL {
        guard let fileContainer = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: appGroup) else {
            fatalError("Shared file container could not be created.")
        }

        return fileContainer.appendingPathComponent("\(databaseName).sqlite")
    }
}
