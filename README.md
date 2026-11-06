# microbreaks
Public repository for [microbreaks.co](https://www.microbreaks.co) — the science-based study timer.

## Deployment

The site is deployed to [CapRover](https://caprover.com/) automatically on every push to `main` (including merged PRs). You can also trigger a deploy manually from the Actions tab using "Run workflow".

### Required Secrets

Add these secrets in **Settings → Secrets and variables → Actions**:

| Secret | Description |
|--------|-------------|
| `CAPROVER_SERVER` | CapRover server URL, e.g. `https://captain.jasperschoormans.nl` |
| `CAPROVER_APP` | App name on CapRover, e.g. `microbreaks` |
| `CAPROVER_APP_TOKEN` | App-specific deploy token (not the captain password) |

### Getting the App Token

1. Open your CapRover dashboard
2. Navigate to **Apps → microbreaks → Deployment**
3. Click **Enable App Token** to generate a token
4. Copy the token and add it as the `CAPROVER_APP_TOKEN` secret
