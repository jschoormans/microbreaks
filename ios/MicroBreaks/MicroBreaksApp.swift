import SwiftUI

@main
struct MicroBreaksApp: App {
    @StateObject private var timer = TimerEngine()
    @StateObject private var store = StoreManager()
    @AppStorage("soundEnabled") private var soundEnabled = true
    @AppStorage("founderUnlocked") private var founderUnlocked = false

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(timer)
                .environmentObject(store)
                .onAppear {
                    SoundPlayer.shared.isEnabled = soundEnabled
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
}
