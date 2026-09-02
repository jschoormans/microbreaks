import SwiftUI

struct PaywallView: View {
    @EnvironmentObject private var store: StoreManager
    @Environment(\.sizeCategory) private var sizeCategory
    @Environment(\.dismiss) private var dismiss
    @AppStorage("founderUnlocked") private var founderUnlocked = false
    @State private var busy = false

    private let bullets = [
        "Built around research on brief waking rests during skill practice (Buch 2021)",
        "Short, frequent microbreaks on the ~10s timescale used in that work",
        "Inspired by spacing: practice + rest, not only grind",
        "Randomized prompts so you don't clock-watch",
        "A timer for evidence-aligned rest habits - not a medical device; results vary"
    ]

    var body: some View {
        ZStack {
            MBTheme.background.ignoresSafeArea()
            ScrollView {
                card
                    .padding(.horizontal, MBType.screenPad())
                    .padding(.vertical, 24)
            }
        }
        .safeAreaPadding()
        .task { await store.loadProduct() }
    }

    private var card: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("Founder unlock - early iOS access")
                .font(MBType.title())
                .kerning(-0.56)
                .foregroundStyle(MBTheme.ink)
                .lineSpacing(6)
                .fixedSize(horizontal: false, vertical: true)

            Text("$12 one-time. Priority on the iOS waitlist + supporters credit when Pro ships. Web timer stays free.")
                .font(MBType.body())
                .foregroundStyle(MBTheme.muted)
                .lineSpacing(7)
                .padding(.top, MBTheme.titleToSub)

            Button(action: purchase) {
                HStack(spacing: 8) {
                    if busy || store.isPurchasing {
                        ProgressView().tint(.white)
                    }
                    Text(priceLabel)
                }
            }
            .buttonStyle(MBPrimaryButtonStyle(enabled: !(busy || store.isPurchasing || founderUnlocked)))
            .disabled(busy || store.isPurchasing || founderUnlocked)
            .padding(.top, MBTheme.subToPrimary)
            .accessibilityLabel("Unlock early access, 12 dollars")

            if founderUnlocked {
                Text("You're in - early iOS access is unlocked.")
                    .font(MBType.label())
                    .foregroundStyle(MBTheme.accentHover)
                    .padding(.top, 12)
            }

            if let message = store.lastMessage, !founderUnlocked {
                Text(message)
                    .font(MBType.trust())
                    .foregroundStyle(MBTheme.muted)
                    .padding(.top, 8)
            }

            VStack(alignment: .leading, spacing: MBTheme.rowGap) {
                ForEach(bullets, id: \.self) { line in
                    HStack(alignment: .top, spacing: 12) {
                        Circle()
                            .fill(MBTheme.accent.opacity(0.55))
                            .frame(width: 6, height: 6)
                            .padding(.top, 7)
                        Text(line)
                            .font(MBType.label())
                            .fontWeight(.regular)
                            .foregroundStyle(MBTheme.muted)
                            .lineSpacing(5)
                    }
                }
            }
            .padding(.top, MBTheme.buttonToList)

            MBTheme.border
                .frame(height: 1)
                .padding(.top, 18)

            Text("Inspired by peer-reviewed motor-skill rest/replay research (Buch et al., Cell Reports 2021). Not a medical device; results vary.")
                .font(MBType.trust())
                .foregroundStyle(MBTheme.faint)
                .lineSpacing(5)
                .padding(.top, 14)

            Button("Not now") { dismiss() }
                .font(MBType.body())
                .foregroundStyle(MBTheme.muted)
                .frame(maxWidth: .infinity)
                .padding(.top, MBTheme.notNowGap)

            Button("Restore purchases") {
                Task { await restore() }
            }
            .font(MBType.trust())
            .foregroundStyle(MBTheme.faint)
            .frame(maxWidth: .infinity)
            .padding(.top, 10)
        }
        .padding(.vertical, MBTheme.cardPadY)
        .padding(.horizontal, MBTheme.cardPadX)
        .background(MBTheme.card)
        .clipShape(RoundedRectangle(cornerRadius: MBTheme.cardRadius, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: MBTheme.cardRadius, style: .continuous)
                .stroke(MBTheme.border, lineWidth: 1)
        )
        .shadow(color: Color(red: 26 / 255, green: 35 / 255, blue: 50 / 255).opacity(0.06), radius: 24, y: 4)
    }

    private var priceLabel: String {
        if founderUnlocked { return "Unlocked" }
        if let product = store.product {
            return "Unlock early access - \(product.displayPrice)"
        }
        return "Unlock early access - $12"
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
