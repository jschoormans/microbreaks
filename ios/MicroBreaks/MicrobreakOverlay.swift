import SwiftUI

struct MicrobreakOverlay: View {
    let secondsLeft: Int
    var onSkip: () -> Void

    var body: some View {
        ZStack {
            Color.black.opacity(0.28).ignoresSafeArea()
            VStack(spacing: 16) {
                Text("Microbreak")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(MBTheme.accentHover)
                    .textCase(.uppercase)
                    .tracking(0.6)
                Text("Relax")
                    .font(.system(size: 28, weight: .semibold))
                    .foregroundStyle(MBTheme.ink)
                Text("Close your eyes. Think of nothing for a few seconds.")
                    .font(.system(size: 15))
                    .foregroundStyle(MBTheme.muted)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 8)
                Text("\(max(0, secondsLeft))s")
                    .font(.system(size: 44, weight: .medium, design: .rounded))
                    .monospacedDigit()
                    .foregroundStyle(MBTheme.accent)
                Text("A brief rest on the ~10s timescale used in motor-skill rest studies — not a personal guarantee.")
                    .font(.system(size: 12))
                    .foregroundStyle(MBTheme.faint)
                    .multilineTextAlignment(.center)
                Button("Continue") {
                    onSkip()
                }
                .font(.system(size: 15, weight: .semibold))
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 12)
                .background(MBTheme.accent)
                .clipShape(RoundedRectangle(cornerRadius: 10))
            }
            .padding(24)
            .frame(maxWidth: 360)
            .background(MBTheme.card)
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(MBTheme.border, lineWidth: 1)
            )
            .padding(24)
        }
        .accessibilityAddTraits(.isModal)
    }
}
