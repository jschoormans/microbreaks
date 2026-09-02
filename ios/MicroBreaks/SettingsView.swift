import SwiftUI

struct SettingsView: View {
    @EnvironmentObject private var timer: TimerEngine
    @Environment(\.dismiss) private var dismiss
    @AppStorage("soundEnabled") private var soundEnabled = true
    @AppStorage("breathingEnabled") private var breathingEnabled = false
    @AppStorage("founderUnlocked") private var founderUnlocked = false
    @Binding var showPaywall: Bool

    var body: some View {
        NavigationStack {
            List {
                Section {
                    Toggle(isOn: $soundEnabled) {
                        Label("Sound", systemImage: soundEnabled ? "speaker.wave.2" : "speaker.slash")
                    }
                    .tint(MBTheme.accent)
                    Toggle(isOn: $breathingEnabled) {
                        Label("Breathing cues", systemImage: "wind")
                    }
                    .tint(MBTheme.accent)
                    Text("Sound plays a short system chime at work and rest. Breathing is a simple inhale/exhale cue — optional.")
                        .font(.system(size: 13))
                        .foregroundStyle(MBTheme.muted)
                } header: {
                    Text("Session")
                }

                Section {
                    stepperRow("Work", value: $timer.workMinutes, range: 10...90, step: 5, suffix: "min")
                    stepperRow("Microbreak", value: $timer.microbreakDuration, range: 5...25, step: 5, suffix: "s")
                    stepperRow("Min gap", value: $timer.minGapSeconds, range: 60...240, step: 30, suffix: "s")
                    stepperRow("Max gap", value: $timer.maxGapSeconds, range: 60...300, step: 30, suffix: "s")
                    Text("Rests arrive at a random interval between min and max gap. Web defaults: 90-180s gap, ~10s rest, 30 min session.")
                        .font(.system(size: 13))
                        .foregroundStyle(MBTheme.muted)
                } header: {
                    Text("Timing")
                }

                Section {
                    if founderUnlocked {
                        Label("Founder unlock is active", systemImage: "checkmark.circle.fill")
                            .foregroundStyle(MBTheme.accentHover)
                    } else {
                        Button {
                            dismiss()
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) {
                                showPaywall = true
                            }
                        } label: {
                            Label("Founder unlock — early iOS access", systemImage: "sparkle")
                        }
                    }
                    Text("The focus timer works without paying. Unlock is a one-time $12 App Store purchase (\(StoreManager.productID)).")
                        .font(.system(size: 13))
                        .foregroundStyle(MBTheme.muted)
                } header: {
                    Text("Unlock")
                }

                Section {
                    Text("Inspired by peer-reviewed motor-skill rest/replay research (Buch et al., Cell Reports 2021). Not a medical device; results vary.")
                        .font(.system(size: 13))
                        .foregroundStyle(MBTheme.faint)
                }
            }
            .scrollContentBackground(.hidden)
            .background(MBTheme.background)
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") { dismiss() }
                        .fontWeight(.semibold)
                        .foregroundStyle(MBTheme.accent)
                }
            }
        }
        .onChange(of: soundEnabled) { _, value in
            SoundPlayer.shared.isEnabled = value
        }
        .onChange(of: timer.workMinutes) { _, _ in
            if timer.phase == .idle { timer.reset() }
        }
    }

    private func stepperRow(_ title: String, value: Binding<Int>, range: ClosedRange<Int>, step: Int, suffix: String) -> some View {
        Stepper(value: value, in: range, step: step) {
            HStack {
                Text(title)
                Spacer()
                Text("\(value.wrappedValue) \(suffix)")
                    .foregroundStyle(MBTheme.muted)
                    .monospacedDigit()
            }
        }
    }
}
