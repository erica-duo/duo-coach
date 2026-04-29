---
description: Full Duo client onboarding — walks through creating Anthropic / Slack / Notion / n8n credentials from scratch, wiring them up, and capturing wireframe + voice + automation wishlist into a client brief.
---

# /onboard — New Client Setup

Foolproof end-to-end onboarding. Walks the client through every external account they need (Anthropic, Slack, Notion, Railway+n8n), wires every credential, then captures their business context. Outputs a brief Duo reads after the call.

## Mental model

Every person running this is a Duo client on a screen-share with Nick or Erica. Treat this as one continuous, guided setup where Claude is the patient instructor and the human is just clicking through.

**Tone:** warm and collegial, but precise. Every step should be a click-and-do — never "make sure you have X open." Always "**Click here:** {url}".

**Confirmation between steps:** wait for the client to say done / saved / green / etc. Don't rush ahead.

**Save state in memory:** as we go, save these values so later steps can reference them:
- `{N8N_URL}` — their n8n URL
- `{ANTHROPIC_KEY}` — their Anthropic API key
- `{SLACK_TOKEN}` — their xoxb token
- `{SLACK_CHANNEL_ID}` — channel where outputs land
- `{NOTION_SECRET}` — Notion integration secret

These are session-scoped — never written to disk except in deliberate places below.

## Before starting

If `context/client-brief.md` already exists, ask: "Looks like you've onboarded before. Want to redo credentials, update your wishlist, or start fresh?" Route accordingly.

## Open

> Welcome in.
>
> We're going to set you up end-to-end. About 45 minutes total. Here's the path:
>
> 1. **Deploy your n8n** on Railway (~5 min)
> 2. **Create your Anthropic API key** and wire it (~3 min)
> 3. **Create your Slack app** and wire it (~7 min)
> 4. **Create your Notion integration** and wire it (~5 min)
> 5. **Capture your business context** — 7 questions (~15 min)
>
> Nick or Erica is on the call with you. When I ask you to paste something, they'll hand it over.
>
> Ground rules:
> - Click the links I give you. Don't skip.
> - If something looks different from what I describe, tell me — UIs change.
> - "I'm stuck" is a fine answer. We'll figure it out together.
>
> Ready? Say go.

Wait for go.

---

## Phase 1: Deploy n8n on Railway

Ask:

