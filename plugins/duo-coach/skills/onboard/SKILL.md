---
name: onboard
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
> 1. Wire up your n8n with the credentials we'll need (about 5 minutes)
> 2. Capture your business context so I know who you are going forward (about 15 minutes)
>
> Nick or Erica is on this call with you — when I ask you to paste something, they'll hand it over.
>
> Have your n8n open in a browser tab? Once you're ready, say go.

Wait for "go" or equivalent.

---

## Phase 1: Wire your n8n

We're going to add 3 credentials to your n8n: Anthropic, Slack, and Notion. Same pattern for each — open the credentials page, create new, paste the token, name it, save.

### 1a. Anthropic

> Open your n8n. Go to **Credentials → Create Credential** (or "+" if you've never made one).
>
> Search "Anthropic". Pick **Anthropic API**.
>
> Paste your Anthropic API key into the **API Key** field.
>
> Click **Save**. Name the credential `Anthropic` so it's findable.
>
> Tell me when it's saved.

Wait for confirmation. Probe if they're stuck: "Are you on the credentials page in n8n?" / "Did the save button turn green?"

### 1b. Slack

> Now Slack. Same flow:
>
> **Credentials → Create Credential** → search "Slack" → pick **Slack API**.
>
> Paste your `xoxb-` bot token in the **Access Token** field.
>
> Save. Name it `Slack`.
>
> Tell me when it's saved.

Wait for confirmation.

### 1c. Notion

> Last one — Notion.
>
> **Credentials → Create Credential** → search "Notion" → pick **Notion API**.
>
> Paste your integration secret in the **API Key** field. (Starts with `secret_` or `ntn_`.)
>
> Save. Name it `Notion`.
>
> Tell me when it's saved.

Wait for confirmation.

### 1d. Confirm

> All three credentials wired. You should see them under Credentials in your n8n with green checkmarks.
>
> If anything's red, tell me which one — we'll re-paste before moving on.

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
