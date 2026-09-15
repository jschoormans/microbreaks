import SwiftUI

struct MicrobreakView: View {
    @EnvironmentObject private var timer: TimerEngine
    @AppStorage("soundOn") private var soundOn = true
    @AppStorage("breathingOn") private var breathingOn = false
    @State private var phaseInhale = true
    @ScaledMetric(relativeTo: .largeTitle) private var countSize: CGFloat = 56

    var body: some View {
        ZStack {
            MBTheme.soft.ignoresSafeArea()
            VStack(spacing: 16) {
                Spacer()
                Text("Break")
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(MBTheme.hover)
                Text("Close your eyes.\nThink of nothing.")
                    .font(.title2.weight(.semibold))
                    .foregroundStyle(MBTheme.ink)
                    .multilineTextAlignment(.center)
                    .fixedSize(horizontal: false, vertical: true)
                Text(String(format: "0:%02d", max(0, timer.breakLeft)))
                    .font(.system(size: countSize, weight: .medium))
                    .monospacedDigit()
                    .foregroundStyle(MBTheme.accent)
                if breathingOn {
                    Text(phaseInhale ? "Inhale" : "Exhale")
                        .font(.body)
                        .foregroundStyle(MBTheme.muted)
                        .animation(.easeInOut(duration: 0.3), value: phaseInhale)
                }
                Spacer()
                Button {
                    timer.resumeBreak()
                } label: {
                    Text("Resume")
                        .font(.body.weight(.semibold))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .foregroundStyle(.white)
                        .background(MBTheme.accent)
                        .clipShape(RoundedRectangle(cornerRadius: MBTheme.buttonRadius))
                }
                Button("Skip") {
                    timer.skipBreak()
                }
                .font(.body)
                .foregroundStyle(MBTheme.muted)
                .padding(.bottom, 8)
            }
            .padding(.horizontal, 24)
            .frame(maxWidth: 390)
        }
        .onAppear {
            SessionFeedback.shared.stopAmbient()
            if soundOn { SessionFeedback.shared.chime() }
            SessionFeedback.shared.softHaptic()
        }
        .onReceive(Timer.publish(every: 4, on: .main, in: .common).autoconnect()) { _ in
            if breathingOn { phaseInhale.toggle() }
        }
        .accessibilityAddTraits(.isModal)
    }
}
