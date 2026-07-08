# Client Setup — Desktop App + /onboard

*Duo-internal runbook. The client never opens a terminal.*

The full onboarding is three steps:

1. **Pre-call (client, async, ~10 min):** install the Claude Code desktop app + sign in
2. **Bootstrap (on the call, ~5 min):** client pastes one kickoff prompt; Claude creates the repo, invites Duo, installs the plugin — all by itself
3. **`/onboard` (on the call, ~25 min):** credentials + brain scaffold + orientation

Total: ~30 minutes of call time, all clicking, no typing commands.

---

## Pre-call message (send 1-2 days out)

Client needs, before the call:

- The **Claude Code desktop app** installed and signed in (they need a Claude Pro or Max plan — confirm which plan Duo recommends for them)
- A **Slack workspace** they admin
- Ideally: a Notion workspace they admin (or we fall back to Google Sheets)

The async message template lives in duo-brain at `context/client-onboarding-message.md`.

## Step 1 — Kickoff prompt (start of call)

Client opens the Claude Code app, starts a session anywhere, and pastes:

```
I'm a new Duo client. Fetch https://raw.githubusercontent.com/erica-duo/duo-coach/main/BOOTSTRAP.md and follow it exactly.
```

Claude then (client just answers questions + clicks browser auth links):

1. Ensures git + gh exist (standalone gh binary — never Homebrew)
2. GitHub account + `gh auth login --web`
3. Creates `{companyslug}-brain` (private — named after the company, e.g. `outpost-event-co-brain`), invites `erica-duo` with Write, clones to `~/Code/{companyslug}-brain`
4. Installs the duo-coach plugin (CLI, or the client types two `/plugin` slash commands)
5. Tells the client to open the brain folder in the app and run `/onboard`

## Step 2 — /onboard

| Phase | What | Time |
|---|---|---|
| 0 | Silent bootstrap verification (Claude-only) | ~0 |
| 1 | n8n Cloud — Starter plan + API key → Erica | ~5 min |
| 2 | Anthropic key + credits → Erica | ~3 min |
| 3 | Slack app **from a manifest** (pre-scoped) + tokens → Erica | ~3 min |
| 4 | Notion integration or Google Sheet | ~5 min |
| 5 | Meeting tool (Fathom/Granola/other) key → Erica | ~3 min |
| 6 | Confirm Erica has everything | ~1 min |
| 7 | Brain scaffold — Claude builds it while they watch; optional context seeding | ~3 min |
| 8 | Orientation (open/close, plan mode, /handoff, first build target) | ~5 min |

All keys go to Erica via Slack DM — never pasted into the chat.

Output: `context/client-brief.md` + `context/first-build.md` + `GETTING-STARTED.md`, pushed.

## What Duo handles after the call

1. Wire all credentials into the client's n8n
2. Push context docs (Context Map, voiceprint) to `context/`
3. Add the two GitHub secrets for push notifications (`SLACK_BOT_TOKEN` = the client's own bot token — never a Duo credential, `SLACK_CHANNEL_ID` = the shared #duo-{client} channel; invite the client's bot to that channel)
4. Build the first automation (see `context/first-build.md`)
5. Run duo-brain's `/new-client-setup` to add them to all Duo systems

---

## Troubleshooting

| Problem | Fix |
|---|---|
| Client's session isn't in a brain repo at /onboard | Phase 0 detects it and re-runs the bootstrap automatically |
| gh install fails | BOOTSTRAP uses the standalone binary release; on Windows it's winget. If both fail, escalate — don't fall back to Homebrew |
| Slack workspace missing from dropdown | Client isn't signed into Slack in the browser — sign in, refresh |
| Slack bot can't post | Bot must be added to the channel from inside the channel (`@app-name` → Add) |
| Notion integration can't read pages | Connect integration to each specific page or DB (Page → ... → Connections) |
| n8n API menu missing | Client is on the free trial — needs Starter plan |
| n8n credential test fails | 99% of the time it's whitespace in the pasted token |
| Client wants terminal/Cursor anyway | Fine — legacy `setup.sh` still works (see README) |
