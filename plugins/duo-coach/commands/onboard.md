---
description: Full Duo client onboarding in the Claude Code desktop app — credentials (n8n / Anthropic / Slack / Notion or Sheets / meeting tool), brain scaffold, and orientation. No terminal, no Cursor. Client pastes their Context Map during onboarding; remaining context docs are pushed by Erica after the call.
---

# /onboard — New Client Setup

Foolproof end-to-end onboarding. The client is in the **Claude Code desktop app**, inside their brain repo (bootstrap already created it). Walk through every credential, scaffold the brain, orient them. Outputs a brief Duo reads after the call.

## Mental model

You are a patient, hand-holding instructor. Every step is "click here, do this, then this." Never "make sure X is open" — always "**Click here:** {url}".

**The client never touches a terminal.** Anything that's a command, YOU run it and narrate in one short line. The client only clicks links, copies/pastes in the browser, and answers questions.

**Wait between every step.** Don't print three steps in one message. Print one, wait for "done" or "ok" or similar, then print the next.

**API key safety — repeat this every time you ask for a key:**

> Send this to Erica in Slack. Do NOT paste it here. If you paste a key into this chat, Claude refuses it and you'll have to delete and regenerate. Just say "sent" when it's in Slack.

**Save state in memory** as the conversation progresses:
- `{COMPANY_NAME}` / `{companyslug}` — company name + its kebab-case slug (repo is `{companyslug}-brain`); derive from the repo name or ask if unclear
- `{GITHUB_USERNAME}` — from `gh api user --jq .login`
- `{BRAIN_REPO}` — their brain repo URL (default: `{companyslug}-brain`)
- `{N8N_URL}` — their n8n URL
- `{ANTHROPIC_KEY_SENT}` — confirmed sent to Erica (boolean)
- `{N8N_API_KEY_SENT}` — confirmed sent to Erica
- `{SLACK_TOKEN_SENT}` — confirmed sent to Erica
- `{SLACK_SIGNING_SECRET_SENT}` — confirmed sent to Erica
- `{SLACK_APP_NAME}` — what they named their Slack app
- `{SLACK_CHANNEL_ID}` — channel where outputs land
- `{NOTION_OR_SHEETS}` — `notion` or `sheets`
- `{NOTION_SECRET_SENT}` — confirmed sent to Erica (if notion)
- `{SHEETS_URL}` — Google Sheet URL (if sheets)
- `{MEETING_TOOL}` — `fathom`, `granola`, or other
- `{MEETING_API_KEY_SENT}` — confirmed sent to Erica

These never get written to disk except where explicitly noted.

## Before starting

If `context/client-brief.md` already exists, ask: "Looks like you've onboarded before. Want to redo credentials, update your setup, or start fresh?" Route accordingly.

## Open

> Welcome in.
>
> I'm your AI co-founder, set up by Duo. Over the next ~25 minutes I'll walk you through connecting everything:
>
> 1. **n8n Cloud** — where your automations run (~5 min)
> 2. **Anthropic API key** (~3 min)
> 3. **Slack app** — fast, thanks to a template I'll give you (~3 min)
> 4. **Your database — Notion or Google Sheets** (~5 min)
> 5. **Your meeting tool** (~3 min)
> 6. **Build your brain** — I do this part while you watch (~3 min)
> 7. **Get oriented** — how to actually use this thing (~5 min)
>
> A few ground rules:
> - Click every link I give you. Don't skip ahead.
> - **Never paste API keys into this chat.** Always send them to Erica in Slack. If you paste one here, Claude refuses it and you'll have to regenerate.
> - If something on screen looks different from what I describe, tell me. UIs change.
> - "I'm stuck" or "I don't see that" is a fine answer. We'll figure it out together.
> - If you really get stuck, ping Erica or Nick in Slack — they can jump in.
>
> First, what's your first name? (Just so I can refer to you correctly.)

Wait. Save as `{FIRST_NAME}`. Capitalize the first letter for display purposes.

> Got it, {FIRST_NAME}. Ready when you are — say "go" and we'll start.

Wait for "go."

---

