#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
CONFIG_SRC="$SCRIPT_DIR/.config"
CONFIG_DST="$HOME/.config"

echo "Installing dotfiles..."
echo ""

# Detect OS
case "$(uname)" in
    Darwin)
        CODE_DST="$HOME/Library/Application Support/Code/User"
        ;;
    Linux)
        CODE_DST="$HOME/.config/Code/User"
        ;;
    *)
        echo "Error: Unsupported OS. This script only supports macOS and Linux."
        exit 1
        ;;
esac

# VS Code
CODE_SRC="$CONFIG_SRC/code/User"

if [[ -d "$CODE_SRC" ]]; then
    mkdir -p "$(dirname "$CODE_DST")"
    ln -sfn "$CODE_SRC" "$CODE_DST"
    echo "  Linked: .config/code/User -> $CODE_DST"
else
    echo "Skipped: .config/code/User/ not found"
fi

echo ""
echo "Done."
