# dotfiles

Personal configuration files (zsh, bash, tmux, AeroSpace, Claude Code, Codex, and more) synced across my servers and MacBooks.

## Secrets

This repo is **public**, so no API keys or tokens live in tracked files. `zsh/.zshrc`
sources `~/.zshrc.local` (gitignored) for machine-local secrets. On a new machine,
recreate it before opening a shell:

```sh
cat > ~/.zshrc.local <<'EOF'
export OPENROUTER_API_KEY="..."
export BRAVE_API_KEY="..."
EOF
chmod 600 ~/.zshrc.local
```

## Claude Code (`claude` package)

Stows into `~/.claude/`. The stateful, secret-bearing parts of Claude Code
(`~/.claude.json`, `projects/`, `settings.local.json`, `.credentials.json`) are
**never tracked** — see `.gitignore`. What lives here is portable, secrets-free
config plus a reproducibility helper:

- **`~/.claude/bootstrap-mcp.sh`** — re-registers my MCP servers on a fresh machine
  via `claude mcp add` (no tokens stored). Idempotent. Run it after `install.sh`:

  ```sh
  ~/.claude/bootstrap-mcp.sh
  # or with custom checkout locations:
  GDC_REPO=~/code/google-doc-claude EB1A_REPO=~/code/eb1a-mission ~/.claude/bootstrap-mcp.sh
  ```

  It registers the secrets-free **gdoc** server (anchored Google Docs comments,
  from the `google-doc-claude` repo). The OAuth/token-based servers
  (`google-workspace`, `asana`, `mcpvault`) need their own auth — see
  `eb1a-mission/INTEGRATIONS.md`.
