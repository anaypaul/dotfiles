#!/usr/bin/env bash
#
# bootstrap-mcp.sh — re-register my Claude Code MCP servers on a fresh machine.
#
# Safe for this PUBLIC dotfiles repo: it ONLY runs `claude mcp add` — no API keys,
# tokens, or OAuth material are stored here. Repo paths are overridable via env
# vars, and the script is idempotent (remove-then-add), so re-running is a no-op.
#
# Usage:
#   ~/.claude/bootstrap-mcp.sh
#   GDC_REPO=/path/to/google-doc-claude EB1A_REPO=/path/to/eb1a-mission ~/.claude/bootstrap-mcp.sh
#
set -euo pipefail

GDC_REPO="${GDC_REPO:-$HOME/workspace/google-doc-claude}"
EB1A_REPO="${EB1A_REPO:-$HOME/workspace/eb1a-mission}"

command -v claude >/dev/null 2>&1 || { echo "error: 'claude' CLI not found on PATH" >&2; exit 1; }

# --- gdoc: anchored Google Docs comments (secrets-free) -------------------------
# Reads/writes Google Docs and posts TRUE inline/anchored comments via Playwright.
# Registered LOCAL to the eb1a-mission project, mirroring the current setup.
# (Auth is a one-time browser login into google-doc-claude/.browser-profile — not
#  stored here; run the `gdoc_login` tool once on a new machine.)
gdoc_py="$GDC_REPO/.venv/bin/python"
gdoc_server="$GDC_REPO/gdocclaude/mcp_server.py"
if [[ -x "$gdoc_py" && -f "$gdoc_server" && -d "$EB1A_REPO" ]]; then
  (
    cd "$EB1A_REPO"
    claude mcp remove gdoc --scope local >/dev/null 2>&1 || true   # idempotent
    claude mcp add gdoc --scope local -e GDOC_HEADLESS=0 -e GDOC_CHANNEL=chrome \
      -- "$gdoc_py" "$gdoc_server"
  )
  echo "✓ gdoc registered (local scope) in $EB1A_REPO"
else
  echo "• skip gdoc: need $gdoc_py + $gdoc_server + $EB1A_REPO" >&2
fi

# --- Auth-dependent servers (NOT scripted here — they need tokens / OAuth) -------
# mcpvault                 : npx -y @bitbonsai/mcpvault@latest .   (run in the target repo)
# google-workspace / asana : require their own OAuth consent — see
#                            eb1a-mission/INTEGRATIONS.md for the exact re-auth steps.
echo "note: mcpvault / google-workspace / asana need their own auth — see eb1a-mission/INTEGRATIONS.md"
