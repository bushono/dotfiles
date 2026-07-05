#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

echo "Installing dotfiles..."
echo ""

# Detect OS and set VS Code config destination
case "$(uname)" in
    Darwin)
        # macOS
        CODE_DST="$HOME/Library/Application Support/Code/User"
        ;;
    Linux)
        # Linux
        CODE_DST="$HOME/.config/Code/User"
        ;;
    *)
        echo "Error: Unsupported OS. This script only supports macOS and Linux."
        exit 1
        ;;
esac

# VS Code config files from repo
CODE_SRC="$SCRIPT_DIR/code/User"

if [[ -d "$CODE_SRC" ]]; then
    mkdir -p "$CODE_DST"
    LINK_COUNT=0
    for item in "$CODE_SRC"/*; do
        [[ -e "$item" ]] || continue
        name=$(basename "$item")
        ln -sf "$item" "$CODE_DST/$name"
        echo "  Linked: $name"
        LINK_COUNT=$((LINK_COUNT + 1))
    done
    echo "VS Code config: $LINK_COUNT linked to $CODE_DST"
else
    echo "Skipped: code/User/ not found"
fi

echo ""

# Generic .config directory
CONFIG_SRC="$SCRIPT_DIR/.config"
CONFIG_DST="$HOME/.config"

if [[ -d "$CONFIG_SRC" ]]; then
    LINK_COUNT=0
    for dir in "$CONFIG_SRC"/*/; do
        [[ -d "$dir" ]] || continue
        DIR_NAME=$(basename "$dir")
        [[ -n "$(ls -A "$dir")" ]] || continue
        ln -sf "$dir" "$CONFIG_DST/$DIR_NAME"
        echo "  Linked: .config/$DIR_NAME"
        LINK_COUNT=$((LINK_COUNT + 1))
    done
    echo "Config dirs: $LINK_COUNT linked to $CONFIG_DST/"
else
    echo "Skipped: .config/ not found"
fi

echo ""
echo "Done."
