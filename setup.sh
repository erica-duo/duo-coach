#!/usr/bin/env bash
# Duo AI Co-Founder — bootstrap installer
# Run with: bash <(curl -sSL https://raw.githubusercontent.com/erica-duo/duo-coach/main/setup.sh)

set -e

# Colors (use $'...' so escape sequences are real characters, not literal text)
BOLD=$'\033[1m'
DIM=$'\033[2m'
GREEN=$'\033[32m'
YELLOW=$'\033[33m'
RED=$'\033[31m'
RESET=$'\033[0m'

step() { echo -e "\n${BOLD}→ $1${RESET}"; }
ok() { echo -e "${GREEN}✓${RESET} $1"; }
warn() { echo -e "${YELLOW}!${RESET} $1"; }
err() { echo -e "${RED}✗${RESET} $1" >&2; }

# Pretty banner
clear
cat <<'EOF'

  ┌──────────────────────────────────────────┐
  │                                          │
  │     Duo AI Co-Founder Setup              │
  │                                          │
  │     This script installs everything you  │
  │     need (Homebrew, Node, GitHub CLI,    │
  │     Claude Code) and creates your repo.  │
  │     Then we move to /onboard-cursor for the     │
  │     rest of the setup.                   │
  │                                          │
  │     Total time: ~10 minutes.             │
  │     You'll be asked for your Mac         │
  │     password once or twice.              │
  │                                          │
  └──────────────────────────────────────────┘

EOF

echo "Press enter to begin (or Ctrl+C to exit)..."
read -r

# ── 1. Prereqs ──────────────────────────────────────────────────────
step "Checking prerequisites"

if ! command -v git &>/dev/null; then
  err "git not installed. Install from https://git-scm.com/downloads then re-run."
  exit 1
fi
ok "git found"

# ── 2. Homebrew ─────────────────────────────────────────────────────
step "Checking Homebrew"

if ! command -v brew &>/dev/null; then
  warn "Homebrew not installed. Installing now (you'll be prompted for your Mac password)..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

  # Add brew to PATH for this session AND persist for future sessions.
  # Apple Silicon brew lives at /opt/homebrew, Intel at /usr/local.
  if [[ -x /opt/homebrew/bin/brew ]]; then
    BREW_SHELLENV='eval "$(/opt/homebrew/bin/brew shellenv)"'
    eval "$(/opt/homebrew/bin/brew shellenv)"
  elif [[ -x /usr/local/bin/brew ]]; then
    BREW_SHELLENV='eval "$(/usr/local/bin/brew shellenv)"'
    eval "$(/usr/local/bin/brew shellenv)"
  fi

  # Persist to .zprofile so future terminal sessions find brew automatically
  if [[ -n "$BREW_SHELLENV" ]] && ! grep -qF "$BREW_SHELLENV" "$HOME/.zprofile" 2>/dev/null; then
    echo "$BREW_SHELLENV" >> "$HOME/.zprofile"
  fi

  ok "Homebrew installed"
else
  ok "homebrew found"
fi

# ── 3. Node ─────────────────────────────────────────────────────────
step "Checking Node.js (used by MCP servers during onboarding)"

if ! command -v node &>/dev/null; then
  warn "Node not installed. Installing via Homebrew..."
  brew install node
  ok "Node installed"
else
  ok "node found ($(node --version))"
fi

# ── 4. gh CLI ───────────────────────────────────────────────────────
step "Checking GitHub CLI"

if ! command -v gh &>/dev/null; then
  warn "gh CLI not installed. Installing..."
  brew install gh
  ok "gh installed"
else
  ok "gh found"
fi

if ! gh auth status &>/dev/null; then
  step "Authenticating with GitHub"
  echo "A browser window will open. Sign in and authorize."
  gh auth login --hostname github.com --git-protocol https --web
fi
ok "GitHub authenticated as $(gh api user --jq .login)"

GH_USER=$(gh api user --jq '.login')

# ── 5. Claude Code ──────────────────────────────────────────────────
step "Checking Claude Code"

