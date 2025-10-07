#!/usr/bin/env bash
set -euo pipefail

# Generate macOS AppIcon PNGs for the asset catalog from a source image (PNG/SVG converted to PNG first).
# Usage:
#   ./generate_appicon.sh [source_png]
# If omitted, defaults to ZenLink/Assets.xcassets/AppIconSource.png

SRC_PATH=${1:-"ZenLink/Assets.xcassets/AppIconSource.png"}
OUT_DIR="ZenLink/Assets.xcassets/AppIcon.appiconset"

if [[ ! -f "$SRC_PATH" ]]; then
  echo "Source image not found: $SRC_PATH" >&2
  echo "Please place your wave PNG at $SRC_PATH or pass a path as an argument." >&2
  exit 1
fi

# Ensure the source is square by resizing to 1024x1024 (will letterbox if not square)
TMP_DIR=$(mktemp -d)
trap 'rm -rf "$TMP_DIR"' EXIT
BASE="$TMP_DIR/base-1024.png"

# Resize the source to 1024x1024. If your source isn't square, consider preparing a square canvas beforehand.
sips -Z 1024 "$SRC_PATH" --out "$BASE" >/dev/null

declare -A sizes=(
  ["mac-16x16@1x.png"]=16
  ["mac-16x16@2x.png"]=32
  ["mac-32x32@1x.png"]=32
  ["mac-32x32@2x.png"]=64
  ["mac-128x128@1x.png"]=128
  ["mac-128x128@2x.png"]=256
  ["mac-256x256@1x.png"]=256
  ["mac-256x256@2x.png"]=512
  ["mac-512x512@1x.png"]=512
  ["mac-512x512@2x.png"]=1024
)

mkdir -p "$OUT_DIR"

for name in "${!sizes[@]}"; do
  dim=${sizes[$name]}
  out="$OUT_DIR/$name"
  sips -Z "$dim" "$BASE" --out "$out" >/dev/null
  echo "Wrote $out ($dim x $dim)"
done

echo "All AppIcon sizes generated into $OUT_DIR"
