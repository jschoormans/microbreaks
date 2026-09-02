# Microbreaks iOS (week 1)

Native SwiftUI timer. Open in Xcode, run on the iPhone simulator (390-pt width first: iPhone 14 / 15).

## Open and run

1. Open `ios/Microbreaks/Microbreaks.xcodeproj`.
2. Select the **Microbreaks** scheme and an iPhone simulator (iOS 17+).
3. Run (Cmd+R). The focus timer works without signing in or paying.

## StoreKit (founder unlock, $12 one-time)

Product id: `com.microbreaks.founderunlock` (non-consumable). There is **no Stripe** in the iOS app.

Local testing:

1. Product → Scheme → Edit Scheme → Run → Options.
2. StoreKit Configuration → `ios/Microbreaks/Microbreaks/Microbreaks.storekit`.
3. Purchase and restore use StoreKit 2. Unlock is persisted via App Store entitlements plus `AppStorage("founderUnlocked")`.

App Store Connect: create the same product id as a $12 USD non-consumable before TestFlight.

## What week 1 includes

- Timer: large tabular time, Start / Pause / Reset, Focus | Break. Paywall never during a running session (including pause and mid-break).
- Microbreak: full-screen rest (~10s). Copy is UX (close your eyes / think of nothing), not a study claim. Primary **Resume**; **Skip** as text. Optional chime if sound is on; soft haptic.
- Settings: Ambient sounds, Breathing cues, duration 25 / 50 / custom. Tertiary waitlist: https://tally.so/r/3NYZLG
- Unlock copy matches `app.html` on `founder-unlock-cta` (headline, $12 sub, five Scientist bullets, trust line, Not now). Primary CTA is StoreKit, not Stripe.

Claim-safe: no 10-20x, no 95%, no proven study hacks, no Huberman.

## Bundle

`com.microbreaks.app` — change if you already have an App Store record.
