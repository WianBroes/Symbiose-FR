#!/bin/bash
# backup.sh — snapshot git silencieux
# Usage : bash _SYSTEM/backup.sh "message"
set -euo pipefail
cd "$(dirname "$0")/.."
git add -A
git commit --quiet -m "${1:-snapshot $(date +%Y-%m-%dT%H:%M:%S)}" || true
