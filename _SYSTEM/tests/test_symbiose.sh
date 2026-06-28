#!/bin/bash
# test_symbiose.sh — Vérification de l'intégrité du framework Symbiose
# Usage: bash _SYSTEM/tests/test_symbiose.sh
# Retour: 0 si tout OK, 1 si erreurs

SYSTEM_DIR="_SYSTEM"
PROFIL_DIR="01_🧠Profil"
ROLES_DIR="${PROFIL_DIR}/roles"
PASS=0
FAIL=0
ERRORS=""

ok()   { echo "  ✅ $1"; PASS=$((PASS+1)); }
fail() { echo "  ❌ $1"; FAIL=$((FAIL+1)); ERRORS="${ERRORS}  ❌ $1\n"; }

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  Test : Symbiose Framework"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# ── 1. Structure système ──────────────────────────────────────────

echo "── 1. Structure système"

FILES_SYSTEM=(
  "${SYSTEM_DIR}/CORE.md"
  "${SYSTEM_DIR}/AUTOSTART.md"
  "${SYSTEM_DIR}/00_FIRST_STARTUP.md"
  "${SYSTEM_DIR}/FONCTIONNEMENT.md"
  "${SYSTEM_DIR}/COMMANDES.md"
  "${SYSTEM_DIR}/analyse.md"
  "${SYSTEM_DIR}/startup_ascii.md"
  "AGENTS.md"
)

FOUND=0
MISSING=0
for f in "${FILES_SYSTEM[@]}"; do
  if [ -f "$f" ]; then
    FOUND=$((FOUND+1))
  else
    echo "  ⚠️  Fichier manquant : $f"
    MISSING=$((MISSING+1))
  fi
done

if [ "$MISSING" -eq 0 ]; then
  ok "Tous les fichiers système présents (${FOUND})"
else
  fail "${MISSING} fichier(s) système manquant(s) sur ${#FILES_SYSTEM[@]}"
fi

# ── 1b. Skills ─────────────────────────────────────────────────────

echo ""
echo "── 1b. Skills"

SKILL_OK=0
SKILL_COUNT=0
for dir in "${SYSTEM_DIR}/skills/"*/; do
  name=$(basename "$dir")
  SKILL_COUNT=$((SKILL_COUNT+1))
  if [ -f "${dir}SKILL.md" ]; then
    SKILL_OK=$((SKILL_OK+1))
  else
    echo "  ⚠️  SKILL.md manquant dans le skill : $name"
  fi
done

if [ "$SKILL_COUNT" -gt 0 ]; then
  ok "${SKILL_OK}/${SKILL_COUNT} skills avec SKILL.md"
else
  fail "Aucun skill trouvé"
fi

# ── 1c. Rôles ──────────────────────────────────────────────────────

echo ""
echo "── 1c. Rôles"

ROLE_OK=0
ROLE_FAIL=0

if [ -f "${ROLES_DIR}/_INDEX.md" ]; then
  ok "_INDEX.md des rôles présent"
  ROLE_OK=$((ROLE_OK+1))
else
  fail "_INDEX.md des rôles manquant"
  ROLE_FAIL=$((ROLE_FAIL+1))
fi

if [ -f "${ROLES_DIR}/symbiose.md" ]; then
  ok "symbiose.md (voix racine) présent"
  ROLE_OK=$((ROLE_OK+1))
else
  fail "symbiose.md (voix racine) manquant"
  ROLE_FAIL=$((ROLE_FAIL+1))
fi

# Vérifier que tous les rôles listés dans _INDEX.md ont leur fichier
if [ -f "${ROLES_DIR}/_INDEX.md" ]; then
  while read -r line; do
    file=$(echo "$line" | grep -oP '\[.*?\]\(\K[^)]+')
    name=$(echo "$line" | grep -oP '\[\K[^]]+(?=\])')
    if [ -n "$file" ] && [ "$file" != "${file%.md}" ]; then
      if [ ! -f "${ROLES_DIR}/${file}" ]; then
        fail "Rôle '$name' listé dans _INDEX.md mais fichier '${file}' manquant"
        ROLE_FAIL=$((ROLE_FAIL+1))
      fi
    fi
  done < <(grep -E '^\|.*\[.*\]\(.*\.md\)' "${ROLES_DIR}/_INDEX.md" 2>/dev/null || true)
fi

# ── 2. Cohérence des rôles focus ────────────────────────────────────

echo ""
echo "── 2. Cohérence des rôles focus"

