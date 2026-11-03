#!/usr/bin/env bash
# Rebuild the launcher in Docker (no JDK or Android SDK needed) and install it on the Skyworth SWTV-20NA.
# Run from the repo root after editing launcher/app/src/main/res/values/config.xml, with debugging on:
#   TV_HOST=<tv ip> bash work/build-and-install.sh
# Docker Desktop must be running.
set -euo pipefail
cd "$(dirname "$0")/.."
: "${TV_HOST:?set TV_HOST to the TV's IP address}"
export TV_HOST
bash tools/docker-build.sh
SKIP_BUILD=1 bash launcher/build-and-install.sh
