# First startup — Wizard Symbiose

> Exécuté une seule fois, au premier démarrage.
> Détecté par l'absence de `01_🧠Profil/👤profil.md`.
> Installe TOUTE l'infrastructure : profil, rôles, kernel, hooks, extensions.

---

## 1. Salutation

Afficher l'ASCII art de Symbiose (`_SYSTEM/startup_ascii.md`).

## 2. Choix de la langue

```
[1] Français
[2] English
```

Attendre la réponse. La langue choisie s'applique pour le reste du wizard et devient la valeur par défaut du profil.

## 3. Profil utilisateur

Demander :
- **Nom** (obligatoire)
- **Description courte** (optionnelle)

Créer automatiquement :
- `01_🧠Profil/👤profil.md` — profil machine + utilisateur
- `01_🧠Profil/roles/symbiose.md` — voix racine
- `01_🧠Profil/roles/symbiose/memory/observations.md` — mémoire
- `01_🧠Profil/roles/_INDEX.md` — index des rôles
- `01_🧠Profil/memory/observations.md` — mémoire principale
- `00_📥Inbox/00_TRANSFERT.md` — transfert (vierge)
- `02_🧬Symbiose/COMMANDES.md` — documentation utilisateur (copié depuis `_SYSTEM/COMMANDES.md`)

<details>
<summary>Templates complets</summary>

**`👤profil.md`**
```yaml
---
type: Symbiose.Profile
version: "1.0"
format: okf-v0.1
active_role: symbiose
last_scan:
last_update:
sessions_total: 0
observations_total: 0
---

# 👤 Profil

## 🖥️ Machine

- **Shell** : `$SHELL` (détecté automatiquement)

## 👤 Utilisateur

- **Nom** : [réponse]
- **Description** : [réponse]
- **Langue** : [choix étape 2]

## 🧘 Posture

*(à remplir par l'usage)*

## 🔭 En émergence

*(vide — première session)*

## 🧬 Traits

*(aucun signaux — première session)*

## 🎯 Compétences

*(aucune XP — première session)*

## ⚡ Synergies

*(aucune — première session)*
```

**`roles/symbiose.md`**
```yaml
---
nom: Symbiose
type: root
date_creation: [date]
appels: 0
dernier_appel: ""
active: true
description: "Voix racine du framework Symbiose. Jamais remplacée."
---

# Rôle — Symbiose

Voix racine. S'adapte à l'utilisateur, pas l'inverse.
Apprend de chaque session.
Les rôles focus s'ajoutent sans remplacer ni contredire.
```

**`00_TRANSFERT.md`**
```yaml
---
type: Symbiose.Transfert
updated: [date]
---

# TRANSFERT

> Première session — aucun transfert.
```

</details>

---

## 4. Détection harness

Détecter l'outil qui exécute l'IA :

```bash
echo "PI: ${PI_CODING_AGENT:-}"  # true si PI
echo "Claude Code: ${CLAUDECODE:-}"  # 1 si Claude Code
```

| Variable | Valeur | Outil détecté |
|----------|--------|---------------|
| `PI_CODING_AGENT=true` | — | **PI** |
| `CLAUDECODE=1` | — | **Claude Code** |
| Ni l'un ni l'autre | — | **Autre** (Codex CLI, Continue…) |

Afficher l'outil détecté. Si aucun, dire "outil non reconnu — l'installation des hooks sera manuelle."

> **Outils additionnels :** si Cursor ou Windsurf sont détectés sur la machine, le wizard peut déployer leur point d'entrée (`_SYSTEM/entrypoints/` → racine du projet). Les templates existent mais ne sont pas activés par défaut.

## 5. Kernel init

Créer les compteurs kernel (ils sont gitignorés, donc absents après clone) :

```bash
echo 0 > _SYSTEM/kernel/.msg_count
echo 0 > _SYSTEM/kernel/.closure_count
rm -f _SYSTEM/kernel/.dream_requested  # nettoyage
```

Afficher : `✓ Kernel initialisé (msg_count=0, closure_count=0)`

## 6. Installation hooks (selon harness)

### 6a. PI

Créer `.pi/extensions/symbiose-kernel.ts` à partir du template système :

```bash
mkdir -p .pi/extensions
cp _SYSTEM/pi-extensions/symbiose-kernel/symbiose-kernel.ts .pi/extensions/symbiose-kernel.ts
```

> L'extension se charge automatiquement au prochain démarrage de PI.
> Elle appelle `kernel.sh` puis `scan-check.sh` après chaque message utilisateur.

**Vérification :** après copie, le fichier `.pi/extensions/symbiose-kernel.ts` doit exister.
Afficher : `✓ Hook PI installé (.pi/extensions/symbiose-kernel.ts)`

### 6b. Claude Code

Créer `.claude/settings.local.json` avec le hook `UserPromptSubmit` :

