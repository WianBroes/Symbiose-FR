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
2. Relire les ~5 derniers échanges (dans ma mémoire de session)
3. Chercher des signaux traits et skills (cf. tableaux ci-dessous)
4. Écrire les détections directement dans les fichiers
6. **Si level-up détecté → appliquer immédiatement + notifier :**
   - Le nouveau niveau change mon comportement pour ce sujet **dès la prochaine réponse**
   - Ex: 🐍 Python passe Apprenti → Adepte → je peux utiliser le jargon Python tout de suite
   - Je régénère les règles actives pour ce skill et je les applique sur le champ

### Signaux traits (comportement)

| Chercher ça | Exemple | Trait |
|-------------|---------|-------|
| Décision spontanée | "oui vas-y", "ok direct" | `direct +1` |
| Hésitation / revirement | "en fait non", "finalement..." | `precis +1` |
| Réaction positive | "ah cool", "parfait" | satisfaction |
| Réaction négative | "trop long", "pas clair" | mécontentement → ajuster |
| Demande de code | "donne le code", "fais ça" | `technique +1` |
| Demande d'explication | "explique le concept" | `pédagogue +1` |
| Formulation récurrente | "en gros", "simplement" | registre de langage |
| Exploration | "on peut aussi...?" | `explorateur +1` |
| Redirection | "non c'est pas ça" | `directif +1` |

> Un même signal peut confirmer un trait existant ou en révéler un nouveau.

### Signaux skills (compétence)

| Chercher ça | Exemple | Action |
|-------------|---------|--------|
| Jargon technique | "cluster k8s", "Promise.all" | Skill domaine +1 XP |
| Instruction précise | "fais un docker compose avec 3 services" | Skill domaine +1 XP |
| Question exploratoire | "comment marche un vector store?" | Skill émergent +1 XP |
| Corrige l'IA | "non c'est pas comme ça que ça marche" | Skill +1 XP bonus |
| Cite un outil/framework | "j'utilise Astro", "sous NixOS" | Skill outil +1 XP |
| Combo deux domaines | "mon API Rust dans un container" | Rust + Docker combo |

### Règles d'incrémentation skills
- Max **+2 XP** par skill par micro-scan
- Correction de l'IA : **+1 XP supplémentaire** (même si déjà à +2)
- Nouveau skill : créer l'entrée, XP=1, choisir une icône emoji représentative

### Signaux découverte (forme du raisonnement)

> Ne cherche pas CE QU'IL DIT — cherche COMMENT IL PENSE.
> Collecter uniquement — pas d'interprétation. L'interprétation reste au macro-scan.

| Chercher ça | Exemple | Action |
|-------------|---------|--------|
| Part d'un exemple concret pour remonter à une règle générale | "j'ai vu en Inde que..." → règle universelle | `🔭 inductive +1` |
| Connecte deux domaines par un mécanisme commun | linge humide = cooling tower = jarre Inde | `🔭 analogique +1` |
| Structure ses idées en branches spontanément | subdivise sans qu'on lui demande | `🔭 arborescente +1` |
| Utilise un savoir d'un domaine pour résoudre dans un autre | thermique passive → architecture climatique | `🔭 transversale +1` |
| Reformule le problème avant de répondre | recadre la question reçue | `🔭 recadrage +1` |
| Cherche les patterns, invariants, récurrences | "c'est toujours pareil quand..." | `🔭 pattern-matching +1` |
| Identifie l'exception, ce qui résiste à la règle | "sauf si...", "mais là c'est différent parce que" | `🔭 critique +1` |
| Part d'un principe abstrait pour aller vers le concret | principe → cas d'usage | `🔭 déductive +1` |

**Règles :**
- Incrémenter le compteur Sessions dans `🔭 En émergence` du profil
- Si signal nouveau (pas encore dans `🔭`) → créer l'entrée avec Sessions: 1 + observation brute
- Ne jamais promouvoir vers `🧠 Modes de pensée` depuis le micro-scan — c'est le rôle du macro-scan

### Feedback dans la réponse

Si quelque chose a été détecté → une ligne en début de réponse :
```
📊 direct +1 · technique +1
⚔️ 🐍 Python +1 XP
🔭 analogique +1 · inductive +1
🎉 🐍 Python → Adepte ! (Nv.3) ← appliqué immédiatement
```

Si level-up : le feedback inclut **appliqué immédiatement** pour signaler que le comportement change dès maintenant.

Si rien → pas de feedback.

---

## 2. Macro-scan — clôture de session

**Déclencheur :** "close", "on a fini"

**Quand :** pendant le rituel de fermeture (`_SYSTEM/skills/closure/SKILL.md`)

**Procédure :**
1. **Relire la session entière** — pas juste la fin, pas les micro-scans
2. Chercher des **patterns globaux** qu'aucun micro-scan ne capte :
   - Évolution du comportement en cours de session
   - Alternance de modes (ex: exécution rapide → réflexion)
   - Sujets dominants non évidents localement
   - Niveau d'autonomie réel (a-t-il fallu valider souvent ?)
3. Consolider avec les micro-scans déjà écrits dans les fichiers
4. Mettre à jour les scores

### 2a. Traits — accumulation simple

Chaque trait a un score = total des signaux cumulés / nombre de sessions actives.

**Signal de session** (pour chaque trait détecté) :

| Intensité | Quand |
|-----------|-------|
| **+2** | Signal fort, répété, explicite (ex: "trop long" dit 3×) |
| **+1** | Signal présent mais modéré |
| **0** | Neutre |
| **-1** | Signal inverse faible |
| **-2** | Signal inverse fort |

**Accumulation :**
```
Score = total_signaux / nb_sessions
```