if ! command -v claude &>/dev/null; then
  warn "Claude Code not installed. Installing via the native installer..."
  # Native installer — does NOT require Node/npm.
  curl -fsSL https://claude.ai/install.sh | bash

  # The native installer drops claude under ~/.local/bin; make sure it's on
  # PATH for the rest of this session and persist it for future sessions.
  if [[ -x "$HOME/.local/bin/claude" ]] && [[ ":$PATH:" != *":$HOME/.local/bin:"* ]]; then
    export PATH="$HOME/.local/bin:$PATH"
    LOCAL_BIN_LINE='export PATH="$HOME/.local/bin:$PATH"'
    if ! grep -qF "$LOCAL_BIN_LINE" "$HOME/.zprofile" 2>/dev/null; then
      echo "$LOCAL_BIN_LINE" >> "$HOME/.zprofile"
    fi
  fi

  if command -v claude &>/dev/null; then
    ok "Claude Code installed"
  else
    warn "Claude Code installed, but not yet on PATH. Open a NEW terminal window after this finishes."
  fi
  echo
  echo "  ${BOLD}You'll need to run \`claude\` once after this script finishes${RESET}"
  echo "  ${BOLD}to authenticate (browser flow). We'll remind you at the end.${RESET}"
else
  ok "claude found"
fi

# ── 6. Pick repo name ───────────────────────────────────────────────
step "Naming your repo"

echo
read -rp "What's your first name? (lowercase, no spaces): " FIRST_NAME
FIRST_NAME=$(echo "$FIRST_NAME" | tr '[:upper:]' '[:lower:]' | tr -d ' ')

if [[ -z "$FIRST_NAME" ]]; then
  err "First name can't be empty."
  exit 1
fi

REPO_NAME="${FIRST_NAME}-coach"
echo
echo "  Your repo will be: ${BOLD}${GH_USER}/${REPO_NAME}${RESET}"
read -rp "Sound good? (y/n) " CONFIRM
if [[ "$CONFIRM" != "y" ]]; then
  read -rp "Type the repo name you want: " REPO_NAME
fi

# ── 7. Create repo from template ────────────────────────────────────
step "Creating your repo from the Duo starter template"

if gh repo view "${GH_USER}/${REPO_NAME}" &>/dev/null; then
  warn "Repo ${GH_USER}/${REPO_NAME} already exists. Skipping creation."
else
  gh repo create "${GH_USER}/${REPO_NAME}" \
    --template erica-duo/duo-starter-template \
    --private \
    --description "AI co-founder by Duo"
  ok "Repo created"
  # Wait for GitHub to finish provisioning the template
  sleep 3
fi

# ── 8. Add Duo as collaborator ──────────────────────────────────────
step "Adding Duo as a collaborator (Write access, not Admin)"

gh api -X PUT "/repos/${GH_USER}/${REPO_NAME}/collaborators/erica-duo" \
  -f permission=push >/dev/null 2>&1 || true
ok "Invite sent to erica-duo"

# ── 9. Clone repo ───────────────────────────────────────────────────
step "Cloning the repo to your machine"

CODE_DIR="$HOME/Code"
mkdir -p "$CODE_DIR"
cd "$CODE_DIR"

if [[ -d "${REPO_NAME}" ]]; then
  warn "Folder ${CODE_DIR}/${REPO_NAME} already exists. Skipping clone."
else
  gh repo clone "${GH_USER}/${REPO_NAME}"
fi
cd "${REPO_NAME}"
ok "Cloned to ${CODE_DIR}/${REPO_NAME}"

# ── 10. Install the duo-coach plugin ────────────────────────────────
step "Installing the duo-coach plugin"

# These commands are safe to run repeatedly
claude plugin marketplace add erica-duo/duo-coach 2>/dev/null || true
claude plugin install duo-coach@duo-coach 2>/dev/null || true
ok "Plugin installed"

# ── 11. Done ────────────────────────────────────────────────────────
cat <<EOF

${GREEN}${BOLD}━━━ All set ━━━${RESET}

Your repo: ${BOLD}${CODE_DIR}/${REPO_NAME}${RESET}
GitHub:    ${BOLD}https://github.com/${GH_USER}/${REPO_NAME}${RESET}

Next:

  1. Open this folder in your terminal:
     ${BOLD}cd ${CODE_DIR}/${REPO_NAME}${RESET}

  2. Start Claude Code:
     ${BOLD}claude${RESET}

     (First time only: it'll open a browser to authenticate. Click through it.)

  3. Run the onboarding flow:
     ${BOLD}/onboard-cursor${RESET}

/onboard-cursor will walk you through the rest — n8n setup, all the credentials,
your meeting tool (Fathom/Granola/etc.), pasting in the docs Erica sent you,
and a few questions about your business.

${BOLD}Heads up:${RESET} when /onboard-cursor asks for an API key, send it to Erica in Slack.
${BOLD}Do NOT paste keys into the terminal${RESET} — Claude Code will refuse them and
you'll have to regenerate.

If you get stuck, ping Erica or Nick in Slack.

EOF
