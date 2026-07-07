# Duo Coach

Duo's Claude Code marketplace. Contains the `duo-coach` plugin — onboarding + client help commands for new Duo clients.

## For Duo clients (recommended: desktop app, no terminal)

1. Install the **Claude Code desktop app** and sign in (Erica sends the link before your call)
2. Open the app, start a chat, and paste:

```
I'm a new Duo client. Fetch https://raw.githubusercontent.com/erica-duo/duo-coach/main/BOOTSTRAP.md and follow it exactly.
```

Claude handles the rest — it creates your brain, connects Duo, and hands you to `/onboard`. You never touch a terminal.

## Legacy: terminal setup (only if you prefer a terminal)

**Mac / Linux** — paste into Terminal:

```bash
bash <(curl -sSL https://raw.githubusercontent.com/erica-duo/duo-coach/main/setup.sh)
```

**Windows** — paste into PowerShell:

```powershell
irm https://raw.githubusercontent.com/erica-duo/duo-coach/main/setup.ps1 | iex
```

### Manual plugin install

If you already have Claude Code set up:

```bash
claude plugin marketplace add erica-duo/duo-coach
claude plugin install duo-coach@duo-coach
```

Then run `/onboard`.

## What's in here

- `BOOTSTRAP.md` — instructions Claude follows to set up a new client (fetched by the kickoff prompt)
- `plugins/duo-coach/` — the plugin: `/onboard` (full setup) + `/help` (client refresher), templates, docs
- `plugins/duo-coach/templates/docs/SETUP.md` — Duo-internal runbook for onboarding calls
- `.claude-plugin/marketplace.json` — marketplace catalog
