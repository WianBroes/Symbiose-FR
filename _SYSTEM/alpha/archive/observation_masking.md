# Observation masking — filtrage au lieu de reformulation

**Palier :** 💡 IDÉE
**Créé :** 2026-06-04

## Principe
JetBrains Research (déc. 2025) a montré que masquer les observations inutiles
coûte **52% moins cher** que les résumer, avec de meilleurs résultats.

## Application à AiBrain
Dans `observations.md` et le rituel de clôture :
- Au lieu de demander à l'IA de reformuler/résumer les observations,
  simplement lui dire "ne garde que celles qui ont 3 confirmations,
  supprime les autres"
- Pas de reformulation, pas de synthèse — juste du filtrage binaire

## Pourquoi
- Économie de tokens
- Évite la contamination par élaboration silencieuse
- Plus fiable que laisser l'IA décider quoi garder

## Référence
- JetBrains Research, déc. 2025 : masking > summarization
- Section 3 de la clôture session 2026-06-04
