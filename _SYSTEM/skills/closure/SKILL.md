---
name: closure
description: Session closure ritual. Macro-scan, TRANSFERT, snapshot. Triggered by "close", "clôture", "on a fini", "closure ritual".
trigger: close|clôture|cloture|on a fini|closure|closure ritual
---

# Closure — Rituel de fin de session

> **Lire ce fichier en entier.** Ne pas sauter d'étapes. Ne pas improviser.
> La clôture est le seul moment où le système apprend de la session.
> Sans elle, le système stagne.

## Déclencheur mécanique

Quand l'utilisateur dit "cloture" (ou tout autre trigger) :

1. **Lire ce fichier.** `read _SYSTEM/skills/closure/SKILL.md`. Pas de mémoire, pas de résumé.
2. **Exécuter la checklist.** Chaque étape dans l'ordre, une par une.
3. **Ne pas décider.** Si c'est écrit, c'est fait. Si c'est pas écrit, c'est pas fait.
4. **Ne pas adapter.** Pas de "cette fois c'est particulier". Le rituel est le même à chaque fois.

> La seule exception : une étape qui dit explicitement "skip si X".

---

**Exécution silencieuse.** Toutes les étapes s'exécutent en silence. Un seul bloc propre affiché à la fin (section 3). Pas de texte intermédiaire, pas de confirmation entre les étapes.

## Checklist — afficher en tête du bloc final

```
✅ Checklist clôture
- [ ] Macro-scan complet (traits · skills · découverte · synergies · question libre)
- [ ] Mode dominant noté dans modes.md
- [ ] Auto-amélioration mode actif (section 2b)
- [ ] Questions en suspens vérifiées (section 6b)
- [ ] Profil mis à jour (profil.md — traits, skills, émergence, synergies)
- [ ] Observations ajoutées (observations.md)
- [ ] Mémoire du rôle actif sauvegardée (roles/[active_role]/memory/)
- [ ] Pipeline alpha révisé (section 7)
- [ ] TRANSFERT mis à jour (section 6)
- [ ] Kernel closure.sh exécuté (section 8)
- [ ] Snapshot git commit local (section 9)
```

Toutes les cases doivent être cochées avant d'afficher le bloc. Si une étape a été skippée pour une raison valide, la noter explicitement (`~[ ] raison`).

---

## 0. Vérification — contenu nouveau (OBLIGATOIRE)

**Ne jamais répondre "déjà fait" sans vérifier.**

1. Quel a été le **dernier message analysé** par le dernier micro-scan ?
2. Y a-t-il des échanges **plus récents** dans cette session ?
3. Si oui → le scan est OBLIGATOIRE
4. Si non → passer à la suite

> Les derniers échanges sont les plus riches — l'utilisateur relit, questionne, insiste.

---

## 1. Macro-scan — analyse complète

### 1a. Relire la session entière

Dans ma mémoire, parcourir la session. Se poser 3 questions :

1. **Quand il a été confronté à une limite ou une erreur cette session, qu'est-ce qu'il a regardé en premier ?**
   → L'outil, lui-même, la situation, le système, le timing ?

2. **Quand il a pris une décision, elle venait d'où ?**
   → D'une exploration préalable, d'une certitude, d'un rejet itératif, d'un principe ?

3. **Qu'est-ce qui l'a arrêté ou relancé cette session ?**
   → Qu'est-ce qui a fermé un sujet ou en a ouvert un nouveau.

4. **Qu'est-ce qu'il a répété sans le dire explicitement ?**
   → Pas ce qu'il a dit — ce qu'il m'a fait faire. Le geste qui traverse ses corrections.

**Répondre en phrases, pas en catégories.** Les étiquettes viennent après.

### 1b. Comportements observés

Relire les moments clés de la session. Se poser :

> *"Quand il a interagi — avec moi, avec un problème, avec une limite — qu'est-ce qu'il a fait concrètement ?"*

