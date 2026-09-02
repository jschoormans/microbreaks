import SwiftUI

struct UnlockView: View {
    @EnvironmentObject private var store: StoreManager
    @EnvironmentObject private var timer: TimerEngine
    @Environment(\.dismiss) private var dismiss
    @AppStorage("founderUnlocked") private var founderUnlocked = false
    @State private var busy = false

    private let bullets = [
        "Built around research on brief waking rests during skill practice (Buch 2021)",
        "Short, frequent microbreaks on the ~10s timescale used in that work",
        "Inspired by spacing: practice + rest, not only grind",
        "Randomized prompts so you don’t clock-watch",
        "A timer for evidence-aligned rest habits — not a medical device; results vary"
    ]

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    Text("Founder unlock — early iOS access")
                        .font(.title2.weight(.semibold))
                        .foregroundStyle(MBTheme.ink)
                    Text("$12 one-time. Priority on the iOS waitlist + supporters credit when Pro ships. Web timer stays free.")
                        .font(.body)
                        .foregroundStyle(MBTheme.muted)

                    Button(action: purchase) {
                        HStack {
                            if busy || store.buying { ProgressView().tint(.white) }
                            Text(cta)
                                .font(.body.weight(.semibold))
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .foregroundStyle(.white)
                        .background(MBTheme.accent)
                        .clipShape(RoundedRectangle(cornerRadius: MBTheme.buttonRadius))
                    }
                    .disabled(busy || store.buying || founderUnlocked || timer.blocksPaywall)

                    Button("Restore purchases") {
                        Task { await restore() }
                    }
                    .font(.subheadline.weight(.medium))
                    .foregroundStyle(MBTheme.hover)
                    .frame(maxWidth: .infinity)

                    if let note = store.note, !founderUnlocked {
                        Text(note)
                            .font(.footnote)
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
                                    .font(.footnote)
                                    .foregroundStyle(MBTheme.muted)
                            }
                        }
                    }
                    .padding(.top, 4)

                    Text("Inspired by peer-reviewed motor-skill rest/replay research (Buch et al., Cell Reports 2021). Not a medical device; results vary.")
                        .font(.caption)
                        .foregroundStyle(MBTheme.faint)
                        .padding(.top, 4)

                    Button("Not now") { dismiss() }
                        .font(.subheadline)
                        .foregroundStyle(MBTheme.muted)
                        .frame(maxWidth: .infinity)
                        .padding(.top, 8)
                }
                .padding(24)
                .frame(maxWidth: 390)
                .frame(maxWidth: .infinity)
            }
            .background(MBTheme.bg)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Not now") { dismiss() }
                        .foregroundStyle(MBTheme.muted)
                }
            }
        }
        .interactiveDismissDisabled(timer.kind == .brk)
        .onChange(of: timer.blocksPaywall) { _, blocked in
            if blocked { dismiss() }
        }
        .task { await store.load() }
    }

    private var cta: String {
        if founderUnlocked { return "Unlocked" }
        return "Unlock early access — $12"
    }

    private func purchase() {
        guard !timer.blocksPaywall else { return }
        busy = true
        Task {
            if await store.buy() { founderUnlocked = true; dismiss() }
            busy = false
        }
    }

    private func restore() async {
        busy = true
        if await store.restore() { founderUnlocked = true; dismiss() }
        busy = false
    }
}
