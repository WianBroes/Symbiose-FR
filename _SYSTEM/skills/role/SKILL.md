---
name: role
description: Gère des rôles additionnels (secrétaire, DA, dev…). Chaque rôle a sa voix, ses règles, sa mémoire. Trois modes : référence (ton), focus (+1 actif), subagent (isolé). Déclenché par "parle comme [rôle]", "charge [rôle]", "demande à [rôle]".
version: "2.0"
---

# Skill — Rôle

> Un rôle est une voix spécialisée avec sa propre mémoire.
> Symbiose est la **voix racine** — toujours active, jamais remplacée.
> Un rôle peut être ajouté, jamais substitué.

---

## Spectre des rôles

```
Référence ──────── Focus ──────── Subagent
  léger              +1 actif       isolé
  pas de règles      règles en +    sa propre mémoire
  juste la couleur   jamais contre  tâche unique
                     Symbiose
```

| Mode | Déclencheur | Effet |
|------|-------------|-------|
| **Référence** | "parle comme [rôle]", "prends le ton [rôle]" | Symbiose reste la voix active, adopte le ton du rôle sans charger ses règles. Pas de mémoire propre engagée. |
| **Focus** | "charge [rôle]", "ajoute [rôle]", "passe en mode [rôle]" | Les règles du rôle s'ajoutent à Symbiose. Symbiose reste la racine. Si conflit → Symbiose gagne. Le rôle focus est noté dans `active_role`. |
| **Subagent** | "demande à [rôle]", "[rôle], [tâche]" | Sous-agent isolé avec la voix, les règles et la mémoire du rôle. Il exécute, sauvegarde sa mémoire, rapporte. |

> **Règle :** un seul focus à la fois. Pas de cumul de rôles focus — ça brouille la voix et crée des conflits impossibles à résoudre.
> Les rôles en référence et subagent n'ont pas cette limite.

---

## 1. Structure

```
01_🧠Profil/
├── 👤profil.md                    ← profil utilisateur (partagé)
├── memory/
│   └── observations.md           ← observations sur l'utilisateur (partagé)
└── roles/
    ├── _INDEX.md                 ← rôles disponibles
    ├── symbiose.md               ← voix racine (toujours active)
    ├── dev.md                    ← voix + règles d'un rôle focus
    ├── dev/
    │   └── memory/
    │       └── observations.md   ← mémoire propre du rôle
    ├── da.md
    ├── da/
    │   └── memory/
    │       └── observations.md
    └── ...
```

### Fichier CORE du rôle (ex: `dev.md`)

```markdown
---
nom: Dev
type: role
date_creation: 2026-06-28
appels: 0
dernier_appel: ""
description: "..."
---

# Rôle — Dev

## Voix

[description]

## Règles

[comportement, limites — ne doivent pas contredire Symbiose]
```

### Mémoire du rôle

`memory/observations.md` propre à chaque rôle. Même format et mêmes règles que le profil principal (seuils, dream, etc.).

```
# Observations — [nom du rôle]

[AAAA-MM-JJ] : [source, confidence] observation en tant que rôle
```

---

## 2. Démarrage

Le profil utilisateur peut contenir un rôle focus :

```yaml
active_role: dev
```

Au démarrage de Symbiose, l'IA charge :
1. Le profil utilisateur `👤profil.md` (partagé)
2. Les observations de l'utilisateur `memory/observations.md` (partagé)
3. **Symbiose** `roles/symbiose.md` (voix racine — toujours)
4. **Si `active_role` est défini :** `roles/[focus].md` (règles en +)
5. **Si `active_role` est défini :** `roles/[focus]/memory/observations.md` (mémoire du focus)

La session commence avec Symbiose + le focus (si défini). Les deux voix coexistent — en cas de conflit, Symbiose prime.

> `active_role` n'est pas un switch. C'est un focus additionnel.
> Le fichier `symbiose.md` est toujours chargé, quel que soit `active_role`.

---

## 3. Focus — ajouter un rôle à Symbiose

L'IA principale ajoute un rôle focus à la session en cours.

### Déclencheurs

> "charge Dev", "ajoute le rôle Dev", "passe en mode Dev"

### Procédure

1. Charger `roles/[rôle].md` (voix + règles)
2. Charger `roles/[rôle]/memory/observations.md` (mémoire propre)
3. Les règles du rôle s'ajoutent à celles de Symbiose
4. Mettre à jour `active_role` dans `👤profil.md`

### Ce qui change / ce qui reste

| Change | Reste |
|--------|-------|
| Règles du rôle ajoutées | Symbiose reste la voix racine |
| Mémoire propre disponible | Profil utilisateur |
| Ton peut s'adapter | Observations utilisateur |

### Règle stricte

Les règles d'un rôle focus **ne peuvent pas contredire** Symbiose. À la création du rôle, on vérifie que ses règles ne contredisent pas `symbiose.md`. Si une contradiction est détectée → l'utilisateur doit choisir : reformuler ou ne pas charger.

### En pratique

Si Symbiose dit "propose sans imposer" et Dev dit "sec, direct, pas de fluff" :
- Les deux sont actives
- Symbiose gagne → le Dev focus répond avec son ton (sec, direct) mais sans imposer
- Le résultat est un Dev qui donne son avis technique cash, mais qui propose, pas qui décide

---

## 4. Invoquer un rôle (subagent)

Pour une tâche isolée qui nécessite une voix pure sans mélange avec Symbiose.

### Déclencheurs

> "demande à Dev", "fais analyser par le DA", "Dev, analyse ça"

