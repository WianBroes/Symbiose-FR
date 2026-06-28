---
name: import
description: Import and index documents into a Symbiose project. Creates a mirrored structure with originals and AI-readable markdown versions. Use when files are present in 00_📥Inbox/, or when the user says "importer", "indexer", "traiter l'inbox", "ajouter ces docs", "convertir ces fichiers", or any variant asking to bring documents into a project.
---

# Import — Indexation documentaire

Importe des fichiers dans un projet Symbiose en créant une structure miroir :
originaux préservés + versions markdown pour l'IA.

## Détection Symbiose

**Avant toute chose**, scanner `00_📥Inbox/` pour les dossiers dont le nom commence par `@user_`.

```bash
ls 00_📥Inbox/ | grep "^@user_"
```

Format du nom : `@user_[hostname]_[date]`

Si détecté → **c'est un export user Symbiose**, pas un document ordinaire.
Annoncer : **"Export user Symbiose détecté — depuis [hostname] ([date]). Importer ?"**

### Import `@user_`

Fusionner dans `01_🧠Profil/` :

**`profile/`** — fichier par fichier :
- Absent localement → copie directe
- Présent des deux côtés → afficher le diff, demander : garder local / prendre import / fusionner manuellement

**`memory/`** :
- `observations.md` → **append** (les observations s'accumulent, ne pas écraser)

Nettoyer l'inbox après import réussi.

---

## Détection contenu Symbiose

Scanner `00_📥Inbox/` pour les dossiers dont le nom suit le pattern `XX_*` (ex: `01_MonProjet`, `02_Archive`).

```bash
ls 00_📥Inbox/ | grep -E "^[0-9]{2}_"
```

Si détecté → **c'est un dossier projet Symbiose**.
Annoncer : **"Dossier projet Symbiose détecté — [nom]. Intégrer à la racine ?"**

### Import `XX_`

- Vérifier qu'un dossier du même nom n'existe pas déjà à la racine
  - Si oui → demander : remplacer / renommer / annuler
- Déplacer depuis `00_📥Inbox/[nom]/` → racine du projet
- Aucune conversion — le contenu est déjà au format Symbiose

Nettoyer l'inbox après import réussi.

---

---

## Structure cible (import documentaire)

```
[Projet]/import/[nom-import]/
├── Originaux/        ← fichiers sources, arborescence préservée
└── import MD/        ← miroir .md, même arborescence
```

## Étapes

### 1. Identifier

Scanner `00_📥Inbox/` pour les fichiers non traités (hors packages Symbiose déjà traités).
Lister et présenter à l'utilisateur pour confirmation.

### 2. Projet destination

Lister les dossiers `XX_*/` existants à la racine.
Demander : **"Quel projet destination ?"** ou proposer d'en créer un nouveau.

### 3. Mode de conversion

Demander : **"Mode d'import ?"**

Expliquer brièvement : le mode complet crée deux dossiers — `Originaux/` (fichiers intacts) + `import MD/` (versions texte lisibles par l'IA, même arborescence). Le mode originaux seulement saute la conversion.

| Type | Action |
|------|--------|
| `.pdf` | `pdftotext file.pdf -` ou `pandoc` → `.md` |
| `.docx` `.doc` `.odt` | `pandoc -t markdown` → `.md` |
| `.txt` `.md` | Copie directe |
| `.jpg` `.png` `.pptx` | Non convertible — `.md` stub uniquement |

Options (présenter dans cet ordre) :
1. **Complet — Originaux + import MD** ← défaut, proposer en premier
2. **Sélectif — choisir quels fichiers convertir**
3. **Originaux seulement — pas de conversion**

> **Invariant :** si conversion, les `.md` sont toujours des copies transformées — l'original dans `Originaux/` n'est jamais modifié. Les deux versions coexistent toujours.

### 4. Créer la structure

```bash
mkdir -p "[Projet]/import/[nom-import]/Originaux"
mkdir -p "[Projet]/import/[nom-import]/import MD"
```

> Fichier unique (pas un dossier) → nom-import = nom du fichier sans extension.

### 5. Déplacer les originaux

Déplacer depuis `00_📥Inbox/[nom-import]/` → `[Projet]/import/[nom-import]/Originaux/`.
Préserver l'arborescence interne exacte.

### 6. Convertir et créer les .md

Pour chaque fichier, créer le miroir dans `import MD/` au même chemin relatif.

Frontmatter à ajouter systématiquement :

```yaml
---
source: Originaux/[chemin-relatif]
date: [extrait du nom si format DD-MM-YY ou YYYY, sinon ~]
acteurs: []
type: [mail | lettre | juridique | rapport | brouillon | notes-perso | annexe]
statut: [converti | vide | image]
---
```

Fichiers non convertibles → stub :
```markdown
---
source: Originaux/fichier.jpg
statut: image
---
> Fichier non convertible — voir Originaux/
```

### 7. Nettoyer l'Inbox

- Supprimer le dossier traité dans `00_📥Inbox/`
- Mettre à jour `00_📥Inbox/00_TRANSFERT.md`

## Règles

- **Forward-only** — ne jamais réorganiser ce qui existe déjà dans le projet
- L'arborescence n'est **jamais aplatie** — reproduite à l'identique
- Réorganisation ultérieure = initiative de l'utilisateur, pas du système
