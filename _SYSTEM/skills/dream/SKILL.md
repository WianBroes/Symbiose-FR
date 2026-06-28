---
name: dream
description: Consolidation des observations + détection de patterns long-terme. Déclenché automatiquement toutes les 10 clôtures.
trigger: auto (dream_requested flag) | manuel ("fais un dream", "consolide les observations", "nettoie la memoire")
---

# Dream — Consolidation & détection de patterns

> Inspiré de OpenAI Dreaming V3, Claude Code AutoDream, et RecMem.
> Le rêve a deux objectifs : (1) compacter les observations, (2) détecter les patterns
> qui n'émergent qu'après plusieurs sessions.

---

## Déclencheurs

| Mode | Condition |
|------|-----------|
| **Automatique (clôture)** | Toutes les 10 clôtures, via `_SYSTEM/kernel/closure.sh` → `.dream_requested` |
| **Automatique (mémoire pleine)** | Quand `observations.md` > 5 000 bytes, via micro-scan (section 1e de `analyse.md`) → `.dream_requested` |
| **Manuel** | Utilisateur dit "fais un dream", "consolide", "nettoie la memoire" |

---

## Procédure

### Phase 1 — Lire l'existant

> 🚩 `touch _SYSTEM/alpha/.used_dream` — signale l'usage au pipeline alpha

1. Lire `01_🧠Profil/memory/observations.md` — arbre d'hypothèses 🌳 + observations brutes
2. Lire `01_🧠Profil/👤profil.md` — section 🧬 Traits, scores actuels
3. Lire `01_🧠Profil/memory/modes.md` — historique des modes
4. Lire `01_🧠Profil/👤profil.md` — section 🔭 En émergence (signaux modes de pensée accumulés)
5. Lire `01_🧠Profil/👤profil.md` — section ⚡ Synergies (synergies candidates + sessions)

### Phase 1b — Mettre à jour l'arbre d'hypothèses

