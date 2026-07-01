# Duo Coach

Duo's Claude Code marketplace. Contains the `duo-coach` plugin — an onboarding interview + setup guide for new Duo clients.

## For Duo clients

If Nick or Erica is on a call with you, follow `plugins/duo-coach/templates/docs/SETUP.md`.

### One-line setup

**Mac / Linux** — paste into Terminal:

```bash
bash <(curl -sSL https://raw.githubusercontent.com/erica-duo/duo-coach/main/setup.sh)
```

**Windows** — paste into PowerShell:

```powershell
irm https://raw.githubusercontent.com/erica-duo/duo-coach/main/setup.ps1 | iex
```

Either script installs the prerequisites (Git, Node, GitHub CLI, Claude Code),
creates your repo from the Duo template, and installs the plugin. Then run `/onboard`.

### Manual plugin install

If you already have Claude Code set up:

```bash
claude plugin marketplace add erica-duo/duo-coach
claude plugin install duo-coach@duo-coach
```

Then run `/onboard`.

## What's in here

- `plugins/duo-coach/` — the actual plugin (skills, docs, templates)
- `.claude-plugin/marketplace.json` — marketplace catalog
