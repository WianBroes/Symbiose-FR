# Analyse — Protocole de scan adaptatif

> Définit les deux niveaux d'analyse : micro (périodique) et macro (clôture).
> L'analyse est faite par l'IA dans la conversation — pas de LLM externe.

---

## 1. Micro-scan — périodique (tous les N messages)

**Déclencheur commun :** `[scan]` présent dans le contexte de la réponse — quelle que soit la source.

**Chaîne d'appel selon le harness :**

**PI**
1. `.pi/extensions/symbiose-kernel.ts` écoute l'événement `input` (source `interactive` uniquement)
2. Appelle `bash _SYSTEM/kernel/kernel.sh` → incrémente `.msg_count`
3. Si `count % interval == 0` → injecte un message `customType: "symbiose-scan"` contenant `[scan]`
4. L'IA lit ce message dans son contexte → détecte `[scan]` → exécute le scan

**Claude Code**
1. Hook `UserPromptSubmit` dans `.claude/settings.local.json` s'exécute avant chaque réponse
2. Appelle `bash _SYSTEM/kernel/kernel.sh` → incrémente `.msg_count`
3. Appelle `bash _SYSTEM/kernel/scan-check.sh` → si c'est l'heure, écrit `[scan]` dans stdout
4. Le harness injecte ce stdout dans le system-reminder de la réponse
5. L'IA lit le system-reminder → détecte `[scan]` → exécute le scan

**Autre outil**
Brancher un hook équivalent qui appelle les 2 scripts et injecte `[scan]` dans le contexte si stdout le contient.

**Procédure :**

1. `[scan]` détecté → lancer le scan. Sinon → ne rien faire.
2. **Observer** : relire les ~5 derniers échanges. Regarder aussi ce que j'ai construit en réponse et ce que ça dit des décisions de l'utilisateur.
3. Se poser une seule question : **"Qu'est-ce qui est notable ici ?"**
4. Si rien de notable → **ne rien faire**. Zéro est un résultat valide.
5. Si quelque chose est notable → écrire l'observation brute (une ligne, français courant).
5b. **Confidence** : auto-évaluer la fiabilité de l'observation :
    - `high` — comportement explicite, répété, ou confirmé par l'utilisateur
    - `medium` — comportement observé une fois, ou inféré depuis un échange
    - `low` — impression, doute, ou pattern naissant non confirmé
    
    Format : `[AAAA-MM-JJ] : [source, confidence] description`
    Exemple : `2026-06-28 : [symbiose, high] Wian vérifie chaque résultat ligne par ligne avant d'accorder sa confiance.`
6. **Écrire** : dans `observations.md` (compact courant) **ET** dans `observations_log.md` (historique append-only).
   - observations.md : une ligne par observation, format compact
   - observations_log.md : préfixé par `[micro-scan]`, format complet
7. **Self-check compliance** : après avoir écrit, vérifier rapidement : *"Est-ce que j'ai bien appliqué les règles actives (traits) dans mes dernières réponses ?"*
   - Si oui → rien
   - Si non → noter l'écart (pas le corriger maintenant — une ligne dans `observations.md` et `observations_log.md` : `[IA, medium] self-check : règle [trait] non respectée dans la réponse X`)
   - Le self-check prend **< 5 secondes**. Si c'est long, c'est que tu réfléchis trop. Tranche vite.
8. **Budget mémoire** : après avoir écrit, vérifier la taille de `observations.md` :
   ```bash
   wc -c 01_🧠Profil/memory/observations.md | cut -d' ' -f1
   ```
   - Si > 5 000 bytes → déclencher un dream automatique (poser `.dream_requested`)
   - Si > 3 000 bytes → alerter dans le feedback : `⚠️ Mémoire à ~[N] bytes — prochain dream bientôt`
9. **Ensuite seulement** : mapper ce qui a été vu aux compteurs (traits, skills, modes) — voir section 1b.

### 1b. Si quelque chose a été observé — incrémenter

