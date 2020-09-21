//  Created by Gagandeep Singh on 21/9/20.

import Foundation

protocol StorageProvider {
    associatedtype Key: RawRepresentable where Key.RawValue == String
}

extension StorageProvider {
    private var storage: UserDefaults {
        if let group = UserDefaults(suiteName: "group.com.deepgagan.CountdownGroup") {
            return group
        }
        return .standard
    }

    func getValue<Value>(for key: Key) -> Value? {
        return storage.value(forKey: key.rawValue) as? Value
    }

    func setValue(_ value: Any?, for key: Key) {
        guard let value = value else {
            return storage.removeObject(forKey: key.rawValue)
        }
        storage.setValue(value, forKey: key.rawValue)
    }
}

struct CountdownStorage: StorageProvider {
    enum Key: String {
        case countdowns
    }

    mutating func addCountdown(_ countdown: Countdown) {
        var countdowns: [String: Data] = getValue(for: .countdowns) ?? [:]

        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .secondsSince1970

        do {
            let data = try encoder.encode(countdown)
            countdowns[countdown.id.uuidString] = data
            setValue(countdowns, for: .countdowns)
        } catch {
            print(error)
        }
    }

    mutating func removeCountdown(id: String) {
        var countdowns: [String: Data] = getValue(for: .countdowns) ?? [:]
        countdowns.removeValue(forKey: id)
        setValue(countdowns, for: .countdowns)
    }

    func getCountdown(id: String) -> Countdown? {
        let countdowns: [String: Data] = getValue(for: .countdowns) ?? [:]
        guard let data = countdowns[id] else { return nil }
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .secondsSince1970
        do {
            let countdown = try decoder.decode(Countdown.self, from: data)
            return countdown
        } catch {
            print(error)
        }
        return nil
    }

    func getCountdowns() -> [Countdown] {
        var countdowns: [Countdown] = []
        let stored: [String: Data] = getValue(for: .countdowns) ?? [:]
        for (key, _) in stored {
            if let countdown = getCountdown(id: key) {
                countdowns.append(countdown)
            }
        }
        return countdowns
    }
}
