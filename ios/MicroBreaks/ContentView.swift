import SwiftUI

struct ContentView: View {
    @EnvironmentObject private var timer: TimerEngine
    @Environment(\.sizeCategory) private var sizeCategory
    @AppStorage("breathingEnabled") private var breathingEnabled = false
    @State private var showSettings = false
    @State private var showPaywall = false

    var body: some View {
        NavigationStack {
            ZStack {
                MBTheme.background.ignoresSafeArea()

                VStack(spacing: 0) {
                    Spacer(minLength: 12)
                    Text(timer.statusTitle)
                        .font(MBType.label())
                        .foregroundStyle(MBTheme.muted)
                        .lineSpacing(5)
                        .accessibilityAddTraits(.updatesFrequently)
                    Text(timer.displayClock)
                        .font(MBType.time())
                        .monospacedDigit()
                        .foregroundStyle(MBTheme.ink)
                        .lineLimit(1)
                        .minimumScaleFactor(0.5)
                        .padding(.top, 8)
                        .accessibilityLabel("Time remaining \(timer.displayClock)")
                    controls
                        .padding(.top, MBTheme.controlsGap)
                    Spacer(minLength: 12)
                }
                .padding(.horizontal, MBType.screenPad())
                .padding(.bottom, 16)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .safeAreaPadding(.bottom)

                if timer.phase == .microbreak {
                    MicrobreakOverlay(
                        secondsLeft: timer.microbreakSecondsLeft,
                        showBreathingCue: breathingEnabled,
                        onResume: { timer.resumeFromBreak() },
                        onSkip: { timer.skipMicrobreak() }
                    )
                    .transition(.opacity)
                    .zIndex(2)
                }
            }
            .navigationTitle("MicroBreaks")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(MBTheme.background, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showSettings = true
                    } label: {
                        Image(systemName: "gearshape")
                            .font(.system(size: 17, weight: .semibold))
                            .foregroundStyle(MBTheme.ink)
                    }
                    .accessibilityLabel("Settings")
                }
            }
        }
        .tint(MBTheme.accent)
        .animation(.easeInOut(duration: 0.25), value: timer.phase)
        .sheet(isPresented: $showSettings) {
            SettingsView(showPaywall: $showPaywall)
        }
        .sheet(isPresented: $showPaywall) {
            PaywallView()
        }
        .onChange(of: timer.phase) { _, phase in
            if phase == .microbreak || phase == .work {
                showPaywall = false
            }
        }
        .onChange(of: showPaywall) { _, presented in
            if presented && timer.blocksPaywall {
                showPaywall = false
            }
        }
    }

    private var controls: some View {
        HStack(spacing: 10) {
            controlButton("Start") { timer.start() }
                .opacity(timer.phase == .work ? 0.4 : 1)
                .disabled(timer.phase == .work || timer.phase == .microbreak)
            controlButton("Pause") { timer.pause() }
                .opacity(timer.phase == .work ? 1 : 0.4)
                .disabled(timer.phase != .work)
            controlButton("Reset") { timer.reset() }
        }
    }

    private func controlButton(_ title: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Text(title)
                .font(MBType.label())
                .foregroundStyle(MBTheme.ink)
                .frame(maxWidth: .infinity)
                .frame(height: MBType.buttonHeight())
                .background(MBTheme.card)
                .clipShape(RoundedRectangle(cornerRadius: MBTheme.buttonRadius, style: .continuous))
                .overlay(
                    RoundedRectangle(cornerRadius: MBTheme.buttonRadius, style: .continuous)
                        .stroke(MBTheme.border, lineWidth: 1)
                )
        }
        .accessibilityLabel(title)
    }
}
