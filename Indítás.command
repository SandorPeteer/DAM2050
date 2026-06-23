#!/bin/bash
# DAM Digitális Acélváros 2050 – Launcher
cd "$(dirname "$0")"

URL="http://localhost:8080/index.html"

open_dam() {
  open -a "Google Chrome" "$URL" 2>/dev/null || \
  open -a "Chromium" "$URL" 2>/dev/null || \
  open "$URL"
}

if curl -fsS "$URL" >/dev/null 2>&1; then
  open_dam
  echo ""
  echo "╔════════════════════════════════════════╗"
  echo "║   DAM már fut: http://localhost:8080   ║"
  echo "╚════════════════════════════════════════╝"
  exit 0
fi

PYTHON_BIN="$(command -v python3)"
if [ -z "$PYTHON_BIN" ]; then
  echo "Nem található python3. Telepíts Python 3-at, vagy indíts helyi webszervert a DAM mappából."
  exit 1
fi

"$PYTHON_BIN" -m http.server 8080 &
SERVER_PID=$!

sleep 1

open_dam

echo ""
echo "╔════════════════════════════════════════╗"
echo "║   DIGITÁLIS ACÉLVÁROS 2050 – AKTÍV     ║"
echo "║   http://localhost:8080                ║"
echo "║   Bezáráshoz nyomj CTRL+C              ║"
echo "╚════════════════════════════════════════╝"

# Vár amíg CTRL+C-t nyomnak, majd leállítja a szervert
trap "kill $SERVER_PID 2>/dev/null; echo 'Szerver leállítva.'; exit" INT TERM
wait $SERVER_PID
