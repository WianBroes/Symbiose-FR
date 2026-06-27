---
name: scan
description: Micro-scan périodique — observation ouverte. Regarde les échanges récents, note ce qui est notable ou rien.
trigger: "[scan]" détecté dans le contexte (system-reminder, hook output, message custom)
---

# Scan

> **EXÉCUTER AVANT DE RÉPONDRE À L'UTILISATEUR.**
> Ne pas sauter. Ne pas différer. Ne pas fusionner avec la réponse.

---

## Observer

Relire les **5 derniers échanges**. Regarder aussi ce que j'ai construit en réponse — fichiers créés, structure, décisions — et ce que ça dit des choix de l'utilisateur.

Se poser **une question :**

> *"Qu'est-ce que son dernier geste dit de comment il fonctionne ?"*

Pas de cases à cocher. Pas de tableaux. Pas de directions à explorer. Juste regarder ce que le geste révèle — un mot, une correction, un silence, un "non", un "vas-y", une reformulation.

**Répondre en une phrase :** pas d'étiquette, pas de catégorie. Une observation brute.

Exemple : *"Quand il détecte une erreur, il regarde d'abord la structure qui l'a permise, pas le comportement qui l'exécute."*

Si rien de notable → **ne rien faire**. Zéro est un résultat valide.

---

## Incrémenter (si quelque chose a été vu)

Si un **comportement déjà référencé** dans le profil a été observé :
→ Incrémenter ses signaux, mettre à jour le score

Si un **comportement nouveau** a été observé :
→ Créer une entrée dans les traits (score 0.5, 1 signal)
→ Ajouter l'observation brute dans `observations.md`

Si un **mode de pensée nouveau** a été observé :
→ Ajouter dans `🔭 En émergence` (Sessions: 1 + observation brute)

> Le protocole complet d'incrémentation est dans `_SYSTEM/analyse.md` §1b.

---

## Synergie

Ne pas chercher des synergies. Elles apparaissent quand plusieurs observations, sur plusieurs sessions, pointent dans la même direction.

---

## Référence — signaux déjà observés

> Pour éviter les doublons, pas pour guider l'observation.

**Traits :** `direct`, `directif`, `precis`, `explorateur`, `observateur`, `systémique`, `socratique`, `👁️ œil`

**Modes de pensée :** `inductive`, `critique`, `vision-driven`

---

## Feedback

Si quelque chose a été détecté → le formater selon `_SYSTEM/analyse.md` §1d.

Si rien → pas de feedback.
