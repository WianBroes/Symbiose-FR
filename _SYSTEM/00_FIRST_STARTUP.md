# 00_FIRST_STARTUP — Wizard de premier démarrage

> S'exécute UNE FOIS lors de la toute première session.
> Configure l'environnement, détecte l'outillage, crée le profil utilisateur.

---

### 1. Préférence linguistique

```
Bienvenue dans Symbiose ! 🌍
Choisissez votre langue :
  1. English (default)
  2. Français
```

Sauvegarder la préférence dans `01_🧠Profil/👤profil.md` (champ `**Langue**` de la section 👤 Utilisateur).

### 2. Scan machine

Remplir `01_🧠Profil/👤profil.md` (section 🖥️ Machine). Exécuter **une commande à la fois** — ne pas grouper.

```bash
uname -s
```
→ Linux / Darwin / MINGW* → adapter les commandes suivantes.

**Linux :**
```bash
cat /etc/os-release | grep PRETTY_NAME
uname -r
cat /proc/cpuinfo | grep "model name" | head -1 | cut -d':' -f2 | xargs
free -h | awk '/^Mem:/{print $2}'
echo $SHELL
```

**macOS :**
```bash
sw_vers -productName
sw_vers -productVersion
uname -r
sysctl -n machdep.cpu.brand_string
echo "$(( $(sysctl -n hw.memsize) / 1073741824 )) GiB"
echo $SHELL
```

**Windows (git-bash) :**
```bash
uname -o
uname -r
wmic cpu get name 2>/dev/null || echo "N/A"
wmic computersystem get TotalPhysicalMemory 2>/dev/null || echo "N/A"
echo $SHELL
```

> Règle : une commande par appel. Si une commande échoue, continuer avec les suivantes — ne pas bloquer.

### 3. Détection de l'outil

Identifier l'outil :

```bash
echo "PI_CODING_AGENT=${PI_CODING_AGENT:-non détecté}"
echo "CLAUDECODE=${CLAUDECODE:-non détecté}"
```

| Variable          | Valeur attendue | Outil       |
|-------------------|-----------------|-------------|
| `PI_CODING_AGENT` | toute valeur    | PI          |
| `CLAUDECODE`      | `1`             | Claude Code |

**Si `CLAUDECODE=1` détecté → proposer :**

```
Claude Code détecté. Activer le kernel (micro-scans automatiques) ?
  1. Oui (recommandé)
  2. Non
```

- **Si oui** → récupérer le chemin absolu du projet (`pwd`), puis créer `.claude/settings.local.json` :
  ```bash
  PROJ=$(pwd)
  mkdir -p .claude
  cat > .claude/settings.local.json << EOF
  {
    "hooks": {
      "UserPromptSubmit": [
        {
          "matcher": "*",
          "hooks": [
            {
              "type": "command",
              "command": "bash '$PROJ/_SYSTEM/kernel/kernel.sh' && bash '$PROJ/_SYSTEM/kernel/scan-check.sh'",
              "timeout": 5
            }
          ]
        }
      ]
    }
  }
  EOF
  ```
  Confirmer : *"Kernel activé — micro-scans toutes les 10 messages."*
- **Si non** → continuer sans. Le système fonctionne, les scans se font uniquement à la clôture.

**Si `PI_CODING_AGENT` détecté → proposer :**

```
PI détecté. Extension web-search disponible (recherche DuckDuckGo + lecture de pages).
Installer maintenant ?
  1. Oui
  2. Non
```

- **Si oui** → exécuter :
  ```bash
  mkdir -p ~/.pi/agent/extensions
  cp -r _SYSTEM/pi-extensions/web-search ~/.pi/agent/extensions/web-search
  pip install duckduckgo-search
  cd ~/.pi/agent/extensions && npm install
  ```
  Confirmer : *"Extension web-search installée. Relance PI pour l'activer."*
- **Si non** → continuer sans. Rappel : disponible à tout moment dans `_SYSTEM/pi-extensions/web-search/`.

### 4. Bienvenue

> **Bienvenue dans Symbiose.**
>
> C'est un **framework adaptatif** — il apprend de vous, de vos sessions,
> de vos choix. Plus vous l'utilisez, plus il s'adapte à votre façon de travailler.
>
> **Règles de base :**
> - Parlez naturellement, comme à un humain.
> - Restez lucide et critique : je suis un outil, pas une vérité.
> - À la fin de chaque session, dites **"close"** ou **"on a fini"**.
> - Idée centrale : **vous construisez votre propre système**. Je fournis le cadre, vous remplissez le contenu.
>
> **Rien n'est figé.**
> La structure que vous voyez — dossiers, noms, catégories, règles — est un point de départ, pas une contrainte.
> Tout peut être renommé, réorganisé, supprimé ou enrichi. Il suffit de le dire.
> Le système s'adapte à vous, pas l'inverse.

