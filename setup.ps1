# Duo AI Co-Founder — bootstrap installer (Windows / PowerShell)
# Run with:
#   irm https://raw.githubusercontent.com/erica-duo/duo-coach/main/setup.ps1 | iex

$ErrorActionPreference = 'Stop'

# ── Helpers ─────────────────────────────────────────────────────────
function Step($m) { Write-Host "`n-> $m" -ForegroundColor White }
function Ok($m)   { Write-Host "[ok] " -ForegroundColor Green -NoNewline; Write-Host $m }
function Warn($m) { Write-Host "[!]  " -ForegroundColor Yellow -NoNewline; Write-Host $m }
function Err($m)  { Write-Host "[x]  " -ForegroundColor Red -NoNewline; Write-Host $m }

function Test-Cmd($name) { [bool](Get-Command $name -ErrorAction SilentlyContinue) }

# Reload PATH from the registry so tools installed by winget are usable
# in THIS same session without reopening the terminal.
function Update-Path {
  $machine = [System.Environment]::GetEnvironmentVariable('Path', 'Machine')
  $user    = [System.Environment]::GetEnvironmentVariable('Path', 'User')
  $env:Path = ($machine, $user | Where-Object { $_ }) -join ';'
}

function Install-WithWinget($id, $label) {
  Warn "$label not installed. Installing via winget..."
  winget install --id $id --exact --silent --accept-source-agreements --accept-package-agreements
  Update-Path
}

# ── Banner ──────────────────────────────────────────────────────────
Clear-Host
Write-Host @'

  +------------------------------------------+
  |                                          |
  |     Duo AI Co-Founder Setup              |
  |                                          |
  |     This script installs everything you  |
  |     need (Git, Node, GitHub CLI,         |
  |     Claude Code) and creates your repo.  |
  |     Then we move to /onboard-cursor for the     |
  |     rest of the setup.                   |
  |                                          |
  |     Total time: ~10 minutes.             |
  |     Windows may prompt you to approve    |
  |     an install once or twice.            |
  |                                          |
  +------------------------------------------+

'@
Read-Host "Press enter to begin (or Ctrl+C to exit)"

# ── 1. Prereqs: winget ──────────────────────────────────────────────
Step "Checking prerequisites"

if (-not (Test-Cmd winget)) {
  Err "winget (the Windows Package Manager) isn't available."
  Write-Host "  winget ships with Windows 11 and recent Windows 10." -ForegroundColor Gray
  Write-Host "  Install 'App Installer' from the Microsoft Store, then re-run this script." -ForegroundColor Gray
  Write-Host "  Store link: https://apps.microsoft.com/detail/9NBLGGH4NNS1" -ForegroundColor Gray
  exit 1
}
Ok "winget found"

# ── 2. Git ──────────────────────────────────────────────────────────
Step "Checking Git"

if (-not (Test-Cmd git)) {
  Install-WithWinget 'Git.Git' 'Git'
  Ok "Git installed"
} else {
  Ok "git found"
}

# ── 3. Node ─────────────────────────────────────────────────────────
Step "Checking Node.js (used by MCP servers during onboarding)"

if (-not (Test-Cmd node)) {
  Install-WithWinget 'OpenJS.NodeJS.LTS' 'Node.js'
  Ok "Node installed"
} else {
  Ok "node found ($(node --version))"
}

# ── 4. gh CLI ───────────────────────────────────────────────────────
Step "Checking GitHub CLI"

if (-not (Test-Cmd gh)) {
  Install-WithWinget 'GitHub.cli' 'GitHub CLI'
  Ok "gh installed"
} else {
  Ok "gh found"
}

gh auth status *> $null
if ($LASTEXITCODE -ne 0) {
  Step "Authenticating with GitHub"
  Write-Host "A browser window will open. Sign in and authorize."
  gh auth login --hostname github.com --git-protocol https --web
}
$GH_USER = (gh api user --jq '.login').Trim()
Ok "GitHub authenticated as $GH_USER"

# ── 5. Claude Code ──────────────────────────────────────────────────
Step "Checking Claude Code"

