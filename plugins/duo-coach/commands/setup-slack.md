---
description: Slack-only wiring — for clients who already have their brain repo (GitHub) and n8n set up and just need Slack connected. Creates the bot from a manifest, installs it, and collects the token/secret/channel ID for Erica.
---

# /setup-slack — Slack-Only Wiring

For clients partway through automations setup who already have their brain repo and n8n but haven't connected Slack. Standalone — doesn't touch GitHub, n8n, Anthropic, or Notion/Sheets. Lifted from Phase 3 of `/onboard`, unchanged.

## Mental model

You are a patient, hand-holding instructor. Every step is "click here, do this, then this." Never "make sure X is open" — always "**Click here:** {url}".

**Wait between every step.** Don't print two steps in one message. Print one, wait for "done" or "sent" or similar, then print the next.

**API key safety — repeat this every time you ask for a key:**

> Send this to Erica in Slack. Do NOT paste it here. If you paste a key into this chat, Claude refuses it and you'll have to delete and regenerate. Just say "sent" when it's in Slack.

**Save state in memory:**
- `{SLACK_APP_NAME}` — what they named their Slack app
- `{SLACK_TOKEN_SENT}` — confirmed sent to Erica
- `{SLACK_SIGNING_SECRET_SENT}` — confirmed sent to Erica
- `{SLACK_CHANNEL_ID}` — channel where outputs land (not a secret — paste directly)

## Open

> Welcome back — last piece to get you fully wired up: Slack. Takes about 3 minutes.
>
> Slack is where most of your automations will deliver their output (recap posts, agendas, etc.). We need to create a Slack "app" — basically a bot — that can post on your behalf. Good news: I have a template that pre-configures everything, so this is quick.
>
> ⚠️ **Make sure you're signed into the Slack workspace you want this in** before you start. Open Slack in your browser first — otherwise the workspace dropdown won't show your workspace.
>
> First: what do you want your bot to be called? Common picks are "AI Assistant," "Co-Pilot," your first name, or anything fun. This is the name that shows up when it posts in Slack.

Wait. Save as `{SLACK_APP_NAME}`.

## 1. Create the app from the manifest

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

## 2. Install to workspace + grab bot token

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

## 3. Grab the signing secret

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

## 4. Pick a channel + add the bot to it

> Now we set up where your AI's outputs will land. Easiest is a private channel just for this.
>
> 1. Open Slack (the app or web version)
> 2. Create a new private channel called `#ai-cofounder` (or whatever — `#automation`, anything)
> 3. Click into that channel
> 4. In the message box, type `@{SLACK_APP_NAME}` — Slack will autocomplete to **your app** (the one you just created). Pick the app from the dropdown, NOT a user with a similar name. Hit enter.
> 5. Slack will ask "Add this app to the channel?" — click **Add**
> 6. Click the channel name at the top to open channel details
> 7. Scroll to the bottom of the details panel
> 8. Find the **Channel ID** (a string starting with `C` or `G`) and copy it
>
> The channel ID isn't a secret — paste it here.

Wait. Save as `{SLACK_CHANNEL_ID}`.

## Done

> That's it — Slack's connected. To recap, Erica should now have in her Slack DM:
> - Your Slack bot token (`xoxb-...`)
> - Your Slack signing secret
> - Your channel ID: `{SLACK_CHANNEL_ID}`
> - Your app name: `{SLACK_APP_NAME}`
>
> **Send Erica a quick "Slack's done, channel is `{SLACK_CHANNEL_ID}`" message.** She'll wire it into your automations from there.

## For Erica (after the client finishes)

- [ ] Add client's `SLACK_BOT_TOKEN` + `SLACK_CHANNEL_ID` to their GitHub repo secrets (activates push notifications)
- [ ] Wire the Slack credential into their n8n instance (Slack API credential: token = their bot token)
- [ ] Invite the client's bot to the `#duo-{client}` Slack Connect channel: `/invite @{SLACK_APP_NAME}`
- [ ] Update Client Registry → `Automations Support` to Yes once fully wired
