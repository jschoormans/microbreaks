import SwiftUI

struct PaywallView: View {
    @EnvironmentObject private var store: StoreManager
    @Environment(\.dismiss) private var dismiss
    @AppStorage("founderUnlocked") private var founderUnlocked = false
    @State private var busy = false

    private let bullets = [
        "Built around research on brief waking rests during skill practice (Buch 2021)",
        "Short, frequent microbreaks on the ~10s timescale used in that work",
        "Inspired by spacing: practice + rest, not only grind",
        "Randomized prompts so you do not clock-watch",
        "A timer for evidence-aligned rest habits — not a medical device; results vary"
    ]

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    Text("Founder unlock — early iOS access")
                        .font(.system(size: 24, weight: .semibold))
                        .foregroundStyle(MBTheme.ink)
                    Text("$12 one-time. Priority on the iOS waitlist + supporters credit when Pro ships. The focus timer stays free.")
                        .font(.system(size: 16))
                        .foregroundStyle(MBTheme.muted)

                    Button(action: purchase) {
                        HStack {
                            if busy || store.isPurchasing {
                                ProgressView().tint(.white)
                            }
                            Text(priceLabel)
                                .font(.system(size: 16, weight: .semibold))
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .foregroundStyle(.white)
                        .background(MBTheme.accent)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                    }
                    .disabled(busy || store.isPurchasing || founderUnlocked)

                    Button("Restore purchases") {
                        Task { await restore() }
                    }
                    .font(.system(size: 15, weight: .medium))
                    .foregroundStyle(MBTheme.accentHover)
                    .frame(maxWidth: .infinity)

                    if founderUnlocked {
                        Text("You are in — early iOS access is locked.")
                            .font(.system(size: 15, weight: .medium))
                            .foregroundStyle(MBTheme.accentHover)
                    }

                    if let message = store.lastMessage, !founderUnlocked {
                        Text(message)
                            .font(.system(size: 13))
                            .foregroundStyle(MBTheme.muted)
                    }

                    VStack(alignment: .leading, spacing: 10) {
                        ForEach(bullets, id: \.self) { line in
                            HStack(alignment: .top, spacing: 10) {
                                Circle()
                                    .fill(MBTheme.accent.opacity(0.55))
                                    .frame(width: 6, height: 6)
                                    .padding(.top, 7)
                                Text(line)
                                    .font(.system(size: 14))
                                    .foregroundStyle(MBTheme.muted)
                            }
                        }
                    }
                    .padding(.top, 8)

                    Text("Inspired by peer-reviewed motor-skill rest/replay research (Buch et al., Cell Reports 2021). Not a medical device; results vary. Purchases use StoreKit (product \(StoreManager.productID)). The web Stripe Payment Link is not used in this app.")
                        .font(.system(size: 12))
                        .foregroundStyle(MBTheme.faint)
                        .padding(.top, 8)
                }
                .padding(24)
            }
            .background(MBTheme.background)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Not now") { dismiss() }
                        .foregroundStyle(MBTheme.muted)
                }
            }
        }
        .task { await store.loadProduct() }
    }

    private var priceLabel: String {
        if founderUnlocked { return "Unlocked" }
        if let product = store.product {
            return "Unlock — \(product.displayPrice)"
        }
        return "Unlock early access — $12"
    }

    private func purchase() {
        busy = true
        Task {
            let ok = await store.purchase()
            if ok { founderUnlocked = true }
            busy = false
        }
    }

    private func restore() async {
        busy = true
        let ok = await store.restore()
        if ok { founderUnlocked = true }
        busy = false
    }
}
