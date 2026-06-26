# Guidelines ACON-style — règles de compression explicites

**Palier :** 💡 IDÉE
**Créé :** 2026-06-04

## Principe
Microsoft Research (ACON, oct. 2025) : plutôt que de tout résumer, optimiser
par *guidelines de compression* affinées itérativement. 26-54% de tokens en
moins, 95%+ accuracy.

## Application à AiBrain
Dans `00_CLOTURE_SESSION.md`, remplacer l'improvisation par des règles explicites
qui disent à l'IA quoi garder et quoi jeter :
- "3-5 items max dans En chantier" (déjà écrit mais implicite)
- "Uniquement les fichiers modifiés, pas les lus"
- "Pas de contexte du passé"
- "Si rien n'est en chantier, écrire 'Rien — session bouclée'"

## Pourquoi
- Réduit le volume des TRANSFERT
- Moins de variance entre sessions
- L'IA n'improvise pas la compression

## Référence
- ACON : arXiv 2510.00615 (Microsoft Research, oct. 2025)
- Déjà partiellement présent dans `00_CLOTURE_SESSION.md` section 5
