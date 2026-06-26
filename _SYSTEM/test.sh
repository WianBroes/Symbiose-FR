#!/bin/bash
# test.sh — Sanité du système Symbiose
# Vérifie présence des fichiers, cohérence des références croisées.
# Usage : bash _SYSTEM/test.sh

set -euo pipefail
cd "$(dirname "$0")/.."

errors=0
warnings=0

# Couleurs si terminal
if [ -t 1 ]; then
  RED='\033[0;31m'
  GREEN='\033[0;32m'
  YELLOW='\033[1;33m'
  NC='\033[0m'
else
  RED=''
  GREEN=''
  YELLOW=''
  NC=''
fi

check_file() {
  if [ -f "$1" ]; then
    echo -e "  ${GREEN}✓${NC} $1"
  else
    echo -e "  ${RED}✗ MANQUANT${NC} $1"
    errors=$((errors + 1))
  fi
}

check_dir() {
  if [ -d "$1" ]; then
    echo -e "  ${GREEN}✓${NC} $1/"
  else
    echo -e "  ${RED}✗ MANQUANT${NC} $1/"
    errors=$((errors + 1))
  fi
}

# ─── 1. Fichiers système obligatoires ────────────────────────────
echo ""
echo "━━━ Fichiers système ━━━"
check_file "AGENTS.md"
check_file "_SYSTEM/CORE.md"
check_file "_SYSTEM/AUTOSTART.md"
check_file "_SYSTEM/00_FIRST_STARTUP.md"
check_file "_SYSTEM/00_SESSION_CLOSE.md"
check_file "_SYSTEM/startup_ascii.md"
check_file "_SYSTEM/analyse.md"
check_file "_SYSTEM/CONVENTIONS.md"
check_file "_SYSTEM/QUICK_START.md"
check_file "_SYSTEM/kernel/kernel.sh"

# ─── 2. Dossiers système ────────────────────────────────────────
echo ""
echo "━━━ Dossiers système ━━━"
check_dir "_SYSTEM/modes"
check_dir "_SYSTEM/skills"
check_dir "_SYSTEM/alpha"
check_dir "_SYSTEM/_Templates"

# ─── 3. Fichiers profil ─────────────────────────────────────────
echo ""
echo "━━━ Profil (optionnels) ━━━"
grep -q "👤 Utilisateur" "01_🧠Profil/👤profil.md" 2>/dev/null && echo -e "  ${GREEN}✓${NC} 👤profil.md (profil utilisateur)" || echo -e "  ${YELLOW}⚠ profil utilisateur absent${NC}"
[ -f "01_🧠Profil/👤profil.md" ] && echo -e "  ${GREEN}✓${NC} 01_🧠Profil/👤profil.md (initialisé)" || echo -e "  ${YELLOW}⚠ 👤profil.md absent — non initialisé${NC}"

# ─── 4. Kernel exécutable ───────────────────────────────────────
echo ""
echo "━━━ Kernel ━━━"
if [ -x "_SYSTEM/kernel/kernel.sh" ]; then
  echo -e "  ${GREEN}✓${NC} kernel.sh exécutable"
else
  echo -e "  ${YELLOW}⚠ kernel.sh non exécutable — réparation${NC}"
  chmod +x "_SYSTEM/kernel/kernel.sh" && echo -e "  ${GREEN}✓${NC} corrigé"
  warnings=$((warnings + 1))
fi

# Test exécution
output=$(bash _SYSTEM/kernel/kernel.sh 2>&1) && echo -e "  ${GREEN}✓${NC} kernel.sh exécuté sans erreur" || {
  echo -e "  ${RED}✗ kernel.sh échoue${NC} : $output"
  errors=$((errors + 1))
}

# ─── 5. Cohérence références ─────────────────────────────────────
echo ""
echo "━━━ Références croisées ━━━"
CORE="docs/README.md _SYSTEM/CORE.md"

# Vérifie que CORE.md référence AUTOSTART
grep -q "AUTOSTART" "_SYSTEM/CORE.md" && echo -e "  ${GREEN}✓${NC} CORE.md référence AUTOSTART" || {
  echo -e "  ${YELLOW}⚠ CORE.md ne référence pas AUTOSTART${NC}"
  warnings=$((warnings + 1))
}

# Vérifie que analyse.md référence kernel
grep -q "kernel.sh" "_SYSTEM/analyse.md" && echo -e "  ${GREEN}✓${NC} analyse.md référence kernel.sh" || {
  echo -e "  ${YELLOW}⚠ analyse.md ne référence pas kernel.sh${NC}"
  warnings=$((warnings + 1))
}

# Vérifie cohérence niveaux skills — pas de "0" dans analyse.md §2b
if grep -A10 "## 2b. Skills" "_SYSTEM/analyse.md" | grep -q "| 0 |"; then
  echo -e "  ${YELLOW}⚠ analyse.md §2b contient encore un niveau 0 (déprécié)${NC}"
  warnings=$((warnings + 1))
else
  echo -e "  ${GREEN}✓${NC} analyse.md §2b pas de niveau 0"
fi

# ─── 6. Skills disponibles ──────────────────────────────────────
echo ""
echo "━━━ Skills ━━━"
check_file "_SYSTEM/skills/_INDEX.md"
check_file "_SYSTEM/skills/import/SKILL.md"
check_file "_SYSTEM/skills/export/SKILL.md"

# ─── Résultat ───────────────────────────────────────────────────
echo ""
if [ $errors -eq 0 ] && [ $warnings -eq 0 ]; then
  echo -e "${GREEN}✓ SYSTÈME OK${NC} — 0 erreurs, 0 warnings"
elif [ $errors -eq 0 ]; then
  echo -e "${YELLOW}✓ SYSTÈME OK — $warnings warnings${NC}"
else
  echo -e "${RED}✗ $errors erreur(s), $warnings warning(s)${NC}"
fi
echo ""

exit $errors
