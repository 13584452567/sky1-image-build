#!/usr/bin/env bash
set -euo pipefail

# CI wrapper for GitHub Actions to build Sky1 GNOME disk image
# Usage: ./scripts/ci-build.sh [desktop] [loadout] [format] [track]

DESKTOP="${1:-gnome}"
LOADOUT="${2:-desktop}"
FORMAT="${3:-image}"
TRACK="${4:-main}"

SKIP_COMPRESS="${SKIP_COMPRESS:-false}"

echo "CI build wrapper: desktop=$DESKTOP loadout=$LOADOUT format=$FORMAT track=$TRACK skip_compress=$SKIP_COMPRESS"

if [ "$(id -u)" -ne 0 ]; then
  echo "Re-running as root using sudo..."
  exec sudo -E bash "$0" "$@"
fi

# Ensure scripts are executable
chmod +x scripts/*.sh

# Export SKIP_COMPRESS so build.sh can read it
export SKIP_COMPRESS

# Non-interactive frontend for live-build
export DEBIAN_FRONTEND=noninteractive

# Run the unified build script
./scripts/build.sh "$DESKTOP" "$LOADOUT" "$FORMAT" "$TRACK"

echo "CI build finished"
