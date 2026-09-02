import AVFoundation
import AudioToolbox
import UIKit

private final class NoiseState {
    var seed: UInt64 = 0xC0FFEE
}

@MainActor
final class SessionFeedback {
    static let shared = SessionFeedback()

    var soundOn = true
    var ambientOn = false

    private var engine: AVAudioEngine?
    private var source: AVAudioSourceNode?
    private var noise = NoiseState()

    func chime() {
        guard soundOn else { return }
        AudioServicesPlaySystemSound(1057)
    }

    func softHaptic() {
        UIImpactFeedbackGenerator(style: .soft).impactOccurred()
    }

    func setAmbient(_ on: Bool) {
        ambientOn = on
        if on { startAmbient() } else { stopAmbient() }
    }

    func startAmbientIfNeeded() {
        if ambientOn { startAmbient() }
    }

    func stopAmbient() {
        engine?.stop()
        engine = nil
        source = nil
    }

    private func startAmbient() {
        stopAmbient()
        let eng = AVAudioEngine()
        let noise = NoiseState()
        self.noise = noise
        let node = AVAudioSourceNode { _, _, _, abl -> OSStatus in
            let ptr = UnsafeMutableAudioBufferListPointer(abl)
            for buf in ptr {
                guard let data = buf.mData else { continue }
                let n = Int(buf.mDataByteSize) / MemoryLayout<Float>.size
                let f = data.bindMemory(to: Float.self, capacity: n)
                for i in 0..<n {
                    noise.seed = noise.seed &* 6364136223846793005 &+ 1
                    let u = Float(noise.seed >> 41) / Float(1 << 23)
                    f[i] = (u * 2 - 1) * 0.012
                }
            }
            return noErr
        }
        eng.attach(node)
        eng.connect(node, to: eng.mainMixerNode, format: nil)
        do {
            try AVAudioSession.sharedInstance().setCategory(.ambient, mode: .default, options: [.mixWithOthers])
            try AVAudioSession.sharedInstance().setActive(true)
            try eng.start()
            engine = eng
            source = node
        } catch {
            engine = nil
        }
    }
}
