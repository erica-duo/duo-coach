---
description: Two-phase Duo client setup. Walks through wiring up n8n credentials (Anthropic, Slack, Notion), then captures wireframe, voice print, tools, and automation wishlist into a client brief.
---

# /onboard — New Client Setup Interview

Two-phase setup. First, walks the client through wiring up their n8n credentials (Anthropic, Slack, Notion). Then captures their wireframe, voice print, tools, and automation wishlist. Outputs a brief Duo reads before building.

## Trigger
- User runs `/onboard`
- OR: user is in a fresh repo with no `context/client-brief.md` and tries to use the system — gently suggest `/onboard` first.

## Mental model

Every person running this is a Duo client on a screen-share with Nick or Erica. They've already gone through the prerequisite setup (GitHub repo, Anthropic key created, Slack app created, Notion integration created, n8n deployed on Railway).

Two phases:
1. **Linking** — connect Anthropic + Slack + Notion credentials inside their n8n. Bulletproof, step-by-step.
2. **Questions** — 7 questions to capture context.

Total: ~25 minutes inside the call.

Tone: warm, collegial, partner-ish. They're already a Duo client. This is a continuation of a relationship.

## Before starting

If `context/client-brief.md` already exists, ask: "Looks like you've onboarded before. Want to update your wishlist, redo credentials, or start fresh?" Route accordingly.

## Open

> Welcome in.
>
> Two things we're doing in this prompt:
>
> 1. **Wire up your n8n** with the credentials we'll need (about 5 minutes)
> 2. **Capture your business context** so I know who you are going forward (about 15 minutes)
>
> Nick or Erica is on this call with you — when I ask you to paste something, they'll hand it over.
>
> First, I need your n8n URL so I can give you direct links.
>
> **Click here to open Railway:** https://railway.app/dashboard
>
> Click into your n8n project. At the top of the project page you'll see a public URL — something like `https://your-n8n.up.railway.app`.
>
> Copy that URL and paste it here.

Wait for the URL. Save it in conversation memory as `{N8N_URL}` and use it in every linking step. If they paste something that doesn't look like a URL (no `http`), ask again. Strip any trailing slash.

---

## Phase 1: Wire your n8n

We're adding 3 credentials to your n8n: Anthropic, Slack, and Notion. Same pattern for each — click the link I give you, paste the token, save.

### 1a. Anthropic

