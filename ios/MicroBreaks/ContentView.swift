import SwiftUI

struct ContentView: View {
    @EnvironmentObject private var timer: TimerEngine
    @Environment(\.sizeCategory) private var sizeCategory
    @AppStorage("breathingEnabled") private var breathingEnabled = false
    @AppStorage("focusExerciseEnabled") private var focusExerciseEnabled = false
    @AppStorage("founderUnlocked") private var founderUnlocked = false
    /// Scientist first-use gate — must match web key.
    @AppStorage("mb-firstuse-v1") private var firstUseSeen = false

    @State private var showSettings = false
    @State private var showPaywall = false
    @State private var showFirstUse = false
    @State private var showFocusExercise = false
    @State private var chromeVisible = true
    @State private var chromeHideTask: Task<Void, Never>?

    private var isIdle: Bool {
        timer.phase == .idle || timer.phase == .finished
    }

    private var isRunningSession: Bool {
        timer.phase == .work || timer.phase == .paused
    }

    private var showFounderChip: Bool {
        isIdle && !founderUnlocked && !showFirstUse && !showFocusExercise
    }

    var body: some View {
        NavigationStack {
            ZStack {
                OceanBackdrop()

                // Tap anywhere while running to reveal chrome.
                Color.clear
                    .contentShape(Rectangle())
                    .ignoresSafeArea()
                    .onTapGesture {
                        guard isRunningSession else { return }
                        revealChrome()
                    }

                VStack(spacing: 0) {
                    Spacer(minLength: 12)

                    statusAndClock
                        .padding(.horizontal, MBType.screenPad())

                    if chromeVisible || isIdle {
                        controls
                            .padding(.top, MBTheme.controlsGap)
                            .padding(.horizontal, MBType.screenPad())
                            .transition(.opacity.combined(with: .move(edge: .bottom)))
                    } else if timer.phase == .work {
                        subtlePause
                            .padding(.top, 20)
                            .transition(.opacity)
                    }

                    if showFounderChip {
                        founderChip
                            .padding(.top, 28)
                            .padding(.horizontal, MBType.screenPad())
                            .transition(.opacity)
                    }

                    Spacer(minLength: 12)
                }
                .padding(.bottom, 16)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .safeAreaPadding(.bottom)
                .animation(.easeInOut(duration: 0.35), value: chromeVisible)
                .animation(.easeInOut(duration: 0.25), value: showFounderChip)

                if timer.phase == .microbreak {
                    MicrobreakOverlay(
                        secondsLeft: timer.microbreakSecondsLeft,
                        showBreathingCue: breathingEnabled,
                        onResume: {
                            timer.resumeFromBreak()
                            scheduleChromeFade()
                        },
                        onSkip: {
                            timer.skipMicrobreak()
                            scheduleChromeFade()
                        }
                    )
                    .transition(.opacity)
                    .zIndex(2)
                }

                if showFocusExercise {
                    FocusExerciseView(
                        onFinished: {
                            showFocusExercise = false
                            beginWorkSession()
                        },
                        onSkip: {
                            showFocusExercise = false
                            beginWorkSession()
                        }
                    )
                    .transition(.opacity)
                    .zIndex(3)
                }

                if showFirstUse {
                    FirstUseView(
                        onStart: {
                            dismissFirstUse()
                            requestStart()
                        },
                        onSkip: {
                            dismissFirstUse()
                        }
                    )
                    .transition(.opacity)
                    .zIndex(4)
                }
            }
            .navigationTitle("MicroBreaks")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(.hidden, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    if chromeVisible || isIdle {
                        Button {
                            showSettings = true
                        } label: {
                            Image(systemName: "gearshape")
                                .font(.system(size: 17, weight: .semibold))
                                .foregroundStyle(MBTheme.ink)
                                .padding(8)
                                .background(Circle().fill(MBTheme.glassFill))
                                .overlay(Circle().stroke(MBTheme.glassStroke, lineWidth: 1))
                        }
                        .accessibilityLabel("Settings")
                        .opacity(chromeVisible || isIdle ? 1 : 0)
                    }
                }
            }
        }
        .tint(MBTheme.accent)
        .animation(.easeInOut(duration: 0.25), value: timer.phase)
        .sheet(isPresented: $showSettings) {
            SettingsView(showPaywall: $showPaywall)
        }
        .sheet(isPresented: $showPaywall) {
            PaywallView()
        }
        .onAppear {
            maybeShowFirstUse()
            chromeVisible = true
        }
        .onChange(of: timer.phase) { _, phase in
            if phase == .microbreak || phase == .work {
                showPaywall = false
            }
            if phase == .work {
                scheduleChromeFade()
            } else if phase == .idle || phase == .finished || phase == .paused {
                revealChrome(persistent: phase != .paused)
                if phase == .paused {
                    // Keep chrome visible while paused; fade again if they resume via Start.
                }
            }
            maybeShowFirstUse()
        }
        .onChange(of: showPaywall) { _, presented in
            if presented && timer.blocksPaywall {
                showPaywall = false
            }
            if presented {
                showFirstUse = false
            }
        }
        .onChange(of: showSettings) { _, open in
            if open { revealChrome(persistent: true) }
        }
    }

    // MARK: - Clock

    private var statusAndClock: some View {
        VStack(spacing: 0) {
            Text(timer.statusTitle)
                .font(MBType.label())
                .foregroundStyle(MBTheme.ink.opacity(0.75))
                .lineSpacing(5)
                .accessibilityAddTraits(.updatesFrequently)

            ZStack {
                // Soft circular progress ring around clock.
                Circle()
                    .stroke(MBTheme.border.opacity(0.55), lineWidth: 6)
                Circle()
                    .trim(from: 0, to: CGFloat(timer.progress))
                    .stroke(
                        MBTheme.accent.opacity(0.85),
                        style: StrokeStyle(lineWidth: 6, lineCap: .round)
                    )
                    .rotationEffect(.degrees(-90))
                    .animation(.linear(duration: 0.35), value: timer.progress)

                Text(timer.displayClock)
                    .font(MBType.time())
                    .monospacedDigit()
                    .foregroundStyle(MBTheme.ink)
                    .lineLimit(1)
                    .minimumScaleFactor(0.5)
                    .padding(.horizontal, 12)
                    .accessibilityLabel("Time remaining \(timer.displayClock)")
            }
            .frame(width: clockSize, height: clockSize)
            .padding(18)
            .mbGlass(cornerRadius: clockSize / 2 + 18)
            .padding(.top, 10)
        }
    }

    private var clockSize: CGFloat {
        MBType.scaled(220, .largeTitle)
    }

    // MARK: - Controls

    private var controls: some View {
        HStack(spacing: 8) {
            controlButton(isIdle || timer.phase == .paused ? "Start" : "Start", enabled: timer.phase != .work && timer.phase != .microbreak) {
                requestStart()
            }
            controlButton("Pause", enabled: timer.phase == .work) {
                timer.pause()
                revealChrome(persistent: true)
            }
            controlButton("Reset", enabled: true) {
                timer.reset()
                revealChrome(persistent: true)
            }
        }
        .padding(6)
        .mbGlass(cornerRadius: 999)
    }

    private var subtlePause: some View {
        Button {
            timer.pause()
            revealChrome(persistent: true)
        } label: {
            Text("Pause")
                .font(MBType.label())
                .foregroundStyle(MBTheme.ink.opacity(0.8))
                .padding(.horizontal, 18)
                .padding(.vertical, 10)
                .mbGlass(cornerRadius: 999)
        }
        .accessibilityLabel("Pause")
    }

    private func controlButton(_ title: String, enabled: Bool, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Text(title)
                .font(MBType.label())
                .foregroundStyle(MBTheme.ink.opacity(enabled ? 1 : 0.4))
                .frame(maxWidth: .infinity)
                .frame(height: MBType.buttonHeight())
                .contentShape(Rectangle())
        }
        .disabled(!enabled)
        .accessibilityLabel(title)
    }

    private var founderChip: some View {
        Button {
            guard !timer.blocksPaywall, !showFirstUse else { return }
            showPaywall = true
        } label: {
            HStack(spacing: 8) {
                Image(systemName: "sparkles")
                    .font(.system(size: 13, weight: .semibold))
                Text("Founder unlock \u{2014} $12")
                    .font(MBType.label())
            }
            .foregroundStyle(MBTheme.accentHover)
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .mbGlass(cornerRadius: 999)
        }
        .accessibilityLabel("Founder unlock, 12 dollars")
    }

    // MARK: - Session flow

    private func requestStart() {
        guard timer.phase != .work, timer.phase != .microbreak else { return }
        if focusExerciseEnabled && (timer.phase == .idle || timer.phase == .finished) {
            showFocusExercise = true
            return
        }
        beginWorkSession()
    }

    private func beginWorkSession() {
        timer.start()
        scheduleChromeFade()
    }

    private func dismissFirstUse() {
        firstUseSeen = true
        showFirstUse = false
    }

    private func maybeShowFirstUse() {
        // Never on paywall / mid-session / focus exercise.
        guard !firstUseSeen else {
            showFirstUse = false
            return
        }
        guard isIdle else {
            showFirstUse = false
            return
        }
        guard !showPaywall, !showFocusExercise else {
            showFirstUse = false
            return
        }
        showFirstUse = true
    }

    private func revealChrome(persistent: Bool = false) {
        chromeHideTask?.cancel()
        withAnimation(.easeInOut(duration: 0.3)) {
            chromeVisible = true
        }
        if !persistent, timer.phase == .work {
            scheduleChromeFade()
        }
    }

    private func scheduleChromeFade() {
        chromeHideTask?.cancel()
        guard timer.phase == .work else { return }
        chromeHideTask = Task { @MainActor in
            try? await Task.sleep(nanoseconds: UInt64(MBTheme.chromeFadeSeconds * 1_000_000_000))
            guard !Task.isCancelled, timer.phase == .work else { return }
            withAnimation(.easeInOut(duration: 0.45)) {
                chromeVisible = false
            }
        }
    }
}
