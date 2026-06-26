---
name: export
description: Export Symbiose framework or user data. Use when the user says "exporter", "export framework", "export profil", "backup", "préparer pour GitHub", or wants to migrate to a new machine or share the framework.
---

# Export — Framework & données utilisateur

Deux modes : exporter le framework nu (GitHub-ready) ou les données personnelles (migration/backup).

## Modes

### Mode A — Framework

Produit un Symbiose vierge prêt à être cloné ou pushé sur GitHub.
Ne contient aucune donnée personnelle.

**Ce qui est copié :**
```
AGENTS.md
_SYSTEM/AUTOSTART.md
_SYSTEM/CORE.md
_SYSTEM/CONVENTIONS.md
_SYSTEM/00_FIRST_STARTUP.md
_SYSTEM/QUICK_START.md
_SYSTEM/startup_ascii.md
_SYSTEM/analyse.md
_SYSTEM/skills/
_SYSTEM/_Templates/
_SYSTEM/modes/
_SYSTEM/pi-extensions/
.gitignore
```

**Ce qui n'est PAS copié :**
- `01_🧠Profil/` (données personnelles)
- `00_📥Inbox/` (contenu)
- Dossiers projets (`XX_*/`)
- `.obsidian/`, `.claude/`, `CLAUDE.md`

**Dossier créé :** `00_📥Inbox/00_TRANSFERT.md` vide (template de démarrage)

**Nommage de la destination :** `Symbiose-framework-YYYY-MM-DD/`

---

### Mode B — Données utilisateur

Exporte `01_🧠Profil/` pour migration vers une nouvelle machine ou un nouvel outil.

**Ce qui est copié :**
```
01_🧠Profil/
  👤profil.md
  memory/
    observations.md
    modes.md
  profile/
    (tous les fichiers)
```

**Nommage de la destination :** `@user_[hostname]_YYYY-MM-DD/`
Le préfixe `@` identifie un export utilisateur Symbiose à l'import.

---

## Étapes

### 1. Identifier le mode

Demander si pas précisé :
```
Export framework (GitHub / partage) ou données utilisateur (migration / backup) ?
  1. Framework
  2. Données utilisateur
```

### 2. Destination

Demander le chemin de destination ou proposer le défaut :
- Framework : `~/Desktop/Symbiose-framework-YYYY-MM-DD/`
- Données utilisateur : `~/Desktop/@user_[hostname]_YYYY-MM-DD/`

Récupérer le hostname : `hostname`
Récupérer la date : `date +%Y-%m-%d`

### 3. Copier

**Mode A — Framework :**
```bash
DEST=~/Desktop/Symbiose-framework-$(date +%Y-%m-%d)
mkdir -p "$DEST/_SYSTEM" "$DEST/00_📥Inbox"

cp AGENTS.md "$DEST/"
cp .gitignore "$DEST/"
cp _SYSTEM/AUTOSTART.md _SYSTEM/CORE.md _SYSTEM/CONVENTIONS.md \
   _SYSTEM/00_FIRST_STARTUP.md _SYSTEM/QUICK_START.md \
   _SYSTEM/startup_ascii.md _SYSTEM/analyse.md "$DEST/_SYSTEM/"
cp -r _SYSTEM/skills "$DEST/_SYSTEM/"
cp -r _SYSTEM/_Templates "$DEST/_SYSTEM/"
cp -r _SYSTEM/modes "$DEST/_SYSTEM/"
cp -r _SYSTEM/pi-extensions "$DEST/_SYSTEM/"
```

Créer le TRANSFERT vide :
```bash
echo "# TRANSFERT" > "$DEST/00_📥Inbox/00_TRANSFERT.md"
```

**Mode B — Données utilisateur :**
```bash
HOST=$(hostname)
DATE=$(date +%Y-%m-%d)
DEST=~/Desktop/@user_${HOST}_${DATE}

cp -r 01_🧠Profil/. "$DEST"
```

### 4. Valider

Afficher l'arborescence créée :
```bash
find "$DEST" -not -path '*/.git/*' | sort
```

Confirmer : **"Export terminé → `[chemin]`"**

---

## Règles

- Ne jamais inclure `01_🧠Profil/` dans un export framework
- Ne jamais modifier les fichiers sources — copie uniquement
- Si la destination existe déjà → demander confirmation avant d'écraser
