#!/usr/bin/env bash
set -euo pipefail

curl -fsSL https://mise.run | sh

export PATH="$HOME/.local/bin:$PATH"
