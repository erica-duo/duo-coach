# Duo Coach

Duo's Claude Code marketplace. Contains the `duo-coach` plugin — an onboarding interview + setup guide for new Duo clients.

## For Duo clients

If Nick or Erica is on a call with you, follow `plugins/duo-coach/templates/docs/SETUP.md`.

To install the plugin into your Claude Code setup:

```bash
claude plugin marketplace add erica-duo/duo-coach
claude plugin install duo-coach@duo-coach
```

Then run `/onboard`.

## What's in here

- `plugins/duo-coach/` — the actual plugin (skills, docs, templates)
- `.claude-plugin/marketplace.json` — marketplace catalog
