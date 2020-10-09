//  Created by Gagandeep Singh on 2/10/20.

import StoreKit
import WidgetKit

typealias ProductIdentifier = String

final class PurchaseManager: NSObject, ObservableObject {
    static let shared = PurchaseManager()
    private let storage = PurchaseStorage()
    private var productsRequest: SKProductsRequest?
    private var productRequestCompletion: ((SKProduct?) -> Void)?
    private var purchaseCompletion: ((Bool) -> Void)?

    var hasPremium: Bool {
        storage.hasPurchase(.premium)
    }

    override init() {
        super.init()
        SKPaymentQueue.default().add(self)
//        if storage.hasPurchase(.premium) {
//            storage.removePurchase(for: Product.premium.identifier)
//        }
    }

    func requestProduct(completion: @escaping (SKProduct?) -> Void) {
        productsRequest?.cancel()
        productRequestCompletion = completion

        productsRequest = SKProductsRequest(productIdentifiers: Product.identifiers)
        productsRequest?.delegate = self
        productsRequest?.start()
    }

    func buyProduct(_ product: SKProduct, completion: @escaping (Bool) -> Void) {
        purchaseCompletion = completion
        let payment = SKPayment(product: product)
        SKPaymentQueue.default().add(payment)
    }

    func restorePurchases() {
        SKPaymentQueue.default().restoreCompletedTransactions()
    }
}

extension PurchaseManager: SKProductsRequestDelegate {
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        productRequestCompletion?(response.products.first)
        productRequestCompletion = nil
    }

    func request(_ request: SKRequest, didFailWithError error: Error) {
        productRequestCompletion = nil
    }
}

extension PurchaseManager: SKPaymentTransactionObserver {
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        transactions.forEach { transaction in
            switch transaction.transactionState {
            case .purchased:
                complete(transaction: transaction)
                break
            case .failed:
                fail(transaction: transaction)
                break
            case .restored:
                restore(transaction: transaction)
                break
            case .deferred:
                break
            case .purchasing:
                break
            @unknown default:
                break
            }
        }
    }

    private func complete(transaction: SKPaymentTransaction) {
        guard let product = Product(rawValue: transaction.payment.productIdentifier) else { return }
        storage.addPurchase(for: product)
        SKPaymentQueue.default().finishTransaction(transaction)
        purchaseCompletion?(true)
        WidgetCenter.shared.reloadAllTimelines()
    }

    private func restore(transaction: SKPaymentTransaction) {
        guard
            let productIdentifier = transaction.original?.payment.productIdentifier,
            let product = Product(rawValue: productIdentifier)
        else { return }
        storage.addPurchase(for: product)
        SKPaymentQueue.default().finishTransaction(transaction)
        purchaseCompletion?(true)
        WidgetCenter.shared.reloadAllTimelines()
    }

    private func fail(transaction: SKPaymentTransaction) {
        if let transactionError = transaction.error as NSError?,
           let localizedDescription = transaction.error?.localizedDescription,
           transactionError.code != SKError.paymentCancelled.rawValue {
            print("Transaction Error: \(localizedDescription)")
        }

        SKPaymentQueue.default().finishTransaction(transaction)
        purchaseCompletion?(false)
    }
}

extension PurchaseManager {
    enum Product: String, CaseIterable {
        case premium = "com.deepgagan.countdown.premium01"
        var identifier: String { rawValue }

        static var identifiers: Set<String> {
            Set(allCases.map { $0.identifier })
        }
    }
}

extension SKProduct {
    fileprivate static var formatter: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        return formatter
    }

    var localizedPrice: String {
        if self.price == 0.00 {
            return "Get"
        } else {
            let formatter = SKProduct.formatter
            formatter.locale = self.priceLocale

            guard let formattedPrice = formatter.string(from: self.price) else {
                return "Unknown Price"
            }

            return formattedPrice
        }
    }
}
