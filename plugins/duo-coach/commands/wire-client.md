---
description: Duo-side post-onboarding credential wiring — collect a client's credentials from Slack and walk through wiring them into n8n and GitHub.
---

# /wire-client — Wire Up a New Client

Run this after a client completes `/onboard`. Collects their credentials one at a time (paste from Slack), then generates a pre-filled wiring checklist so everything gets done in one pass.

## Mental model

You're helping Erica, not the client. Move fast. Ask for each credential, save it, then produce a complete actionable checklist. Don't explain what things are — Erica knows.

## Step 1 — Identify the client

> Which client are we wiring up? (First name or slug — e.g. "Jon" or "jon-coach")

Wait. Save as `{CLIENT}`. Derive `{SLUG}` as lowercase hyphenated (e.g. "Jon" → `jon-coach` if not already provided). Check if `~/Code/clients/{SLUG}/` exists — if not, note it at the end.

## Step 2 — Collect credentials

Ask for each credential in order, one message at a time. For each one say what it is and where to find it in Slack, then wait.

> Paste Jon's **n8n URL** (from Slack — format: `https://name.app.n8n.cloud`)

Wait. Save as `{N8N_URL}`. Strip trailing slash.

> Paste Jon's **n8n API key**

Wait. Save as `{N8N_API_KEY}`.

> Paste Jon's **Anthropic API key** (starts with `sk-ant-`)

Wait. Save as `{ANTHROPIC_KEY}`.

> Paste Jon's **Slack bot token** (starts with `xoxb-`)

Wait. Save as `{SLACK_TOKEN}`.

> Paste Jon's **Slack signing secret**

Wait. Save as `{SLACK_SIGNING_SECRET}`.

> Paste Jon's **Slack channel ID** (starts with `C` or `G` — this is their `#ai-cofounder` channel in their workspace)

Wait. Save as `{CLIENT_SLACK_CHANNEL_ID}`.

> Paste Jon's **Slack app name**

Wait. Save as `{SLACK_APP_NAME}`.

> Notion or Sheets?

Wait. Save as `{DB_TYPE}`.

**If Notion:**
> Paste Jon's **Notion integration secret** (starts with `secret_` or `ntn_`)

Wait. Save as `{NOTION_SECRET}`.

**If Sheets:**
> Paste Jon's **Google Sheet URL**

Wait. Save as `{SHEETS_URL}`.

> What meeting tool — Fathom, Granola, or other?

Wait. Save as `{MEETING_TOOL}`.

> Paste Jon's **{MEETING_TOOL} API key**

Wait. Save as `{MEETING_API_KEY}`.

**If Fathom:**
> Paste Jon's **Fathom webhook secret**

Wait. Save as `{MEETING_WEBHOOK_SECRET}`.

> Paste Jon's **GitHub username**

Wait. Save as `{GITHUB_USERNAME}`.

> What's the brain repo name? (default: `{CLIENT_FIRST_NAME}-brain`)

Wait. Save as `{BRAIN_REPO}`.

> What's Jon's Duo Slack channel ID? (the `#duo-{client}` channel in our workspace — needed for GitHub push notifications)

Wait. Save as `{DUO_CHANNEL_ID}`.

---

## Step 3 — Save credentials locally

Write all credentials to `~/Code/clients/{SLUG}/context/.credentials` (this file is gitignored):

```
N8N_URL={N8N_URL}
N8N_API_KEY={N8N_API_KEY}
ANTHROPIC_KEY={ANTHROPIC_KEY}
SLACK_TOKEN={SLACK_TOKEN}
SLACK_SIGNING_SECRET={SLACK_SIGNING_SECRET}
CLIENT_SLACK_CHANNEL_ID={CLIENT_SLACK_CHANNEL_ID}
SLACK_APP_NAME={SLACK_APP_NAME}
DB_TYPE={DB_TYPE}
NOTION_SECRET={NOTION_SECRET}
SHEETS_URL={SHEETS_URL}
MEETING_TOOL={MEETING_TOOL}
MEETING_API_KEY={MEETING_API_KEY}
MEETING_WEBHOOK_SECRET={MEETING_WEBHOOK_SECRET}
GITHUB_USERNAME={GITHUB_USERNAME}
BRAIN_REPO={BRAIN_REPO}
DUO_CHANNEL_ID={DUO_CHANNEL_ID}
```

If the client directory doesn't exist, skip this step and note it at the end.

Make sure `.credentials` is in `.gitignore` for the client repo. If not, add it.

---

## Step 4 — Wiring checklist

Output this checklist with all values pre-filled. Erica works through it top to bottom.

```
━━━ WIRING CHECKLIST — {CLIENT} ━━━━━━━━━━━━━━━

── GitHub secrets (2 min) ──────────────────────

[ ] Go to: https://github.com/{GITHUB_USERNAME}/{BRAIN_REPO}/settings/secrets/actions
    Add secret: SLACK_BOT_TOKEN  →  [paste Duo's bot token]
    Add secret: SLACK_CHANNEL_ID →  {DUO_CHANNEL_ID}

── n8n credentials ─────────────────────────────

[ ] Go to: {N8N_URL}/home/credentials

    Add Anthropic API:
      Key: {ANTHROPIC_KEY}
      Name it: Anthropic

    Add Slack API:
      Token: {SLACK_TOKEN}
      Name it: Slack

    {if notion}Add Notion API:
      Key: {NOTION_SECRET}
      Name it: Notion{/if}

    {if fathom}Add Fathom (HTTP Request / custom):
      API key: {MEETING_API_KEY}
      Webhook secret: {MEETING_WEBHOOK_SECRET}
      Name it: Fathom{/if}

    {if granola}Add Granola API key:
      Key: {MEETING_API_KEY}
      Name it: Granola{/if}

── n8n workflows ────────────────────────────────

[ ] Import / activate standard workflows for {CLIENT}
    (Pre-call agenda, post-call recap, sales insights)
    Use n8n MCP or paste workflow JSON from n8n-workflows/

── Confirm ──────────────────────────────────────

[ ] All n8n credentials show green
[ ] Test push to {BRAIN_REPO} — notification fires in #duo-{CLIENT}
[ ] Ping {CLIENT} in Slack: "You're all wired up. First automation incoming."

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

After Erica confirms each section done, mark it `[x]`. When all are done:

> All wired. {CLIENT} is live.
