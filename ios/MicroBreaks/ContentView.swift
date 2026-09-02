import SwiftUI

struct ContentView: View {
    @EnvironmentObject private var timer: TimerEngine
    @AppStorage("founderUnlocked") private var founderUnlocked = false
    @AppStorage("breathingEnabled") private var breathingEnabled = false
    @State private var showSettings = false
    @State private var showPaywall = false
    @State private var showBreathing = false

    var body: some View {
        ZStack {
            MBTheme.background.ignoresSafeArea()

            VStack(spacing: 0) {
                header
                Spacer(minLength: 12)
                timerRing
                Spacer(minLength: 12)
                controls
                if !founderUnlocked {
                    founderChip
                }
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 16)

            if timer.phase == .microbreak {
                MicrobreakOverlay(
                    secondsLeft: timer.microbreakSecondsLeft,
                    onSkip: { timer.skipMicrobreak() }
                )
                .transition(.opacity)
            }
        }
        .animation(.easeInOut(duration: 0.25), value: timer.phase)
        .sheet(isPresented: $showSettings) {
            SettingsView(showPaywall: $showPaywall)
        }
        .sheet(isPresented: $showPaywall) {
            PaywallView()
        }
        .sheet(isPresented: $showBreathing) {
            BreathingView()
        }
    }

    private var header: some View {
        HStack {
            Text("MicroBreaks")
                .font(.system(size: 17, weight: .semibold))
                .foregroundStyle(MBTheme.ink)
            Spacer()
            Text(timer.statusTitle)
                .font(.system(size: 15, weight: .medium))
                .foregroundStyle(MBTheme.muted)
            Spacer()
            Button {
                showSettings = true
            } label: {
                Image(systemName: "slider.horizontal.3")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundStyle(MBTheme.ink)
                    .frame(width: 36, height: 36)
            }
            .accessibilityLabel("Settings")
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 10)
        .background(MBTheme.card)
        .clipShape(Capsule())
        .overlay(Capsule().stroke(MBTheme.border, lineWidth: 1))
        .padding(.top, 12)
    }

    private var timerRing: some View {
        ZStack {
            Circle()
                .stroke(MBTheme.border, lineWidth: 12)
            Circle()
                .trim(from: 0, to: timer.progress)
                .stroke(MBTheme.accent, style: StrokeStyle(lineWidth: 12, lineCap: .round))
                .rotationEffect(.degrees(-90))
                .animation(.linear(duration: 0.35), value: timer.progress)
            VStack(spacing: 8) {
                Text(timer.displayClock)
                    .font(.system(size: 48, weight: .medium, design: .rounded))
                    .monospacedDigit()
                    .foregroundStyle(MBTheme.ink)
                if timer.phase == .work {
                    Text("Next rest in \(timer.segmentSecondsLeft)s")
                        .font(.system(size: 13))
                        .foregroundStyle(MBTheme.faint)
                } else if timer.phase == .idle {
                    Text("Short rests on a ~10s timescale")
                        .font(.system(size: 13))
                        .foregroundStyle(MBTheme.faint)
                }
            }
        }
        .frame(width: 280, height: 280)
        .padding(8)
        .background(MBTheme.card)
        .clipShape(Circle())
        .shadow(color: Color.black.opacity(0.04), radius: 8, y: 2)
    }

    private var controls: some View {
        HStack(spacing: 12) {
            roundButton(system: "wind", label: "Breathing") {
                showBreathing = true
            }
            if timer.isRunning {
                roundButton(system: "pause.fill", label: "Pause") {
                    timer.pause()
                }
            } else {
                roundButton(system: "play.fill", label: "Start") {
                    if breathingEnabled {
                        showBreathing = true
                    }
                    timer.start()
                }
            }
            roundButton(system: "stop.fill", label: "Reset") {
                timer.reset()
            }
        }
    }

    private func roundButton(system: String, label: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Image(systemName: system)
                .font(.system(size: 18, weight: .semibold))
                .foregroundStyle(MBTheme.ink)
                .frame(width: 56, height: 56)
                .background(MBTheme.card)
                .clipShape(Circle())
                .overlay(Circle().stroke(MBTheme.border, lineWidth: 1))
        }
        .accessibilityLabel(label)
    }

    private var founderChip: some View {
        Button {
            showPaywall = true
        } label: {
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text("Founder unlock — early iOS access")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundStyle(MBTheme.ink)
                    Text("Timer stays free. $12 one-time via App Store.")
                        .font(.system(size: 12))
                        .foregroundStyle(MBTheme.muted)
                }
                Spacer()
                Text("$12")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(MBTheme.accentHover)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background(MBTheme.soft)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
            }
            .padding(14)
            .background(MBTheme.card)
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(MBTheme.border, lineWidth: 1)
            )
        }
        .padding(.top, 16)
        .accessibilityLabel("Founder unlock")
    }
}
