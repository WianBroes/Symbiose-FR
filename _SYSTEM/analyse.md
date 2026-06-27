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
5. Si quelque chose est notable → écrire l'observation brute dans `observations.md` (une ligne, français courant).
6. **Ensuite seulement** : mapper ce qui a été vu aux compteurs (traits, skills, modes) — voir section 1b.

### 1b. Si quelque chose a été observé — incrémenter

**Traits (comportement) :**
- Comportement déjà référencé dans le profil → +1 signal
- Comportement nouveau → créer l'entrée (score 0.5, 1 signal)

**Skills (domaine) :**
- Compétence déjà référencée → +1 XP
- Nouveau skill → créer l'entrée, XP=1, choisir un emoji
- Correction de l'IA par l'utilisateur → +1 XP bonus (même si déjà au max)
- Max **+2 XP** par skill par micro-scan

**Modes de pensée (🔭 En émergence) :**
- Mode de pensée déjà vu → +1 session
- Nouveau mode → créer l'entrée (Sessions: 1 + observation brute)
- Ne jamais promouvoir vers `🧠 Modes de pensée` depuis le micro-scan — c'est le rôle du macro-scan

### 1c. Level-up

Si un skill atteint un nouveau niveau → appliquer immédiatement :
- Le nouveau niveau change mon comportement pour ce sujet **dès la prochaine réponse**
- Je régénère les règles actives pour ce skill et je les applique sur le champ

### 1d. Feedback dans la réponse

Si quelque chose a été détecté → une ligne en début de réponse :
```
📊 direct +1 · technique +1
⚔️ 🐍 Python +1 XP · 💻 Dev +1 XP
🎉 🐍 Python → Adepte ! (Nv.3) ← appliqué immédiatement
🔭 critique +1
```

Si level-up : le feedback inclut **appliqué immédiatement**.

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
4. Mettre à jour les scores

### 2a. Traits — accumulation simple

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

## 4. Scan à la demande

L'utilisateur peut demander une analyse à tout moment :
- *"Analyse mes traits"* — exécute le macro-scan immédiat
- *"Fais le point"* — idem
- *"Quels sont mes skills ?"* — lit et affiche l'état actuel

Dans ce cas, suivre la procédure de macro-scan (section 2) mais sans fermer la session.