Noter en une phrase par comportement. Pas de traduction en trait — juste le geste.

Exemples (pour la forme, pas pour la catégorie) :
- *"Quand l'IA s'est trompé, il a pointé la structure qui a rendu l'erreur possible, pas l'erreur elle-même."*
- *"Il a dit 'non' trois fois de suite sur le même point sans s'énerver, jusqu'à ce que ça soit juste."*
- *"Il a exploré 6 options en 2 messages avant de dire oui à la 7e."*

### 1c. Domaines mobilisés

Relire les sujets abordés. Se poser :

> *"De quoi il a parlé, et à quel niveau de profondeur ?"*

Noter le domaine et le niveau :
- *"Régulation urbanisme wallon — détails sur les articles du CoDT"*
- *"Budget immobilier — chiffres précis, frais notaire, mensualités"*
- *"Conception de système mémoire — architecture, cycle de vie, synchronisation"*

Ces phrases nourrissent les skills. Pas de traduction automatique.

### 1d. Appliquer l'accumulation

```
Score = total_signaux_cumulés / nb_sessions_actives
```

Chaque signal détecté en session s'ajoute au total cumulé du trait.
Le score est la moyenne par session — stable, différencié, sans convergence artificielle.

### 1e. Forme du raisonnement

> Ce scan cherche **comment** il pense, pas ce qu'il sait. Remplir uniquement si signal observé — ne pas forcer.

Relire les échanges où il a expliqué, questionné ou résolu quelque chose. Se poser :

> *"Par où il est rentré dans le problème ?"*

Noter le mouvement, pas l'étiquette :
- *"Il est parti d'un exemple concret (une annonce) pour remonter au système (le CoDT)."*
- *"Il a comparé deux options en les faisant tourner mentalement avant de choisir."*
- *"Il a identifié ce qui ne collait pas dans mon explication avant de dire ce qui était juste."*

**Règle de promotion :**
- Même pattern observé ≥ 3 sessions distinctes → proposer comme mode de pensée
- Ne jamais promouvoir sur déclaration de l'utilisateur — observation uniquement

### 1f. Question libre

### 1g. Question libre — qu'est-ce que j'ai appris sur lui ?

Se poser **une seule question, sans format imposé :**

> *"Qu'est-ce que j'ai appris sur cette personne cette session ?"*

Répondre librement — pas de tableau, pas de catégorie, pas de signal à cocher. Ce que la session a révélé sur qui elle est, comment elle pense, ce qui compte pour elle. Des choses qui ne seraient pas apparues dans un scan mécanique.

Écrire la réponse dans `memory/observations.md` — brut, tel quel, sans reformater.
Attribuer la source : `[symbiose]` si ça émerge de l'interaction, `[IA]` si c'est une projection à vérifier.

> C'est l'IA qui analyse, pas l'utilisateur. La valeur vient de cette asymétrie.

### 1g. Scan poches émergentes (profil)

> Après la question libre (1f), avant le scan synergies (1h). Les fichiers sont mis à jour en 1i.

**Quand :** à chaque clôture, après la question libre.

**Procédure :**

1. Relire les observations **ajoutées cette session** dans `observations.md`
2. Lister les thèmes qui se dégagent (pas de catégories pré-définies)
3. Regarder ce qui existe déjà comme poches dans `01_🧠Profil/`
   → `ls 01_🧠Profil/[0-9]*.md` (fichiers numérotés comme `00_Index.md`, `01_*.md`, etc.)
4. **Si un thème revient ≥ 3 fois dans les observations de la session**
   → et qu'il n'a pas encore de poche dédiée
   → proposer dans le bloc final : *"J'ai [N] observations sur [thème]. Je crée une poche ?"*
