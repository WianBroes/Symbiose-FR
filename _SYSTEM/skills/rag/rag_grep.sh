#!/bin/bash
# rag_grep.sh — Recherche full-text dans le vault Symbiose
# Zéro dépendance : grep + awk + sort
#
# Usage:
#   bash rag_grep.sh [options] "requête" [dossier]
#
# Options:
#   --exact       Phrase exacte (grep -F)
#   --and         Tous les mots doivent apparaître (intersection)
#   --or          Un des mots suffit (défaut)
#   --max N       Nombre max de fichiers à afficher (défaut: 5)
#   --context N   Lignes de contexte (défaut: 2)
#   --rebuild-index Construire l'index de mots-clés

set -uo pipefail

# ─── Config ────────────────────────────────────────────────────────────
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
VAULT_ROOT="$(cd "$SCRIPT_DIR/../../.." && pwd)"
INDEX_FILE="$SCRIPT_DIR/.index"
MAX_FILES=5
_CONTEXT=2
MODE="or"
EXACT=false
REBUILD_INDEX=false
QUERY=""
TARGET_DIR="$VAULT_ROOT"

# ─── Parse args ────────────────────────────────────────────────────────
while [[ $# -gt 0 ]]; do
  case "$1" in
    --exact) EXACT=true; shift ;;
    --and) MODE="and"; shift ;;
    --or) MODE="or"; shift ;;
    --max) MAX_FILES="$2"; shift 2 ;;
    --context) _CONTEXT="$2"; shift 2 ;;
    --rebuild-index) REBUILD_INDEX=true; shift ;;
    --*) echo "❌ Option inconnue : $1"; exit 1 ;;
    *)
      if [[ -z "$QUERY" ]]; then
        QUERY="$1"
      else
        TARGET_DIR="$1"
      fi
      shift ;;
  esac
done

# ─── Aide ──────────────────────────────────────────────────────────────
if [[ -z "$QUERY" && "$REBUILD_INDEX" == false ]]; then
  echo "❌ Usage : bash rag_grep.sh [options] \"requête\" [dossier]"
  echo "   bash rag_grep.sh --rebuild-index"
  exit 1
fi

# ─── Resolve target directory ──────────────────────────────────────────
if [[ "$TARGET_DIR" != /* ]]; then
  TARGET_DIR="$VAULT_ROOT/$TARGET_DIR"
fi
if [[ ! -d "$TARGET_DIR" ]]; then
  echo "❌ Dossier introuvable : $TARGET_DIR"
  exit 1
fi

# ─── Rebuild index ─────────────────────────────────────────────────────
if [[ "$REBUILD_INDEX" == true ]]; then
  echo "🔨 Rebuild de l'index (cela peut prendre quelques secondes)..."
  find "$VAULT_ROOT" -name "*.md" -not -path "*/node_modules/*" -not -path "*/.git/*" \
    -not -path "*/_Corbeille/*" -not -path "*/_SYSTEM/kernel/*" \
    | while read -r f; do
        words=$(grep -oP '\b[a-zA-Zéèêëàâäùûüôöîïç]{4,}\b' "$f" 2>/dev/null | sort | uniq | wc -l)
        echo "$words|$f"
      done > "$INDEX_FILE"
  echo "✅ Index sauvegardé : $(wc -l < "$INDEX_FILE") fichiers indexés"
  exit 0
fi

# ─── Exclusions ────────────────────────────────────────────────────────
EXCLUDE_DIRS=(
  "-path '*/node_modules/*'"
  "-path '*/.git/*'"
  "-path '*/_Corbeille/*'"
  "-path '*/_SYSTEM/kernel/*'"
  "-path '*/_SYSTEM/rag/*'"
  "-path '*/pi-extensions/*'"
)

build_exclude() {
  local expr=""
  for excl in "${EXCLUDE_DIRS[@]}"; do
    if [[ -z "$expr" ]]; then
      expr="$excl"
    else
      expr="$expr -o $excl"
    fi
  done
  echo "$expr"
}

# ─── Mode : phrase exacte ──────────────────────────────────────────────
if [[ "$EXACT" == true ]]; then
  find "$TARGET_DIR" -name "*.md" -not -path "*/node_modules/*" -not -path "*/.git/*" \
    -not -path "*/_Corbeille/*" -not -path "*/_SYSTEM/kernel/*" \
    -exec grep -l -F "$QUERY" {} \; 2>/dev/null \
    | while read -r f; do
        rel=$(echo "$f" | sed "s|$VAULT_ROOT/||")
        count=$(grep -c -F "$QUERY" "$f" 2>/dev/null || echo 0)
        echo "$count|$rel|$f"
      done \
    | sort -t'|' -k1 -rn \
    | head -n "$MAX_FILES" \
    | while IFS='|' read -r count rel full; do
        echo "📄 **$rel** ($count occurrences)"
        grep -n -F "$QUERY" "$full" 2>/dev/null | head -n 5 | while IFS=':' read -r line text; do
          echo "  > ligne $line : $(echo "$text" | sed 's/^ *//' | cut -c1-200)"
        done
        echo ""
      done
  exit 0
fi

# ─── Mode : AND (tous les mots) ────────────────────────────────────────
if [[ "$MODE" == "and" ]]; then
  read -ra words <<< "$QUERY"
  find "$TARGET_DIR" -name "*.md" -not -path "*/node_modules/*" -not -path "*/.git/*" \
    -not -path "*/_Corbeille/*" -not -path "*/_SYSTEM/kernel/*" 2>/dev/null \
    | while read -r f; do
        all_found=true
        total=0
        for w in "${words[@]}"; do
          c=$(grep -oi "$w" "$f" 2>/dev/null | wc -l)
          total=$((total + c))
          if [[ "$c" -eq 0 ]]; then all_found=false; break; fi
        done
        if [[ "$all_found" == true ]]; then
          rel=$(echo "$f" | sed "s|$VAULT_ROOT/||")
          echo "$total|$rel|$f"
        fi
      done \
    | sort -t'|' -k1 -rn \
    | head -n "$MAX_FILES" \
    | while IFS='|' read -r count rel full; do
        echo "📄 **$rel** ($count occurrences)"
        for w in "${words[@]}"; do
          grep -n -i "$w" "$full" 2>/dev/null | head -n 3 | while IFS=':' read -r line text; do
            echo "  > ligne $line : $(echo "$text" | sed 's/^ *//' | cut -c1-200)"
          done
        done
        echo ""
      done
  exit 0
fi

# ─── Mode : OR (défaut) ───────────────────────────────────────────────
# Construire une regex avec tous les mots
regex=$(echo "$QUERY" | sed 's/ /|/g')

find "$TARGET_DIR" -name "*.md" -not -path "*/node_modules/*" -not -path "*/.git/*" \
  -not -path "*/_Corbeille/*" -not -path "*/_SYSTEM/kernel/*" \
  -exec grep -l -E "$regex" {} \; 2>/dev/null \
  | while read -r f; do
      rel=$(echo "$f" | sed "s|$VAULT_ROOT/||")
      count=$(grep -c -E "$regex" "$f" 2>/dev/null || echo 0)
      echo "$count|$rel|$f"
    done \
  | sort -t'|' -k1 -rn \
  | head -n "$MAX_FILES" \
  | while IFS='|' read -r count rel full; do
      echo "📄 **$rel** ($count occurrences)"
      grep -n -E "$regex" "$full" 2>/dev/null | head -n 5 | while IFS=':' read -r line text; do
        echo "  > ligne $line : $(echo "$text" | sed 's/^ *//' | cut -c1-200)"
      done
      echo ""
    done
