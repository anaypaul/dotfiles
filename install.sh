#!/usr/bin/env bash
# Symlink every dotfile package into $HOME using GNU Stow.
# One-shot setup for a new machine:
#   git clone https://github.com/anaypaul/dotfiles.git ~/workspace/dotfiles
#   ~/workspace/dotfiles/install.sh
set -euo pipefail
shopt -s nullglob

cd "$(dirname "${BASH_SOURCE[0]}")"

# Ensure GNU Stow is available.
if ! command -v stow >/dev/null 2>&1; then
  if [[ "$(uname -s)" == "Darwin" ]] && command -v brew >/dev/null 2>&1; then
    echo "Installing GNU Stow via Homebrew..."
    brew install stow
  else
    echo "error: GNU Stow is required. Install it (brew install stow / apt install stow / dnf install stow) and re-run." >&2
    exit 1
  fi
fi

# Packages that only apply on macOS (skipped elsewhere). Space-padded for matching.
mac_only=" aerospace "

packages=()
for dir in */; do
  pkg="${dir%/}"
  if [[ "$(uname -s)" != "Darwin" && "$mac_only" == *" $pkg "* ]]; then
    echo "skip: $pkg (macOS-only) on $(uname -s)"
    continue
  fi
  packages+=("$pkg")
done

if [[ ${#packages[@]} -eq 0 ]]; then
  echo "No packages to stow."
  exit 0
fi

# --restow makes re-runs idempotent (cleans then relinks).
stow --target="$HOME" --restow --verbose "${packages[@]}"
echo "Linked into \$HOME: ${packages[*]}"
