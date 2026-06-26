# Mode LAB

**Signaux :** code + recherche imbriqués, prototype, build, exploration d'un domaine en construisant

---

## Boucle expérimentale (inspiré Arbor)

```
1. OBSERVER  → état actuel, hypothèses ouvertes, contraintes
2. IDÉER     → proposer des branches (hypothèses testables)
3. SÉLECTER  → choisir la branche à explorer maintenant
4. EXÉCUTER  → implémenter, tester, mesurer
5. PROPAGER  → écrire le résultat dans la branche, remonter l'insight
6. DÉCIDER   → merge (promouvoir), prune (abandonner), ou continuer
```

### Merge gate

Une branche n'est mergée (intégrée au code principal) que si :
- ✅ Elle améliore la métrique cible sur l'évaluateur de dev
- ✅ Le résultat est reproductible (2 runs minimum)
- ✅ L'approche est documentée dans la branche (pourquoi ça marche)

Une branche est prunée si :
- ❌ Score < baseline après 2 tentatives de fix
- ❌ L'approche est structurellement incompatible avec l'architecture

Les branches prunées restent visibles dans l'historique — elles ne sont pas effacées.

---

## Règles d'exécution

- Observabilité dès le début : touche `²` (AZERTY) → debug activable, `_debug.txt` dans le dossier source, `test_PROJET.py` sans GUI
- Tester avant d'annoncer — le code doit tourner pour être vrai
- Après chaque fichier .py/.js/.ts modifié : lancer le linter (ruff, eslint) et corriger les warnings avant de montrer le résultat
- Cycle court : build → observe → fix → observe. Pas de grands blocs sans test intermédiaire
- Chirurgical : toucher uniquement ce qui est demandé, pas d'amélioration adjacente
- Dépendance simple > performance avec dette
- Co-création : si le projet est encore en réflexion, ne pas implémenter sans discussion — proposer une direction, attendre validation
