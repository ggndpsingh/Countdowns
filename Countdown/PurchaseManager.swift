//  Created by Gagandeep Singh on 2/10/20.

import StoreKit

typealias ProductIdentifier = String

final class PurchaseManager: NSObject, ObservableObject {
    static let shared = PurchaseManager()
    private var productsRequest: SKProductsRequest?
    private var receiptRequest: SKReceiptRefreshRequest?
    private var productRequestCompletion: ((SKProduct?) -> Void)?
    private var purchaseCompletion: ((Bool) -> Void)?
    private var purchasedProducts: [ProductIdentifier] = [] {
        didSet {
            objectWillChange.send()
        }
    }

    var hasPremium: Bool {
        purchasedProducts.contains(Product.premium.identifier)
    }

    override init() {
        super.init()
        SKPaymentQueue.default().add(self)
        Product.allCases.forEach {
            if UserDefaults.standard.bool(forKey: $0.identifier) {
                UserDefaults.standard.removeObject(forKey: $0.identifier)
//                purchasedProducts.append($0.identifier)
            }
        }
    }

    func requestProduct(completion: @escaping (SKProduct?) -> Void) {
        productsRequest?.cancel()
        productRequestCompletion = completion

        productsRequest = SKProductsRequest(productIdentifiers: Product.identifiers)
        productsRequest?.delegate = self
        productsRequest?.start()
    }

    func requestReceipt() {
        receiptRequest = SKReceiptRefreshRequest()
        receiptRequest?.delegate = self
        receiptRequest?.start()
    }

    func buyProduct(_ product: SKProduct, completion: @escaping (Bool) -> Void) {
        purchaseCompletion = completion
        let payment = SKPayment(product: product)
        SKPaymentQueue.default().add(payment)
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
                purchaseCompletion?(true)
                break
            case .failed:
                fail(transaction: transaction)
                purchaseCompletion?(false)
                break
            case .restored:
                restore(transaction: transaction)
                purchaseCompletion?(true)
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
        print("complete...")
        deliverPurchaseNotificationFor(identifier: transaction.payment.productIdentifier)
        UserDefaults.standard.setValue(true, forKey: transaction.payment.productIdentifier)
        purchasedProducts.append(transaction.payment.productIdentifier)
        SKPaymentQueue.default().finishTransaction(transaction)
    }

    private func restore(transaction: SKPaymentTransaction) {
        guard let productIdentifier = transaction.original?.payment.productIdentifier else { return }

        print("restore... \(productIdentifier)")
        deliverPurchaseNotificationFor(identifier: productIdentifier)
        UserDefaults.standard.setValue(true, forKey: transaction.payment.productIdentifier)
        purchasedProducts.append(transaction.payment.productIdentifier)
        SKPaymentQueue.default().finishTransaction(transaction)
    }

    private func fail(transaction: SKPaymentTransaction) {
        print("fail...")
        if let transactionError = transaction.error as NSError?,
           let localizedDescription = transaction.error?.localizedDescription,
           transactionError.code != SKError.paymentCancelled.rawValue {
            print("Transaction Error: \(localizedDescription)")
        }

        SKPaymentQueue.default().finishTransaction(transaction)
    }

    private func deliverPurchaseNotificationFor(identifier: String?) {
        guard let identifier = identifier else { return }
        UserDefaults.standard.set(true, forKey: identifier)
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
