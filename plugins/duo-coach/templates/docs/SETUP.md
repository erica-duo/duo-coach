# Client Setup — One Command + /onboard

The full Duo client onboarding is two steps:

1. Run the bootstrap script (sets up GitHub repo, plugin, Claude Code) — ~5 min
2. Run `/onboard` (sets up n8n, all credentials, captures their wireframe + wishlist) — ~40 min

Total: ~45 min on a screen-share call.

---

## Pre-call prep (sent to client 1-2 days out)

Client needs:
- GitHub account
- Homebrew (https://brew.sh)
- Claude Code (https://docs.claude.com/claude-code) — run `claude` once to auth
- Anthropic account at console.anthropic.com with ~$20 in credits
- Notion workspace they're an admin of

That's it.

---

## Step 1 — One-command bootstrap

In their terminal:

```bash
bash <(curl -sSL https://raw.githubusercontent.com/erica-duo/duo-coach/main/setup.sh)
```

This script:

1. Verifies prereqs (git, brew)
2. Installs `gh` CLI if missing
3. Auths `gh` (browser flow)
4. Asks for their first name → creates `{firstname}-coach` repo from `erica-duo/duo-starter-template`
5. Adds Duo (`erica-duo`) as a Write collaborator
6. Clones the repo to `~/Code/{firstname}-coach`
7. Installs the duo-coach plugin

If Claude Code isn't installed, the script tells them where to install it and exits cleanly. Re-run is idempotent.

---

## Step 2 — Run /onboard

```bash
cd ~/Code/{firstname}-coach
claude
```

In Claude:
```
/onboard
```

The plugin's `/onboard` skill walks them through:

| Phase | What | Time |
|---|---|---|
| 1 | Deploy n8n on Railway | ~5 min |
| 2 | Create Anthropic key + wire into n8n | ~3 min |
| 3 | Create Slack app + token + wire into n8n | ~7 min |
| 4 | Create Notion integration + wire into n8n | ~5 min |
| 5 | 7 questions (wireframe, voice, tools, week, wishlist) | ~15 min |

Output: `context/wireframe.md`, `context/voice.md`, `context/client-brief.md`.

---

## What Duo handles after the call

1. `git pull` the client's brief
2. Pick top priority from their automation wishlist
3. Build it in their n8n (you have Owner access)
4. Export workflow JSON to their `n8n-workflows/` folder
5. Commit + push to their repo

---

## Troubleshooting

| Problem | Fix |
|---|---|
| `setup.sh` says "Homebrew not installed" | Install from brew.sh, re-run setup.sh |
| `setup.sh` says "Claude Code not installed" | Install from docs.claude.com/claude-code, run `claude` once, re-run setup.sh |
| Repo creation says "already exists" | Script handles this — keeps going. Safe to re-run |
| Slack bot can't post | Bot must be `/invite @{app-name}`'d from inside the channel |
| Notion integration can't read pages | Connect integration to each specific page or DB (Page → ... → Connections) |
| n8n credential test fails | 99% of the time it's whitespace in the pasted token |
| Railway sleeps the n8n | Upgrade to Railway "always on" tier (~$5/mo) |
