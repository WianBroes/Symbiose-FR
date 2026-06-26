# Skill — new-project

> Créer un nouveau dossier projet dans le vault selon les conventions Symbiose.
> Déclenché par : "nouveau projet", "ajouter un dossier", "créer un projet", "nouveau dossier".

---

## 1. Trouver le prochain numéro libre

```bash
ls -d [0-9][0-9]_* 2>/dev/null | sort | tail -1
```

Prendre le numéro suivant. `00_` et `01_` sont réservés système.

---

## 2. Choisir l'emoji

Demander si le domaine n'est pas évident. Référence dans `_SYSTEM/CONVENTIONS.md` :

| Domaine | Emoji |
|---------|-------|
| Code / développement | 💻 |
| Projet de vie | 🌱 |
| Finance | 💰 |
| Recherche / étude | 📚 |
| Créatif / design | 🎨 |
| Personnel | 🧑 |
| Juridique / litige | ⚖️ |

Si le domaine n'est pas dans la liste → proposer un emoji cohérent et valider avec l'utilisateur. L'ajouter ensuite à `CONVENTIONS.md`.

---

## 3. Créer la structure

**Cas A — dossier catégorie (placeholder ou domaine large) :**

```
XX_EmojiNom/
└── PROJET.md      ← basé sur _SYSTEM/_Templates/Projet.md, statut: dormant
```

**Cas B — projet concret dans une catégorie existante :**

```
XX_EmojiCategorie/
└── 🧬NomProjet/       ← emoji thématique au projet + nom en PascalCase
    └── PROJET.md      ← basé sur _SYSTEM/_Templates/Master Project.md si tech, sinon Projet.md
```

Règle : si le projet a une stack / architecture → `Master Project.md`. Sinon → `Projet.md`.

---

## 4. Remplir PROJET.md

Champs obligatoires :
- `nom` — nom court
- `statut` — `actif | dormant | archive`
- `type` — `code | dossier | vie`
- `derniere_activite` — date du jour

Champs optionnels selon contexte :
- `stack` — si projet tech
- `dependances` — si lié à d'autres projets
- `tags` — mots-clés libres

---

## 5. Icône sur les fichiers clés (optionnel)

Si l'utilisateur veut un fichier visuellement identifiable dans l'explorateur :
→ Proposer 3-4 emojis cohérents avec le domaine
→ Renommer le fichier : `👤profil.md`, `🧬Symbiose/`, etc.
→ Mettre à jour toutes les références avec `sed -i`

---

## 6. Mettre à jour le PROJET.md de la catégorie parente

Si le projet est imbriqué dans une catégorie (Cas B), mettre à jour la section `## Structure` du `PROJET.md` parent pour refléter le nouveau sous-projet.

---

## 7. Confirmer

Afficher l'arbre final du dossier créé.
