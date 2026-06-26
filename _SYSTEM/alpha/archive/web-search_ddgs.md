# web-search DDGS migration

**Palier :** 🔬 ALPHA
**Créé :** 2026-06-04

## Problème
Google a changé son HTML → le scraper `parseGoogleResults()` ne fonctionne plus.
Le moteur renvoie du JavaScript, pas les résultats.

## Solution
Remplacer l'appel HTTP direct à Google par l'appel au script Python
`_SYSTEM/scripts/web_search.py` qui utilise la lib `ddgs` 9.14.1 (DuckDuckGo).

## Fichiers modifiés
- `~/.pi/agent/extensions/web-search.ts` — réécriture complète (Google → Python)
- `_SYSTEM/scripts/web_search.py` — existant, non modifié

## Dépendances
- Python 3
- `ddgs` 9.14.1 (pip install --user --break-system-packages ddgs)

## Sessions
- 2026-06-04 : conception + implémentation + test ✅

## Bugs connus
- Chemin du script hardcodé vers le vault Wian (pas portable)