> **Click here to open your n8n credentials page:** {N8N_URL}/home/credentials
>
> Click the **+ Add credential** button (top right).
>
> In the search bar, type `Anthropic`. Click **Anthropic API** when it appears.
>
> Paste your Anthropic API key in the **API Key** field.
>
> At the top of the page, click the credential name (it'll say "Anthropic API account") and rename it to just `Anthropic`.
>
> Click **Save** (bottom right).
>
> Tell me when you see "Connection tested successfully" or a green dot.

Wait for confirmation. If stuck, probe specifically:
- "Are you on the credentials page? URL should end in `/home/credentials`"
- "Did the search return Anthropic API as the top result?"
- "After paste, is the Save button blue (active) or grayed out?"

### 1b. Slack

> **Click here:** {N8N_URL}/home/credentials
>
> Same flow:
>
> 1. Click **+ Add credential**
> 2. Search `Slack`. Click **Slack API**.
> 3. Paste your `xoxb-` bot token in the **Access Token** field.
> 4. Rename the credential to `Slack`.
> 5. Click **Save**.
>
> Tell me when it's green.

Wait. Probe if stuck.

### 1c. Notion

> **Click here:** {N8N_URL}/home/credentials
>
> Same flow:
>
> 1. Click **+ Add credential**
> 2. Search `Notion`. Click **Notion API**.
> 3. Paste your integration secret in the **API Key** field. (Starts with `secret_` or `ntn_`.)
> 4. Rename the credential to `Notion`.
> 5. Click **Save**.
>
> Tell me when it's green.

Wait.

### 1d. Confirm all three

> **Open your credentials list:** {N8N_URL}/home/credentials
>
> You should see three credentials: Anthropic, Slack, Notion — all with green dots.
>
> If anything's red or missing, tell me which one and we'll re-do it before moving on.

Wait. Only proceed to Phase 2 once all three are green.

---

## Phase 2: Capture your context

Ask ONE question per message. Probe when answers are vague. Don't batch.

### Who you are

**Q1.** Ask Duo for your Core Offer Wireframe — Nick or Erica will paste it here. (Every Duo client has one — it covers business, audience, problem framing, positioning anchors, and engagement models.)

*Wait for them to paste it. Save it verbatim to `context/wireframe.md`. Don't edit, don't summarize, don't reformat. If they don't have one yet, write "TBD — Duo will add" and move on.*

### Your voice

**Q2.** Ask Duo for your voice print — Nick or Erica will paste it here.

*Wait for them to paste it. Save it verbatim to `context/voice.md`. Same rules — no editing, no summarizing.*

### Your tools

**Q3.** What tools do you run your business on? List everything — CRM, project management, comms, docs, finance, content.

*Probe for specifics:* which Notion workspace, which Slack channels matter most, which email tool.

### What you want automated

**Q4.** Walk me through your week. What repeat tasks eat your time? Be specific — "every Monday I do X, every Wednesday I do Y."

*This is the main course. Let them talk. Follow up on anything that sounds automatable.*

**Q5.** If I could wave a wand and automate ONE thing tomorrow, what would save you the most time or stress? Specific example, not a category.

**Q6.** What else? Anything manual, repetitive, or annoying that you've thought "someone should automate this."

*Keep asking "what else?" until they're out of ideas. Don't stop at one.*

### Wrap

**Q7.** Is there anything we should know that we haven't asked? Context about your business, how you work, what's off-limits, anything?

## Writing the brief

After the interview, write `context/client-brief.md`:

```markdown
# Client Brief — {Business Name}

*Generated by /onboard on {date}. Duo reads this before building the client's custom setup.*

## Foundation
See `context/wireframe.md` (Core Offer Wireframe pasted by Duo during onboarding).

## Voice
See `context/voice.md` (pasted by Duo during onboarding).

## n8n credentials wired
- Anthropic ✓
- Slack ✓
- Notion ✓

## Tools in use
{Q3 — list with specifics (workspace names, channel names, tool versions)}

## Weekly manual work (opportunity map)
{Q4 — bullet list of repeat tasks, with a Duo-flagged note on each: "LIKELY AUTOMATABLE" / "NEEDS SCOPING" / "KEEP MANUAL"}

## Top priority automation
{Q5 — the #1 thing to build first}

## Automation wishlist
{Q6 — everything else they mentioned, numbered}

## Other context
{Q7 — anything else}

---

## Duo action items

- [ ] Review this brief
- [ ] Confirm tool access for top priority
- [ ] Scope and build top priority in client's n8n
- [ ] Export workflow JSON to `n8n-workflows/`
- [ ] Schedule build session with client
```

Also write:
- `context/wireframe.md` — the Core Offer Wireframe verbatim
- `context/voice.md` — the voice print verbatim

## Close

Show a summary:

> Here's what we did:
>
> - **n8n credentials:** Anthropic, Slack, Notion all wired
> - **Foundation:** Core Offer Wireframe captured
> - **Voice:** Voice print captured
> - **Top priority to automate:** {Q5}
> - **Wishlist items:** {count}
>
> Everything's saved to `context/client-brief.md`. Nick and Erica will review it and come back with what they're building first.
>
> If anything looks off, tell me now and I'll fix it.

Wait for edits. When they're set:

> You're set. From here, every time you open Claude Code in this folder, I'll load this context and know exactly who you are. And whatever Duo builds in your n8n will run automatically.

## What NOT to do

- Don't skip the linking phase. Even if they say "I'll do it later" — do it now or you'll be debugging credential issues later.
- Don't accept marketing-speak in the questions. Probe until you get the real thing.
- Don't ask more than 7 questions in Phase 2. Capture extras as memory or save for next call.
- Don't try to scope or design automations yourself. Capture what they want. Duo builds.
- Don't write files until both phases are complete.
- Don't use emojis in any of the written files.
