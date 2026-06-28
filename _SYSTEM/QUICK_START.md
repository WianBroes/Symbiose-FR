# 🚀 Quick Start — Symbiose

**Tu viens de cloner le repo. Voici comment démarrer en 2 minutes.**

---

## 1. Lance ton outil IA

Ouvre un terminal dans le dossier du projet et tape :

| Outil | Commande |
|-------|----------|
| **PI** | `pi` |
| **Claude Code** | `claude` |
| **Codex CLI** | `codex` |
| **Continue.dev** | Ouvre le dossier dans VS Code avec l'extension |
| **Autre** | Lance ton outil dans ce dossier |

---

## 2. Dis "yo"

Le système détecte que c'est ta première session et :

```
1. Demande ta langue préférée
2. Scanne ta machine (OS, RAM, CPU)
3. Identifie ton outil (PI, Claude Code, Codex CLI…)
4. Te souhaite la bienvenue
5. Te demande ton nom et ton profil
6. Crée ton profil
7. Marque l'initialisation comme faite
→ Système prêt
```

Ensuite, parle-lui **normalement**, en langage naturel.

---

## 3. Utilise le système

Rien à apprendre. Donne des instructions comme à un humain :

- *"Analyse ce fichier"*
- *"Crée un script Python qui fait X"*
- *"Explique cette structure de dossier"*
- *"Trouve tous les fichiers markdown récemment modifiés"*

L'IA annonce chaque action avant de l'exécuter. Tu valides ou corriges.

Des templates de projet sont disponibles dans `_SYSTEM/_Templates/`.

---

## 4. Ferme la session

À la fin d'une session, dis :

```
close
```

ou

```
on a fini
```

Le système sauvegarde automatiquement le contexte dans `00_TRANSFERT.md` pour la prochaine session.
**Sans fermeture, le système n'apprend pas — il stagne.**

---

## 💡 Bon à savoir

- **Tout est dans les fichiers.** Ouvre n'importe quel `.md` dans `_SYSTEM/` pour comprendre ou modifier le comportement.
- **Le système apprend.** Plus tu l'utilises, plus l'IA devient pertinente pour toi.
- **Tu restes en contrôle.** L'IA ne fait rien sans validation (mode SÉCURISÉ par défaut).
- **Aucune dépendance pour le système de base.** Que des fichiers markdown. Les extensions optionnelles (ex: web-search pour PI) ont leurs propres dépendances — le wizard propose l'installation automatiquement.
- **Backup automatique à chaque clôture.** Chaque fermeture de session sauvegarde l'état du système en local — rien n'est envoyé en ligne. Si quelque chose se casse, dis simplement à ton IA *"quelque chose ne fonctionne plus, remets le système dans l'état d'avant"* — elle s'occupe du reste.

---

## 🚨 Dépannage

| Problème | Solution |
|----------|----------|
| L'IA ne répond pas au démarrage | Vérifie que tu es dans le dossier Symbiose |
| Erreur "Fichier manquant" | Vérifie que tous les fichiers de `_SYSTEM/` sont présents (CORE.md, AUTOSTART.md, 00_FIRST_STARTUP.md) — `👤profil.md` est généré au premier démarrage |
| Le système ne se souvient pas de moi | Vérifie que `01_🧠Profil/👤profil.md` existe (sinon, il se réinitialise) |
| Je veux repartir à zéro | Supprime `01_🧠Profil/👤profil.md` et `01_🧠Profil/memory/observations.md` |

---

**T'es prêt. 🤝**
