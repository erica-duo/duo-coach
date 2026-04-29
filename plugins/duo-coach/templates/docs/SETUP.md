# Client Setup — 45-Minute Onboarding Call

The script Duo walks through with the client on the onboarding call. Goal: by the end, the client has a GitHub repo with Duo as a collaborator, their own n8n instance running on Railway, and Slack + Notion + Anthropic connected in n8n. After that, Duo builds whatever they need on top.

This call is about **infrastructure**, not building specific automations. Those come later, custom per client.

---

## Order of operations

1. GitHub repo from template + Duo as collaborator
2. Install Claude Code
3. Anthropic API key
4. Slack bot token
5. Notion integration
6. Railway account + deploy n8n
7. Wire credentials into n8n
8. Run `/onboard`

Total: ~45 min on the call.

---

## 1. GitHub repo

**With the client screen-sharing:**

1. Go to `https://github.com/erica-duo/duo-starter-template`
2. Click **Use this template** → **Create a new repository**
3. Name it something like `{their-name}-coach` (private)
4. **Settings → Collaborators → Add people** — invite Duo's GitHub handle with **Write** permission. NOT Admin.
5. Clone locally:
   ```bash
   git clone git@github.com:{client-handle}/{their-name}-coach.git
   cd {their-name}-coach
   ```

Duo accepts the invite right away.

---

## 2. Claude Code

Install: https://docs.claude.com/claude-code

In their repo:
```bash
claude plugin install erica-duo/duo-coach
```

---

## 3. Anthropic API key

1. https://console.anthropic.com → **API Keys** → Create
2. Add ~$20 in starter credits

Copy the key — they'll paste it into n8n in step 7.

---

## 4. Slack bot token

1. https://api.slack.com/apps → **Create New App** → **From scratch**
2. Name: `{Client name} AI`
3. **OAuth & Permissions** → Bot Token Scopes:
   - `chat:write`
   - `channels:history`
   - `channels:read`
4. Install to workspace, copy the Bot User OAuth Token (starts with `xoxb-`)
5. Create a private channel for outputs (e.g. `#ai-cofounder`). Invite the bot: `/invite @{app-name}`. Copy the channel ID.

---

## 5. Notion integration

1. https://www.notion.so/my-integrations → **New integration**
2. Name: `{Client} AI`. Pick their workspace.
3. Capabilities: read + update + insert content
4. Copy the **Internal Integration Secret**

We'll connect specific databases and pages later, depending on what they ask us to build.

---

## 6. Railway + n8n

This is where their automations will live. Each client gets their own n8n instance — they own it, they control it, we have access via login.

1. https://railway.app → sign up with GitHub
2. **New Project** → **Deploy from Template** → search "n8n"
3. Pick the official n8n template. Click Deploy.
4. Once it boots (~2 min), Railway gives them a URL like `https://your-n8n.up.railway.app`. Visit it.
5. Create the n8n owner account (email + strong password). This is THEIR account — we get a separate user added later.
6. **In n8n: Settings → Users → Invite** Duo's email. Role: Owner or Admin so we can build workflows.

Cost: ~$5-10/month on Railway. They put their own credit card.

---

## 7. Wire credentials into n8n

Inside their n8n, **Credentials → New**:

### Slack
- Type: Slack API
- Access Token: paste the `xoxb-` token from step 4
- Save

### Notion
- Type: Notion API
- API Key: paste the integration secret from step 5
- Save

### Anthropic
- Type: Anthropic API
- API Key: paste the key from step 3
- Save

Test each one (n8n has a "Test" button on the credential page) and confirm green checkmark.

---

## 8. Run /onboard

```bash
cd {their-repo}
claude
```

Then in Claude:
```
/onboard
```

7 questions, ~15 minutes:
- Their Core Offer Wireframe (you paste it in when asked)
- Their voice print (you paste it in when asked)
- Their tools
- Walk through their week
- The #1 thing they want automated
- What else
- Anything we should know

Output: a `client-brief.md` you read after the call to scope what to build first.

---

## After the call

The client has:
- A GitHub repo with Duo as collaborator
- Their own n8n on Railway with Slack, Notion, and Anthropic credentials wired up
- Claude Code installed with the duo-coach plugin
- A `client-brief.md` with their automation wishlist

Duo's next step:
1. Read their brief
2. Pick the top priority automation
3. Build it directly in their n8n (we have access)
4. Export the workflow JSON to their `n8n-workflows/` folder in GitHub for backup + version control
5. Iterate from there

For ideas of what we typically build, see `IDEAS.md`.

---

## Troubleshooting

- **Claude Code can't find the plugin** — confirm they ran `claude plugin install erica-duo/duo-coach` from inside their repo
- **Slack bot can't post** — bot must be invited to the channel, even private ones (`/invite @{app-name}`)
- **Notion integration can't read pages** — connect the integration to each specific page or database (Page → ... → Connections)
- **n8n credential test fails** — usually a copy/paste whitespace issue. Re-paste the token.
- **Railway sleeps the n8n** — for active workflows, upgrade to Railway's "always on" tier ($5/mo)
