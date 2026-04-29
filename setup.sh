#!/usr/bin/env bash
# Duo AI Co-Founder — bootstrap installer
# Run with: bash <(curl -sSL https://raw.githubusercontent.com/erica-duo/duo-coach/main/setup.sh)

set -e

# Colors
BOLD='\033[1m'
DIM='\033[2m'
GREEN='\033[32m'
YELLOW='\033[33m'
RED='\033[31m'
RESET='\033[0m'

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
  │     This script gets your GitHub repo,   │
  │     Claude Code, and plugin wired up.    │
  │     Then we'll move to /onboard for the  │
  │     rest of the setup.                   │
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

if ! command -v brew &>/dev/null; then
  warn "Homebrew not installed. We'll need it to install gh CLI."
  echo "  Install from https://brew.sh — it'll prompt for your password."
  echo "  Once installed, re-run this script."
  exit 1
fi
ok "homebrew found"

# ── 2. gh CLI ───────────────────────────────────────────────────────
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

# ── 3. Pick repo name ───────────────────────────────────────────────
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

# ── 4. Create repo from template ────────────────────────────────────
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

# ── 5. Add Duo as collaborator ──────────────────────────────────────
step "Adding Duo as a collaborator (Write access, not Admin)"

gh api -X PUT "/repos/${GH_USER}/${REPO_NAME}/collaborators/erica-duo" \
  -f permission=push >/dev/null 2>&1 || true
ok "Invite sent to erica-duo"

# ── 6. Clone repo ───────────────────────────────────────────────────
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

# ── 7. Claude Code ──────────────────────────────────────────────────
step "Checking Claude Code"

if ! command -v claude &>/dev/null; then
  warn "Claude Code not installed."
  echo
  echo "  Install it from: ${BOLD}https://docs.claude.com/claude-code${RESET}"
  echo
  echo "  Once installed, run claude once to authenticate, then re-run this script."
  echo "  We'll pick up where we left off."
  exit 0
fi
ok "Claude Code found"

# ── 8. Install the duo-coach plugin ─────────────────────────────────
step "Installing the duo-coach plugin"

# These commands are safe to run repeatedly
claude plugin marketplace add erica-duo/duo-coach 2>/dev/null || true
claude plugin install duo-coach@duo-coach 2>/dev/null || true
ok "Plugin installed"

# ── 9. Done ─────────────────────────────────────────────────────────
cat <<EOF

${GREEN}${BOLD}━━━ All set ━━━${RESET}

Your repo: ${BOLD}${CODE_DIR}/${REPO_NAME}${RESET}
GitHub:    ${BOLD}https://github.com/${GH_USER}/${REPO_NAME}${RESET}

Next:

  1. Open this folder in your terminal:
     ${BOLD}cd ${CODE_DIR}/${REPO_NAME}${RESET}

  2. Start Claude Code:
     ${BOLD}claude${RESET}

  3. Run the onboarding flow:
     ${BOLD}/onboard${RESET}

Nick or Erica should be on a screen-share with you for the rest. They've got
your Core Offer Wireframe and voice print ready to paste in.

EOF
