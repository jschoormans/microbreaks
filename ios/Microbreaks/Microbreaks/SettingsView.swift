import SwiftUI

struct SettingsView: View {
    var requestUnlock: () -> Void
    @EnvironmentObject private var timer: TimerEngine
    @Environment(\.dismiss) private var dismiss
    @AppStorage("ambientOn") private var ambientOn = false
    @AppStorage("soundOn") private var soundOn = true
    @AppStorage("breathingOn") private var breathingOn = false
    @AppStorage("founderUnlocked") private var founderUnlocked = false
    @AppStorage("durationPreset") private var durationPreset = "25"
    @State private var customMinutes = 25

    var body: some View {
        NavigationStack {
            List {
                Section {
                    Toggle("Ambient sounds", isOn: $ambientOn)
                        .tint(MBTheme.accent)
                    Toggle("Session chime", isOn: $soundOn)
                        .tint(MBTheme.accent)
                    Toggle("Breathing cues", isOn: $breathingOn)
                        .tint(MBTheme.accent)
                    Text("Ambient is a quiet wash during Focus. Chime and a soft haptic play when a Break starts, if sound is on.")
                        .font(.footnote)
                        .foregroundStyle(MBTheme.muted)
                } header: {
                    Text("Cues")
                }

                Section {
                    Picker("Duration", selection: $durationPreset) {
                        Text("25 min").tag("25")
                        Text("50 min").tag("50")
                        Text("Custom").tag("custom")
                    }
                    .pickerStyle(.segmented)
                    if durationPreset == "custom" {
                        Stepper(value: $customMinutes, in: 5...180, step: 5) {
                            Text("\(customMinutes) min")
                                .monospacedDigit()
                        }
                    }
                    Text("Focus length. Breaks last about 10 seconds and appear at a random gap during the session. The timer works without paying.")
                        .font(.footnote)
                        .foregroundStyle(MBTheme.muted)
                } header: {
                    Text("Duration")
                }

                Section {
                    if founderUnlocked {
                        Text("Founder unlock is active.")
                            .foregroundStyle(MBTheme.hover)
                    } else {
                        Button("Founder unlock") {
                            dismiss()
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                requestUnlock()
                            }
                        }
                    }
                    Link("Join the waitlist", destination: URL(string: "https://tally.so/r/3NYZLG")!)
                        .font(.footnote)
                        .foregroundStyle(MBTheme.faint)
                } header: {
                    Text("Access")
                } footer: {
                    Text("Waitlist is optional. Unlock is StoreKit only — there is no Stripe checkout in this app.")
                }
            }
            .scrollContentBackground(.hidden)
            .background(MBTheme.bg)
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") { dismiss() }
                        .fontWeight(.semibold)
                        .foregroundStyle(MBTheme.accent)
                }
            }
            .onAppear {
                customMinutes = timer.workMinutes
                if timer.workMinutes == 25 { durationPreset = "25" }
                else if timer.workMinutes == 50 { durationPreset = "50" }
                else { durationPreset = "custom" }
            }
            .onChange(of: durationPreset) { _, _ in applyDuration() }
            .onChange(of: customMinutes) { _, _ in applyDuration() }
        }
        .presentationDetents([.large])
    }

    private func applyDuration() {
        let m: Int
        switch durationPreset {
        case "25": m = 25
        case "50": m = 50
        default: m = customMinutes
        }
        timer.workMinutes = m
        timer.applyDurationIfIdle()
    }
}
