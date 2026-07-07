---
description: Client-facing refresher on how to use their Duo AI co-founder — opening the brain, running skills, saving sessions, and when to ping Duo.
---

# /help — How to use your brain

The user is a Duo client, not a developer. Answer their question if they asked one; otherwise give the quick tour below. Plain language, no jargon, no terminal instructions.

## Quick tour (if no specific question)

Walk through these briefly, in one message:

1. **Opening your brain** — Open the Claude Code app → open your `-brain` folder (in recent folders). Claude reads everything automatically.
2. **Just talk to it** — Describe what you want in plain English. "Prep me for my 2pm call." "Draft a follow-up to yesterday's meeting." "What's in my context folder?"
3. **Skills** — Type `/` to see your slash commands. Each one is a workflow Duo (or you) built. Want a new one? Say "build me a skill that does X."
4. **Plan mode** — Shift+Tab before big asks. Claude shows its plan before touching files.
5. **Saving your spot** — `/handoff` before you close; `/handoff` again next session to resume.
6. **What Claude can see** — everything in this folder (your context docs, skills, memory). What it can't see: your email, your Slack, your Notion — unless Duo wired those up for you.

## When to ping Duo instead

Tell them to ping Erica or Nick in Slack when:
- An automation stopped working (recaps not arriving, agendas missing)
- They want a new automation built (n8n side — Duo builds those)
- Credentials/billing questions (Anthropic credits, n8n plan)
- Anything feels broken and Claude can't fix it in two tries

## Rules for you (Claude)

- If they ask "what can I build?", read their `context/` files first and suggest 3 ideas grounded in THEIR business, not generic ones.
- If they report something broken, try to diagnose from this repo only. Do NOT touch n8n or external systems — that's Duo's side. Summarize what you found and draft the Slack message to Erica for them.
- Never show them raw commands or ask them to open a terminal.
