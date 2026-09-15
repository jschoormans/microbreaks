import SwiftUI

@main
struct MicrobreaksApp: App {
    @StateObject private var timer = TimerEngine()
    @StateObject private var store = StoreManager()
    @AppStorage("soundOn") private var soundOn = true
    @AppStorage("ambientOn") private var ambientOn = false
    @AppStorage("founderUnlocked") private var founderUnlocked = false

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(timer)
                .environmentObject(store)
                .onAppear {
                    SessionFeedback.shared.soundOn = soundOn
                    SessionFeedback.shared.setAmbient(ambientOn && timer.kind == .focus)
                }
                .onChange(of: soundOn) { _, v in SessionFeedback.shared.soundOn = v }
                .onChange(of: ambientOn) { _, v in
                    SessionFeedback.shared.setAmbient(v && timer.kind == .focus)
                }
                .onChange(of: timer.kind) { _, k in
                    if k == .focus && ambientOn {
                        SessionFeedback.shared.startAmbientIfNeeded()
                    } else {
                        SessionFeedback.shared.stopAmbient()
                    }
                }
                .onReceive(NotificationCenter.default.publisher(for: .founderUnlockDidChange)) { n in
                    if n.object as? Bool == true { founderUnlocked = true }
                }
                .task {
                    await store.load()
                    if await store.entitled() { founderUnlocked = true }
                }
        }
    }
}
