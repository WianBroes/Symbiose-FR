# CHANGELOG — Symbiose

---

## 2026-06-25

### Kernel v2 — support multi-outils

- **Atomic increment** : `kernel.sh` utilise `mkdir` comme lock (Linux, macOS, Windows git-bash)
- **`scan-check.sh`** : logique de scan extraite dans un script dédié — source unique de vérité
- **`.scan_interval`** : intervalle configurable (défaut 10), partagé entre tous les outils
- **Claude Code** : hook `UserPromptSubmit` branché sur les scripts kernel (`settings.local.json` créé par le wizard)
- **PI** : extension mise à jour pour déléguer à `scan-check.sh`

### Cross-platform

- `kernel.sh` : `flock` (Linux) → `mkdir` lock (universel)
- `backup.sh` : `date -Iseconds` → `date +%Y-%m-%dT%H:%M:%S` (universel)
- Wizard scan machine : commandes adaptées Linux / macOS / Windows

### Partage & distribution

- `CLAUDE.md` désignoré — inclus dans le repo (charge `AGENTS.md` automatiquement)
- Compteurs kernel (`msg_count`, `closure_count`) gitignorés — repartent à zéro pour chaque utilisateur
- Wizard : Claude Code détecté → création automatique du hook kernel
- README, LICENSE, CHANGELOG, CONTRIBUTING déplacés à la racine

---

## 2026-06-08

### PATCH-001 — Suppression espace dans `00_📥Inbox`

Renommé `00_📥 Inbox` → `00_📥Inbox` — élimine le backslash dans les commandes bash.

### PATCH-002 — Variable de détection Claude Code

`CLAUDE_CODE` → `CLAUDECODE` dans le wizard.

### PATCH-003 — CLAUDE.md et wizard

Wizard propose la création de `CLAUDE.md` si Claude Code détecté.

### PATCH-004 — Extensions PI

Ajout `_SYSTEM/pi-extensions/web-search/` — recherche DuckDuckGo + lecture de pages.
