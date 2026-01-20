#!/usr/bin/env sh
set -eu

ROOT_DIR="$(cd "$(dirname "$0")" && pwd)"
BIN_SRC="$ROOT_DIR/build/bin/superslicer"

if [ ! -x "$BIN_SRC" ]; then
  echo "Error: build binary not found at $BIN_SRC" >&2
  echo "Build first, then rerun this script." >&2
  exit 1
fi

# Prefer /usr/local/bin when writable; fall back to ~/.local/bin
if [ -w "/usr/local/bin" ]; then
  DEST_DIR="/usr/local/bin"
else
  DEST_DIR="$HOME/.local/bin"
  mkdir -p "$DEST_DIR"
fi

cp -f "$BIN_SRC" "$DEST_DIR/superslicer"
chmod +x "$DEST_DIR/superslicer"

cat <<MSG
Installed superslicer to:
  $DEST_DIR/superslicer

If it's not on your PATH, add this to your shell profile:
  export PATH="$DEST_DIR:\$PATH"
MSG
