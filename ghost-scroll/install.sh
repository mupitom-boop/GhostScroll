#!/usr/bin/env bash
set -e
PLASMOID_ID="org.kde.ghostscroll"
INSTALL_DIR="$HOME/.local/share/plasma/plasmoids/$PLASMOID_ID"
DIR="$(cd "$(dirname "$0")" && pwd)"

echo "==> Removing older version (if exists)…"
rm -rf "$INSTALL_DIR"

echo "==> Installing in $INSTALL_DIR …"
mkdir -p "$INSTALL_DIR"
cp -r "$DIR"/* "$INSTALL_DIR/"

echo ""
echo "✓ Ghost Scroll installed!"
echo "  Right click desktop → Edit mode > Install widgets → 'Ghost Scroll'"
echo "  You might want to reload your plasma session before using'"
