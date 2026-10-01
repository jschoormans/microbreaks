import SwiftUI

/// Optional ~10–15s visual attention exercise before Start. Product UX, not a study finding.
struct FocusExerciseView: View {
    var duration: Int = 12
    var onFinished: () -> Void
    var onSkip: () -> Void

    @State private var secondsLeft: Int = 12
    @State private var bounce = false
    @State private var timer: Timer?
    @State private var catName: String = "CatFocus3"

    var body: some View {
        ZStack {
            OceanBackdrop(dimOpacity: 1.15)

            VStack(spacing: 0) {
                Spacer(minLength: 24)
                Text("Focus")
                    .font(MBType.label())
                    .foregroundStyle(MBTheme.softWhite.opacity(0.85))
                Text("Look at the cat.\nLet your mind settle.")
                    .font(MBType.title())
                    .kerning(-0.56)
                    .foregroundStyle(MBTheme.softWhite)
                    .multilineTextAlignment(.center)
                    .lineSpacing(6)
                    .padding(.top, MBTheme.titleToSub)
                Text("Optional ~15s attention exercise. Product habit, not a study finding.")
                    .font(MBType.body())
                    .foregroundStyle(MBTheme.softWhite.opacity(0.78))
                    .multilineTextAlignment(.center)
                    .lineSpacing(6)
                    .padding(.horizontal, MBType.screenPad())
                    .padding(.top, 12)

                ZStack {
                    Circle()
                        .fill(MBTheme.glassFill.opacity(0.55))
                        .frame(width: 220, height: 220)
                        .blur(radius: 1)
                    Image(catName)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 168, height: 168)
                        .clipShape(Circle())
                        .overlay(Circle().stroke(MBTheme.glassStroke, lineWidth: 3))
                        .shadow(color: MBTheme.oceanDeep.opacity(0.35), radius: 16, y: 6)
                        .offset(y: bounce ? -10 : 10)
                        .animation(.easeInOut(duration: 0.7).repeatForever(autoreverses: true), value: bounce)
                }
                .padding(.top, 28)
                .accessibilityLabel("Focus cat")

                Text("\(max(0, secondsLeft))s")
                    .font(MBType.time())
                    .monospacedDigit()
                    .foregroundStyle(MBTheme.softWhite)
                    .padding(.top, 20)
                    .accessibilityLabel("\(max(0, secondsLeft)) seconds left")

                Spacer()

                Button("Skip focus") {
                    stop()
                    onSkip()
                }
                .font(MBType.body())
                .foregroundStyle(MBTheme.softWhite.opacity(0.85))
                .padding(.bottom, 28)
                .safeAreaPadding(.bottom)
            }
            .padding(.horizontal, MBType.screenPad())
        }
        .onAppear {
            secondsLeft = max(10, min(15, duration))
            catName = Bool.random() ? "CatFocus3" : "CatFocus4"
            bounce = true
            startTick()
        }
        .onDisappear { stop() }
        .accessibilityAddTraits(.isModal)
    }

    private func startTick() {
        stop()
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            Task { @MainActor in
                secondsLeft -= 1
                if secondsLeft <= 0 {
                    stop()
                    onFinished()
                }
            }
        }
        if let timer {
            RunLoop.main.add(timer, forMode: .common)
        }
    }

    private func stop() {
        timer?.invalidate()
        timer = nil
    }
}
