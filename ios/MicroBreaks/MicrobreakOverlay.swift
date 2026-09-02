import SwiftUI

/// Full-screen ~10s rest. UX copy only - no Buch / Huberman on this screen.
struct MicrobreakOverlay: View {
    let secondsLeft: Int
    @Environment(\.sizeCategory) private var sizeCategory
    var showBreathingCue: Bool = false
    var onResume: () -> Void
    var onSkip: () -> Void

    var body: some View {
        ZStack {
            MBTheme.background.ignoresSafeArea()

            VStack(spacing: 0) {
                Spacer()
                Text("Break")
                    .font(MBType.label())
                    .foregroundStyle(MBTheme.muted)
                    .lineSpacing(5)
                Text("Close your eyes.\nThink of nothing.")
                    .font(MBType.title())
                    .kerning(-0.56)
                    .foregroundStyle(MBTheme.ink)
                    .multilineTextAlignment(.center)
                    .lineSpacing(6)
                    .padding(.top, MBTheme.titleToSub)
                if showBreathingCue {
                    Text("Inhale, then exhale - at your own pace.")
                        .font(MBType.body())
                        .foregroundStyle(MBTheme.muted)
                        .multilineTextAlignment(.center)
                        .lineSpacing(7)
                        .padding(.top, 12)
                }
                Text("\(max(0, secondsLeft))s")
                    .font(MBType.time())
                    .monospacedDigit()
                    .foregroundStyle(MBTheme.accent)
                    .padding(.top, 20)
                    .accessibilityLabel("\(max(0, secondsLeft)) seconds left")
                Spacer()
                Button(action: onResume) {
                    Text("Resume")
                }
                .buttonStyle(MBPrimaryButtonStyle())
                .accessibilityLabel("Resume")
                Button("Skip this break", action: onSkip)
                    .font(MBType.body())
                    .foregroundStyle(MBTheme.muted)
                    .padding(.top, MBTheme.notNowGap)
            }
            .padding(.horizontal, MBType.screenPad())
            .padding(.bottom, 24)
            .safeAreaPadding(.bottom)
        }
        .accessibilityAddTraits(.isModal)
    }
}
