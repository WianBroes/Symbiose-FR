#!/bin/bash
# closure.sh — compteur de clôtures, dispatch dream
# Bash pur — zéro logique LLM ici.
#
# Appelé par le skill de clôture après chaque session close.
# Au seuil de 10 clôtures, pose un flag .dream_requested
# pour que l'IA lance un pass de consolidation au prochain démarrage.
#
# Usage : bash _SYSTEM/kernel/closure.sh

set -euo pipefail
cd "$(dirname "$0")/../.."

KERNEL="_SYSTEM/kernel"
CLOSURE_COUNT="$KERNEL/.closure_count"
DREAM_THRESHOLD="${SYMBIOSE_DREAM_INTERVAL:-10}"

[ -f "$CLOSURE_COUNT" ] || echo 0 > "$CLOSURE_COUNT"

count=$(cat "$CLOSURE_COUNT")
count=$((count + 1))
echo "$count" > "$CLOSURE_COUNT"

if (( count >= DREAM_THRESHOLD )); then
  touch "$KERNEL/.dream_requested"
fi

exit 0
