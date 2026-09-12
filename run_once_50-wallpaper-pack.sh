#!/bin/bash
# ==============================================================================
# Seed the blxss ambient wallpaper pack into the local wallpaper cache.
# random-wallpaper (Alt+Shift+W) rotates it from there - cache-first, no
# network, no SSD wear. Only copies files that are missing locally.
# ==============================================================================
set -euo pipefail

SRC_DIR="${CHEZMOI_SOURCE_DIR:-$HOME/.local/share/chezmoi}/wallpapers"
DEST_DIR="$HOME/.local/share/wallpapers"
mkdir -p "$DEST_DIR"

copied=0
for img in "$SRC_DIR"/blxss_*.jpg; do
    [ -e "$img" ] || continue
    base="$(basename "$img")"
    if [ ! -f "$DEST_DIR/$base" ]; then
        cp -a "$img" "$DEST_DIR/$base"
        copied=$((copied + 1))
    fi
done

echo "==> Wallpaper pack: $copied new file(s) seeded into $DEST_DIR"
