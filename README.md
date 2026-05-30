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