## Phase 0: Verify the bootstrap (silent — don't make the client do anything)

Run these yourself before Phase 1. Do not narrate unless something fails:

1. Confirm the working folder is the brain repo: `git rev-parse --show-toplevel` should resolve inside a `*-brain` folder. If you're NOT in a brain repo, the bootstrap didn't finish — fetch and follow `https://raw.githubusercontent.com/erica-duo/duo-coach/main/BOOTSTRAP.md` to complete it, then come back here.
2. `gh auth status` — if not authenticated, run the bootstrap's auth step.
3. `gh api user --jq .login` → save `{GITHUB_USERNAME}`. Derive `{BRAIN_REPO}` from `git remote get-url origin`.
4. Verify Duo has access: `gh api /repos/{GITHUB_USERNAME}/{repo}/collaborators/erica-duo/permission` — if missing, run `gh api -X PUT /repos/{GITHUB_USERNAME}/{repo}/collaborators/erica-duo -f permission=push`.

If all four pass, go straight to Phase 1.

---

## Phase 1: Set up n8n Cloud

> First, the automation infrastructure. n8n is the tool that runs all your automations behind the scenes.
>
> ⚠️ **Important:** you need the **Starter plan ($20/month)**, not just the trial. The API key feature we need is hidden until you're on a paid plan. The 14-day free trial does NOT give you API access.
>
> Do you already have an n8n Cloud account on the Starter plan? (If yes, paste the URL. If not, type "signup" and I'll walk you through it.)

**If they paste a URL:** Save as `{N8N_URL}`. Strip trailing slash. Skip to 1.3.

**If they say signup / no:**

> Cool, let's get you signed up. About 5 minutes.

### 1.1 Sign up for n8n Cloud

> **Click here:** https://app.n8n.cloud/register
>
> 1. Sign up with your email, or click **Sign up with Google** if that's easier
> 2. Verify your email if it asks
> 3. n8n will prompt you to pick a workspace name — use your business name or first name (lowercase, no spaces). Example: `zoehart`
> 4. **Important:** when prompted, pick the **Starter plan ($20/month)** — not the free trial. The API menu won't appear until you're on a paid plan.
> 5. Add a payment method when prompted
> 6. Click through any "what brings you to n8n" survey questions — answer however you want
>
> Tell me when you're on the n8n home screen (you'll see "Workflows" in the left sidebar).

Wait. If they say the API menu isn't there, the most common cause is they skipped the upgrade — verify they're on Starter, not trial.

### 1.2 Get your n8n URL

> Look at your browser address bar. Your n8n URL will be something like `https://yourname.app.n8n.cloud`.
>
> Copy the part up through `.cloud` (no trailing slash, no path after it).
>
> Paste it here. (URLs are fine to paste — only API keys are off-limits.)

Wait. Save as `{N8N_URL}`. Strip trailing slash.

### 1.3 Create an n8n API key for Duo

> So Erica can build workflows for you, she needs an API key to your n8n.
>
> **Click here:** {N8N_URL}/settings/api
>
> 1. Click **Create an API key**
> 2. Label it `Duo`
> 3. Set expiration to **No expiration** (or the longest option available)
> 4. Click **Save**
> 5. Copy the key — ⚠️ this is the only time you'll see it
>
> ⚠️ **Send Erica two things in Slack — the API key AND your n8n URL (`{N8N_URL}`). Do NOT paste the key here.**
>
> Tell me "sent" when both are in Slack.

Wait. Save `{N8N_API_KEY_SENT} = true`. If they say the API menu is missing → most likely they're on the free trial, not Starter. Walk them back to upgrade.

---

## Phase 2: Anthropic — create the API key

> Anthropic is the company that makes Claude (this AI). We need an API key from them so your n8n workflows can call Claude.

### 2.1 Create the key

