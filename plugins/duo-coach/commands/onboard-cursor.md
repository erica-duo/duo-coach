---
description: Duo client onboarding for Cursor setups — credentials (n8n / Anthropic / Slack / Notion or Sheets / meeting tool), brain scaffold, and orientation. Run this after the terminal setup script.
---

# /onboard-cursor — New Client Setup (Cursor flow)

Foolproof end-to-end onboarding. Gets the client set up in Cursor and GitHub, walks through every credential, builds their brain, and orients them on how to use it. Outputs a brief Duo reads after the call.

## Mental model

You are a patient, hand-holding instructor. Every step is "click here, do this, then this." Never "make sure X is open" — always "**Click here:** {url}".

**Wait between every step.** Don't print three steps in one message. Print one, wait for "done" or "ok" or similar, then print the next.

**API key safety — repeat this every time you ask for a key:**

> Send this to Erica in Slack. Do NOT paste it here in the terminal. If you paste a key into Claude Code, it'll refuse it and you'll have to delete and regenerate. Just say "sent" when it's in Slack.

**Save state in memory** as the conversation progresses:
- `{FIRST_NAME}` — captured from the user's first response
- `{GITHUB_USERNAME}` — their GitHub username
- `{COMPANY_NAME}` / `{companyslug}` — business name + kebab slug (repo naming)
- `{BRAIN_REPO}` — their brain repo name (default: `{companyslug}-brain`)
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
> I'm your AI co-founder, set up by Duo. Over the next 30-40 minutes I'll walk you through everything we need to get you running:
>
> 1. **Cursor + GitHub** — your visual workspace and where your brain lives (~5 min)
> 2. **Set up n8n Cloud** — where your automations run (~5 min)
> 3. **Create your Anthropic API key** (~3 min)
> 4. **Create your Slack app** (~10 min)
> 5. **Pick your database — Notion or Google Sheets** (~5 min)
> 6. **Wire up your meeting tool** (~5 min)
> 7. **Build your brain** — scaffold your personal AI workspace (~5 min)
> 8. **Get oriented** — how to actually use this thing (~5 min)
>
> A few ground rules:
> - Click every link I give you. Don't skip ahead.
> - **Never paste API keys here in the terminal.** Always send them to Erica in Slack. If you paste one in here, Claude refuses it and you'll have to regenerate.
> - If something on screen looks different from what I describe, tell me. UIs change.
> - "I'm stuck" or "I don't see that" is a fine answer. We'll figure it out together.
> - If you really get stuck, ping Erica or Nick in Slack — they can jump in.
>
> First, two quick things: what's your first name, and what's your business called?

Wait. Save `{FIRST_NAME}` (capitalize for display) and `{COMPANY_NAME}`. Derive `{companyslug}`: lowercase, spaces/punctuation to hyphens, drop suffixes like LLC/Inc (e.g. "Outpost Event Co" → `outpost-event-co`).

> Got it, {FIRST_NAME}. Ready when you are — say "go" and we'll start.

Wait for "go."

---

## Phase 0: Cursor + GitHub

> Before we touch any credentials, let's get your visual workspace set up. Two things: Cursor (a code editor that makes your brain easy to see and navigate) and GitHub (where your brain lives in the cloud — think of it like Google Drive for code files).
>
> Both are free. Let's do GitHub first.

### 0.1 GitHub account

> **Click here:** https://github.com/signup
>
> Do you already have a GitHub account? If yes, tell me your username and we'll move on. If not, sign up now — it takes about 2 minutes.

Wait. If they have one, save username as `{GITHUB_USERNAME}` and move on. If signing up, walk them through it, then save username.

> Got it. GitHub username: `{GITHUB_USERNAME}`.
>
> Think of GitHub as your Google Drive for your brain. Everything you build — your skills, your context, your automations — lives here. Erica has access and can push things directly to it, so you'll always be in sync.

### 0.2 Download Cursor

> Now Cursor. It's a code editor — basically a window into your brain that makes it easy to see all your files, edit them, and run Claude Code without staring at a plain terminal.
>
> **Click here:** https://cursor.com
>
> Click **Download** and install it. Free plan is all you need — no subscription required.
>
> Tell me when it's installed and open.

Wait.

