import SwiftUI

/// Optional inhale / exhale cue. No Huberman copy on this screen.
struct BreathingView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var inhale = true
    @State private var scale: CGFloat = 0.72

    var body: some View {
        NavigationStack {
            VStack(spacing: 28) {
                Spacer()
                ZStack {
                    Circle()
                        .fill(MBTheme.soft)
                        .frame(width: 220, height: 220)
                    Circle()
                        .fill(MBTheme.accent.opacity(0.85))
                        .frame(width: 140, height: 140)
                        .scaleEffect(scale)
                }
                Text(inhale ? "Inhale" : "Exhale")
                    .font(.system(size: 24, weight: .semibold))
                    .foregroundStyle(MBTheme.ink)
                Text("A calm pace. Skip anytime — this is optional.")
                    .font(.system(size: 15))
                    .foregroundStyle(MBTheme.muted)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 24)
                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(MBTheme.background)
            .navigationTitle("Breathing")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") { dismiss() }
                        .fontWeight(.semibold)
                        .foregroundStyle(MBTheme.accent)
                }
            }
            .onAppear { pulse() }
        }
    }

    private func pulse() {
        withAnimation(.easeInOut(duration: 4).repeatForever(autoreverses: true)) {
            scale = 1.12
        }
        Timer.scheduledTimer(withTimeInterval: 4, repeats: true) { _ in
            inhale.toggle()
        }
    }
}
