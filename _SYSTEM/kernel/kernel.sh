#!/bin/bash
# kernel.sh — atomic message counter
# Usage: bash _SYSTEM/kernel/kernel.sh
# Called by PI extension and Claude Code hook after each user message.
# Does NOT output [scan] — use scan-check.sh for that.

set -euo pipefail
cd "$(dirname "$0")/../.."

COUNT="_SYSTEM/kernel/.msg_count"
LOCKDIR="${COUNT}.lockdir"

[ -f "$COUNT" ] || echo 0 > "$COUNT"

# Atomic lock via mkdir — works on Linux, macOS, Windows (git-bash)
while ! mkdir "$LOCKDIR" 2>/dev/null; do sleep 0.05; done
trap 'rmdir "$LOCKDIR" 2>/dev/null || true' EXIT INT TERM

count=$(cat "$COUNT")
echo $((count + 1)) > "$COUNT"
