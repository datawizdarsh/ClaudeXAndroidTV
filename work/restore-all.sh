#!/usr/bin/env bash
# Put the Skyworth SWTV-20NA back the way it was before the cleanup on 2026-11-01.
# Re-enables every package disabled in the four batches, gives Home back to the stock launcher
# (com.google.android.tvlauncher), and resets Private DNS to Android's default.
#
# Usage, from the repo root, with USB/Network debugging on and the TV allowed:
#   TV_HOST=<tv ip> bash work/restore-all.sh
# One app only: TV_HOST=<tv ip> tools/venv/Scripts/python tools/tv.py "pm enable --user 0 <package>"
set -euo pipefail
cd "$(dirname "$0")/.."
: "${TV_HOST:?set TV_HOST to the TV's IP address}"
export TV_HOST
PY=tools/venv/bin/python
[ -x "$PY" ] || PY=tools/venv/Scripts/python.exe

# Newest batch first. The first call also hands Home back to the stock launcher.
bash tools/restore.sh work/batch4-choices.txt com.google.android.tvlauncher
bash tools/restore.sh work/batch3-leftovers.txt
bash tools/restore.sh work/batch2-ads.txt
bash tools/restore.sh work/batch1-telemetry.txt

# Private DNS was unset before (Android default = opportunistic / "Automatic").
"$PY" -I tools/tv.py "settings put global private_dns_mode opportunistic"
"$PY" -I tools/tv.py "settings delete global private_dns_specifier"

echo "Done. The new launcher (com.gathin.tvhome) is still installed but no longer Home;"
echo "remove it with: $PY tools/tv.py 'pm uninstall com.gathin.tvhome'"