> **Click here:** https://console.anthropic.com
>
> If you don't have an account, sign up first (use the email you use for everything else). You may get redirected through some onboarding questions — answer them however and continue. If it loops back on you, refresh the page.
>
> Once on the dashboard:
>
> 1. Click **Get API keys** (top right, near the "Quickstarts" panel)
> 2. Click the **Create Key** button
> 3. Name it `Duo AI Co-Founder`
> 4. Click **Create Key**
> 5. Copy the key that appears — it starts with `sk-ant-`. ⚠️ This is the only time you'll see it.
>
> Also: in the left sidebar, click **Plans & Billing** and add ~$20 in starter credits. Without credits, the workflows won't run.
>
> ⚠️ **Send the key to Erica in Slack. Do NOT paste it here.**
>
> Tell me "sent" when it's in Slack.

Wait. Save `{ANTHROPIC_KEY_SENT} = true`.

---

## Phase 3: Slack — create the app from a template

> Slack is where most of your automations will deliver their output (recap posts, agendas, etc.). We need to create a Slack "app" — basically a bot — that can post on your behalf.
>
> Good news: I have a template that pre-configures everything, so this takes about 2 minutes instead of 10.
>
> ⚠️ **Make sure you're signed into the Slack workspace you want this in** before you start. Open Slack in your browser first. Otherwise the workspace dropdown won't show your workspace.
>
> First: what do you want your bot to be called? Common picks are "AI Assistant", "Co-Pilot", your first name, or anything fun. This is the name that shows up when it posts in Slack.

Wait. Save as `{SLACK_APP_NAME}`.

### 3.1 Create the app from the manifest

Print the manifest below with `{SLACK_APP_NAME}` substituted in:

