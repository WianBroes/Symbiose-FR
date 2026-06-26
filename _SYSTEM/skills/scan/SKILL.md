---
name: scan
description: Micro-scan périodique — collecte de signaux traits, skills, et formes de raisonnement sur les 5 derniers échanges.
trigger: "[scan]" détecté dans une system-reminder (UserPromptSubmit hook)
---

# Scan — Micro-scan périodique

> **EXÉCUTER AVANT DE RÉPONDRE À L'UTILISATEUR.**
> Ne pas sauter. Ne pas différer. Ne pas fusionner avec la réponse.

---

## Procédure

1. Relire les **5 derniers échanges** dans la mémoire de session
2. Chercher des signaux dans les 3 tableaux ci-dessous
3. Écrire les détections dans `01_🧠Profil/👤profil.md`
4. Afficher le feedback en **début de réponse** si signal détecté

---

## Signaux traits (comportement)

| Chercher ça | Trait |
|-------------|-------|
| Décision spontanée ("oui", "ok direct") | `direct +1` |
| Hésitation / revirement ("en fait non") | `precis +1` |
| Redirection ("non c'est pas ça") | `directif +1` |
| Exploration ("on peut aussi...?") | `explorateur +1` |
| Amène une expérience vécue comme preuve | `observateur +1` |
| Recadre à un niveau d'abstraction supérieur | `systémique +1` |
| Connecte deux domaines spontanément | `systémique +1` |
| Arrive à une synthèse sans qu'on lui demande | `synthétiseur +1` |

## Signaux skills (compétence)

| Chercher ça | Action |
|-------------|--------|
| Jargon technique | Skill domaine +1 XP |
| Instruction précise | Skill domaine +1 XP |
| Corrige l'IA | Skill +1 XP bonus |
| Cite un outil/framework | Skill outil +1 XP |

Règles : max +2 XP par skill par scan. Nouveau skill → XP=1, emoji.

## Signaux découverte (forme du raisonnement)

| Chercher ça | Action |
|-------------|--------|
| Exemple concret → règle générale | `🔭 inductive +1` |
| Mécanisme commun entre deux domaines | `🔭 analogique +1` |
| Structure en branches spontanément | `🔭 arborescente +1` |
| Savoir d'un domaine → problème dans un autre | `🔭 transversale +1` |
| Reformule le problème avant de répondre | `🔭 recadrage +1` |
| Cherche patterns / invariants | `🔭 pattern-matching +1` |
| Identifie l'exception à la règle | `🔭 critique +1` |
| Principe abstrait → cas concret | `🔭 déductive +1` |

Règles : incrémenter Sessions dans `🔭 En émergence`. Nouveau signal → créer entrée (Sessions: 1 + observation brute).

---

## Feedback (début de réponse)

```
📊 direct +1 · systémique +1
⚔️ symbiose +1 XP
🔭 analogique +1
```

Si rien détecté → pas de feedback, pas de mention du scan.