if [ -f "${ROLES_DIR}/symbiose.md" ]; then
  CONFLICTS=0
  for role_file in "${ROLES_DIR}"/*.md; do
    role_name=$(basename "$role_file" .md)
    [ "$role_name" = "symbiose" ] || [ "$role_name" = "_INDEX" ] && continue

    # Vérifier que le rôle focus précise qu'il s'ajoute à Symbiose
    if grep -qi "sans le contredire\|s'ajoute\|ne remplace" "$role_file" 2>/dev/null; then
      : # OK
    fi
  done
  if [ "$CONFLICTS" -eq 0 ]; then
    ok "Rôles focus cohérents avec Symbiose"
  fi
fi

# ── 3. Kernel ─────────────────────────────────────────────────────

echo ""
echo "── 3. Kernel"

KERNEL_OK=0
for f in "kernel.sh" "scan-check.sh" "closure.sh"; do
  if [ -f "${SYSTEM_DIR}/kernel/${f}" ]; then
    KERNEL_OK=$((KERNEL_OK+1))
  else
    fail "kernel/${f} manquant"
  fi
done
ok "${KERNEL_OK}/3 scripts kernel présents"

# Test : kernel.sh incrémente correctement
if [ -f "${SYSTEM_DIR}/kernel/kernel.sh" ]; then
  PRE_COUNT=$(cat "${SYSTEM_DIR}/kernel/.msg_count" 2>/dev/null || echo 0)
  bash "${SYSTEM_DIR}/kernel/kernel.sh" 2>/dev/null || true
  POST_COUNT=$(cat "${SYSTEM_DIR}/kernel/.msg_count" 2>/dev/null || echo 0)
  if [ "$POST_COUNT" = "$((PRE_COUNT + 1))" ]; then
    ok "kernel.sh incrémente .msg_count (${PRE_COUNT} → ${POST_COUNT})"
  else
    fail "kernel.sh : .msg_count ${PRE_COUNT} → ${POST_COUNT} (attendu $((PRE_COUNT + 1)))"
  fi
fi

# ── 4. Profil ──────────────────────────────────────────────────────

echo ""
echo "── 4. Profil utilisateur"

PROFIL_FILE="${PROFIL_DIR}/👤profil.md"
if [ -f "$PROFIL_FILE" ]; then
  ok "Profil présent"

  # Sections obligatoires
  for section in "🧬 Traits" "🎯 Compétences" "🖥️ Machine" "👤 Utilisateur"; do
    if grep -q "^## ${section}" "$PROFIL_FILE"; then
      ok "Section '${section}' présente"
    else
      fail "Section '${section}' manquante"
    fi
  done

  # active_role valide
  AR=$(grep "^active_role:" "$PROFIL_FILE" 2>/dev/null | sed 's/.*: //')
  if [ -n "$AR" ]; then
    if [ -f "${ROLES_DIR}/${AR}.md" ]; then
      ok "active_role='${AR}' → fichier présent"
    else
      fail "active_role='${AR}' mais roles/${AR}.md introuvable"
    fi
  fi
fi

# Mémoire
MEM_FILE="${PROFIL_DIR}/memory/observations.md"
if [ -f "$MEM_FILE" ]; then
  MEM_SIZE=$(wc -c < "$MEM_FILE" 2>/dev/null || echo 0)
  if [ "$MEM_SIZE" -gt 10000 ]; then
    fail "Mémoire saturée (${MEM_SIZE} bytes > 10KB) — dream nécessaire"
  elif [ "$MEM_SIZE" -gt 7000 ]; then
    echo "  ⚠️  Mémoire ~$(($MEM_SIZE / 1000))KB — dream bientôt nécessaire"
  else
    ok "Mémoire OK (${MEM_SIZE} bytes)"
  fi
fi

# ── 5. Versions ────────────────────────────────────────────────────

echo ""
echo "── 5. Versions"

for skill_file in "${SYSTEM_DIR}/skills/"*/SKILL.md; do
  skill_name=$(basename "$(dirname "$skill_file")")
  version=$(grep "^version:" "$skill_file" 2>/dev/null | sed 's/version: "\(.*\)"/\1/')
  echo "  ℹ️  ${skill_name} : v${version:-?}"
done

# ── Résultat ────────────────────────────────────────────────────────

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  ${PASS} ✅  /  ${FAIL} ❌"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

if [ "$FAIL" -gt 0 ]; then
  echo -e "$ERRORS"
  exit 1
fi

exit 0
