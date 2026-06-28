# CONVENTIONS — Architecture du vault

> Règles d'organisation du vault Symbiose.
> Le système est agnostique, mais ces conventions sont optimisées pour **Obsidian** (tri de l'explorateur, rendu des emoji, liens internes).
> Elles restent valides en terminal ou dans tout autre outil.

---

## Dossiers racine

Format : `XX_emoji Nom`

| Composant | Règle |
|-----------|-------|
| `XX_` | Deux chiffres + underscore — contrôle l'ordre dans l'explorateur Obsidian et `ls` |
| `emoji` | Un emoji thématique collé après le underscore — lecture d'un coup d'œil |
| `Nom` | PascalCase ou kebab-case |

**Réservés :**
- `00_` → système uniquement (`00_📥Inbox`)
- `_` (underscore en tête) → dossiers invisibles dans Obsidian (`_SYSTEM`, `_SYSTEM/_Templates`)

**Nouveaux projets :** lister la racine, prendre le prochain numéro libre à partir de `01_`.

**Emoji par domaine :**
| Domaine | Emoji |
|---------|-------|
| Juridique / litige | ⚖️ |
| Code / développement | 💻 |
| Projet de vie | 🌱 |
| Recherche / étude | 📚 |
| Finance | 💰 |
| Créatif / design | 🎨 |
| Personnel | 🧑 |

Exemples : `01_⚖️Affaire-Murphy`, `02_💻MonApp`, `03_🌱Jardin`.

---

## Fichiers

- Noms en `MAJUSCULES.md` pour les fichiers structurants d'un projet (`README`, `CHRONOLOGIE`, `ACTEURS`, `POINTS_OUVERTS`).
- Noms en `kebab-case.md` pour les notes courantes.
- Pas d'espaces dans les noms de fichiers — les liens Obsidian fonctionnent mais c'est fragile en terminal.

---

## Dossiers système

| Dossier | Rôle |
|---------|------|
| `_SYSTEM/` | Cœur du système — ne modifier que pour corriger un bug, ajouter une feature validée par le pipeline alpha, ou sur instruction explicite |
| `_SYSTEM/_Templates/` | Modèles de fichiers et de projets |
| `00_📥Inbox/` | Entrée : TRANSFERT, fichiers en attente de classement |

**Fichiers hard-lockés à la racine** (ne pas déplacer) :
- `AGENTS.md` — point d'entrée universel pour tous les outils IA
- `CLAUDE.md` — requis par Claude Code

---

## Graph Obsidian

Les dossiers `_` sont exclus du graph par défaut via `.obsidian/graph.json` :
```
-path:"_SYSTEM"
```

Le graph ne montre que les projets et leurs connexions réelles — acteurs, lieux, fichiers structurants. Les notes de travail dans `notes/` apparaissent, les fichiers système non.

**Écriture graph-friendly :**
- Personnes → `[[Prénom Nom]]`
- Lieux / entités clés → `[[Nom]]`
- Fichiers structurants du projet → liés depuis le README (`Lié à : [[CHRONOLOGIE]] · [[ACTEURS]]…`)
- Dates → texte brut, pas de liens