### 5. Profil utilisateur

Demander :
1. **Nom ou surnom**
2. **Courte description** — qui vous êtes, ce que vous faitez, centres d'intérêt tech

Ajouter les infos collectées dans `01_🧠Profil/👤profil.md` (section `## 👤 Utilisateur` — le fichier existe déjà après le scan machine).

### 6. Configuration Obsidian

Si le vault est ouvert dans Obsidian, `.obsidian/` existe déjà. Sinon, le créer.

Créer ou mettre à jour `.obsidian/graph.json` pour exclure les dossiers système du graph :

```json
{
  "collapse-filter": true,
  "search": "-path:\"_SYSTEM\"",
  "showTags": false,
  "showAttachments": false,
  "hideUnresolved": false,
  "showOrphans": true,
  "collapse-color-groups": true,
  "colorGroups": [],
  "collapse-display": true,
  "showArrow": false,
  "textFadeMultiplier": 0,
  "nodeSizeMultiplier": 1,
  "lineSizeMultiplier": 1,
  "collapse-forces": true,
  "centerStrength": 0.518713248970312,
  "repelStrength": 10,
  "linkStrength": 1,
  "linkDistance": 250,
  "scale": 0.6666666666666666,
  "close": false
}
```

> Si `.obsidian/graph.json` existe déjà : mettre à jour uniquement le champ `"search"` sans toucher au reste.

### 7. Finalisation

Créer les fichiers suivants (gitignorés — non trackés) :

- `01_🧠Profil/index.md` — sommaire OKF listant les concepts
- `01_🧠Profil/log.md` — historique des modifications (OKF §7)
- `01_🧠Profil/👤profil.md` — sections 🖥️ Machine, 👤 Utilisateur, 🧬 Traits, 🎯 Compétences (fichier unique, créé à l'étape 2) — avec frontmatter OKF (`type: Symbiose.Profile`)
- `01_🧠Profil/memory/observations.md` — frontmatter OKF (`type: Symbiose.Memory`), contenu "*Aucune observation pour l'instant.*"
- `01_🧠Profil/memory/modes.md` — frontmatter OKF (`type: Symbiose.ModeHistory`), contenu "*Aucune session enregistrée.*"

Créer les dossiers vault (gitignorés — non trackés) avec leur `PROJET.md` :

| Dossier | nom | type | statut | description |
|---------|-----|------|--------|-------------|
| `02_🧬Symbiose/` | Symbiose | code | actif | Framework adaptatif IA — .md pur, zéro dépendance |
| `03_💻Dev/` | Dev | code | dormant | Projets de développement et code |
| `04_🌱Vie/` | Vie | vie | dormant | Projets de vie et développement personnel |
| `05_💰Finances/` | Finances | dossier | dormant | Suivi financier et patrimoine |
| `06_📚Recherche/` | Recherche | dossier | dormant | Recherches, études, apprentissages |
| `07_🎨Creatif/` | Creatif | dossier | dormant | Projets créatifs et design |

Chaque `PROJET.md` est généré depuis `_SYSTEM/_Templates/Projet.md` en remplaçant `{{NOM}}`, `{{DESCRIPTION}}`, `type`, `statut` et `derniere_activite` (date du jour). `{{TREE}}` = arbre minimal du dossier. `{{STATUT_NOTES}}` = "Aucun projet actif." sauf pour Symbiose ("Actif — admin : [nom utilisateur].").

> Ces dossiers servent de point de départ — l'utilisateur peut les renommer, en supprimer, ou en ajouter via le skill `new-project`.

Puis :
- Créer `00_📥Inbox/` et `00_📥Inbox/00_TRANSFERT.md` avec le contenu initial :
  ```
  ---
  type: Symbiose.Transfert
  updated: [date du jour]
  ---

  # TRANSFERT

  ## En chantier

  *(vide)*

  ## Résolu cette session

  - Session d'initialisation — système prêt ✓
  ```

> Puis afficher le message de bienvenue directement :
> ```
> Yo [nom], système prêt.
> System is ready. Start whenever you are.
> ```
