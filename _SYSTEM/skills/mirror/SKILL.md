---
name: mirror
description: Synchronisation FR→EN. Détecte les fichiers manquants ou périmés, traduit à la demande, met à jour MIRROR_STATUS.
trigger: "mirror", "mirror check", "mirror [fichier]", "synchroniser EN", "traduire [fichier]"
---

# Skill — mirror

> Synchronise Symbiose-EN depuis Symbiose-FR.
> Claude traduit. Wian valide. MIRROR_STATUS est la source de vérité.

---

## Prérequis — repo EN local

```bash
FR_ROOT=$(git rev-parse --show-toplevel)
EN_ROOT="${FR_ROOT/Symbiose-FR/Symbiose-EN}"
```

Si `$EN_ROOT` n'existe pas :
```bash
gh repo clone WianBroes/Symbiose-EN "$EN_ROOT"
```
Confirmer : *"Repo EN cloné dans `$EN_ROOT`."*

---

## Commande : `mirror check`

**Objectif :** afficher ce qui est manquant ou périmé dans EN.

### 1. Lire MIRROR_STATUS

Charger `_SYSTEM/MIRROR_STATUS.md` — liste de tous les fichiers trackés.

### 2. Pour chaque ligne du tableau

```bash
CURRENT_HASH=$(git log -1 --format="%h" -- "[FR path]")
```

Comparer `CURRENT_HASH` avec le hash stocké dans MIRROR_STATUS :

| Condition | Statut affiché |
|-----------|----------------|
| Statut = `✗ —` | `✗ manquant` |
| Statut = `⚠️ ~` | `⚠️ non suivi — vérification requise` |
| Hash stocké ≠ CURRENT_HASH | `⚠️ périmé (FR: CURRENT_HASH / EN: hash stocké)` |
| Hash stocké = CURRENT_HASH | `✓ à jour` |

### 3. Afficher le rapport

```
── Mirror check ──────────────────
✗ manquants (4)
  · SECURITY.md
  · _SYSTEM/skills/scan/SKILL.md
  · _SYSTEM/skills/update/SKILL.md
  · _SYSTEM/skills/new-project/SKILL.md

⚠️ non suivis (16)
  · README.md
  · AGENTS.md
  · ...

✓ à jour (0)
──────────────────────────────────
Dis "mirror [fichier]" pour traduire.
```

---

## Commande : `mirror [fichier]`

**Objectif :** traduire un fichier FR → EN, valider, écrire, mettre à jour le statut.

Accepte : nom court (`CORE.md`), chemin FR (`_SYSTEM/CORE.md`), ou chemin EN (`_SYSTEM/COMMANDS.md`).
Résoudre via MIRROR_STATUS si chemin ambigu.

### 1. Lire le fichier FR

```bash
cat "$FR_ROOT/[FR path]"
```

### 2. Traduire

- Traduire tout le contenu en anglais
- Garder la structure identique (frontmatter, titres, tableaux, blocs de code)
- Garder les noms propres du système tels quels : noms de traits (`direct`, `systémique`...), noms de fichiers, commandes bash, chemins
- Adapter les références culturelles si nécessaire

### 3. Afficher la traduction

Afficher le contenu traduit en entier pour validation.

```
── Traduction : [fichier] ────────
[contenu traduit]
──────────────────────────────────
OK pour écrire dans EN ? (oui / corrections)
```

### 4. Écrire si validé

Si Wian dit "oui" ou équivalent :

```bash
# Créer le dossier si nécessaire
mkdir -p "$EN_ROOT/$(dirname "[EN path]")"
# Écrire le fichier
# (écrire le contenu traduit dans $EN_ROOT/[EN path])
```

### 5. Mettre à jour MIRROR_STATUS

Récupérer le hash actuel du fichier FR :
```bash
NEW_HASH=$(git log -1 --format="%h" -- "[FR path]")
```

Mettre à jour la ligne correspondante dans `_SYSTEM/MIRROR_STATUS.md` :
- Remplacer le hash par `NEW_HASH`
- Remplacer le statut par `✓ NEW_HASH`

### 6. Commit dans EN

```bash
cd "$EN_ROOT"
git add "[EN path]"
git commit -m "mirror: translate [EN path] from FR [NEW_HASH]"
```

Confirmer : *"[fichier] traduit et commité dans EN."*

---

## Notes

- Ne jamais écraser un fichier EN sans afficher la traduction et obtenir confirmation.
- **Le push GitHub (FR ou EN) est toujours à la discrétion de l'utilisateur.** L'IA ne push jamais — ni en clôture, ni après un mirror, ni pour aucune raison. Commits locaux uniquement.
- Si le fichier EN existant est différent de la traduction → afficher les deux et laisser Wian choisir.
- MIRROR_STATUS vit dans FR — c'est la source de vérité du tracking.
- Les fichiers de données personnelles (profil, memory, observations, TRANSFERT) ne sont jamais mirrorés.
