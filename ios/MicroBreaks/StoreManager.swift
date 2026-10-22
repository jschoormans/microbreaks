import Foundation
import StoreKit

enum StoreError: Error {
    case unverified
}

@MainActor
final class StoreManager: ObservableObject {
    static let productID = "com.microbreaks.founderunlock"

    @Published var product: Product?
    @Published var isPurchasing = false
    @Published var lastMessage: String?

    private var updates: Task<Void, Never>?

    init() {
        updates = listenForTransactions()
    }

    deinit {
        updates?.cancel()
    }

    func loadProduct() async {
        do {
            let products = try await Product.products(for: [Self.productID])
            product = products.first
            if product == nil {
                lastMessage = "Product \(Self.productID) is not available. Use the StoreKit config in the simulator."
            }
        } catch {
            lastMessage = "Could not load the App Store product."
        }
    }

    func purchase() async -> Bool {
        guard let product else {
            lastMessage = "Product is not loaded yet."
            return false
        }
        isPurchasing = true
        defer { isPurchasing = false }
        do {
            let result = try await product.purchase()
            switch result {
            case .success(let verification):
                let transaction = try checkVerified(verification)
                await transaction.finish()
                lastMessage = nil
                return true
            case .userCancelled:
                return false
            case .pending:
                lastMessage = "Purchase is pending."
                return false
            @unknown default:
                return false
            }
        } catch {
            lastMessage = "Purchase did not complete. You can try again."
            return false
        }
    }

    func restore() async -> Bool {
        do {
            try await AppStore.sync()
            for await result in Transaction.currentEntitlements {
                if case .verified(let transaction) = result,
                   transaction.productID == Self.productID {
                    return true
                }
            }
            lastMessage = "No founder unlock found for this Apple ID."
            return false
        } catch {
            lastMessage = "Restore did not complete."
            return false
        }
    }

    func hasEntitlement() async -> Bool {
        for await result in Transaction.currentEntitlements {
            if case .verified(let transaction) = result,
               transaction.productID == Self.productID {
                return true
            }
        }
        return false
    }

    private func listenForTransactions() -> Task<Void, Never> {
        Task.detached {
            for await result in Transaction.updates {
                if case .verified(let transaction) = result {
                    await transaction.finish()
                    if transaction.productID == StoreManager.productID {
                        await MainActor.run {
                            NotificationCenter.default.post(name: .founderUnlockDidChange, object: true)
                        }
                    }
                }
            }
        }
    }

    private func checkVerified<T>(_ result: VerificationResult<T>) throws -> T {
        switch result {
        case .unverified:
            throw StoreError.unverified
        case .verified(let value):
            return value
        }
    }
}

extension Notification.Name {
    static let founderUnlockDidChange = Notification.Name("founderUnlockDidChange")
}