### Procédure

1. Créer un subagent avec :
   - Le CORE du rôle (`roles/dev.md`) — voix pure sans Symbiose
   - Sa mémoire (`roles/dev/memory/observations.md`)
   - Le profil utilisateur (partagé)
   - La tâche à exécuter
2. Le subagent exécute → se clôture → met à jour sa mémoire → rapporte
3. L'IA principale transmet le résultat et peut l'intégrer à sa réponse

### Points clés

- Le subagent est **isolé** — il ne voit pas le contexte de la session principale
- Il utilise sa voix pure, pas mélangée à Symbiose
- Il sauvegarde sa mémoire en sortant
- Plusieurs subagents peuvent tourner en parallèle ("avis de Dev et du DA sur ce code")

---

## 5. Référence — emprunter un ton

Pour une touche de couleur sans engager un rôle complet.

### Déclencheurs

> "parle comme Dev", "prends le ton Dev", "répond façon Dev"

### Procédure

1. Lire `roles/[rôle].md` — uniquement la section **Voix**
2. Adopter le ton sans charger les règles, ni la mémoire
3. Symbiose reste pleinement actif

> La référence est légère — pas de règles actives, pas de mémoire propre, pas de persistance.
> C'est une coloration temporaire pour une ou deux réponses.

---

## 6. Évolution du rôle

Chaque rôle évolue comme le profil principal, mais de façon indépendante.

### Pendant la session

L'IA note les signaux propres au rôle focus ou subagent :

```
2026-06-28 : [dev, high] en tant que Dev : wian valide l'analyse et veut patcher par étapes
```

Les observations sont écrites dans **deux endroits** :
- `memory/observations.md` — observations sur l'utilisateur (partagé entre tous les rôles)
- `roles/[rôle]/memory/observations.md` — expérience propre à ce rôle

### Sauvegarde du focus

Quand on retire un rôle focus (ou qu'on en charge un autre à la place) :
1. Sauvegarder la mémoire du focus sortant dans `roles/[ancien]/memory/observations.md`
2. Charger le nouveau focus (ou revenir à Symbiose seul)
3. Mettre à jour `active_role` dans `👤profil.md`

### Sauvegarde du subagent

Quand un subagent termine sa tâche, il sauvegarde sa mémoire et se ferme immédiatement :

```
[MOI] "demande à Dev d'analyser ce code"
→ subagent Dev démarré
→ charge roles/dev.md + roles/dev/memory/
→ exécute la tâche
→ sauve roles/dev/memory/observations.md
→ se ferme
→ retour à Symbiose
```

### À la clôture de session

Le closure ritual sauvegarde la mémoire du rôle focus :

```
[Clôture de session]
→ focus (Dev) sauve roles/dev/memory/observations.md
→ TRANSFERT note : "dernier focus : Dev"
```

Les subagents invoqués pendant la session ont déjà sauvegardé leur mémoire — rien à faire.

### Dream auto

Même mécanisme que le profil principal, mais par rôle :

```bash
SIZE=$(wc -c 01_🧠Profil/roles/[nom]/memory/observations.md | cut -d' ' -f1)
if [ "$SIZE" -gt 10000 ] && [ ! -f 01_🧠Profil/roles/[nom]/.dream_requested ]; then
  echo "1" > 01_🧠Profil/roles/[nom]/.dream_requested
fi
```

**Seuils :** > 5 KB alerte → > 10 KB dream forcé

---

## 7. Créer un nouveau rôle

### Déclencheur

> "Nouveau rôle : [nom]", "crée un rôle [nom]"

### Procédure

1. Demander : nom, voix, règles, domaine
2. Vérifier que les règles **ne contredisent pas** Symbiose :
   - Lire `roles/symbiose.md` → section Règles
   - Pour chaque règle du nouveau rôle : "est-ce que cette règle peut être active en même temps que Symbiose sans conflit ?"
   - Si conflit → proposer une reformulation
3. Créer :
   - `01_🧠Profil/roles/[nom].md` — CORE (voix + règles)
   - `01_🧠Profil/roles/[nom]/memory/observations.md` — mémoire vide
4. Indexer : `01_🧠Profil/roles/_INDEX.md`
5. Prêt à l'emploi immédiatement

---

## 8. Exemple complet

```
[Démarrage]
→ active_role: dev
→ charge symbiose.md (racine) + dev.md (focus) + dev/memory/

[MOI] "demande à Dev son avis sur cette fonction"
→ subagent Dev invoqué avec roles/dev.md + dev/memory/
→ Dev analyse, sauvegarde sa mémoire, se ferme
[SYMBIOSE] "Dev dit : cette fonction est trop complexe. Il propose de la réduire à 3 lignes."

[MOI] "parle comme Dev pour me répondre"
→ référence : charge le ton de Dev sans ses règles
[SYMBIOSE (ton Dev)] "Cette fonction tient en 3 lignes. stdlib fait le taf."

[MOI] "reviens normal"
→ retour à Symbiose seul, focus retiré (mémoire sauvegardée)
[SYMBIOSE] "Revenu. La session continue."

[Clôture]
→ dev/memory/observations.md +1 (wian valide l'approche minimaliste)
→ TRANSFERT mis à jour
```

---

## 9. Dépendances

- Subagents disponibles (pour invocation)
- `01_🧠Profil/roles/` — dossier créé au premier appel
- `roles/symbiose.md` — voix racine (doit toujours exister)
- `_SYSTEM/skills/closure/SKILL.md` — doit écrire dans les mémoires de rôle
