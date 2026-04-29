# What Duo Builds for Clients

Examples of automations and skills Duo has built or could build for clients. Use this as inspiration during `/onboard` — it helps the client think bigger than "I want my email summarized."

These are NOT pre-installed. We build whatever they actually want, customized for their business.

---

## Call-related

- **Post-call recap** — Fathom or Granola transcript drops, Claude generates a recap, action items, or content drafts in their voice
- **Pre-call brief** — morning of a client call, Claude pulls last meeting's notes + recent Slack + relevant docs, posts a heads-up to Slack
- **Follow-up email draft** — after a sales/discovery call, generate the follow-up email with next steps
- **Contract from transcript** — sales call ends → Claude generates a draft contract using their template

## Content + writing

- **Transcript → social posts** — mine call recordings for content ideas in their voice
- **Newsletter generator** — weekly digest of their week's calls, Slack activity, or notes
- **Blog formatter** — AI draft → clean HTML with alt text, ready to paste into their CMS
- **LinkedIn post scoring** — paste a draft, Claude scores against their voice rules and rewrites if it falls short

## Operations

- **Slack scanner** — daily scan of their channels, surface action items, dedupe against existing tasks
- **Email triage** — morning brief of what needs a response, what's spam, what's worth flagging
- **Meeting prep** — give Claude a contact name, get a one-page brief from past calls + notes + recent activity
- **Task creation from messages** — pin a Slack message → task in Notion or Asana

## Client / customer work (for agencies and coaches)

- **Client health check** — weekly scan across calls, Slack, invoice status, output a "thriving / steady / needs attention" report
- **Onboarding intake** — new client signs up → Claude runs a discovery interview and outputs a brief
- **Contract / SOW generator** — based on their offer wireframe + a discovery call transcript

## Finance + admin

- **Invoice nudge** — overdue invoices → friendly Slack reminder
- **Recurring invoice automation** — every month, generate and send invoices to their retainer clients
- **Expense categorization** — Mercury or bank feed → categorized into Notion or sheets

## Research

- **Prospect dossier** — give Claude a name and company, get research compiled from their site, LinkedIn, recent news
- **Competitive monitoring** — weekly scan of competitor sites + content, surface what's new
- **Voice of customer** — mine support tickets or sales calls for prospect language and pain points

---

## How we pick what to build first

After `/onboard` we read their `client-brief.md` and weigh:

- **Volume** — how often does this manual work happen? Daily > weekly > monthly
- **Pain** — how much does it stress them out or eat their time?
- **Leverage** — does building it once free them up for something bigger?
- **Tool fit** — do they already have the tools wired up (Notion, Slack), or would we have to add infrastructure?

Top 1-2 picks get built first. We layer in the rest over the engagement.
