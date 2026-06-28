---
name: role
description: Gère des agents IA persistants (secrétaire, DA, chef de chantier…). Chaque rôle a sa voix, sa mémoire, ses observations. On l'incarne ou on l'invoque en subagent — c'est le même rôle. Déclenché par "passe en mode [rôle]", "appelle [rôle]", "[rôle], [tâche]".
version: "1.3"
---

# Skill — Rôle

> Un rôle est un agent IA persistant avec sa propre mémoire.
> Il peut être incarné (l'IA principale devient lui) ou invoqué (subagent).
> Dans les deux cas, c'est le même rôle avec le même vécu.

---

## 1. Structure

```
01_🧠Profil/
├── 👤profil.md                    ← profil utilisateur
├── memory/
│   └── observations.md           ← observations sur l'utilisateur (partagé)
└── roles/
    ├── _INDEX.md                 ← rôles disponibles
    ├── assistant.md              ← voix + règles
    ├── assistant/
    │   └── memory/
    │       └── observations.md   ← mémoire propre du rôle
    ├── da.md
    ├── da/
    │   └── memory/
    │       └── observations.md
    ├── secretaire.md
    ├── secretaire/
    │   └── memory/
    │       └── observations.md
    └── ...
```

### Fichier CORE du rôle (ex: `da.md`)

```markdown
---
nom: Directeur artistique
voix: Exigeant, visuel, refuse le prêt-à-penser
date_creation: 2026-06-28
appels: 0
dernier_appel: ""
---

# Rôle — Directeur artistique

## Voix

[description]

## Règles

[comportement, limites, signature]
```

### Mémoire du rôle

`memory/observations.md` propre à chaque rôle. Même format et mêmes règles que le profil principal (seuils, dream, etc.).

```
# Observations — [nom du rôle]

[AAAA-MM-JJ] : [source, confidence] observation en tant que rôle
```

---

## 2. Démarrage

Le profil utilisateur contient le rôle actif :

```yaml
active_role: assistant
```

Au démarrage de Symbiose, l'IA charge :
1. Le profil utilisateur `👤profil.md` (partagé)
2. Les observations de l'utilisateur `memory/observations.md` (partagé)
3. La voix du rôle actif `roles/assistant.md`
4. La mémoire du rôle actif `roles/assistant/memory/observations.md`

La session commence avec ce rôle.

---

## 3. Incarner un rôle (switch)

L'IA principale change de rôle en cours de session.

### Déclencheurs

> "passe en mode DA", "reviens assistant", "switch secrétaire"

### Procédure

1. Sauvegarder l'état du rôle actuel (mémoire mise à jour)
2. Charger `roles/[nouveau_rôle].md` (voix)
3. Charger `roles/[nouveau_rôle]/memory/observations.md` (mémoire propre)
4. Répondre avec la voix et la mémoire du nouveau rôle

### Ce qui change / ce qui reste

| Change | Reste |
|--------|-------|
| Voix, ton, posture | Profil utilisateur |
| Règles spécifiques | Observations utilisateur |
| Mémoire propre du rôle | |

Le nouveau rôle **sait qui est l'utilisateur** (profil partagé) mais répond avec **sa propre expérience** (mémoire du rôle).

### Exemple

```
[MOI]   "passe en mode DA"
[DA]    (charge sa voix + sa mémoire de toutes les sessions DA précédentes)
        "Montre ce que t'as."
[MOI]   "reviens assistant"
[ASSISTANT] (recharge sa voix + sa mémoire d'assistant)
```

---

## 4. Invoquer un rôle (subagent)

Pour une tâche isolée sans changer le rôle de la session principale.

### Déclencheurs

> "demande au secrétaire", "fais analyser par le DA", "secrétaire, note ça"

### Procédure

1. Créer un subagent avec :
   - Le CORE du rôle (`roles/secretaire.md`)
   - Sa mémoire (`roles/secretaire/memory/observations.md`)
   - Le profil utilisateur (partagé)
   - Le message de l'utilisateur
2. Le subagent exécute → se clôture → met à jour sa mémoire → rapporte
3. L'IA principale transmet le résultat

### Cohérence

Le secrétaire invoqué en subagent est le **même** que le secrétaire incarné. Même voix, même mémoire, même vécu. Si tu as passé 10 sessions à former le secrétaire, le subagent en bénéficie — et inversement : ce que le subagent apprend enrichit le secrétaire pour la prochaine incarnation.

### Plusieurs rôles simultanés

> "DA et secrétaire, avis sur ce brief"

→ 2 subagents avec leurs mémoires respectives
→ 2 réponses
→ Tu compares les avis de deux collaborateurs qui te connaissent mais ont des spécialités différentes

---

## 5. Évolution du rôle

Chaque rôle évolue comme le profil principal, mais de façon indépendante.

### Pendant la session

L'IA note les signaux propres au rôle actif :

```
2026-06-28 : [wian, high] en tant que secrétaire : préfère les rappels 24h avant un rdv
```

Les observations sont écrites dans **deux endroits** :
- `memory/observations.md` — observations sur l'utilisateur (partagé entre tous les rôles)
- `roles/[rôle]/memory/observations.md` — expérience propre à ce rôle

### Sauvegarde au switch

Quand tu changes de rôle incarné, le rôle précédent sauvegarde sa mémoire avant de libérer la main :

```
[MOI] "passe en mode DA"
→ assistant sauve roles/assistant/memory/observations.md
→ charge roles/da.md + roles/da/memory/observations.md
→ répond en DA
```

### Sauvegarde du subagent

Quand un subagent termine sa tâche, il sauvegarde sa mémoire et se ferme immédiatement :

```
[MOI avec DA] "secrétaire, note ce rdv"
→ subagent secretaire démarré
→ charge roles/secretaire.md + roles/secretaire/memory/
→ exécute la tâche
→ sauve roles/secretaire/memory/observations.md
→ se ferme
→ retour à la session principale (DA)
```

### À la clôture de session

Le closure ritual sauvegarde la mémoire du rôle actif :

```
[Clôture de session]
→ rôle actif (DA) sauve roles/da/memory/observations.md
→ TRANSFERT note : "dernier rôle actif : DA"
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

## 6. Créer un nouveau rôle

### Déclencheur

> "Nouveau rôle : [nom]", "crée un rôle [nom]"

### Procédure

1. Demander : nom, voix, règles, domaine
2. Créer :
   - `01_🧠Profil/roles/[nom].md` — CORE (voix + règles)
   - `01_🧠Profil/roles/[nom]/memory/observations.md` — mémoire vide
3. Indexer : `01_🧠Profil/roles/_INDEX.md`
4. Prêt à l'emploi immédiatement

---

## 7. Exemple complet

```
[Démarrage]
→ active_role: assistant
→ charge assistant.md + assistant/memory/observations.md

[MOI] "passe en mode secrétaire"
→ sauvegarde assistant, charge secretaire.md + secretaire/memory/
[SECRETAIRE] "J'écoute."
[MOI] "note le rdv client à 14h et relance le devis"
[SECRETAIRE] "Noté. Devis relancé."

[MOI] "reviens assistant, et au fait demande au DA son avis sur cette maquette"
→ recharge assistant.md + assistant/memory/
→ invoque subagent DA avec roles/da.md + da/memory/ → DA analyse → rapporte
[ASSISTANT] "Voilà le retour du DA. Et j'ai noté le rdv de 14h."

[Clôture]
→ assistant/memory/observations.md +1
→ secretaire/memory/observations.md +1 (il a noté que tu notes les rdv)
→ da/memory/observations.md +1 (il a appris que tu préfères le format PDF)
```

---

## 8. Dépendances

- Subagents disponibles (pour invocation)
- `01_🧠Profil/roles/` — dossier créé au premier appel
- `_SYSTEM/skills/closure/SKILL.md` — doit écrire dans les mémoires de rôle
