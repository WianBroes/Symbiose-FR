#!/bin/bash
# scan-check.sh — outputs [scan] if it's time for a micro-scan
# Usage: bash _SYSTEM/kernel/scan-check.sh
# Reads interval from .scan_interval (default: 7).

set -euo pipefail
cd "$(dirname "$0")/../.."

COUNT="_SYSTEM/kernel/.msg_count"
INTERVAL_FILE="_SYSTEM/kernel/.scan_interval"

count=$(cat "$COUNT" 2>/dev/null || echo 0)
interval=$(cat "$INTERVAL_FILE" 2>/dev/null || echo 7)

if [ $(( count % interval )) -eq 0 ]; then
  echo "[scan]"
  echo ""
  echo "⚠️ SCAN OBLIGATOIRE — Exécuter maintenant, avant de répondre à l'utilisateur :"
  cat "$(dirname "$0")/../../_SYSTEM/skills/scan/SKILL.md"
fi
