#!/usr/bin/env bash

# Exit with nonzero exit code if anything fails and show script content
# set -ex
set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd -- "$SCRIPT_DIR/.." && pwd)"
GAME_DIR="${CYBERPUNK_DIR:-/d/Program Files (x86)/Steam/steamapps/common/Cyberpunk 2077}"
CLI="$GAME_DIR/tools/redscript-cli.exe"
INPUT="$GAME_DIR/r6/cache/final.redscripts"
OUTPUT="$REPO_ROOT/decompiled-redscripts"

if [[ ! -f "$CLI" ]]; then
  printf 'redscript-cli.exe not found: %s\n' "$CLI" >&2
  exit 1
fi

if [[ ! -f "$INPUT" ]]; then
  printf 'Compiled redscript bundle not found: %s\n' "$INPUT" >&2
  exit 1
fi

mkdir -p "$OUTPUT"
cd "$GAME_DIR"
"$CLI" decompile -i "$INPUT" -o "$OUTPUT" -f