import Foundation
import StoreKit

private enum VerifyError: Error { case unverified }

@MainActor
final class StoreManager: ObservableObject {
    static let productID = "com.microbreaks.founderunlock"

    @Published var product: Product?
    @Published var buying = false
    @Published var note: String?

    private var listenTask: Task<Void, Never>?

    init() { listenTask = listen() }
    deinit { listenTask?.cancel() }

    func load() async {
        do {
            product = try await Product.products(for: [Self.productID]).first
            if product == nil {
                note = "Product \(Self.productID) is unavailable. Edit the scheme → Run → Options → StoreKit Configuration → Microbreaks.storekit."
            }
        } catch {
            note = "Could not load the App Store product."
        }
    }

    func buy() async -> Bool {
        guard let product else {
            note = "Product is not loaded yet."
            return false
        }
        buying = true
        defer { buying = false }
        do {
            switch try await product.purchase() {
            case .success(let v):
                let t = try Self.verified(v)
                await t.finish()
                note = nil
                return true
            case .userCancelled: return false
            case .pending:
                note = "Purchase is pending."
                return false
            @unknown default: return false
            }
        } catch {
            note = "Purchase did not complete."
            return false
        }
    }

    func restore() async -> Bool {
        do {
            try await AppStore.sync()
            if await entitled() { return true }
            note = "No founder unlock on this Apple ID."
            return false
        } catch {
            note = "Restore did not complete."
            return false
        }
    }

    func entitled() async -> Bool {
        for await r in Transaction.currentEntitlements {
            if case .verified(let t) = r, t.productID == Self.productID { return true }
        }
        return false
    }

    private func listen() -> Task<Void, Never> {
        Task.detached {
            for await r in Transaction.updates {
                if case .verified(let t) = r {
                    await t.finish()
                    if t.productID == StoreManager.productID {
                        await MainActor.run {
                            NotificationCenter.default.post(name: .founderUnlockDidChange, object: true)
                        }
                    }
                }
            }
        }
    }

    private static func verified<T>(_ r: VerificationResult<T>) throws -> T {
        switch r {
        case .unverified: throw VerifyError.unverified
        case .verified(let v): return v
        }
    }
}
