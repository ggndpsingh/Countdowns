//  Created by Gagandeep Singh on 9/10/20.

import Foundation

protocol Storage {
    associatedtype Key: RawRepresentable where Key.RawValue == String
}

extension Storage {
    private var store: UserDefaults {
        guard let group = UserDefaults(suiteName: "group.com.deepgagan.CountdownGroup") else {
            return .standard
        }
        return group
    }

    func value<T>(for key: Key) -> T? {
        store.value(forKey: key.rawValue) as? T
    }

    func bool(for key: Key) -> Bool {
        store.bool(forKey: key.rawValue)
    }

    func set(_ value: Any, for key: Key) {
        store.setValue(value, forKey: key.rawValue)
    }

    func remove(for key: Key) {
        store.removeObject(forKey: key.rawValue)
    }
}