L'arbre (`## 🌳 Arbre d'hypothèses`) est la structure consolidée. Après avoir lu les observations brutes :

1. **Nouvelles branches** : une observation qui apparaît 2+ sessions → créer H[N] avec statut `🔬 en test`
2. **Branches à promouvoir** : `🔬 en test` + nouveau signal confirmant → passer à `✅ confirmé` + ajouter l'insight
3. **Branches à infirmer** : contredite par l'évidence → passer à `❌ infirmé` (garde la branche, ajoute la raison)
4. **Branches à fusionner** : deux H qui pointent vers la même conclusion → merger en gardant les sous-branches
5. **Branches dormantes** : `✅ confirmé` mais non observé depuis 5+ sessions → proposer `💤 dormant` (ne pas appliquer seul)

Format des branches :
```
### H[ID]: [Titre] · [statut]
- **B[ID].[N]** · [description] → [résultat] ([preuve])
- **→ Insight** : [leçon actionnable pour l'IA]
```

### Phase 2 — Signaux faibles & patterns long-terme

Chercher dans TOUTES les observations (pas juste les récentes) :

**A. Traits manqués**
- Un comportement qui apparaît dans 3+ sessions mais n'a jamais été noté comme trait
- Ex: si l'utilisateur dit "on va faire X" dans session 1, "faut qu'on fasse X" session 3, "X est important" session 5 → trait `planificateur` non détecté
- Action : créer le trait dans `👤profil.md` (🧬 Traits) avec score initial 0.3 + notifier

**B. Patterns de raisonnement (méta-analyse)**
- Même structure de question répétée (ex: toujours "et si..." avant d'implémenter)
- Même réaction à l'erreur (ex: toujours "c'est pas ça" au lieu de "corrige X")
- Même niveau d'abstraction dominant (toujours pratique, rarement systémique)
- Action : ajouter une observation de pattern + ajuster commentaire trait si pertinent

**C. Confirmation / Infirmation de traits**
- Un trait qui n'a pas été observé depuis N sessions → notifier
- Ne pas décider seul — notifier : *"X n'a pas été observé depuis 3 sessions. Je garde le score en l'état ?"*

**D. Convergence de signaux faibles**
- Deux observations séparées qui pointent vers la même conclusion
- Ex: "préfère les solutions mécaniques" + "ne fait pas confiance à la mémoire de l'IA" → même trait `mécanicien`
- Action : fusionner les observations, ajuster le trait en conséquence

**E. Modes de pensée — promotion depuis 🔭**
- Parcourir `🔭 En émergence` : tout signal avec Sessions ≥ 3 → proposer promotion dans `🧠 Modes de pensée`
- Parcourir `🔭 En émergence` : signal présent depuis dream précédent sans progression → noter comme signal faible persistant (ne pas supprimer)
- Ne jamais promouvoir seul — proposer à l'utilisateur avec la preuve (sessions, observations)

**F. Synergies — validation long-terme**
- Parcourir `⚡ Synergies` : pour chaque synergie candidate, chercher dans les observations si elle se confirme ou se contredit sur l'ensemble des sessions
- Sessions ≥ 3 confirmées → marquer comme synergie **active** dans `⚡`
- Contredite par de nouveaux éléments → marquer `❌ infirmé` + raison (ne pas supprimer — le trace reste)
- Chercher de nouvelles synergies émergentes non détectées en closure : combinaisons entre `🧬 Traits` + `🔭 En émergence` + `🎯 Compétences` + `🧠 Modes de pensée` qui pointent vers quelque chose de cohérent sur plusieurs sessions

### Phase 3 — Consolidation (compact)

1. Regrouper les observations redondantes (même idée, formulations différentes)
2. Supprimer les doublons stricts (mot pour mot)
3. Compacter les formulations : une ligne par observation, max 200 caractères
4. Convertir les dates relatives en dates absolues (ex: "la semaine dernière" → "2026-06-11")
5. **Filtrage par confidence** :
   - Les observations `low` qui n'ont pas été confirmées depuis le dernier dream sont **proposées à l'archivage** (déplacées dans `observations_log.md` uniquement)
   - Les observations `medium` qui n'ont pas été ré-observées depuis 2+ dreams sont **déclassées en `low`**
   - Les observations `high` sont **toujours conservées**
   - Les patterns `🔬 en test` consolidés depuis ≥ 3 sessions passent en `✅ confirmé`
6. Lossless : le résultat doit contenir AU MOINS autant d'information que l'original
7. **Mise à jour de `observations_log.md`** : après le compact, ajouter une entrée dans le log :
   ```
   ## [AAAA-MM-JJ] — dream
   - [dream] Consolidation terminée : [N] observations compactées en [M], [K] archivées (low confidence), [P] motifs confirmés.
   ```

### Phase 4 — Mise à jour & notification

1. Marquer la date du dream dans `01_🧠Profil/memory/observations.md` :
   ```
   > Dernier dream : 2026-06-18
   ```
2. Si traits mis à jour → notifier
3. Si pattern détecté → notifier
4. Si trait significativement modifié → demander confirmation

### Phase 5 — Nettoyage

```bash
rm -f _SYSTEM/kernel/.dream_requested
echo 0 > _SYSTEM/kernel/.closure_count
```

---

## Règles

| Règle | Description |
|-------|-------------|
| **Jamais de décision seul** | Pattern détecté ? Le signaler, pas l'appliquer. Sauf si le pattern est confirmé 3×. |
| **Lossless** | Le dream ne supprime jamais d'information unique. Moins de mots, pas moins de sens. |
| **Dates absolues** | Toujours convertir les dates relatives. "La semaine dernière" → illisible dans 3 mois. |
| **Pas de reformulation créative** | Pas de "donc l'utilisateur est plutôt X". Compactage lexical uniquement. |
| **Pas plus d'une minute** | Si c'est long, c'est que tu réfléchis trop. Tranche vite, garde large. |

---

## Gestion des poches profil (dream)

> Rôle du dream dans le cycle de vie des poches émergentes créées en closure (scan poche).
> À activer quand au moins 2 poches existent dans `01_🧠Profil/`.

Pendant la Phase 2 du dream, après le scan des observations, vérifier aussi les poches :

1. **Poche dormante** : poche non alimentée depuis 5+ sessions → proposer archivage
2. **Fusion** : deux poches qui se recoupent fortement → proposer fusion
3. **Éclatement** : poche devenue trop large (>30 lignes) → proposer division
4. **Compact** : appliquer la règle lossless aux poches comme aux observations
5. **Obsolescence** : informations devenues fausses ou caduques → proposer mise à jour

> Ces actions sont proposées, jamais appliquées seules.

---

## Cycle de vie long-terme

```
Session 1      observations brutes
Session 2      observations brutes
Session 3      observations brutes
    ↓ (10 clôtures)
Dream #1       compact + patterns
    ↓
Session 11-20  nouvelles observations brutes
    ↓ (10 clôtures)
Dream #2       compact + patterns + vérification patterns dream #1
    ↓
... etc
```
