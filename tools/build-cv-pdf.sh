#!/usr/bin/env bash
# Regenerates Ayman-Zahran-CV.pdf from cv.html using headless Chromium.
# Designed to run both locally (macOS Google Chrome) and in CI (Ubuntu chromium-browser).
#
# Outputs Ayman-Zahran-CV.pdf at the repo root.

set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
SRC="${ROOT}/cv.html"
OUT="${ROOT}/Ayman-Zahran-CV.pdf"

[ -f "$SRC" ] || { echo "Missing $SRC" >&2; exit 1; }

# Pick whichever Chromium-family binary is available.
CHROME=""
for c in \
  "/Applications/Google Chrome.app/Contents/MacOS/Google Chrome" \
  "/Applications/Chromium.app/Contents/MacOS/Chromium" \
  "/usr/bin/google-chrome" \
  "/usr/bin/google-chrome-stable" \
  "/usr/bin/chromium" \
  "/usr/bin/chromium-browser"; do
  [ -x "$c" ] && { CHROME="$c"; break; }
done

[ -n "$CHROME" ] || { echo "No Chrome/Chromium binary found." >&2; exit 1; }

echo "Rendering $SRC → $OUT (using: $CHROME)"

"$CHROME" --headless=new --disable-gpu --no-sandbox \
  --print-to-pdf-no-header \
  --virtual-time-budget=10000 \
  --print-to-pdf="$OUT" \
  "file://${SRC}" >/dev/null 2>&1

ls -lh "$OUT"
echo "Done."
