import SwiftUI
import UIKit

enum MBTheme {
    static let accent = Color(red: 13 / 255, green: 148 / 255, blue: 136 / 255) // #0d9488
    static let accentHover = Color(red: 15 / 255, green: 118 / 255, blue: 110 / 255) // #0f766e
    static let background = Color(red: 244 / 255, green: 246 / 255, blue: 245 / 255) // #f4f6f5
    static let ink = Color(red: 26 / 255, green: 35 / 255, blue: 50 / 255) // #1a2332
    static let muted = Color(red: 92 / 255, green: 107 / 255, blue: 122 / 255) // #5c6b7a
    static let faint = Color(red: 138 / 255, green: 151 / 255, blue: 165 / 255) // #8a97a5
    static let border = Color(red: 228 / 255, green: 233 / 255, blue: 236 / 255) // #e4e9ec
    static let card = Color.white
    static let soft = Color(red: 236 / 255, green: 253 / 255, blue: 248 / 255) // #ecfdf8

    static let cardRadius: CGFloat = 16
    static let buttonRadius: CGFloat = 10
    static let screenPad: CGFloat = 20
    static let cardPadY: CGFloat = 28
    static let cardPadX: CGFloat = 24
    static let titleToSub: CGFloat = 8
    static let subToPrimary: CGFloat = 20
    static let buttonToList: CGFloat = 22
    static let rowGap: CGFloat = 10
    static let buttonHeight: CGFloat = 48
    static let notNowGap: CGFloat = 16
    static let controlsGap: CGFloat = 24
}

/// Type scale at 390pt width; sizes grow with Dynamic Type (SF Pro = system).
enum MBType {
    static func title() -> Font { .system(size: scaled(28, .title), weight: .semibold) }
    static func time() -> Font { .system(size: scaled(72, .largeTitle), weight: .medium) }
    static func body() -> Font { .system(size: scaled(15, .body), weight: .regular) }
    static func label() -> Font { .system(size: scaled(13, .subheadline), weight: .medium) }
    static func trust() -> Font { .system(size: scaled(12, .caption1), weight: .regular) }
    static func buttonHeight() -> CGFloat { scaled(48, .body) }
    static func screenPad() -> CGFloat { scaled(20, .body) }

    static func scaled(_ base: CGFloat, _ style: UIFont.TextStyle) -> CGFloat {
        UIFontMetrics(forTextStyle: style).scaledValue(for: base)
    }
}

struct MBPrimaryButtonStyle: ButtonStyle {
    var enabled: Bool = true

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.system(size: MBType.scaled(15, .body), weight: .semibold))
            .foregroundStyle(.white)
            .frame(maxWidth: .infinity)
            .frame(height: MBType.buttonHeight())
            .background(enabled ? (configuration.isPressed ? MBTheme.accentHover : MBTheme.accent) : MBTheme.accent.opacity(0.5))
            .clipShape(RoundedRectangle(cornerRadius: MBTheme.buttonRadius, style: .continuous))
    }
}