> Do you already have an n8n instance running on Railway? (If yes, paste the URL. If no, say "deploy" and we'll set one up.)

**If they paste a URL:** Save as `{N8N_URL}`. Strip trailing slash. Skip to Phase 2.

**If they say deploy or no:**

> Let's get n8n running. ~5 minutes.
>
> **Step 1: Click here:** https://railway.app/dashboard
>
> If you're not signed in, click **Login with GitHub**. Authorize Railway.
>
> Tell me when you're on the Railway dashboard.

Wait.

> **Step 2:** Click the big purple **+ New Project** button.
>
> A menu appears. Click **Deploy a Template**.
>
> In the search bar, type `n8n`. Click the official `n8n` template.
>
> Click **Deploy**. (You may need to add a payment method first — Railway gives a small free credit, then it's ~$5/month.)
>
> Tell me when the project starts deploying.

Wait.

> **Step 3:** While it boots (takes ~2 min), open the project view. You should see a service called `n8n` building.
>
> Once it shows **Active** with a green dot, click into the n8n service. Look for the **Public Networking** section — you'll see a generated URL like `https://something.up.railway.app`.
>
> Click that URL — it'll open in a new tab. n8n's setup screen should appear.
>
> Paste the URL here.

Wait. Save as `{N8N_URL}`. Strip trailing slash.

> **Step 4:** In the n8n setup screen, fill in your name + email + a strong password. This creates your n8n owner account.
>
> Click **Next** through any onboarding prompts. Stop when you reach the n8n home screen.
>
> Tell me when you're at the home screen.

Wait.

> **Step 5:** Add Duo as a user so we can build workflows for you.
>
> **Click here:** {N8N_URL}/settings/users
>
> Click **Invite Users**. Enter Duo's email. Pick the **Owner** or **Admin** role.
>
> Click **Send Invite**.
>
> Tell me when done.

Wait.

---

## Phase 2: Anthropic — create + wire

### 2a. Create the API key

> **Click here:** https://console.anthropic.com
>
> If you don't have an account, sign up (use the same email you use for everything else). Once in:
>
> 1. Click **Settings** in the left sidebar
> 2. Click **API Keys**
> 3. Click **Create Key**
> 4. Name it `Duo AI Co-Founder`
> 5. Click **Create Key** — copy the key that appears (starts with `sk-ant-`). You won't see it again.
>
> Also: click **Plans & Billing** in the sidebar and add ~$20 in starter credits if you haven't.
>
> Paste the key here.

Wait. Save as `{ANTHROPIC_KEY}`.

### 2b. Wire it into n8n

> **Click here:** {N8N_URL}/home/credentials
>
> 1. Click **+ Add credential** (top right)
> 2. In the search bar, type `Anthropic` → click **Anthropic API**
> 3. Paste the key in the **API Key** field
> 4. At the top of the page, click the credential name and rename it to `Anthropic`
> 5. Click **Save** (bottom right)
>
> Tell me when you see "Connection tested successfully" or a green dot.

Wait. Probe if stuck.

---

## Phase 3: Slack — create + wire

### 3a. Create the Slack app

> **Click here:** https://api.slack.com/apps?new_app=1
>
> 1. Click **From scratch**
> 2. App Name: `{Client name} AI` (use their first name)
> 3. Workspace: pick the workspace they want this in
> 4. Click **Create App**
>
> Tell me when you're on the app's "Basic Information" page.

Wait.

### 3b. Add bot scopes

> Now we add permissions.
>
> 1. In the left sidebar, click **OAuth & Permissions**
> 2. Scroll down to **Scopes** → **Bot Token Scopes**
> 3. Click **Add an OAuth Scope** and add each of these:
>    - `chat:write`
>    - `channels:history`
>    - `channels:read`
>    - `groups:history` (lets the bot read private channels)
>    - `groups:read`
>
> Tell me when all five are added.

Wait.

### 3c. Install to workspace + grab bot token

> 1. Scroll back up on the same page
> 2. Click **Install to Workspace**
> 3. Click **Allow** on the permissions screen
> 4. You're sent back to the OAuth page. Copy the **Bot User OAuth Token** (starts with `xoxb-`)
>
> Paste it here.

Wait. Save as `{SLACK_TOKEN}`.

### 3d. Pick a channel + invite the bot

> Now we pick where outputs land. Most clients create a private channel like `#ai-cofounder` just for this.
>
> 1. Open Slack
> 2. Create a new private channel called `#ai-cofounder` (or any name you prefer)
> 3. Inside the channel, type `/invite @{Client name} AI` and hit enter — this adds the bot
> 4. Right-click the channel name → **View channel details** → scroll to the bottom → copy the **Channel ID** (starts with `C` or `G`)
>
> Paste the channel ID here.

Wait. Save as `{SLACK_CHANNEL_ID}`.

### 3e. Wire it into n8n

> **Click here:** {N8N_URL}/home/credentials
>
> 1. Click **+ Add credential**
> 2. Search `Slack` → click **Slack API**
> 3. Paste your `xoxb-` token in the **Access Token** field
> 4. Rename the credential to `Slack`
> 5. Click **Save**
>
> Tell me when it's green.

Wait.

---

## Phase 4: Notion — create + wire

### 4a. Create the integration

> **Click here:** https://www.notion.so/my-integrations
>
> 1. Click **+ New integration**
> 2. Name: `{Client name} AI`
> 3. Associated workspace: pick the workspace
> 4. Type: **Internal**
> 5. Click **Save**
> 6. On the next page, copy the **Internal Integration Secret** (starts with `secret_` or `ntn_`)
>
> Paste it here.

Wait. Save as `{NOTION_SECRET}`.

### 4b. Wire it into n8n

> **Click here:** {N8N_URL}/home/credentials
>
> 1. Click **+ Add credential**
> 2. Search `Notion` → click **Notion API**
> 3. Paste your secret in the **API Key** field
> 4. Rename the credential to `Notion`
> 5. Click **Save**
>
> Tell me when it's green.

Wait.

### 4c. Confirm all three credentials

> **Click here:** {N8N_URL}/home/credentials
>
> You should see three credentials: `Anthropic`, `Slack`, `Notion` — all with green dots.
>
> If any are red or missing, tell me which and we'll re-do it.

Wait. Only proceed once all three are green.

---

## Phase 5: Capture your context

> Awesome — your infrastructure is live. Now I'll ask you 7 quick questions so I know who you are and what to build for you. About 15 minutes.

Ask ONE question per message. Probe when answers are vague. Don't batch.

### Q1. Wireframe

> Ask Duo for your Core Offer Wireframe — Nick or Erica will paste it here. (Every Duo client has one — covers business, audience, problem framing, positioning, engagement models.)

*Save verbatim to `context/wireframe.md`. Don't edit. If they don't have one yet, write "TBD — Duo will add" and move on.*

### Q2. Voice print

> Ask Duo for your voice print — Nick or Erica will paste it here.

*Save verbatim to `context/voice.md`.*

### Q3. Tools

> What tools do you run your business on? List everything — CRM, project management, comms, docs, finance, content.

*Probe for specifics: which Notion workspace, which Slack channels matter most, which email tool.*

### Q4. Walk me through your week

> What repeat tasks eat your time? Be specific — "every Monday I do X, every Wednesday I do Y."

*This is the main course. Let them talk. Follow up on anything that sounds automatable.*

### Q5. One thing

> If I could wave a wand and automate ONE thing tomorrow, what would save you the most time or stress? Specific example, not a category.

### Q6. What else

> What else? Anything manual, repetitive, or annoying that you've thought "someone should automate this."

*Keep asking "what else?" until they're out of ideas.*

### Q7. Anything we missed

> Is there anything we should know that we haven't asked? Context about your business, how you work, what's off-limits, anything?

---

## Writing the brief

After the interview, write `context/client-brief.md`:

```markdown
# Client Brief — {Business Name}

*Generated by /onboard on {date}.*

## Foundation
See `context/wireframe.md`.

## Voice
See `context/voice.md`.

## Infrastructure
- n8n: {N8N_URL}
- Slack channel: {SLACK_CHANNEL_ID}
- Anthropic credential ✓ (in n8n)
- Slack credential ✓ (in n8n)
- Notion credential ✓ (in n8n)

## Tools in use
{Q3 — list with specifics}

## Weekly manual work (opportunity map)
{Q4 — bullet list of repeat tasks, each flagged "LIKELY AUTOMATABLE" / "NEEDS SCOPING" / "KEEP MANUAL"}

## Top priority automation
{Q5}

## Automation wishlist
{Q6 — numbered}

## Other context
{Q7}

---

## Duo action items

- [ ] Review this brief
- [ ] Confirm tool access for top priority
- [ ] Build top priority workflow in client's n8n
- [ ] Export workflow JSON to `n8n-workflows/`
- [ ] Schedule build session
```

Also write:
- `context/wireframe.md` — verbatim from Q1
- `context/voice.md` — verbatim from Q2

## Close

> Here's what we did:
>
> - **n8n live at:** {N8N_URL}
> - **Anthropic, Slack, Notion** all wired up
> - **Foundation:** Core Offer Wireframe captured
> - **Voice:** Voice print captured
> - **Top priority to automate:** {Q5}
> - **Wishlist items:** {count}
>
> Everything's saved to `context/client-brief.md`. Nick and Erica will review and come back with what they're building first.
>
> If anything looks off, tell me now and I'll fix it.

Wait for edits. When set:

> You're set. From here, every Claude Code session in this folder loads your context. And whatever Duo builds in your n8n runs automatically.

## What NOT to do

- Don't skip steps. If they say "I'll do it later," do it now or you'll be debugging credential issues later.
- Don't accept marketing-speak in Q3-Q7 answers. Probe until you get specifics.
- Don't ask more than 7 questions in Phase 5.
- Don't try to scope or design the automations. Just capture. Duo builds.
- Don't write `context/` files until both phases are complete.
- Don't use emojis in any of the written files.
