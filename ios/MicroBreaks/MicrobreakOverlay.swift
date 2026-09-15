import SwiftUI

/// Immersive microbreak on ocean. UX copy only — no Buch / Huberman / unlock.
struct MicrobreakOverlay: View {
    let secondsLeft: Int
    @Environment(\.sizeCategory) private var sizeCategory
    var showBreathingCue: Bool = false
    var onResume: () -> Void
    var onSkip: () -> Void

    @State private var showCatPeek = false
    @State private var catName = "CatFocus4"

    var body: some View {
        ZStack {
            // Keep ocean visible; deepen dim for immersion.
            MBTheme.oceanDeep.opacity(0.55)
                .ignoresSafeArea()
                .allowsHitTesting(false)

            VStack(spacing: 0) {
                Spacer()
                Text("Break")
                    .font(MBType.label())
                    .foregroundStyle(MBTheme.softWhite.opacity(0.85))
                    .lineSpacing(5)
                Text("Close your eyes.\nThink of nothing.")
                    .font(MBType.title())
                    .kerning(-0.56)
                    .foregroundStyle(MBTheme.softWhite)
                    .multilineTextAlignment(.center)
                    .lineSpacing(6)
                    .padding(.top, MBTheme.titleToSub)
                if showBreathingCue {
                    Text("Inhale, then exhale \u{2014} at your own pace.")
                        .font(MBType.body())
                        .foregroundStyle(MBTheme.softWhite.opacity(0.8))
                        .multilineTextAlignment(.center)
                        .lineSpacing(7)
                        .padding(.top, 12)
                }
                Text("\(max(0, secondsLeft))s")
                    .font(MBType.time())
                    .monospacedDigit()
                    .foregroundStyle(MBTheme.softWhite)
                    .padding(.top, 20)
                    .accessibilityLabel("\(max(0, secondsLeft)) seconds left")

                if showCatPeek {
                    Image(catName)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 72, height: 72)
                        .clipShape(Circle())
                        .overlay(Circle().stroke(MBTheme.glassStroke, lineWidth: 2))
                        .opacity(0.85)
                        .padding(.top, 18)
                        .accessibilityLabel("Cat peek")
                        .transition(.opacity.combined(with: .scale))
                }

                Spacer()
                Button(action: onResume) {
                    Text("Resume")
                }
                .buttonStyle(MBPrimaryButtonStyle())
                .accessibilityLabel("Resume")
                Button("Skip this break", action: onSkip)
                    .font(MBType.body())
                    .foregroundStyle(MBTheme.softWhite.opacity(0.85))
                    .padding(.top, MBTheme.notNowGap)
            }
            .padding(.horizontal, MBType.screenPad())
            .padding(.bottom, 24)
            .safeAreaPadding(.bottom)
        }
        .onAppear {
            // Soft optional cat flavor (~40% of breaks).
            if Bool.random() {
                catName = Bool.random() ? "CatFocus3" : "CatFocus4"
                withAnimation(.easeInOut(duration: 0.6).delay(0.4)) {
                    showCatPeek = true
                }
            }
        }
        .accessibilityAddTraits(.isModal)
    }
}
