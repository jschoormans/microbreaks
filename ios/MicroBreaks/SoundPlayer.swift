import AudioToolbox

/// System chimes only — no bundled audio, no Stripe, no remote streams.
final class SoundPlayer {
    static let shared = SoundPlayer()
    var isEnabled = true

    func playWorkChime() {
        guard isEnabled else { return }
        AudioServicesPlaySystemSound(1057)
    }

    func playBreakChime() {
        guard isEnabled else { return }
        AudioServicesPlaySystemSound(1025)
    }

    func playSessionEnd() {
        guard isEnabled else { return }
        AudioServicesPlaySystemSound(1005)
    }
}