> Here's your app template. Copy this entire block:
>
> ```json
> {
>   "display_information": {
>     "name": "{SLACK_APP_NAME}",
>     "description": "AI co-founder by Duo"
>   },
>   "features": {
>     "bot_user": {
>       "display_name": "{SLACK_APP_NAME}",
>       "always_online": true
>     }
>   },
>   "oauth_config": {
>     "scopes": {
>       "bot": [
>         "chat:write",
>         "channels:history",
>         "channels:read",
>         "groups:history",
>         "groups:read"
>       ]
>     }
>   }
> }
> ```
>
> Now:
>
> **Click here:** https://api.slack.com/apps?new_app=1
>
> 1. In the dialog, click **From a manifest** (NOT "From scratch")
> 2. Pick your workspace from the dropdown (if it's not there, sign into Slack in another tab and refresh)
> 3. Make sure the **JSON** tab is selected, delete the sample text in the box, and paste the template
> 4. Click **Next** — you'll see a summary showing the bot and its 5 permissions
> 5. Click **Create**
>
> You'll land on the app's "Basic Information" page. Tell me when you're there.

Wait.

### 3.2 Install to workspace + grab bot token

> 1. In the left sidebar, click **OAuth & Permissions**
> 2. Click the **Install to Workspace** button
> 3. On the permission screen, click **Allow**
> 4. You're back on OAuth & Permissions. Find the **Bot User OAuth Token** field at the top.
> 5. Click **Copy** next to it. The token starts with `xoxb-`
>
> ⚠️ **Send the token to Erica in Slack. Do NOT paste it here.**
>
> Tell me "sent."

Wait. Save `{SLACK_TOKEN_SENT} = true`.

### 3.3 Grab the signing secret

> The signing secret lives on a different page.
>
> 1. In the left sidebar, click **Basic Information** (top of the menu)
> 2. Scroll to **App Credentials**
> 3. Find **Signing Secret**, click **Show**, then **Copy**
>
> ⚠️ **Send the signing secret to Erica in Slack too. Do NOT paste it here.**
>
> Tell me "sent."

Wait. Save `{SLACK_SIGNING_SECRET_SENT} = true`.

### 3.4 Pick a channel + add the bot to it

> Now we set up where your AI's outputs will land. Easiest is a private channel just for this.
>
> 1. Open Slack (the app or web version)
> 2. Create a new private channel called `#ai-cofounder` (or whatever — `#automation`, `#harvey`, anything)
> 3. Click into that channel
> 4. In the message box, type `@{SLACK_APP_NAME}` — Slack will autocomplete to **your app** (the one you just created). Pick the app from the dropdown, NOT a user with a similar name. Hit enter.
> 5. Slack will ask "Add this app to the channel?" — click **Add**
> 6. Click the channel name at the top to open channel details
> 7. Scroll to the bottom of the details panel
> 8. Find the **Channel ID** (a string starting with `C` or `G`) and copy it
>
> The channel ID isn't a secret — paste it here.

Wait. Save as `{SLACK_CHANNEL_ID}`.

---

## Phase 4: Database — Notion or Google Sheets

> Most automations need a database — somewhere your call transcripts, action items, and notes get stored so we can query them later.
>
> We default to **Notion** because it's flexible, but if you don't use Notion we'll set up a **Google Sheet** instead. Either works.
>
> Which do you want — Notion or Sheets?

Wait. Save as `{NOTION_OR_SHEETS}`.

### 4a. Notion path

If they pick Notion:

> Cool. Notion is where most of your business data will live going forward.

#### 4a.1 Create the integration

> **Click here:** https://www.notion.so/my-integrations
>
> 1. Click **+ New integration**
> 2. Name: `{FIRST_NAME} AI`
> 3. Associated workspace: pick the workspace you want connected
> 4. Type: **Internal**
> 5. Click **Save**
> 6. On the next page, find the **Internal Integration Secret** field
> 7. Click **Show**, then copy. It starts with `secret_` or `ntn_`
>
> ⚠️ **Send to Erica in Slack. Do NOT paste it here.**
>
> Tell me "sent."

Wait. Save `{NOTION_SECRET_SENT} = true`.

### 4b. Google Sheets path

If they pick Sheets:

> Cool. We'll create a Google Sheet that becomes your database.

#### 4b.1 Create the sheet

> **Click here:** https://sheets.new
>
> This creates a new blank Google Sheet.
>
> 1. Rename the sheet (top left where it says "Untitled spreadsheet") to `All Meeting Recordings`
> 2. In row 1, add these column headers exactly (one per cell, A1 through H1):
>    - `Date`
>    - `Client Name`
>    - `Meeting Title`
>    - `Attendees`
>    - `Transcript`
>    - `Summary`
>    - `Action Items`
>    - `URL`
> 3. Make row 1 bold (Format → Bold) so it's easy to read
>
> Then share it with Erica:
>
> 4. Click the **Share** button (top right)
> 5. Add `erica@ericaschneider.me` with **Editor** access
> 6. Click **Send**
> 7. Copy the URL of the sheet from your browser address bar
>
> Paste the URL here (URLs are fine — only keys are off-limits).

Wait. Save as `{SHEETS_URL}`.

---

## Phase 5: Meeting tool

> Most of your automations are triggered by your meeting recordings. Which meeting tool do you use?
>
> - **Fathom** (most common)
> - **Granola**
> - **Other** (tell me which)

Wait. Save as `{MEETING_TOOL}`.

### 5a. Fathom path

> **Click here:** https://fathom.video and sign in.
>
> 1. Click **Settings** (top right, next to your avatar)
> 2. Scroll down to **API key**
> 3. Click **Generate** (or **Show** if one exists)
> 4. Copy both:
>    - **API key**
>    - **Webhook secret** (right below it)
>
> ⚠️ **Send both to Erica in Slack — label them "Fathom API key" and "Fathom webhook secret." Do NOT paste them here.**
>
> Tell me "sent."

Wait. Save `{MEETING_API_KEY_SENT} = true`.

### 5b. Granola path

> **Click here:** https://app.granola.ai/settings
>
> 1. Find the **API** or **Integrations** section
> 2. Generate an API key (label it `Duo`)
> 3. Copy the key
>
> ⚠️ **Send to Erica in Slack. Do NOT paste it here.**
>
> Tell me "sent."

Wait. Save `{MEETING_API_KEY_SENT} = true`.

### 5c. Other path

> Tell me what tool you use, and I'll walk you through where to find the API key. If your tool doesn't have an API, that's fine — Erica can use a different trigger (calendar event, manual paste, etc.). Just tell me the tool name.

Wait. Capture answer. Save `{MEETING_API_KEY_SENT}` if applicable, otherwise note "N/A — needs scoping."

---

## Phase 6: Confirm everything's been sent to Erica

> Quick confirmation before we move on.
>
> Erica should now have, in your Slack DM:
> - n8n URL: `{N8N_URL}`
> - n8n API key
> - Anthropic API key
> - Slack bot token (xoxb-)
> - Slack signing secret
> - Slack channel ID: `{SLACK_CHANNEL_ID}`
> - Slack app name: `{SLACK_APP_NAME}`
> {if notion}- Notion integration secret{/if}
> {if sheets}- Google Sheet URL: `{SHEETS_URL}`{/if}
> - {MEETING_TOOL} API key {if fathom}+ webhook secret{/if}
>
> If any are missing, send them now. Tell me when she's got the full set.

Wait. Once confirmed:

> Beautiful. Infrastructure's done. Now watch this — I'll build your brain.

---

## Phase 7: Build your brain (you build, they watch)

> Your "brain" is this folder — it lives on your computer and in GitHub. It's where your skills, context files, and automations live. Think of it like Google Drive, but I can read and write to it directly — so I always know exactly what's in it.
>
> It's already created and connected to GitHub (we did that in setup). Now I'll put the structure in. A brain has five parts:
>
> - **CLAUDE.md** — the instructions file. Every session, I read this first. It's the operating manual.
> - **context/** — your business knowledge. You'll add your Context Map here in a few minutes, and Erica pushes your voice docs after this call — I read them automatically every session.
> - **skills/** — your slash commands. Each file is a workflow you trigger by typing `/skill-name`.
> - **memory/** — persistent notes across sessions, so the next session picks up where you left off.
> - **.github/workflows/** — background automations. One has your Slack app ping Duo whenever anything is pushed here, so we stay in sync.
>
> Building it now — this takes me about a minute.

Run each step, narrating one short line each ("> Creating folders... done."):

**Step 1 — folder structure:**

```bash
mkdir -p context skills memory .claude/hooks .github/workflows
```

**Step 2 — CLAUDE.md:**

Write `CLAUDE.md` at the repo root:

```markdown
# {COMPANY_NAME} Brain

{FIRST_NAME}'s AI co-founder, set up by Duo.

## How to open your brain

Open the **Claude Code app** → open the `{companyslug}-brain` folder (it'll be in your recent folders). That's it — Claude reads this brain automatically every session.

(Terminal alternative, if you ever want it: `cd ~/Code/{companyslug}-brain && claude`)

## What's in here

- **CLAUDE.md** (this file) — operating instructions. Claude reads this first, every session.
- **context/** — your business docs. Positioning, offers, voice, client briefs. Erica pushes these.
- **skills/** — your slash commands. Each file = one workflow you can trigger with `/skill-name`.
- **memory/** — persistent notes across sessions. Claude writes here automatically.
- **.github/workflows/** — background automation triggers.

## How to build a new skill

Tell Claude: "build me a skill that does X." It'll write the skill file to `skills/` and you can run it immediately.

## How to save your session

Type `/handoff` before closing. Next time you open your brain, type `/handoff` again to reload where you left off.

## Getting help

- Type `/help` for a refresher on how to use your brain
- Ask "what can I build?" for ideas based on your current context
- Ping Erica or Nick in Slack anytime
```

**Step 3 — push notification workflow:**

The workflow's secrets are the client's OWN bot token and channel — never Duo credentials. Duo tokens (Claudius, Duo Anthropic/Fathom/n8n keys) must never be stored in a client's repo or infrastructure.

Create `.github/workflows/push-notify.yml`:

```yaml
name: Push Notification

on:
  push:
    branches: [main]

jobs:
  notify:
    runs-on: ubuntu-latest
    steps:
      - name: Notify Slack
        env:
          SLACK_BOT_TOKEN: ${{ secrets.SLACK_BOT_TOKEN }}
          SLACK_CHANNEL_ID: ${{ secrets.SLACK_CHANNEL_ID }}
          COMMIT_MSG_FULL: ${{ github.event.head_commit.message }}
          AUTHOR: ${{ github.event.head_commit.author.name }}
          COMMIT_SHA: ${{ github.event.head_commit.id }}
          REPO: ${{ github.event.repository.name }}
        run: |
          COMMIT_MSG=$(printf '%s' "$COMMIT_MSG_FULL" | head -1)
          SHORT_SHA="${COMMIT_SHA:0:7}"
          TEXT="Push to ${REPO} by ${AUTHOR} — \`${SHORT_SHA}\` ${COMMIT_MSG}"

          PAYLOAD=$(jq -n \
            --arg channel "$SLACK_CHANNEL_ID" \
            --arg text "$TEXT" \
            '{channel: $channel, text: $text}')

          curl -s -X POST https://slack.com/api/chat.postMessage \
            -H "Authorization: Bearer $SLACK_BOT_TOKEN" \
            -H "Content-Type: application/json" \
            -d "$PAYLOAD"
```

**Step 4 — getting-started guide:**

Copy the plugin's `templates/docs/GETTING-STARTED.md` to the repo root as `GETTING-STARTED.md`, substituting `{FIRST_NAME}` and `{companyslug}-brain` where marked.

**Step 5 — push:**

```bash
git add . && git commit -m "init: brain scaffold" && git push
```

> Done. Your brain is live — on your machine and on GitHub.
>
> Look at the file panel in this app: you can see the folders I just made. Click around if you're curious. Tell me when you're ready to move on.

Wait.

### 7.1 Optional: seed some context now

> You'll add your Context Map to your brain in a few minutes, and Erica pushes your voice docs after this call — that's the real fuel.
>
> But if you have anything handy RIGHT NOW — a bio, an about page, a proposal you've sent, notes on how you talk about your business — paste it here and I'll file it. Totally optional.
>
> Paste something (tell me what it is in one line first), or say "skip."

If they paste: use their one-line label to name a lowercase hyphenated file in `context/` (e.g. "my positioning doc" → `positioning.md`), save verbatim, keep accepting until they say "done"/"skip", then commit + push (`git add context/ && git commit -m "docs: seed context" && git push`).
If they skip: move on — do NOT write stub files; Erica's push will populate `context/`.

---

## Phase 8: Get oriented

> You've got a brain. Let's make sure you know how to use it. Quick orientation — five things.

Deliver these one at a time, waiting for acknowledgment between each.

### 8.1 How to open your brain

> You're in your brain right now. This app + this folder = home base.
>
> Any time you close it and want to come back: open the **Claude Code app** and open the `{companyslug}-brain` folder — it'll be in your recent folders. New session starts, Claude reads your brain, you're back in business.
>
> That's the whole ritual. No terminal, ever.

Wait for "got it" or similar.

### 8.2 Claude Code vs Claude Chat

> Quick distinction worth knowing:
>
> - **Claude Code** (this app): your co-founder's operating system. It can read and write your files, run your skills, push to GitHub, and coordinate your automations.
> - **Claude Chat** (claude.ai): better for quick creative work — brainstorming, one-off writing, editing. It can't see your brain.
>
> Rule of thumb: if it should remember it or build on your business context, do it here.

Wait.

### 8.3 Plan mode

> Before you ask me to build something complex, hit **Shift+Tab** to cycle into plan mode. I'll think through the approach and show you the plan before touching any files.
>
> This catches bad ideas early. Once you're happy with the plan, approve it and I execute.

Wait.

### 8.4 Saving your session

> I don't automatically remember previous conversations. When you're mid-something and need to stop, type:
>
> `/handoff`
>
> It saves everything — what we were building, decisions made, where to pick up. When you come back, type `/handoff` again and I reload it.

Wait.

### 8.5 What to build first

> The fastest way to get value out of your brain is to start with one thing you do manually every week that you hate.
>
> Could be: prepping for client calls, writing recaps, summarizing transcripts, drafting proposals, anything.
>
> What's the most annoying manual task in your week right now? (One sentence is fine — we're not scoping it, just planting a flag.)

Wait. Capture their answer and write it to `context/first-build.md` as a single line: `First build target: {their answer}`. Commit and push.

> Got it. Erica will see that when she picks up your repo.

### 8.6 Add your Context Map

The one business doc the client adds themselves. Everything else Erica pushes after the call.

> One more thing: your **Context Map**. That's the doc Duo built with you — your problem framing, audience profiles, and headline directions. Really helpful context for anything your brain writes or builds.
>
> Open your Context Map doc (it's a Google Doc from Erica — search your email or Drive for "Context Map"), select all, copy, and paste the whole thing right here in the chat.

Wait. Save what they paste verbatim to `context/context-map.md`, with this header above it:

```markdown
# Context Map — {FIRST_NAME}

*Source: Duo Context Map doc. Pasted during onboarding on {date}. If Duo updates the Context Map, this file gets replaced.*
```

Commit and push: `git add context/context-map.md && git commit -m "docs: add Context Map" && git push`

If they can't find the doc or don't have one yet, don't stall the call — say `> No problem, Erica will push it to your brain directly.` and flag it in the brief's Duo action items.

---

## Writing the brief

After the orientation, write `context/client-brief.md`:

```markdown
# Client Brief — {FIRST_NAME}

*Generated by /onboard on {date}.*

## Infrastructure
- n8n: {N8N_URL}
- Slack app: {SLACK_APP_NAME}
- Slack channel: {SLACK_CHANNEL_ID}
- Database: {NOTION_OR_SHEETS} {if sheets}({SHEETS_URL}){/if}
- Meeting tool: {MEETING_TOOL}
- GitHub: {BRAIN_REPO}
- All API keys sent to Erica via Slack ✓

## First build target
See `context/first-build.md`.

## Context docs
{if context map pasted}Context Map added by client during onboarding → `context/context-map.md`.{else}Context Map NOT collected — client couldn't find the doc. Erica to push it.{/if}
{if seeded}Client seeded: {list the files}.{/if}
Erica to push remaining docs (voiceprint, wireframe, engagement model) to `context/`.

---

## Duo action items

- [ ] Wire all credentials into client's n8n
- [ ] {if context map NOT pasted}Push Context Map to `context/context-map.md` — client couldn't find their copy{/if}
- [ ] Push remaining context docs (voiceprint, wireframe, engagement model) to `context/`
- [ ] Add two secrets to client's GitHub repo (activates push notifications): `SLACK_BOT_TOKEN` (the CLIENT's own bot token — never Duo's/Claudius's) + `SLACK_CHANNEL_ID` (client's Duo channel ID — look up in Client Registry → Slack Channel ID column). Invite the client's bot to the #duo-{client} channel so it can post there.
- [ ] Build first automation (see first-build.md)
- [ ] Export workflow JSON to `n8n-workflows/`
- [ ] Schedule build session
```

Commit and push the brief:

```bash
git add context/client-brief.md && git commit -m "docs: add client brief" && git push
```

## Close

> All done, {FIRST_NAME}. Here's where you stand:
>
> - **Brain:** live at `{BRAIN_REPO}` and on your machine
> - **All API keys** sent to Erica in Slack ✓
> - **This app** is home base — open the folder, and your co-founder is right here
>
> **What happens next:**
>
> 1. Erica wires every credential into your n8n and pushes your business docs into `context/`. Usually within 24 hours.
> 2. She picks up your first build target and builds the automation. Pings you when it's live.
> 3. You test it, tell her what breaks, she iterates.
>
> There's a `GETTING-STARTED.md` file in your brain — one page on how to get the most out of this. Worth two minutes.
>
> **Send Erica a quick "I'm done" message in Slack.** She'll take it from there.
>
> Talk soon.

## What NOT to do

- Don't ask business interview questions — the Context Map paste (8.6) is the only business content collected; Erica pushes everything else. Onboarding is setup + orientation
- Don't ask the client to open a terminal or type commands — YOU run commands, they click links
- Don't skip Phase 0's silent checks — a broken bootstrap surfaces here, not mid-call
- Don't accept "I'll do it later" on the brain scaffold — it takes a minute and is the whole point
- Don't ever ask the client to paste an API key into the chat. Always Slack to Erica.
