//  Created by Gagandeep Singh on 20/9/20.

import Intents
import CloudKit

class IntentHandler: INExtension, SelectCountdownIntentHandling {
    private let manager = CountdownsManagerKey.defaultValue

    override func handler(for intent: INIntent) -> Any {
        // This is the default implementation.  If you want different objects to handle different intents,
        // you can override this and return the handler you want for that particular intent.

        return self
    }

    func resolveCountdown(for intent: SelectCountdownIntent, with completion: @escaping (WidgetCountdownResolutionResult) -> Void) {

    }

    func provideCountdownOptionsCollection(for intent: SelectCountdownIntent, with completion: @escaping (INObjectCollection<WidgetCountdown>?, Error?) -> Void) {
        let selection: [Countdown] = {
            if PurchaseManager.shared.hasPremium {
                return manager.getAllObjects().map(Countdown.init)
            }

            guard let first = manager.getFirstPendingObject() else { return [] }
            return [Countdown(object: first)]
        }()
        let collection = INObjectCollection(items: selection.map { WidgetCountdown(identifier: $0.id.uuidString, display: $0.title) })
        completion(collection, nil)
    }
}
