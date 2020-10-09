//  Created by Gagandeep Singh on 9/10/20.

import UIKit

struct PurchaseStorage: Storage {
    typealias Key = PurchaseManager.Product
    func addPurchase(for product: Key) {
        set(true, for: .premium)
    }

    func removePurchase(for product: Key) {
        remove(for: .premium)
    }

    func hasPurchase(_ product: Key) -> Bool {
        bool(for: .premium)
    }
}
