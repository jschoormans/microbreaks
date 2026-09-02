import Foundation
import Combine

enum SessionPhase: Equatable {
    case idle
    case work
    case microbreak
    case paused
    case finished
}

@MainActor
final class TimerEngine: ObservableObject {
    static let defaultWorkMinutes = 30
    static let defaultMicrobreakSeconds = 10
    static let defaultMinGapSeconds = 90
    static let defaultMaxGapSeconds = 180

    @Published private(set) var phase: SessionPhase = .idle
    @Published private(set) var remainingWorkSeconds: Int
    @Published private(set) var totalWorkSeconds: Int
    @Published private(set) var segmentSecondsLeft: Int = 0
    @Published private(set) var microbreakSecondsLeft: Int = 0
    @Published var workMinutes: Int
    @Published var microbreakDuration: Int
    @Published var minGapSeconds: Int
    @Published var maxGapSeconds: Int

    private var timer: Timer?
    private var elapsedWorkSeconds = 0
    private var nextBreakAfter: Int = 0
    private var workInSegment = 0

    var displayClock: String {
        let value: Int = phase == .microbreak ? microbreakSecondsLeft : remainingWorkSeconds
        let m = max(0, value) / 60
        let s = max(0, value) % 60
        return String(format: "%d:%02d", m, s)
    }

    var progress: Double {
        guard totalWorkSeconds > 0 else { return 0 }
        return min(1, Double(elapsedWorkSeconds) / Double(totalWorkSeconds))
    }

    var statusTitle: String {
        switch phase {
        case .idle: return "Do something today"
        case .work: return "Work mode"
        case .microbreak: return "Relax"
        case .paused: return "Pause"
        case .finished: return "Session complete"
        }
    }

    var isRunning: Bool { phase == .work || phase == .microbreak }

    init(
        workMinutes: Int = TimerEngine.defaultWorkMinutes,
        microbreakDuration: Int = TimerEngine.defaultMicrobreakSeconds,
        minGapSeconds: Int = TimerEngine.defaultMinGapSeconds,
        maxGapSeconds: Int = TimerEngine.defaultMaxGapSeconds
    ) {
        self.workMinutes = workMinutes
        self.microbreakDuration = microbreakDuration
        self.minGapSeconds = minGapSeconds
        self.maxGapSeconds = maxGapSeconds
        let total = workMinutes * 60
        self.totalWorkSeconds = total
        self.remainingWorkSeconds = total
    }

    func start() {
        guard !isRunning else { return }
        if phase == .idle || phase == .finished {
            elapsedWorkSeconds = 0
            totalWorkSeconds = max(1, workMinutes) * 60
            remainingWorkSeconds = totalWorkSeconds
            scheduleNextBreak()
        }
        phase = .work
        SoundPlayer.shared.playWorkChime()
        beginTicking()
    }

    func pause() {
        guard isRunning else { return }
        timer?.invalidate()
        timer = nil
        phase = .paused
    }

    func reset() {
        timer?.invalidate()
        timer = nil
        elapsedWorkSeconds = 0
        workInSegment = 0
        totalWorkSeconds = max(1, workMinutes) * 60
        remainingWorkSeconds = totalWorkSeconds
        microbreakSecondsLeft = 0
        segmentSecondsLeft = 0
        phase = .idle
    }

    func skipMicrobreak() {
        guard phase == .microbreak else { return }
        endMicrobreak()
    }

    private func beginTicking() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            Task { @MainActor in
                self?.tick()
            }
        }
        if let timer {
            RunLoop.main.add(timer, forMode: .common)
        }
    }

    private func tick() {
        switch phase {
        case .work:
            elapsedWorkSeconds += 1
            remainingWorkSeconds = max(0, totalWorkSeconds - elapsedWorkSeconds)
            workInSegment += 1
            segmentSecondsLeft = max(0, nextBreakAfter - workInSegment)
            if elapsedWorkSeconds >= totalWorkSeconds {
                finishSession()
            } else if workInSegment >= nextBreakAfter {
                beginMicrobreak()
            }
        case .microbreak:
            microbreakSecondsLeft -= 1
            if microbreakSecondsLeft <= 0 {
                endMicrobreak()
            }
        default:
            break
        }
    }

    private func beginMicrobreak() {
        phase = .microbreak
        microbreakSecondsLeft = max(5, microbreakDuration)
        SoundPlayer.shared.playBreakChime()
    }

    private func endMicrobreak() {
        scheduleNextBreak()
        phase = .work
        SoundPlayer.shared.playWorkChime()
    }

    private func finishSession() {
        timer?.invalidate()
        timer = nil
        remainingWorkSeconds = 0
        phase = .finished
        SoundPlayer.shared.playSessionEnd()
    }

    private func scheduleNextBreak() {
        let lo = min(minGapSeconds, maxGapSeconds)
        let hi = max(minGapSeconds, maxGapSeconds)
        nextBreakAfter = Int.random(in: lo...hi)
        workInSegment = 0
        segmentSecondsLeft = nextBreakAfter
    }
}
