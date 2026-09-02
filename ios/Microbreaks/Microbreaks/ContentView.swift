import SwiftUI

struct ContentView: View {
    @EnvironmentObject private var timer: TimerEngine
    @AppStorage("founderUnlocked") private var founderUnlocked = false
    @State private var showSettings = false
    @State private var showUnlock = false
    @ScaledMetric(relativeTo: .largeTitle) private var timeSize: CGFloat = 64

    var body: some View {
        ZStack {
            MBTheme.bg.ignoresSafeArea()
            VStack(spacing: 20) {
                header
                Spacer(minLength: 8)
                timeCard
                Spacer(minLength: 8)
                controls
                if !founderUnlocked && !timer.blocksPaywall {
                    unlockHint
                }
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 12)
            .frame(maxWidth: 390)
            .frame(maxWidth: .infinity)

            if timer.kind == .brk {
                MicrobreakView()
                    .transition(.opacity)
                    .zIndex(2)
            }
        }
        .animation(.easeInOut(duration: 0.2), value: timer.kind)
        .sheet(isPresented: $showSettings) {
            SettingsView(requestUnlock: presentUnlockIfAllowed)
        }
        .sheet(isPresented: $showUnlock) {
            UnlockView()
        }
        .onChange(of: timer.blocksPaywall) { _, blocked in
            if blocked { showUnlock = false }
        }
    }

    private var header: some View {
        HStack {
            Text("Microbreaks")
                .font(.headline)
                .foregroundStyle(MBTheme.ink)
            Spacer()
            Text(timer.stateLabel)
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(timer.kind == .brk ? MBTheme.hover : MBTheme.muted)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(MBTheme.soft)
                .clipShape(Capsule())
            Spacer()
            Button {
                showSettings = true
            } label: {
                Image(systemName: "gearshape")
                    .font(.body.weight(.semibold))
                    .foregroundStyle(MBTheme.ink)
                    .frame(width: 44, height: 44)
            }
            .accessibilityLabel("Settings")
        }
        .padding(.horizontal, 8)
        .padding(.top, 8)
    }

    private var timeCard: some View {
        VStack(spacing: 12) {
            Text(timer.clock)
                .font(.system(size: timeSize, weight: .medium, design: .default))
                .monospacedDigit()
                .foregroundStyle(MBTheme.ink)
                .minimumScaleFactor(0.5)
                .lineLimit(1)
                .accessibilityLabel("Time remaining \(timer.clock)")
            Text(timer.kind == .done ? "Session complete" : timer.stateLabel)
                .font(.title3.weight(.medium))
                .foregroundStyle(MBTheme.muted)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 36)
        .padding(.horizontal, 20)
        .background(MBTheme.card)
        .clipShape(RoundedRectangle(cornerRadius: MBTheme.radius))
        .overlay(
            RoundedRectangle(cornerRadius: MBTheme.radius)
                .stroke(MBTheme.border, lineWidth: 1)
        )
    }

    private var controls: some View {
        HStack(spacing: 10) {
            if timer.isRunning {
                primaryButton("Pause") { timer.pause() }
            } else {
                primaryButton("Start") { timer.start() }
            }
            outlineButton("Reset") { timer.reset() }
        }
    }

    private func primaryButton(_ title: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Text(title)
                .font(.body.weight(.semibold))
                .frame(maxWidth: .infinity)
                .padding(.vertical, 14)
                .foregroundStyle(.white)
                .background(MBTheme.accent)
                .clipShape(RoundedRectangle(cornerRadius: MBTheme.buttonRadius))
        }
    }

    private func outlineButton(_ title: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Text(title)
                .font(.body.weight(.semibold))
                .frame(maxWidth: .infinity)
                .padding(.vertical, 14)
                .foregroundStyle(MBTheme.ink)
                .background(MBTheme.card)
                .clipShape(RoundedRectangle(cornerRadius: MBTheme.buttonRadius))
                .overlay(
                    RoundedRectangle(cornerRadius: MBTheme.buttonRadius)
                        .stroke(MBTheme.border, lineWidth: 1)
                )
        }
    }

    private var unlockHint: some View {
        Button {
            presentUnlockIfAllowed()
        } label: {
            Text("Founder unlock")
                .font(.footnote.weight(.medium))
                .foregroundStyle(MBTheme.muted)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 10)
        }
        .accessibilityLabel("Open founder unlock")
    }

    private func presentUnlockIfAllowed() {
        guard !timer.blocksPaywall else { return }
        showUnlock = true
    }
}
