import SwiftUI

/// Soft pulse on/over ocean. No Huberman copy.
struct BreathingView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.sizeCategory) private var sizeCategory
    @State private var inhale = true
    @State private var scale: CGFloat = 0.72

    var body: some View {
        NavigationStack {
            ZStack {
                OceanBackdrop(dimOpacity: 1.05)

                VStack(spacing: 28) {
                    Spacer()
                    ZStack {
                        Circle()
                            .fill(MBTheme.glassFill.opacity(0.35))
                            .frame(width: 240, height: 240)
                            .blur(radius: 2)
                        Circle()
                            .fill(MBTheme.accent.opacity(0.55))
                            .frame(width: 150, height: 150)
                            .scaleEffect(scale)
                            .shadow(color: MBTheme.accent.opacity(0.45), radius: 28)
                    }
                    Text(inhale ? "Inhale" : "Exhale")
                        .font(MBType.title())
                        .kerning(-0.56)
                        .foregroundStyle(MBTheme.softWhite)
                    Text("A calm pace. Skip anytime \u{2014} this is optional.")
                        .font(MBType.body())
                        .foregroundStyle(MBTheme.softWhite.opacity(0.82))
                        .multilineTextAlignment(.center)
                        .lineSpacing(7)
                        .padding(.horizontal, MBType.screenPad())
                    Spacer()
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            .navigationTitle("Breathing")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(.hidden, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") { dismiss() }
                        .fontWeight(.semibold)
                        .foregroundStyle(MBTheme.softWhite)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .mbGlass(cornerRadius: 999)
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
