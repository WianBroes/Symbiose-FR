# Fonctionnement — Symbiose

> Comment le système fonctionne sous le capot.

---

## Vue d'ensemble

```
Utilisateur
    │
    ▼
AGENTS.md ──── point d'entrée universel (PI, Claude Code, Codex CLI…)
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
    │       └── tous les 7 messages → [scan] → micro-scan profil
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
└── .scan_interval  ← intervalle en messages (défaut: 7)
```

Branché via hook `UserPromptSubmit` (Claude Code) ou extension `.pi` (PI).
L'IA reçoit `[scan]` dans le contexte quand c'est l'heure — elle ne gère pas le compteur.

**Installation :**
- **Claude Code :** `bash _SYSTEM/00_FIRST_STARTUP.md` section 3 — crée `.claude/settings.local.json` automatiquement
- **PI :** crée l'extension `.pi/extensions/symbiose-kernel.ts` (template dispo dans la section 3 de `00_FIRST_STARTUP.md`)
- **Autres outils :** le hook doit appeler `bash _SYSTEM/kernel/kernel.sh && bash _SYSTEM/kernel/scan-check.sh` après chaque message utilisateur

---

## Profil adaptatif

Le profil émerge de l'usage — il n'est pas rempli à la main.

```
01_🧠Profil/
├── 👤profil.md        ← Machine + Utilisateur + 🧬 Traits + 🎯 Compétences
└── memory/
    ├── observations.md ← signaux bruts accumulés session après session
    └── observations.md  ← observations sur l'utilisateur
```

**Cycle d'adaptation :**
1. L'IA observe des signaux pendant la session (style, domaine, rythme)
2. Micro-scan tous les 7 messages → écrit dans `observations.md`
3. Macro-scan à la clôture → consolide dans `👤profil.md` (Traits + Compétences)
4. Au démarrage suivant → l'IA lit le profil + le rôle actif et adapte son comportement

**Traits** — comportement (direct, technique, concis…) → modifient le ton et la forme
**Compétences** — domaines (code, droit, finance…) → modifient la profondeur

---

## Rôles IA

L'IA a une voix par défaut (Symbiose) et peut en adopter d'autres à la demande.

```
01_🧠Profil/
└── roles/
    ├── _INDEX.md         ← rôles disponibles
    ├── symbiose.md       ← voix par défaut (créée au premier démarrage)
    ├── symbiose/
    │   └── memory/
    │       └── observations.md  ← mémoire propre du rôle
    ├── da.md             ← rôles spécialisés (créés à la demande)
    ├── da/memory/...
    └── ...
```

**Fonctionnement :**
- Le `active_role` est stocké dans `👤profil.md`
- Chaque rôle a sa voix (fichier .md) et sa mémoire (`memory/observations.md`)
- Tous les rôles partagent le profil utilisateur — ils savent qui tu es
- On peut **charger** un rôle focus (ajouter ses règles à Symbiose, jamais à la place) ou l'**invoquer** en subagent (voix pure, tâche isolée, mémoire propre)
- À la clôture, la mémoire du rôle actif est sauvegardée

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
├── new-project/SKILL.md
└── role/SKILL.md      ← rôles IA (voix, mémoire, invocation)
```

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
Le système (skills, kernel) survit. Seul le profil utilisateur est recréé.
