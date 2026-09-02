import Foundation
import Combine

enum SessionKind: Equatable {
    case idle
    case focus
    case pause
    case brk
    case done
}

@MainActor
final class TimerEngine: ObservableObject {
    static let microbreakSeconds = 10
    static let minGap = 90
    static let maxGap = 180

    @Published private(set) var kind: SessionKind = .idle
    @Published private(set) var remaining: Int
    @Published private(set) var total: Int
    @Published private(set) var breakLeft: Int = 0
    @Published var workMinutes: Int {
        didSet { UserDefaults.standard.set(workMinutes, forKey: "workMinutes") }
    }

    private var timer: Timer?
    private var elapsed = 0
    private var nextBreak = 0
    private var inSegment = 0
    private var pausedFrom: SessionKind = .focus

    var isRunning: Bool { kind == .focus || kind == .brk }

    /// True while a session is in progress (including pause). Paywall must not appear.
    var blocksPaywall: Bool { kind == .focus || kind == .brk || kind == .pause }

    var stateLabel: String {
        switch kind {
        case .idle, .done: return "Focus"
        case .focus: return "Focus"
        case .brk: return "Break"
        case .pause: return pausedFrom == .brk ? "Break" : "Focus"
        }
    }

    var clock: String {
        let v = kind == .brk ? breakLeft : remaining
        return String(format: "%d:%02d", max(0, v) / 60, max(0, v) % 60)
    }

    init() {
        let stored = UserDefaults.standard.object(forKey: "workMinutes") as? Int
        let minutes = stored ?? 25
        workMinutes = minutes
        let t = max(1, minutes) * 60
        total = t
        remaining = t
    }

    func start() {
        if kind == .idle || kind == .done {
            elapsed = 0
            total = max(1, workMinutes) * 60
            remaining = total
            scheduleBreak()
            kind = .focus
            tickLoop()
            return
        }
        if kind == .pause {
            kind = pausedFrom == .brk ? .brk : .focus
            tickLoop()
        }
    }

    func pause() {
        guard isRunning else { return }
        pausedFrom = kind
        timer?.invalidate()
        timer = nil
        kind = .pause
    }

    func reset() {
        timer?.invalidate()
        timer = nil
        elapsed = 0
        inSegment = 0
        total = max(1, workMinutes) * 60
        remaining = total
        breakLeft = 0
        kind = .idle
    }

    func resumeBreak() { endBreak() }
    func skipBreak() { endBreak() }

    func applyDurationIfIdle() {
        guard kind == .idle else { return }
        total = max(1, workMinutes) * 60
        remaining = total
    }

    private func tickLoop() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            Task { @MainActor in self?.tick() }
        }
        if let timer { RunLoop.main.add(timer, forMode: .common) }
    }

    private func tick() {
        switch kind {
        case .focus:
            elapsed += 1
            remaining = max(0, total - elapsed)
            inSegment += 1
            if elapsed >= total { finish() }
            else if inSegment >= nextBreak { beginBreak() }
        case .brk:
            breakLeft -= 1
            if breakLeft <= 0 { endBreak() }
        default: break
        }
    }

    private func beginBreak() {
        kind = .brk
        breakLeft = Self.microbreakSeconds
        NotificationCenter.default.post(name: .microbreakBegan, object: nil)
    }

    private func endBreak() {
        guard kind == .brk else { return }
        if elapsed >= total {
            finish()
            return
        }
        scheduleBreak()
        kind = .focus
        NotificationCenter.default.post(name: .microbreakEnded, object: nil)
    }

    private func finish() {
        timer?.invalidate()
        timer = nil
        remaining = 0
        kind = .done
    }

    private func scheduleBreak() {
        nextBreak = Int.random(in: Self.minGap...Self.maxGap)
        inSegment = 0
    }
}

extension Notification.Name {
    static let microbreakBegan = Notification.Name("microbreakBegan")
    static let microbreakEnded = Notification.Name("microbreakEnded")
    static let founderUnlockDidChange = Notification.Name("founderUnlockDidChange")
}
