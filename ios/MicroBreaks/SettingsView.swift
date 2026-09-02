import SwiftUI

struct SettingsView: View {
    @EnvironmentObject private var timer: TimerEngine
    @Environment(\.sizeCategory) private var sizeCategory
    @Environment(\.dismiss) private var dismiss
    @AppStorage("soundEnabled") private var soundEnabled = true
    @AppStorage("breathingEnabled") private var breathingEnabled = false
    @AppStorage("founderUnlocked") private var founderUnlocked = false
    @AppStorage("durationPreset") private var durationPreset = "25"
    @AppStorage("customMinutes") private var customMinutes = 40
    @Binding var showPaywall: Bool
    @State private var showBreathing = false

    private let tallyURL = URL(string: "https://tally.so/r/3NYZLG")!

    var body: some View {
        NavigationStack {
            List {
                Section {
                    Toggle(isOn: $soundEnabled) {
                        Text("Ambient sounds")
                            .font(MBType.body())
                    }
                    .tint(MBTheme.accent)
                    Toggle(isOn: $breathingEnabled) {
                        Text("Breathing cues")
                            .font(MBType.body())
                    }
                    .tint(MBTheme.accent)
                    if breathingEnabled {
                        Button("Preview breathing") {
                            showBreathing = true
                        }
                        .font(MBType.label())
                        .foregroundStyle(MBTheme.accentHover)
                    }
                } header: {
                    Text("Session")
                }

                Section {
                    Picker("Focus length", selection: $durationPreset) {
                        Text("25 min").tag("25")
                        Text("50 min").tag("50")
                        Text("Custom").tag("custom")
                    }
                    .pickerStyle(.segmented)
                    .listRowInsets(EdgeInsets(top: 12, leading: 16, bottom: 12, trailing: 16))
                    if durationPreset == "custom" {
                        Stepper(value: $customMinutes, in: 5...180, step: 5) {
                            HStack {
                                Text("Custom")
                                Spacer()
                                Text("\(customMinutes) min")
                                    .foregroundStyle(MBTheme.muted)
                                    .monospacedDigit()
                            }
                        }
                    }
                    Text("Microbreaks stay ~10s. Focus length is 25, 50, or custom.")
                        .font(MBType.trust())
                        .foregroundStyle(MBTheme.muted)
                        .lineSpacing(5)
                } header: {
                    Text("Focus length")
                }

                Section {
                    if founderUnlocked {
                        Label("Founder unlock is active", systemImage: "checkmark.circle.fill")
                            .foregroundStyle(MBTheme.accentHover)
                    } else {
                        Button {
                            guard !timer.blocksPaywall else { return }
                            dismiss()
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) {
                                if !timer.blocksPaywall {
                                    showPaywall = true
                                }
                            }
                        } label: {
                            Text("Founder unlock - early iOS access")
                        }
                        .disabled(timer.blocksPaywall)
                    }
                    Text("The focus timer works without paying. Unlock is a one-time $12 App Store purchase.")
                        .font(MBType.trust())
                        .foregroundStyle(MBTheme.muted)
                        .lineSpacing(5)
                } header: {
                    Text("Unlock")
                }

                Section {
                    Link(destination: tallyURL) {
                        Text("Notify me")
                            .font(MBType.body())
                            .foregroundStyle(MBTheme.faint)
                            .frame(maxWidth: .infinity)
                    }
                    .listRowBackground(Color.clear)
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
            .sheet(isPresented: $showBreathing) {
                BreathingView()
            }
        }
        .onAppear { applyPreset() }
        .onChange(of: soundEnabled) { _, value in
            SoundPlayer.shared.isEnabled = value
        }
        .onChange(of: durationPreset) { _, _ in applyPreset() }
        .onChange(of: customMinutes) { _, _ in applyPreset() }
    }

    private func applyPreset() {
        let minutes: Int
        switch durationPreset {
        case "50": minutes = 50
        case "custom": minutes = customMinutes
        default: minutes = 25
        }
        timer.applyWorkMinutes(minutes)
    }
}