### 0.3 Connect Cursor to GitHub

> In Cursor:
>
> 1. Open the **Source Control** panel (the branching icon in the left sidebar, or `Cmd+Shift+G`)
> 2. Click **Sign in to GitHub** if prompted, or go to **Cursor → Settings → Extensions → GitHub** and sign in
> 3. Authorize Cursor when the browser pops up
>
> Tell me when GitHub is connected.

Wait.

> Perfect. You're set up. Cursor is your window into your brain — you'll be opening it a lot.

---

## Phase 1: Set up n8n Cloud

> Now let's get the automation infrastructure sorted. n8n is the tool that runs all your automations behind the scenes.
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
> ⚠️ **Send the key to Erica in Slack. Do NOT paste it in the terminal.**
>
> Tell me "sent" when it's in Slack.

Wait. Save `{ANTHROPIC_KEY_SENT} = true`.

---

## Phase 3: Slack — create the app + tokens

> Slack is where most of your automations will deliver their output (recap posts, agendas, etc.). We need to create a Slack "app" — basically a bot — that can post on your behalf.
>
> ⚠️ **Make sure you're signed into the Slack workspace you want this in** before you start. Open Slack in your browser first. Otherwise the workspace dropdown won't show your workspace.

### 3.1 Create the Slack app

> **Click here:** https://api.slack.com/apps?new_app=1
>
> A dialog opens asking how you want to start.
>
> 1. Click **From scratch**
> 2. App Name: pick whatever you want — common picks are something like "AI Assistant", "Co-Pilot", your first name, or anything fun. This is the name your bot will show up as in Slack messages.
> 3. Workspace: pick the Slack workspace you want this in (your business one). If your workspace doesn't appear in the dropdown, you're not signed in — open Slack in another tab, sign in, then refresh this page.
> 4. Click **Create App**
>
> You'll land on a page called "Basic Information." Tell me what you named it.

Wait. Save the name as `{SLACK_APP_NAME}`.

### 3.2 Add bot scopes

> Now we tell Slack what your bot is allowed to do.
>
> 1. In the left sidebar, click **OAuth & Permissions**
> 2. Scroll down until you see **Scopes**
> 3. Under **Bot Token Scopes**, click **Add an OAuth Scope**
> 4. Add each of these one at a time (click Add OAuth Scope between each):
>    - `chat:write`
>    - `channels:history`
>    - `channels:read`
>    - `groups:history`
>    - `groups:read`
>
> Tell me when all five are added.

Wait.

### 3.3 Install to workspace + grab bot token

> 1. Scroll back to the top of the same page
> 2. Click the green **Install to Workspace** button
> 3. On the permission screen, click **Allow**
> 4. You're redirected back to OAuth & Permissions. Find the **Bot User OAuth Token** field at the top.
> 5. Click **Copy** next to it. The token starts with `xoxb-`
>
> ⚠️ **Send the token to Erica in Slack. Do NOT paste it here.**
>
> Tell me "sent."

Wait. Save `{SLACK_TOKEN_SENT} = true`.

### 3.4 Grab the signing secret

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

### 3.5 Pick a channel + add the bot to it

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

> Beautiful. Infrastructure's done. Now let's build your brain.

---

## Phase 7: Build your brain

> Your "brain" is a GitHub repository that lives on your computer and in GitHub. It's where your skills, context files, and automations live. Think of it like Google Drive, but Claude Code can read and write to it directly — so your AI always knows exactly what's in it.
>
> We're going to create it now. Takes about 5 minutes.

### 7.1 Create the GitHub repo

**First check:** if the setup script already created and cloned a repo (you're currently inside a `*-brain` or `*-coach` git folder — check `git remote get-url origin`), save it as `{BRAIN_REPO}`, tell the client "your repo already exists from setup — skipping ahead," and jump to 7.3.

> **Click here:** https://github.com/new
>
> 1. Repository name: `{companyslug}-brain` (example: `outpost-event-co-brain`) — or tell me a different name you prefer
> 2. Description: `My AI co-founder brain`
> 3. Set it to **Private**
> 4. Check **Add a README file**
> 5. Click **Create repository**
>
> Tell me when it's created and paste the repo URL (it'll look like `https://github.com/{GITHUB_USERNAME}/{companyslug}-brain`).

