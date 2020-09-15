//  Created by Gagandeep Singh on 16/9/20.

import UserNotifications

extension UNUserNotificationCenter {
    func hasPendingNotification(with identifier: String) -> Bool {
        var result = false

        let semaphore = DispatchSemaphore(value: 0)
        UNUserNotificationCenter.current().getPendingNotificationRequests { requests in
            result = requests.map { $0.identifier }.contains(identifier)
            semaphore.signal()
        }
        _ = semaphore.wait(timeout: .distantFuture)

        return result
    }
}
