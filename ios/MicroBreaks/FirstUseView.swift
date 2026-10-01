import SwiftUI

/// One-shot first-use sheet. Scientist pack verbatim. AppStorage key mb-firstuse-v1.
/// Never auto-starts; never shown on paywall or mid-session.
struct FirstUseView: View {
    var onStart: () -> Void
    var onSkip: () -> Void

    private let cards: [(String, String)] = [
        (
            "Focus",
            "Optional ~15s visual attention exercise before you start \u{2014} look at the point (or cat) and let your mind settle. Product habit, not a study finding."
        ),
        (
            "Breathing",
            "Optional breathing cue if you want to feel more alert. Informational only \u{2014} skip anytime."
        ),
        (
            "Sounds / cats",
            "Optional background sound and a focus visual. Atmosphere, not science."
        )
    ]

    var body: some View {
        ZStack {
            Color(red: 26 / 255, green: 35 / 255, blue: 50 / 255)
                .opacity(0.46)
                .ignoresSafeArea()
                .accessibilityHidden(true)

            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    Text("How Microbreaks works")
                        .font(.system(size: MBType.scaled(22, .title2), weight: .semibold))
                        .kerning(-0.44)
                        .foregroundStyle(MBTheme.ink)
                        .padding(.bottom, 16)
                        .accessibilityAddTraits(.isHeader)

                    whatWhyBlock(
                        kicker: "What",
                        body: "A focus timer that inserts brief (~10s) microbreaks at random while you work \u{2014} short pauses between practice bouts, not another Pomodoro clone."
                    )
                    .padding(.bottom, 14)

                    whatWhyBlock(
                        kicker: "Why",
                        body: "Inspired by peer-reviewed motor-skill rest/replay research on short waking rests (Buch et al., Cell Reports 2021). That\u{2019}s lab skill practice, not a guarantee for every study session. Not a medical device; results vary."
                    )
                    .padding(.bottom, 16)

                    VStack(spacing: 10) {
                        ForEach(cards, id: \.0) { title, copy in
                            VStack(alignment: .leading, spacing: 6) {
                                Text(title)
                                    .font(.system(size: MBType.scaled(15, .headline), weight: .semibold))
                                    .foregroundStyle(MBTheme.ink)
                                Text(copy)
                                    .font(MBType.label())
                                    .fontWeight(.regular)
                                    .foregroundStyle(MBTheme.muted)
                                    .lineSpacing(5)
                                    .fixedSize(horizontal: false, vertical: true)
                            }
                            .padding(.vertical, 16)
                            .padding(.horizontal, 18)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(MBTheme.card)
                            .clipShape(RoundedRectangle(cornerRadius: MBTheme.cardRadius, style: .continuous))
                            .overlay(
                                RoundedRectangle(cornerRadius: MBTheme.cardRadius, style: .continuous)
                                    .stroke(MBTheme.border, lineWidth: 1)
                            )
                        }
                    }
                    .padding(.bottom, 20)

                    Button(action: onStart) {
                        Text("Start timer")
                    }
                    .buttonStyle(MBPrimaryButtonStyle())
                    .accessibilityLabel("Start timer")

                    Button(action: onSkip) {
                        Text("Skip")
                            .font(MBType.body())
                            .fontWeight(.medium)
                            .foregroundStyle(MBTheme.muted)
                            .frame(maxWidth: .infinity)
                            .padding(.top, 10)
                            .padding(.vertical, 8)
                    }
                    .accessibilityLabel("Skip")

                    Text("Inspired by Buch et al., Cell Reports 2021. Not a medical device; results vary.")
                        .font(MBType.trust())
                        .foregroundStyle(MBTheme.faint)
                        .lineSpacing(5)
                        .padding(.top, 12)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                .padding(20)
                .frame(maxWidth: 420)
                .background(MBTheme.card)
                .clipShape(RoundedRectangle(cornerRadius: MBTheme.cardRadius, style: .continuous))
                .overlay(
                    RoundedRectangle(cornerRadius: MBTheme.cardRadius, style: .continuous)
                        .stroke(MBTheme.border, lineWidth: 1)
                )
                .shadow(color: MBTheme.ink.opacity(0.16), radius: 32, y: 8)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .accessibilityAddTraits(.isModal)
        .accessibilityElement(children: .contain)
    }

    private func whatWhyBlock(kicker: String, body: String) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(kicker.uppercased())
                .font(.system(size: MBType.scaled(11, .caption1), weight: .semibold))
                .tracking(0.44)
                .foregroundStyle(MBTheme.faint)
            Text(body)
                .font(.system(size: MBType.scaled(14, .body), weight: .regular))
                .foregroundStyle(MBTheme.muted)
                .lineSpacing(6)
                .fixedSize(horizontal: false, vertical: true)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}