**Traits (comportement) :**
- Comportement déjà référencé dans le profil → +1 signal
- Comportement nouveau → créer l'entrée (score 0.5, 1 signal)

**Skills (domaine) :**
- Compétence déjà référencée → +1 XP
- Nouveau skill → créer l'entrée, XP=1, choisir un emoji
- Erreur factuelle, logique erronée, ou formulation incorrecte signalée par l'utilisateur → +1 XP bonus (même si déjà au max)
- Max **+2 XP** par skill par micro-scan

**Modes de pensée (🔭 En émergence) :**
- Mode de pensée déjà vu → +1 session
- Nouveau mode → créer l'entrée (Sessions: 1 + observation brute)
- Ne jamais promouvoir vers `🧠 Modes de pensée` depuis le micro-scan — c'est le rôle du macro-scan

### 1c. Level-up

Si un skill atteint un nouveau niveau → appliquer immédiatement :
- Le nouveau niveau change mon comportement pour ce sujet **dès la prochaine réponse**
- Je régénère les règles actives pour ce skill et je les applique sur le champ

### 1d. Écriture dans observations_log.md

Chaque micro-scan qui produit une observation écrit **aussi** dans `01_🧠Profil/memory/observations_log.md`.

Format :
```
## [AAAA-MM-JJ]
- [micro-scan] [AAAA-MM-JJ] : [source, confidence] description
```

Les entrées sont **append-only** — jamais modifiées, jamais supprimées.
L'ordre chronologique permet de reconstruire l'évolution complète.

### 1e. Forgetting automatique — dream auto

Si la taille de `observations.md` dépasse 10 000 bytes, le système a besoin d'un dream pour compacter.

**Déclenchement :**
```bash
SIZE=$(wc -c 01_🧠Profil/memory/observations.md | cut -d' ' -f1)
if [ "$SIZE" -gt 10000 ] && [ ! -f _SYSTEM/kernel/.dream_requested ]; then
  echo "1" > _SYSTEM/kernel/.dream_requested
  echo "⚠️ Dream auto : observations.md > 10KB — dream déclenché au prochain démarrage."
fi
```

> Ne pas déclencher si `.dream_requested` existe déjà (évite les doubles).
> Le dream s'exécute au prochain démarrage via AUTOSTART.md.

