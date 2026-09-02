# MicroBreaks iOS (week 1)

Native SwiftUI timer matching the Designer spec (tokens from `app.html`). Free focus timer, random ~10s microbreaks, optional ambient sound and breathing, and a $12 founder unlock via **StoreKit 2** (not Stripe).

Does **not** change `index.html` or `timer.html`.

## Open in Xcode

1. Clone `jschoormans/microbreaks` and check out `ios-week1` (or this PR branch).
2. Open **`ios/MicroBreaks.xcodeproj`** in Xcode 15 or later (iOS 17 SDK).
3. Select the **MicroBreaks** scheme and an iPhone simulator (for example iPhone 16, 390-pt logical width).
4. Set your team under Signing & Capabilities if you run on a device. Simulator needs no paid team.
5. Press Run (Cmd-R).

The shared scheme already points at `ios/MicroBreaks/Products.storekit`. Confirm under **Product -> Scheme -> Edit Scheme -> Run -> Options -> StoreKit Configuration**.

## StoreKit product

| Field | Value |
| --- | --- |
| Product ID | `com.microbreaks.founderunlock` |
| Type | Non-consumable, one-time |
| Price | USD 12.00 (localizes via StoreKit) |
| Config file | `ios/MicroBreaks/Products.storekit` |
| Bundle ID | `com.microbreaks.app` |

In the simulator, buy with a StoreKit test transaction (Xcode -> Debug -> StoreKit). Restore Purchases re-reads current entitlements. Unlock is also stored in `AppStorage` key `founderUnlocked` for week-1 persistence.

**Do not** add a Stripe Payment Link in the iOS client. Stripe stays on the web (`app.html`).

Create the same product ID in App Store Connect before TestFlight / App Store.

## Screens (Designer)

1. **Timer** - large tabular time (72/1.0 medium, SF Pro), Start / Pause / Reset 24pt below, state **Focus | Break**. Settings live in the nav bar, not on the dial. No paywall while a session is running.
2. **Microbreak** - full-screen ~10s. Copy: close your eyes / think of nothing (UX, not Buch). **Resume** primary, **Skip this break** as text. System chime if Ambient sounds is on.
3. **Settings** - Ambient sounds, Breathing cues, focus length **25 / 50 / Custom**, Tally waitlist `https://tally.so/r/3NYZLG` as tertiary Notify me.
4. **Unlock** - **Founder unlock - early iOS access**; $12 one-time + supporters credit; StoreKit CTA **Unlock early access - $12** full-width teal (height 48, radius 10); five bullets from `app.html`, then trust line; **Not now** 16pt below. No Huberman. Never presented mid-break.

Tokens: bg `#f4f6f5`, card `#fff`, ink `#1a2332`, muted `#5c6b7a`, faint `#8a97a5`, border `#e4e9ec`, accent `#0d9488`, hover `#0f766e`, soft `#ecfdf8`. Card radius 16, buttons 10. Screen pad 20. Card pad 28x24. Safe area + Dynamic Type (`MBType`).

## Copy notes

Default timer and microbreak screens avoid Huberman Lab and Buch citations. Buch appears only on the unlock / trust block, matching `app.html`.

## Leftover vs later weeks

Not in this slice: production App Icon PNG, boxing-bell / dingaling / seabirds assets, 15s cat focus exercise, YouTube / how-it-works stats, Live Activities / background timer, dark mode, localization, App Store Connect listing + screenshots, paid-team device signing, receipt/email thanks flow.
