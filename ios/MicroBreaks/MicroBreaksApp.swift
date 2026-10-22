import SwiftUI

@main
struct MicroBreaksApp: App {
    @StateObject private var timer = TimerEngine()
    @StateObject private var store = StoreManager()
    @AppStorage("soundEnabled") private var soundEnabled = true
    @AppStorage("founderUnlocked") private var founderUnlocked = false
    @AppStorage("durationPreset") private var durationPreset = "25"
    @AppStorage("customMinutes") private var customMinutes = 40

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(timer)
                .environmentObject(store)
                .onAppear {
                    SoundPlayer.shared.isEnabled = soundEnabled
                    applyDurationPreset()
                }
                .onChange(of: soundEnabled) { _, value in
                    SoundPlayer.shared.isEnabled = value
                }
                .onReceive(NotificationCenter.default.publisher(for: .founderUnlockDidChange)) { note in
                    if note.object as? Bool == true {
                        founderUnlocked = true
                    }
                }
                .task {
                    await store.loadProduct()
                    if await store.hasEntitlement() {
                        founderUnlocked = true
                    }
                }
        }
    }

    private func applyDurationPreset() {
        let minutes: Int
        switch durationPreset {
        case "50": minutes = 50
        case "custom": minutes = customMinutes
        default: minutes = 25
        }
        timer.applyWorkMinutes(minutes)
    }
}
