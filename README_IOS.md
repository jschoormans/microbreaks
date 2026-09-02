# MicroBreaks iOS (week 1)

Native SwiftUI timer that matches the live web product at [microbreaks.co](https://microbreaks.co): a free focus timer with random ~10s microbreaks, optional sound and breathing, and a $12 founder unlock via StoreKit 2 (not Stripe).

## Open in Xcode

1. Clone `jschoormans/microbreaks` and check out `ios-week1` (or this PR branch).
2. Open **`ios/MicroBreaks.xcodeproj`** in Xcode 15 or later (iOS 17 SDK).
3. Select the **MicroBreaks** scheme and an iPhone simulator (for example iPhone 16).
4. Set your team under Signing & Capabilities if you run on a device. Simulator needs no paid team.
5. Press Run (Cmd-R).

The shared scheme already points at `ios/MicroBreaks/Products.storekit`. Confirm under **Product → Scheme → Edit Scheme → Run → Options → StoreKit Configuration**.

## StoreKit product

| Field | Value |
| --- | --- |
| Product ID | `com.microbreaks.founderunlock` |
| Type | Non-consumable, one-time |
| Price | USD 12.00 (localizes via StoreKit) |
| Config file | `ios/MicroBreaks/Products.storekit` |
| Bundle ID | `com.microbreaks.app` |

In the simulator, buy with a StoreKit test transaction (Xcode → Debug → StoreKit). Restore Purchases re-reads current entitlements. Unlock is also stored in `AppStorage` key `founderUnlocked` for week-1 persistence.

**Do not** add a Stripe Payment Link in the iOS client. Stripe stays on the web (`app.html`).

Create the same product ID in App Store Connect before TestFlight / App Store.

## Week-1 behavior

- **Timer (free):** 30-minute default session. Play / pause / reset. Circular progress, teal `#0d9488` on background `#f4f6f5`.
- **Microbreaks:** random gap between 90–180s (web defaults); overlay ~10s (“Relax”). Timer keeps working without paying.
- **Sound toggle:** system chimes at work, rest, and session end.
- **Breathing toggle:** optional inhale/exhale sheet (no Huberman copy on default screens).
- **Paywall sheet:** headline **Founder unlock — early iOS access**. Claim-safe bullets. No 10–20×, no 95%, no “proven study hacks”.

## Copy notes

Default screens avoid Huberman Lab. Trust line: inspired by Buch et al., Cell Reports 2021; not a medical device; results vary.

## Leftover vs Designer spec

Not in this slice: production App Icon PNG, DaisyUI/navbar pixel match, 15s cat focus exercise, boxing-bell / dingaling / seabirds assets, YouTube / how-it-works stats, Live Activities / background timer, dark mode, localization, App Store Connect listing + screenshots, paid-team device signing, receipt/email thanks flow.
