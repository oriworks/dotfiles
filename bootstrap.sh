#!/usr/bin/env bash
set -euo pipefail

sudo apt install zsh -y
chsh -s $(which zsh)

curl -fsSL https://mise.run | sh

export PATH="$HOME/.local/bin:$PATH"

mise bootstrap --adopt https://github.com/oriworks/dotfiles.git --yes
