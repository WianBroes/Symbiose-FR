#!/bin/bash
# backup_profil.sh — Backup du profil utilisateur avant modification
# Usage: bash _SYSTEM/backup_profil.sh
# Copie 01_🧠Profil/👤profil.md → 01_🧠Profil/backups/profil.YYYY-MM-DD_HH-MM-SS.md

PROFIL="01_🧠Profil/👤profil.md"
BACKUP_DIR="01_🧠Profil/backups"

if [ ! -f "$PROFIL" ]; then
  echo "❌ Profil introuvable : $PROFIL"
  exit 1
fi

mkdir -p "$BACKUP_DIR"

TIMESTAMP=$(date +"%Y-%m-%d_%H-%M-%S")
BACKUP_FILE="${BACKUP_DIR}/profil.${TIMESTAMP}.md"

cp "$PROFIL" "$BACKUP_FILE"

echo "✅ Backup : ${BACKUP_FILE}"
echo "   $(wc -c < "$BACKUP_FILE") bytes"
