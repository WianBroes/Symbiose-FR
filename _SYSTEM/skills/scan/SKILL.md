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
| Décrit un concept visuel complet en une phrase | `👁️ œil +1` |
| Itère jusqu'à satisfaction esthétique (pas technique) | `👁️ œil +1` |

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
| Part de l'image mentale, choisit les outils après | `🔭 vision-driven +1` |

Règles : incrémenter Sessions dans `🔭 En émergence`. Nouveau signal → créer entrée (Sessions: 1 + observation brute).

## Détection ouverte (OBLIGATOIRE)

> Les tableaux ci-dessus listent des signaux **connus**. Mais les vrais signaux sont ceux qu'on n'a pas encore identifiés.

**Après avoir checké les 3 tableaux, se poser :**

> *"Y a-t-il quelque chose dans ces échanges qui ne rentre dans aucune case, mais qui est notable ?"*

Une attitude, une formulation, un mode de pensée, une réaction — qui n'est pas dans les tableaux mais qui pourrait devenir un nouveau signal.

**Si oui :**
1. Formuler le nouveau signal en une ligne
2. Ajouter dans `🔭 En émergence` du profil (Sessions: 1)
3. Noter l'observation brute dans `observations.md`

> Ne pas forcer. Mais ne pas fermer. Les tableaux sont une base, pas une limite.

**Cas typiques qui passent entre les mailles :**
- Une réaction émotionnelle inattendue (surprise, frustration, admiration)
- Une métaphore récurrente ("c'est comme...")
- Un mode de décision (essai-erreur ? planification ? intuition ?)
- Un rapport à la complexité (simplifie ou complexifie ?)

---

## Feedback (début de réponse)

```
📊 direct +1 · systémique +1
⚔️ symbiose +1 XP
🔭 analogique +1
```

Si rien détecté → pas de feedback, pas de mention du scan.