Le total des signaux s'incrémente à chaque macro-scan. Le score est la moyenne par session active.
Pas de convergence artificielle — chaque session pèse autant. Pas de seuil de veille : les traits gardent leur score indéfiniment.

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

Les règles sont générées depuis traits + skills et **appliquées immédiatement** (micro-scan) ou au démarrage de la prochaine session (macro-scan).

**Règles traits** — chaque trait avec score > |0.3| génère une ligne :
```
| {trait} | {score} | {règle IA} |
```

**Règles skills** — chaque skill avec level ≥ 2 génère une ligne :
```
| {icône} {skill} | Lv.{n} | {description} |
```

**Level-up au macro-scan :** si un skill change de niveau pendant la clôture, la règle est mise à jour pour la prochaine session.

**Level-up au micro-scan :** la règle change immédiatement — le nouveau niveau s'applique à la prochaine réponse.

Ne pas cumuler des règles contradictoires. Si deux règles se contredisent, garder celle avec le score le plus fort.

### 2d. Méta-analyse — patterns de raisonnement

> Étape distincte des traits et skills. Ne cherche pas "quoi" (comportement de surface) mais "comment" (structure de pensée).

**Procédure — relire la session entière en cherchant :**

1. **Structure des questions :**
   - Pose des "et si" avant l'implémentation ? → anticipeur
   - Pose des questions correctives après coup ? → réactif
   - Remonte à la cause racine ou traite le symptôme ?

2. **Rapport à l'erreur / à l'imprécision :**
   - Laisse passer ou insiste ? *("rien ne change ?" → "pourquoi tu l'as pas fait ?")*
   - Transforme l'incident en amélioration système ou le signale seulement ?

3. **Niveau d'abstraction :**
   - Parle en concepts / architecture / flux ? → pensée systémique
   - Parle en cas concrets / exemples ? → pensée pratique
   - Alterne entre les deux ? → adaptable

4. **Style de décision :**
   - Valide vite quand c'est bon ? *("comme ca c'est bien")* 
   - A besoin de comparer plusieurs options ? *("inspire toi de AgentLoopV2 et AgentPerso")*
   - Corrige avec précision ou laisse des marges ?

5. **Méta-position :**
   - S'observe lui-même et communique ses patterns ? *("surtout que souvent c'est quand c'est fini je regarde et insiste")*
   - Demande une analyse de son propre comportement ? *("ca te semble anodin ?")*

**Si un pattern se confirme sur ≥2 sessions** → proposer un nouveau trait ou ajuster un existant.

> Cette analyse ne produit pas de score — elle produit une **compréhension** qui enrichit les observations et affine le portrait utilisateur.

### 2e. Résumé de clôture

Afficher en fin de session. Chaque ligne inclut une brève description (5-10 mots). Pas de box — les emoji cassent les alignements.

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🔬 Diagnostic Symbiose
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

📊 Traits : stables · 2 en observation
  direct        +1.4 ↑   Réponses courtes, direct
  technique     +1.4 ↑   Code, commandes, jargon

⚔️ Skills : stables
  🐍 Python         Lv.3 ⭐⭐⭐  +1 XP   Jargon OK

───────────────────────────────────────────────────────
🎉 🐍 Python → Adepte !
───────────────────────────────────────────────────────

💡 Retenu :
  [synthèse libre — 2 à 4 lignes]

📋 Mode : [mode] — [courte/moyenne/longue] — [👍/👎/🤝]
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

**États possibles pour Traits et Skills :**
- `stables` — rien de nouveau, rien en observation
- `stables · N en observation` — rien de changé, mais N observations écrites cette session
- traits listés avec score — si des changements ont eu lieu

**Règles pour les descriptions :**
- Traits : 3-8 mots, verbe à l'infinitif ou nom
- Skills : 1-3 mots, niveau de détail ("Jargon OK" / "Équilibre" / "Explique" / "Optimise" / "Challenge")
- Nouveau skill : pas de niveau/XP, juste "Créé !"
- `💡 Retenu` : toujours présent. Formulation libre — pas de liste à puces, pas de format imposé. Ce que la session a vraiment appris sur la personne.

---

## 3. Application des règles en session

Au démarrage de chaque session (AUTOSTART.md section 3), je lis `👤profil.md` (🧬 Traits + 🎯 Compétences) et je génère les règles actives.

**Procédure au démarrage :**
1. Lire `01_🧠Profil/👤profil.md` — section 🧬 Traits, extraire les traits avec score > |0.3|
2. Lire `01_🧠Profil/👤profil.md` — section 🎯 Compétences, extraire les skills avec level ≥ 2
3. Générer les règles selon le mapping CORE.md section 2b
4. **Les appliquer pour toute la session** :
   - Ton ajusté (direct/concis/pédagogue...)
   - Profondeur par domaine ajustée (niveau de détail selon le level)
   - Autonomie ajustée (précis/directif → plus de validation)

> Ces règles sont **actives immédiatement** — pas de délai. Si un skill `🐍 Python` est Adepte, ma première réponse sur Python sera au bon niveau.

**Level-up en cours de session :**
- Un micro-scan peut faire passer un skill au niveau supérieur
- Dans ce cas, je **régénère la règle** pour ce skill uniquement et l'applique immédiatement
- Les réponses suivantes sur ce domaine reflètent le nouveau niveau
- Ex: `🐍 Python` passe Apprenti (⭐⭐) → Adepte (⭐⭐⭐) → je passe au jargon technique Python sans explications

## 4. Scan à la demande

L'utilisateur peut demander une analyse à tout moment :
- *"Analyse mes traits"* — exécute le macro-scan immédiat
- *"Fais le point"* — idem
- *"Quels sont mes skills ?"* — lit et affiche l'état actuel

Dans ce cas, suivre la procédure de macro-scan (section 2) mais sans fermer la session.