Wait. Save repo URL as `{BRAIN_REPO}`.

### 7.2 Clone it locally

> Before we pull it down, let's make sure git is authenticated with GitHub — otherwise the clone will fail.
>
> Run this:
>
> ```
> gh auth status
> ```
>
> If it says "Logged in to github.com" — great, skip ahead.
> If it says "not logged in" — run `gh auth login`, choose **GitHub.com → HTTPS → Login with a web browser**, and follow the prompts.
>
> Tell me once `gh auth status` shows you're logged in.

Wait. Once confirmed:

> Now let's pull your repo down.
>
> Run:
>
> ```
> gh repo clone {GITHUB_USERNAME}/{companyslug}-brain
> ```
>
> Tell me when it's done.

Wait.

### 7.3 Initialize your brain structure

> Before I build this out, let me show you what you're about to get.
>
> A brain has six parts:
>
> - **CLAUDE.md** — the instructions file. Every time you open your brain, Claude reads this first. It's the operating manual — who you are, how you work, what Claude should and shouldn't do.
> - **context/** — your business knowledge. Everything you paste in here Claude reads automatically every session.
> - **skills/** — your slash commands. Each file in here is a workflow you trigger by typing `/skill-name`. Things like "prep me for this call" or "write my weekly recap."
> - **memory/** — persistent notes across sessions. Claude writes here automatically so the next session picks up where you left off.
> - **.claude/hooks** — background triggers. Run automatically when certain events happen. You won't touch these much — they're the self-updating glue.
> - **.github/workflows/** — automation workflows. One of these pings Duo in Slack any time you push something, so we always know what you're building and can stay in sync.
>
> Everything lives in GitHub, which means Erica can see it, push to it, and stay in sync with you at all times.
>
> Ready? I'll build it now.

Run each step below, narrating out loud as you go:

**Step 1 — folder structure:**

Say: `> Creating your folders — context, skills, memory, and hooks...`

```bash
mkdir -p context skills memory .claude/hooks
```

Say: `> Done.`

**Step 2 — CLAUDE.md:**

Say: `> Writing your CLAUDE.md — this is the file that tells me who you are every time you open your brain...`

Write `CLAUDE.md` to the repo root `CLAUDE.md`:

```markdown
# {COMPANY_NAME} Brain

{FIRST_NAME}'s AI co-founder, set up by Duo.

## How to open your brain

Open **Cursor** → open this folder (File → Open Folder, or recents) → open the terminal (Terminal → New Terminal) → type `claude`. That's it — Claude reads this brain automatically.

## What's in here

- **CLAUDE.md** (this file) — operating instructions. Claude reads this first, every session.
- **context/** — your business docs. Positioning, offers, voice, client briefs. Erica pushes these.
- **skills/** — your slash commands. Each file = one workflow you can trigger with `/skill-name`.
- **memory/** — persistent notes across sessions. Claude writes here automatically.
- **.claude/hooks** — background automation triggers. Runs quietly when certain events happen.

## How to build a new skill

Tell Claude: "build me a skill that does X." It'll write the skill file to `skills/` and you can run it immediately.

## How to save your session

Type `/handoff` before closing. Next time you open your brain, type `/handoff` again to reload where you left off.

## Getting help

- Ask "what can I build?" for ideas based on your current context
- Ping Erica or Nick in Slack anytime
```

Say: `> Done.`

**Step 3 — push notification workflow:**

Say: `> Setting up the Slack notification — this pings Duo any time you push something...`

Create `.github/workflows/push-notify.yml` in the repo:

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

Say: `> Done.`

**Step 4 — push to GitHub:**

Say: `> Pushing everything to GitHub...`

```bash
git add . && git commit -m "init: brain scaffold" && git push
```

Say: `> Done. Your brain is live.`

> Now open Cursor, go to **File → Open Folder**, and navigate to your brain folder (inside the folder you made on your Desktop). You'll see all five parts sitting right there — CLAUDE.md, context, skills, memory, hooks.
>
> Take a look around. This is yours. Tell me when you can see the files.

Wait.

### 7.4 (removed — no doc collection)

Do NOT ask for wireframes, positioning docs, voice docs, or any business context. Erica pushes all context docs to `context/` after the call. Onboarding is credentials + GitHub + orientation only.

### 7.5 Give Duo access

> One last thing: Erica needs write access to your brain so she can push skill updates and new automations as she builds them.
>
> **Click here:** {BRAIN_REPO}/settings/access
>
> 1. Click **Add people**
> 2. Search for `erica@ericaschneider.me`
> 3. Set permission to **Write**
> 4. Click **Add {GITHUB_USERNAME} to this repository**
>
> Tell me when it's done.

Wait.

> Perfect. You're both connected to the same brain now.

---

## Phase 8: Get oriented

> You've got a brain. Let's make sure you know how to use it. Quick orientation — five things.

Deliver these one at a time, waiting for acknowledgment between each.

### 8.1 How to open your brain

> You're already in your brain right now. This terminal, in this Cursor window, is home base.
>
> Any time you close it and want to come back: open Cursor, open the `{companyslug}-brain` folder, open the terminal. That's it — Claude Code loads and reads your brain automatically.
>
> If you're ever in a different terminal: `open your brain folder in Cursor, then in its terminal run: claude`.

Wait for "got it" or similar.

### 8.2 Claude Code vs Claude Chat

> Quick distinction worth knowing:
>
> - **Claude Code** (what you're using now): handles automations, file coordination, pushing to GitHub, and running skills. This is your co-founder's operating system.
> - **Claude Chat** (claude.ai): better for creative work — writing, brainstorming, editing. Keep using it for that.
>
> They're not competing. Use Code for the infrastructure; use Chat for the creative work.

Wait.

### 8.3 Plan mode

> Before you ask Claude Code to build something complex, hit **Shift+Tab** to cycle into plan mode. It'll think through the approach and show you the plan before touching any files.
>
> This saves a lot of tokens and catches bad ideas early. Once you're happy with the plan, hit Enter and it executes.

Wait.

### 8.4 Saving your session

> Claude Code doesn't automatically remember previous conversations. When you're mid-session and need to stop, type:
>
> `/handoff`
>
> It'll save everything — what you were building, decisions made, where to pick up next time. When you come back, type `/handoff` again and it'll reload the context.

Wait.

### 8.5 What to build first

> The fastest way to get value out of your brain is to start with one thing you do manually every week that you hate.
>
> Could be: prepping for client calls, writing recaps, summarizing transcripts, drafting proposals, anything.
>
> What's the most annoying manual task in your week right now? (One sentence is fine — we're not scoping it, just planting a flag.)

Wait. Capture their answer and write it to `context/first-build.md` as a single line: `First build target: {their answer}`. Commit and push.

> Got it. Erica will see that when she picks up your repo.

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
None collected during onboarding (by design). Erica to push positioning, problem framing, and voice docs to `context/`.

---

## Duo action items

- [ ] Wire all credentials into client's n8n
- [ ] Push context docs (positioning, problem framing, voice) to `context/`
- [ ] Add two secrets to client's GitHub repo (activates push notifications): `SLACK_BOT_TOKEN` (Duo's bot token) + `SLACK_CHANNEL_ID` (client's Duo channel ID — look up in Client Registry → Slack Channel ID column)
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
> - **Brain:** live at `{BRAIN_REPO}` and cloned to your machine
> - **Context docs** loaded — Claude knows your business ✓
> - **All API keys** sent to Erica in Slack ✓
> - **Cursor** connected and your brain is open
>
> **What happens next:**
>
> 1. Erica wires every credential into your n8n. Usually within 24 hours.
> 2. She picks up your first build target and builds the automation. Pings you when it's live.
> 3. You test it, tell her what breaks, she iterates.
>
> From now on: `open your brain folder in Cursor, then in its terminal run: claude` is home base. Open it, build things, run your skills.
>
> **Send Erica a quick "I'm done" message in Slack.** She'll take it from there.
>
> Talk soon.

## What NOT to do

- Don't ask business interview questions — context is the four doc pastes, not a Q&A session
- Don't skip the Cursor step — it's how clients see and understand their brain
- Don't skip the GitHub repo step — Duo needs access from day one
- Don't accept "I'll do it later" on the brain scaffold — it takes 5 minutes and is the whole point
- Don't ever ask the client to paste an API key in the terminal. Always Slack to Erica.