```bash
mkdir -p .claude
cat > .claude/settings.local.json << 'EOF'
{
  "hooks": {
    "UserPromptSubmit": [
      {
        "matcher": "*",
        "hooks": [
          {
            "type": "command",
            "command": "bash '_SYSTEM/kernel/kernel.sh' && bash '_SYSTEM/kernel/scan-check.sh'",
            "timeout": 5
          }
        ]
      }
    ]
  }
}
EOF
```

Afficher : `✓ Hook Claude Code installé (.claude/settings.local.json)`

### 6c. Autre outil

Afficher les instructions manuelles :

> *"Ton outil ([nom]) n'a pas d'installation automatique. Pour brancher le kernel :*
> *1. Configure un hook qui s'exécute après chaque message utilisateur*
> *2. Le hook doit appeler : `bash _SYSTEM/kernel/kernel.sh && bash _SYSTEM/kernel/scan-check.sh`*
> *3. Si scan-check.sh affiche [scan], injecte "[scan]" dans le contexte de l'IA*
> *→ Voir `_SYSTEM/kernel/` pour la documentation complète."*

## 7. Extensions PI (optionnel, si harness = PI)

Proposer :

> *"Extension **web-search** disponible — ajoute la recherche web (DuckDuckGo) et la lecture de pages à PI."*

Si oui → installer :

```bash
cp -r _SYSTEM/pi-extensions/web-search ~/.pi/agent/extensions/web-search
pip install duckduckgo-search 2>/dev/null || pip3 install duckduckgo-search
```

Afficher : `✓ Extension web-search installée`

## 8. Git (optionnel)

Vérifier si le dossier est déjà un dépôt git :

```bash
git rev-parse --is-inside-work-tree 2>/dev/null && echo "git_ok" || echo "pas_git"
```

### Si pas git → proposer :

> *"Symbiose n'est pas dans un dépôt git. Veux-tu initialiser un dépôt ?"*

Si oui :

```bash
git init
git add AGENTS.md _SYSTEM/
git commit -m "init: Symbiose framework"
```

Proposer ensuite un remote GitHub :

> *"Ajouter un remote GitHub ? (lien du repo)"*

Si l'utilisateur donne une URL → `git remote add origin [url]`

Afficher : `✓ Git initialisé`

### Si git existe → skip silencieux (pas de message). Le wizard continue.

## 9. Test intégrité

Exécuter le test système :

```bash
bash _SYSTEM/tests/test_symbiose.sh
```

Afficher le résultat. Si erreurs → les signaler avant la clôture.

## 10. Clôture — récap complet

Afficher le récap des installations :

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  ✓ Profil · Rôle Symbiose
  ✓ Harness : [PI / Claude Code / autre]
  ✓ Kernel : .msg_count · .closure_count
  ✓ Hook : [PI / Claude Code / manuel]
  ✓ Extensions : [web-search / aucune]
  ✓ Git : [initialisé / déjà présent / non]
  ✓ Tests : [N/N] ✅
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

FR: Bienvenue [nom], Symbiose est prêt.
EN: Welcome [nom], Symbiose is ready.
```

Puis afficher — en fonction de la langue :

**Français :**
> *Symbiose est un framework adaptatif. Il apprend de toi, session après session.*
> *Pour comprendre comment il fonctionne → `02_🧬Symbiose/PROJET.md`*
> *Pour une vue d'ensemble des commandes → `02_🧬Symbiose/COMMANDES.md`*
> *Besoin de rien ? Dis "yo" pour démarrer ou pose ta question directement.*
> *💡 Tu peux créer des rôles spécialisés (dev, secrétaire, DA…) — "demande à Dev", "passe en mode Dev". Voir `01_🧠Profil/roles/`.*
> *🔧 Pour de vrais sous-agents parallèles sous PI : demande à PI d'installer "amosblomqvist/pi-subagents" — il le fera tout seul. Sous Claude Code c'est natif.*

**English:**
> *Symbiose is an adaptive framework. It learns from you, session by session.*
> *To understand how it works → `02_🧬Symbiose/PROJET.md`*
> *For a command overview → `02_🧬Symbiose/COMMANDES.md`*
> *Ready to start? Say "yo" or just ask your first question.*
> *💡 You can create specialized roles (dev, secretary, AD…) — "ask Dev", "switch to Dev mode". See `01_🧠Profil/roles/`.*
> *🔧 For true parallel sub-agents under PI: just ask PI to install "amosblomqvist/pi-subagents" — it will handle it. Under Claude Code it's native.*

---

## Notes d'implémentation

- **Ordre** : suivre les étapes dans l'ordre. Ne pas fusionner.
- **Langue** : le wizard entier est dans la langue choisie à l'étape 2.
- **Erreur** : si une étape échoue (ex: `cp` impossible), signaler mais ne pas bloquer le wizard. Marquer `⚠️` dans le récap.
- **Persistence** : toutes les étapes 7-12 sont optionnelles (kernel, hooks, git) — le système fonctionne sans, mais l'expérience est réduite. Les notifier comme "recommandé" dans le récap.