if (-not (Test-Cmd claude)) {
  Warn "Claude Code not installed. Installing via the native installer..."
  # Native Windows installer — does NOT require Node/npm.
  irm https://claude.ai/install.ps1 | iex
  Update-Path
  # The native installer drops claude under %USERPROFILE%\.local\bin;
  # make sure it's on PATH for the rest of this session.
  $claudeBin = Join-Path $HOME '.local\bin'
  if ((Test-Path $claudeBin) -and ($env:Path -notlike "*$claudeBin*")) {
    $env:Path = "$env:Path;$claudeBin"
  }
  if (Test-Cmd claude) {
    Ok "Claude Code installed"
  } else {
    Warn "Claude Code installed, but not yet on PATH. Open a NEW PowerShell window after this finishes."
  }
  Write-Host
  Write-Host "  You'll need to run ``claude`` once after this script finishes" -ForegroundColor White
  Write-Host "  to authenticate (browser flow). We'll remind you at the end." -ForegroundColor White
} else {
  Ok "claude found"
}

# ── 6. Pick repo name ───────────────────────────────────────────────
Step "Naming your repo"

Write-Host
$FIRST_NAME = (Read-Host "What's your first name? (lowercase, no spaces)").ToLower() -replace '\s',''

if ([string]::IsNullOrWhiteSpace($FIRST_NAME)) {
  Err "First name can't be empty."
  exit 1
}

$REPO_NAME = "$FIRST_NAME-coach"
Write-Host
Write-Host "  Your repo will be: " -NoNewline; Write-Host "$GH_USER/$REPO_NAME" -ForegroundColor White
$CONFIRM = Read-Host "Sound good? (y/n)"
if ($CONFIRM -ne 'y') {
  $REPO_NAME = Read-Host "Type the repo name you want"
}

# ── 7. Create repo from template ────────────────────────────────────
Step "Creating your repo from the Duo starter template"

gh repo view "$GH_USER/$REPO_NAME" *> $null
if ($LASTEXITCODE -eq 0) {
  Warn "Repo $GH_USER/$REPO_NAME already exists. Skipping creation."
} else {
  gh repo create "$GH_USER/$REPO_NAME" `
    --template erica-duo/duo-starter-template `
    --private `
    --description "AI co-founder by Duo"
  Ok "Repo created"
  # Wait for GitHub to finish provisioning the template
  Start-Sleep -Seconds 3
}

# ── 8. Add Duo as collaborator ──────────────────────────────────────
Step "Adding Duo as a collaborator (Write access, not Admin)"

try {
  gh api -X PUT "/repos/$GH_USER/$REPO_NAME/collaborators/erica-duo" -f permission=push *> $null
} catch {}
Ok "Invite sent to erica-duo"

# ── 9. Clone repo ───────────────────────────────────────────────────
Step "Cloning the repo to your machine"

$CODE_DIR = Join-Path $HOME 'Code'
New-Item -ItemType Directory -Force -Path $CODE_DIR | Out-Null
Set-Location $CODE_DIR

$REPO_PATH = Join-Path $CODE_DIR $REPO_NAME
if (Test-Path $REPO_PATH) {
  Warn "Folder $REPO_PATH already exists. Skipping clone."
} else {
  gh repo clone "$GH_USER/$REPO_NAME"
}
Set-Location $REPO_PATH
Ok "Cloned to $REPO_PATH"

# ── 10. Install the duo-coach plugin ────────────────────────────────
Step "Installing the duo-coach plugin"

# These commands are safe to run repeatedly
try { claude plugin marketplace add erica-duo/duo-coach *> $null } catch {}
try { claude plugin install duo-coach@duo-coach *> $null } catch {}
Ok "Plugin installed"

# ── 11. Done ────────────────────────────────────────────────────────
Write-Host
Write-Host "=== All set ===" -ForegroundColor Green
Write-Host
Write-Host "Your repo: " -NoNewline; Write-Host $REPO_PATH -ForegroundColor White
Write-Host "GitHub:    " -NoNewline; Write-Host "https://github.com/$GH_USER/$REPO_NAME" -ForegroundColor White
Write-Host @"

Next:

  1. Open this folder in your terminal:
     cd $REPO_PATH

  2. Start Claude Code:
     claude

     (First time only: it'll open a browser to authenticate. Click through it.)

  3. Run the onboarding flow:
     /onboard-cursor

/onboard-cursor will walk you through the rest — n8n setup, all the credentials,
your meeting tool (Fathom/Granola/etc.), pasting in the docs Erica sent you,
and a few questions about your business.

Heads up: when /onboard-cursor asks for an API key, send it to Erica in Slack.
Do NOT paste keys into the terminal — Claude Code will refuse them and
you'll have to regenerate.

If you get stuck, ping Erica or Nick in Slack.

"@
