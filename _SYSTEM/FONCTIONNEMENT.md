# Fonctionnement — Symbiose

> Comment le système fonctionne sous le capot.

---

## Vue d'ensemble

```
Utilisateur
    │
    ▼
AGENTS.md ──── point d'entrée universel (PI, Claude Code, Cursor, Codex…)
    │
    ▼
AUTOSTART.md ── séquence de démarrage
    │
    ├── 01_🧠Profil/👤profil.md existe ?
    │       ├── Non → wizard (00_FIRST_STARTUP.md)
    │       └── Oui → compact flow (ASCII → validation → salut)
    │
    ▼
Session active
    │
    ├── Chaque message → kernel.sh (compteur) + scan-check.sh
    │       └── tous les 10 messages → [scan] → micro-scan profil
    │
    ├── Skills chargés à la demande (trigger détecté → lecture SKILL.md)
    │
    └── "close" → skills/closure/SKILL.md → macro-scan → TRANSFERT → snapshot
```

---

## Kernel

Mécanisme bash pur — indépendant de l'outil IA.

```
_SYSTEM/kernel/
├── kernel.sh       ← incrémente .msg_count de façon atomique
├── scan-check.sh   ← lit .scan_interval, émet [scan] si c'est l'heure
├── .msg_count      ← compteur partagé (ne pas toucher)
└── .scan_interval  ← intervalle en messages (défaut: 10)
```

Branché via hook `UserPromptSubmit` (Claude Code) ou extension `.pi` (PI).
L'IA reçoit `[scan]` dans le contexte quand c'est l'heure — elle ne gère pas le compteur.

---

## Profil adaptatif

Le profil émerge de l'usage — il n'est pas rempli à la main.

```
01_🧠Profil/
├── 👤profil.md        ← Machine + Utilisateur + 🧬 Traits + 🎯 Compétences
└── memory/
    ├── observations.md ← signaux bruts accumulés session après session
    └── modes.md        ← historique des modes dominants par session
```

**Cycle d'adaptation :**
1. L'IA observe des signaux pendant la session (style, domaine, rythme)
2. Micro-scan tous les 10 messages → écrit dans `observations.md`
3. Macro-scan à la clôture → consolide dans `👤profil.md` (Traits + Compétences)
4. Au démarrage suivant → l'IA lit le profil et adapte son comportement

**Traits** — comportement (direct, technique, concis…) → modifient le ton et la forme
**Compétences** — domaines (code, droit, finance…) → modifient la profondeur

---

## Skills

Modules de procédure chargés à la demande. Principe de *progressive disclosure* — seules les descriptions sont en contexte permanent, le contenu est lu quand le trigger est détecté.

```
_SYSTEM/skills/
├── _INDEX.md          ← descriptions visibles en permanence
├── import/SKILL.md
├── export/SKILL.md
├── closure/SKILL.md
├── dream/SKILL.md
└── new-project/SKILL.md
```

---

## Modes

Auto-détectés par les signaux de session. Chaque mode suggère un niveau d'autonomie.

| Mode | Signal détecté | Autonomie |
|------|---------------|-----------|
| LAB | fichiers .py/.js/.ts, shell, builds | AUTONOME |
| STRUCTUREL | uniquement .md, réorganisation | SÉCURISÉ |
| DOSSIER | sources à croiser, analyse | SÉCURISÉ |
| CRÉATION | design, écriture libre | AUTONOME |
| META | questions sur Symbiose lui-même | CRITIQUE |

Les modes se combinent. L'utilisateur peut override à tout moment.

---

## Pipeline alpha

Toute évolution du système suit un cycle de vie formalisé :

```
IDÉE → ALPHA → BETA → PRERELEASE → RELEASE
```

Géré dans `_SYSTEM/alpha/`. Évite les modifications non contrôlées du cœur du système.

---

## Reset

Supprimer `01_🧠Profil/👤profil.md` → le wizard se relance à la prochaine session.
Le système (skills, modes, kernel) survit. Seul le profil utilisateur est recréé.
