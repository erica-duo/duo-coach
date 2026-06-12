# duo-coach

Minimal Claude Code plugin for Duo clients. Gets their infrastructure stood up — GitHub repo, n8n on Railway, Slack + Notion connected — so Duo can build automations on top.

## What's in here

- `/onboard` — 7-question interview that captures their wireframe, voice print, tools, and automation wishlist
- `templates/docs/SETUP.md` — the 45-minute onboarding call script
- `templates/docs/IDEAS.md` — examples of what Duo builds for clients

That's it. No baked-in automations — those get built custom per client in their n8n.

## How it fits

Each Duo client gets:

1. Their own GitHub repo (cloned from `duo-starter-template`) — code, config, brand context
2. Their own n8n on Railway — where automations actually run
3. This plugin installed — captures their wishlist via `/onboard`
4. Duo as a GitHub collaborator + n8n user — we build directly in their setup

The client owns everything. If they fire Duo, they remove our access. n8n workflow JSON is version-controlled in their GitHub repo as backup.

## Install

```bash
# From inside the client's starter repo
claude plugin install erica-duo/duo-coach
```

Then run `/onboard`.

## Architecture

- **GitHub** — code + n8n workflow JSON backups + brand context (`context/`, `memory/`)
- **n8n on Railway** — runs all automations, hosts credentials (Slack, Notion, Anthropic)
- **Slack** — default destination for automation outputs
- **Notion** — most clients run their business here; n8n reads + writes