5. **Si validation** → créer le fichier `01_🧠Profil/[NUM]_[Theme].md` + l'indexer dans `00_Index.md`
   → Copier les observations concernées dans la poche (ne pas les supprimer d'observations.md)
6. **Si le thème existe déjà** (poche existante) → ne rien faire, les observations y seront ajoutées à la prochaine validation
7. **Si pas assez de signal** → rien. Les observations restent dans `observations.md` jusqu'à la prochaine session.

**Règle :** jamais de création sans validation. Jamais de poche vide. Zéro catégorie pré-créée.

**Note cycle de vie :** une fois que des poches existent, le dream (tous les 10 cycles) gère la consolidation long-terme — compactage, fusion, éclatement, archivation. Voir `_SYSTEM/skills/dream/SKILL.md` § Gestion des poches profil.

---

### 1h. Scan synergies

> Après avoir scanné traits, skills, et modes de pensée séparément — regarder les combinaisons.
> Ne pas forcer. Seulement si une combinaison pointe vers quelque chose que les éléments seuls ne montrent pas.

**Question :** *"Y a-t-il 2-3 éléments de dimensions différentes qui se renforcent et pointent dans la même direction ?"*

**Si oui :**
1. Nommer le pattern (une formule courte, pas une étiquette)
2. Lister les éléments qui le composent
3. Formuler la piste — une direction, pas une conclusion
4. Ajouter dans `⚡ Synergies` du profil

**Règle de promotion :**
- Synergie observée sur 1 session → noter dans `⚡ Synergies` (Sessions: 1)
- Confirmée sur 2+ sessions distinctes → piste **active** (indiquer dans la colonne Piste)
- Contredite par de nouveaux éléments → marquer `❌ infirmé` + raison (ne pas supprimer — le trace reste)

**Exemples de combinaisons à surveiller :**

| Combinaison | Piste possible |
|-------------|----------------|
| `observateur` + `analogique` + `systémique` | Traducteur de savoirs — tire des lois du réel, les transfère entre domaines |
| `direct` + `synthétiseur` + `arborescente` | Architecte de solutions — structure vite, décide sans perdre la nuance |
| `explorateur` + `transversale` + `inductive` | Apprend en connectant — pas en accumulant |
| `precis` + `systémique` + `recadrage` | Penseur critique — voit la limite d'un modèle avant les autres |

> Ces exemples sont des amorces, pas des règles. Le système construit ses propres combinaisons depuis les éléments réels observés.

### 1i. Mettre à jour les fichiers

Appliquer toutes les détections des étapes précédentes, dans cet ordre :

1. **1b (comportements)** → écrire dans `observations.md` chaque phrase notée, préfixée par `Comportement :`
2. **1c (domaines)** → écrire dans `observations.md` chaque domaine noté, préfixé par `Domaine :`
3. **1e (raisonnement)** → écrire dans `observations.md` chaque pattern noté, préfixé par `Raisonnement :`
4. **1f (question libre)** → écrire dans `observations.md` brut, tel quel
5. **1g (poches)** → créer le fichier si validé
6. **1h (synergies)** → ajouter dans `👤profil.md` (⚡ Synergies)
7. Mettre à jour les scores traits dans `👤profil.md` (🧬 Traits)
8. Mettre à jour les XP skills dans `👤profil.md` (🎯 Compétences)
9. Mettre à jour `👤profil.md` (🔭 En émergence) — incrémenter sessions
9b. **Sauvegarder la mémoire du rôle actif** :
   - Lire `01_🧠Profil/👤profil.md` → champ `active_role`
   - Écrire les observations de la session dans `01_🧠Profil/roles/[active_role]/memory/observations.md`
   - Ne pas dupliquer ce qui est déjà dans `01_🧠Profil/memory/observations.md`
   - Si le rôle a été changé en session : chaque rôle utilisé reçoit ses observations
10. **Écrire dans `observations_log.md`** : chaque ligne écrite en 1-4 est **aussi** écrite dans le log, préfixée par `[macro-scan]` :
    ```
    ## [AAAA-MM-JJ] — macro-scan
    - [macro-scan] [AAAA-MM-JJ] : [source, confidence] description
    ```
    > Le log est append-only. Chaque macro-scan ajoute une section datée.
    > Le compact (`observations.md`) peut changer, le log ne change jamais.

> C'est ici que tout ce qui a été détecté en 1b-1h est écrit. Si une détection n'a pas encore été écrite, elle l'est maintenant. **Pas de détection sans trace écrite.**

### 1j. Notifier les changements significatifs

- Level-up de skill → notifier
- Nouveau trait → notifier
- Trait significativement modifié → notifier

---

## 2. Mode dominant

Écrire dans `01_🧠Profil/memory/modes.md` :

```
[DATE] [PROJET] — [description: ce qu'on a fait, signaux, mode dominant]
```

Vérifier les 5 dernières entrées — si pattern ≥ 2 → proposer graduation.

### 2b. Auto-amélioration du mode actif

Pour chaque mode détecté cette session, lire `_SYSTEM/modes/[MODE].md` et se poser 3 questions :
1. Une règle a-t-elle **manqué** — quelque chose qu'on aurait eu besoin de préciser ?
2. Une règle était-elle **inutile ou contra-productive** cette session ?
3. Un **signal de détection nouveau** est-il apparu ?

Si oui → mettre à jour le fichier directement. Annoncer dans le bloc final.
Si non → skip silencieux.

---

## 3. Afficher le résumé

Format obligatoire — pas de variation :

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🔬 Diagnostic Symbiose
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

📊 Traits :
  [trait]  [+/-score]  [description]

⚔️ Skills :
  [icône] [nom]  Lv.[n]  +[n] XP  [description]

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
📊 Score session :
  • Précision règles : [N]/10 — [justification 1 phrase]
  • Pertinence obs. : [N]/10 — [justification 1 phrase]
  • Adaptation mode : [N]/10 — [justification 1 phrase]
  • **Total : [N]/30 ([N]%)**
  _Auto-évalué via self-checks + qualité des observations._

📋 Mode : [mode]
Session : [courte/moyenne/longue] — [👍/👎/🤝]

🗒️ Journal IA :
  Décisions : [ce qui a été choisi et pourquoi — si non-évident]
  Non-décisions : [ce qui a été écarté et pourquoi]
  Méthodes échouées : [approches qui n'ont pas fonctionné cette session]
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

> Le journal IA est vide si la session n'a pas produit de décisions notables. Ne pas forcer.
> Le score session est auto-évalué : basé sur les self-checks (précision), la pertinence des observations écrites (pertinence), et
> l'adéquation du comportement au mode détecté (adaptation). La tendance sur plusieurs sessions est plus parlante que le score isolé.

---

## 4. Nettoyage kernel

```bash
echo 0 > _SYSTEM/kernel/.msg_count
```

---

## 5. Profil — mode suggestion

> Application du mode suggestion défini dans `_SYSTEM/analyse.md` §3b.

1. Lister toutes les **propositions accumulées** en cours de session (via feedback 💡 des micro-scans)
2. Ajouter les **patterns du macro-scan** qui méritent un changement de trait
3. Formuler : *"J'ai [N] proposition(s) pour le profil cette session : [liste avec confidence]. J'applique ?"*
4. Si oui → montrer les changements avant d'écrire, puis appliquer
5. Si non → ne pas insister. Les propositions restent en attente pour la prochaine session.

> Le mode suggestion remplace l'ancien "proposer (ne pas imposer)".
> La différence : les propositions sont accumulées en continu dans la session, pas seulement à la clôture.

---

## 6. TRANSFERT — mise à jour

Lire `00_📥Inbox/00_TRANSFERT.md` → fusionner l'état courant :
- **Résolu** → supprimer
- **Avancé** → mettre à jour
- **Nouveau** → ajouter
- **Inchangé** → garder

**Contrainte :** max 5 items dans "En chantier". "Rien — session bouclée" si vide.

---

## 6b. Questions en suspens

**Détection pendant la session :** repérer les moments où l'utilisateur (ou l'IA) a répondu "je sais pas", "peut-être", "pas sûr", "j'hésite" — signaux naturels d'incertitude non résolue.

**À la clôture :**

1. Si des signaux d'incertitude ont été détectés → proposer : *"Tu as dit 'je sais pas' sur [X]. Je l'ajoute dans les questions en suspens ?"*
2. Vérifier si `00_📥Inbox/QUESTIONS_EN_SUSPENS.md` existe :
   - **Si absent et question à ajouter** → créer le fichier, y ajouter la question
   - **Si présent** → parcourir chaque question ouverte : une piste a-t-elle émergé pendant cette session, même indirectement ? Si oui → noter la piste, signaler dans le bloc final
   - **Si absent et rien à ajouter** → skip silencieux

> Ce mécanisme repose sur la sédimentation : une réponse à un problème latent remonte quand elle est prête, pas quand on cherche. Rien à retenir, rien à déclencher — le signal "je sais pas" existe déjà dans la conversation naturelle.

**Format du fichier :**
```markdown
# Questions en suspens

## [question ou problème ouvert]
> Ouvert le : [date]
> Piste : [si une piste a émergé — sinon laisser vide]
```

---

## 7. Pipeline alpha — review automatique

**Obligatoire.** Le pipeline vit ou meurt ici.

1. Lire `_SYSTEM/alpha/00_INDEX.md`
2. Pour chaque feature en 🔬 ALPHA / 🧪 BETA / 🚦 PRERELEASE :
   - Vérifier si `_SYSTEM/alpha/.used_[nom]` existe → feature **utilisée** cette session
   - Vérifier avec `00_TRANSFERT.md` si les fichiers ont été modifiés → feature **modifiée**
3. **Règles de compteur :**
   - Si **modifiée** → reset compteur à 0
   - Si **utilisée** (flag présent) → incrémenter compteur (+1) + supprimer le flag
   - Si **ni modifiée ni utilisée** → compteur inchangé
4. **Seuils de promotion :**
   - 🔬 ALPHA → 🧪 BETA : 3 sessions d'usage sans bug
   - 🧪 BETA → 🚦 PRERELEASE : 5 sessions d'usage sans bug (cumul BETA)
   - 🚦 PRERELEASE → ✅ RELEASE : proposer à l'utilisateur
5. **Abandon :** si une feature n'a pas été utilisée depuis 5+ sessions → proposer l'abandon
   - Si compteur 0 et sessions ≥ 3 sans usage ni modif → proposer l'abandon
6. Mettre à jour `00_INDEX.md` + nettoyer les flags `.used_*`
7. Notifier : *"Pipeline alpha : [X] promue(s), [Y] proposée(s) à l'abandon."*

> Chaque feature pose son propre flag quand elle s'exécute : `touch _SYSTEM/alpha/.used_[nom]`
> La clôture lit les flags, incrémente, puis les supprime. Automatique, sans question.

---

## 8. Compteur de clôture

```bash
bash _SYSTEM/kernel/closure.sh
```

> Incrémente `.closure_count`. Toutes les 10 clôtures, pose `.dream_requested` pour le prochain démarrage.

Toutes les 10 clôtures, `.dream_requested` est posé → l'IA lance un dream de consolidation au prochain démarrage.

---

## 9. Snapshot — profil + système

```bash
git add [fichiers _SYSTEM/ modifiés]
git add [fichiers 01_🧠Profil/ modifiés]
git diff --cached --quiet || git commit -m "session close YYYY-MM-DD" --quiet
```

> `01_🧠Profil/` n'est plus exclu du snapshot — les commits de profil permettent de revenir en arrière
> sur un changement de trait ou une consolidation de dream qui ne conviendrait pas.
> `.gitignore` mis à jour en conséquence.
> Si pas de git → skip silencieux.