**Coefficient de refroidissement :** le dream ne peut pas être déclenché plus d'une fois toutes les 3 sessions.
Si `.dream_requested` a été posé lors de la session N, ignorer le déclenchement auto jusqu'à la session N+3.
(Le déclenchement manuel par l'utilisateur contourne cette limite.)

### 1f. Budget token — alerte proactive

À chaque micro-scan, vérifier la taille mémoire :

```bash
wc -c 01_🧠Profil/memory/observations.md 2>/dev/null | cut -d' ' -f1 || echo 0
```

| Seuil | Action |
|-------|--------|
| > 1 000 bytes | Rien — normal |
| > 3 000 bytes | Feedback : `⚠️ Mémoire ~[N] bytes` |
| > 7 000 bytes | Feedback : `⚠️ Mémoire ~[N] bytes — le dream va bientôt être nécessaire` |
| > 10 000 bytes | Déclencher dream auto (section 1e) |
| > 15 000 bytes | Feedback critique : `🚨 Mémoire saturée > 15KB — dream nécessaire de toute urgence` |

> Le seuil de 10 000 bytes correspond à ~120-180 lignes d'observations, soit plusieurs sessions.
> Avec le dream qui compacte, on reste généralement sous les 5KB après consolidation.
> Au-delà, le contexte token commence à être impacté.

### 1g. Mode suggestion — proposer sans bloquer

Quand un micro-scan détecte un changement de trait ou skill significatif :

**NE PAS** appliquer immédiatement (sauf level-up qui a son propre mécanisme en 1c).
**NE PAS** demander validation qui bloque.

**À la place :**
1. Noter le changement proposé dans le feedback : `💡 Proposition : [trait] → +0.5 (signal observé)`
2. Laisser le trait inchangé dans `👤profil.md` **jusqu'au prochain macro-scan** (clôture)
3. Au macro-scan, présenter les propositions accumulées : *"J'ai [N] proposition(s) : [liste]. J'applique ?"*

> Le mode suggestion garde le profil stable en cours de session (pas de changement de comportement intempestif)
> tout en accumulant les signaux pour une décision consolidée à la clôture.

### 1h. Feedback dans la réponse

Si quelque chose a été détecté → une ligne en début de réponse :
```
📊 direct +1 · technique +1
⚔️ 🐍 Python +1 XP · 💻 Dev +1 XP
🎉 🐍 Python → Adepte ! (Nv.3) ← appliqué immédiatement
🔭 critique +1
💡 Proposition : systémique +0.5
⚠️ Mémoire ~3.4KB
```

Si level-up : le feedback inclut **appliqué immédiatement**.
Si proposition (mode suggestion) : préfixé par `💡`.
Si alerte mémoire : préfixé par `⚠️`.

Si rien → pas de feedback.

---

## 2. Macro-scan — clôture de session

**Déclencheur :** "close", "on a fini"

**Quand :** pendant le rituel de fermeture (`_SYSTEM/skills/closure/SKILL.md`)

**Procédure :**
1. **Relire la session entière** — pas juste la fin, pas les micro-scans
2. Chercher des **patterns globaux** qu'aucun micro-scan ne capte :
   - Évolution du comportement en cours de session
   - Alternance de modes
   - Sujets dominants
   - Niveau d'autonomie réel
   - Ce qui a été créé et ce que ça dit
3. Consolider avec les micro-scans déjà écrits
4. **Confidence globale** : pour chaque pattern détecté, lui assigner une confidence
   - Si l'utilisateur a explicitement confirmé → `high`
   - Si le pattern est apparu ≥ 3 fois dans la session → `high`
   - Si apparu 1-2 fois sans confirmation → `medium`
   - Si c'est une intuition non vérifiée → `low`
5. Mettre à jour les scores

> Les patterns à `low` confidence sont notés dans `observations_log.md` mais pas consolidés dans le profil.
> Ils seront revérifiés au prochain macro-scan.

Chaque trait a un score = total des signaux cumulés / nombre de sessions actives.

**Signal de session** (pour chaque trait détecté) :

| Intensité | Quand |
|-----------|-------|
| **+2** | Signal fort, répété, explicite |
| **+1** | Signal présent mais modéré |
| **0** | Neutre |
| **-1** | Signal inverse faible |
| **-2** | Signal inverse fort |

**Accumulation :**
```
Score = total_signaux / nb_sessions
```

Pas de convergence artificielle — chaque session pèse autant.

### 2b. Skills — XP cumulatif

Les skills **ne décroissent pas** entre sessions.

**Niveaux :**

| Niveau | Titre | XP requis |
|--------|-------|-----------|
| ⭐ | Novice | 1 |
| ⭐⭐ | Apprenti | 3 |
| ⭐⭐⭐ | Adepte | 6 |
| ⭐⭐⭐⭐ | Expert | 10 |
| ⭐⭐⭐⭐⭐ | Master | 15 |
| 👑 | Grandmaster | 21 |

```
level = floor((sqrt(1 + 8 × XP) - 1) / 2)
```

### 2c. Règles actives

Générées depuis traits + skills et appliquées au démarrage de la prochaine session (ou immédiatement pour un micro-scan level-up).

**Règles traits** — chaque trait avec score > |0.3| génère une ligne :
```
| {trait} | {score} | {règle IA} |
```

**Règles skills** — chaque skill avec level ≥ 2 génère une ligne :
```
| {icône} {skill} | Lv.{n} | {description} |
```

Ne pas cumuler des règles contradictoires. Si deux règles se contredisent, garder celle avec le score le plus fort.

### 2d. Méta-analyse — patterns de raisonnement

> Ne cherche pas CE QU'IL DIT — cherche COMMENT IL PENSE.

**Procédure — relire la session entière en s'ouvrant à :**

- **Structure des questions** — anticipe ou réagit ? Cause ou symptôme ?
- **Rapport à l'erreur** — laisse passer ou insiste ? L'incident devient amélioration ou simple signal ?
- **Niveau d'abstraction** — concepts généraux ou cas concrets ? Alterne ?
- **Style de décision** — valide vite ? Compare plusieurs options ? Corrige avec précision ou laisse des marges ?
- **Méta-position** — s'observe lui-même ? Commente ses propres patterns ?

> Cette analyse ne produit pas de score. Elle produit une compréhension qui enrichit les observations et affine le portrait.

**Si un pattern se confirme sur ≥2 sessions** → proposer un nouveau trait ou ajuster un existant.

> **Mode suggestion** : la proposition est présentée dans le résumé, pas appliquée.
> L'utilisateur valide ou non à la lecture.
> Format : `💡 Proposition : nouveau trait [nom] (confidence: [niveau]) — [preuve]`

### 2e. Résumé de clôture

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🔬 Diagnostic Symbiose
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

📊 Traits : stables · 2 en observation
  direct        +1.4 ↑   Réponses courtes, direct
  technique     +1.4 ↑   Code, commandes, jargon

⚔️ Skills : stables
  🐍 Python         Lv.3 ⭐⭐⭐  +1 XP   Jargon OK

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🎉 🐍 Python → Adepte !
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

💡 Retenu :
  [synthèse libre — 2 à 4 lignes]

📋 Mode : [mode] — [courte/moyenne/longue]
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

**États possibles :**
- `stables` — rien de nouveau
- `stables · N en observation` — N observations écrites cette session
- Traits listés avec score si changements

---

## 3. Application des règles en session

Au démarrage de chaque session (AUTOSTART.md section 3), je lis `👤profil.md` et je génère les règles actives.

**Procédure au démarrage :**
1. Lire `👤profil.md` — section 🧬 Traits, extraire traits avec score > |0.3|
2. Lire `👤profil.md` — section 🎯 Compétences, extraire skills avec level ≥ 2
3. Générer les règles selon le mapping CORE.md section 2b
4. Les appliquer pour toute la session

> Ces règles sont actives immédiatement.

**Level-up en cours de session :**
- Un micro-scan peut faire passer un skill au niveau supérieur
- Je régénère la règle pour ce skill uniquement et l'applique immédiatement
- Les réponses suivantes sur ce domaine reflètent le nouveau niveau

### 3b. Mode suggestion — mise à jour différée du profil

**Principe :** les changements de traits sont proposés, pas appliqués en cours de session.
Cela évite que le comportement de l'IA change brutalement en milieu de conversation.

| Type de changement | Comportement | Délai d'application |
|---------------------|-------------|---------------------|
| Level-up skill | Appliqué immédiatement (1c) | Immédiat |
| Nouveau trait | Proposé dans feedback (💡) | Macro-scan (clôture) |
| Ajustement trait existant | Proposé dans feedback (💡) | Macro-scan (clôture) |
| Confirmation utilisateur explicite | Appliqué immédiatement | Immédiat |

**À la clôture :**
1. Lire toutes les propositions accumulées dans le feedback de la session
2. Les présenter dans le résumé : *"J'ai [N] proposition(s) pour le profil : [liste]. OK ?"*
3. Appliquer seulement après validation

> Exception : si l'utilisateur dit explicitement "applique" en cours de session, c'est appliqué.
> Le mode suggestion est un **défaut**, pas une règle absolue.

## 4. Scan à la demande

L'utilisateur peut demander une analyse à tout moment :
- *"Analyse mes traits"* — exécute le macro-scan immédiat
- *"Fais le point"* — idem
- *"Quels sont mes skills ?"* — lit et affiche l'état actuel

Dans ce cas, suivre la procédure de macro-scan (section 2) mais sans fermer la session.
