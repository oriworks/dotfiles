#!/usr/bin/env bash
set -euo pipefail

# 1. Instalação do ZSH
PACKAGES=("zsh")
MISSING=()

for pkg in "${PACKAGES[@]}"; do
    if ! dpkg -s "$pkg" >/dev/null 2>&1; then
        MISSING+=("$pkg")
    fi
done

if [ ${#MISSING[@]} -gt 0 ]; then
    sudo apt update && sudo apt install -y "${MISSING[@]}"
fi

ZSH_PATH=$(which zsh)
ACTUAL_SHELL=$(getent passwd "$USER" | cut -d: -f7)

if [ "$ACTUAL_SHELL" != "$ZSH_PATH" ]; then
    sudo chsh -s "$ZSH_PATH" "$USER"
fi

ZSHENV="$HOME/.zshenv"
MARKER="# >>> bootstrap.sh: mise on PATH >>>"
if ! grep -qF "$MARKER" "$ZSHENV" 2>/dev/null; then
  {
    echo "$MARKER"
    echo 'export PATH="$HOME/.local/bin:$PATH"'
    echo "# <<< bootstrap.sh: mise on PATH <<<"
  } >> "$ZSHENV"
  echo "added ~/.local/bin to PATH in $ZSHENV"
fi

curl -fsSL https://mise.run | sh

export PATH="$HOME/.local/bin:$PATH"

mise bootstrap --adopt https://github.com/oriworks/dotfiles.git --yes
