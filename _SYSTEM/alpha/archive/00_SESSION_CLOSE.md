# 00_SESSION_CLOSE — Closure ritual

> **Single reference for closing a session.** Execute all steps silently, display one block at end.

---

## 0. Display

Final block : checklist → what was built → what remains → observations → profile suggestion.

```
## ✅ Closure checklist
- [ ] Sections 1-3 filled
- [ ] Dominant mode noted in 01_🧠Profil/memory/modes.md
- [ ] Self-improvement for active mode(s)
- [ ] Macro-scan done (analyse.md section 2)
- [ ] Observations: X new
- [ ] Profil updated (👤profil.md sections 🧬 Traits + 🎯 Compétences)
- [ ] Pipeline alpha reviewed (promotions/abandons)
- [ ] 00_TRANSFERT.md updated
- [ ] Snapshot local (`git add "00_📥Inbox/00_TRANSFERT.md" [+ _SYSTEM/*.md si modifiés] && git commit -m "session close YYYY-MM-DD" --quiet`)
- [ ] Snapshot profil (`git add 01_🧠Profil/ && git commit -m "profile snapshot YYYY-MM-DD" --quiet`)
```

## 0b. Dominant mode (required)

Write to `01_🧠Profil/memory/modes.md` :
```
[DATE] [PROJECT] — [raw description: what we did, signals, what dominated]
```

**New mode detection:** read last 5 entries → pattern ≥2x → candidate. 3 confirmations → propose graduation → le mode est documenté dans `01_🧠Profil/memory/modes.md` avec son autonomie suggérée.

---

## 1. Trigger

User says **"close"**, **"we're done"**, or **"closure ritual"**.

## 1b. FIRST — vérifier qu'il y a du nouveau (obligatoire)

**Règle stricte — ne JAMAIS sauter cette étape. Ne JAMAIS répondre "déjà fait" sans vérifier.**

1. Quel a été le **dernier message analysé** ? (point de référence)
2. Y a-t-il des **échanges plus récents** dans cette session ?
3. Si oui → **le scan est OBLIGATOIRE**, même si un macro-scan a déjà eu lieu plus tôt
4. Si non → passer à la suite (rien de nouveau, le profil est à jour)

> **Pourquoi c'est critique :** la fin de session est le moment où l'utilisateur est le plus lucide — il relit, questionne, insiste. Les signaux les plus riches émergent souvent dans ces derniers échanges. Les sauter = perdre le meilleur de la session.

> Ne pas assumer. Vérifier. Chaque message non scanné = opportunité d'apprentissage perdue.

## 2. Macro-scan — analyse complète des nouveaux échanges

> Suivre le protocole `_SYSTEM/analyse.md` section 2 — macro-scan.
> **Ne scanner QUE les échanges non encore analysés** — pas de duplication.

**Étapes :**
1. **Relire les nouveaux échanges** — patterns, ton, signaux
2. **Consolider avec les micro-scans** déjà écrits dans 👤profil.md
3. **Appliquer l'accumulation** sur les traits
4. **Incrémenter les skills** (XP cumulatif)
5. **Détecter les level-up**
6. **Mettre à jour les règles actives** (traits + skills)
7. **Afficher le résumé visuel** (cf. analyse.md section 2d)

### 2a. Nettoyage kernel

```
echo 0 > _SYSTEM/kernel/.msg_count
```

## 3. Template

```markdown
# Session close {{DATE}} — {{TOPIC}}

**Agent:** {{ACTIVE AI}}
**Mode:** {{detected mode}}
**Triggered by:** user

---

## 1. 🔧 What was built

> Exact file paths, technical decisions, concrete results.

-

## 2. 🔶 What remains in progress

> Unresolved, known bugs, priorities (P1/P2/P3).

-

## 3. 🧠 Observations on user

> 3-5 max, only what's NEW. Format: `[observed]` / source: `[user]` `[symbiose]` `[AI]`.
> No psychologizing. Check `01_🧠Profil/` before writing.
> If you think there's nothing to observe → don't conclude alone. Ask the user.

**Avant d'écrire ici — protocole obligatoire :**
1. Relire la session entière, pas juste la fin
2. Chercher : décisions spontanées, réactions, formulations récurrentes, refus, validations immédiates
3. Lire `01_🧠Profil/memory/observations.md` — incrémenter ce qui se confirme, ajouter ce qui est nouveau
4. Incrémenter les compteurs est le minimum — identifier du nouveau est l'objectif

-
```

## 4. After closure

### 4a. Profile — suggest, don't assume

Ask: *"I have [N] observation(s) that could enrich the profile: [list]. Want me to prepare them?"*

If user says yes → update `01_🧠Profil/` and `CORE.md` section 2 if actionable rule changes. Show changes before writing.

### 4b. Profile snapshot (required)

```bash
git add 01_🧠Profil/ && git commit -m "profile snapshot YYYY-MM-DD" --quiet
```

Le profil versionné permet un rollback si une session écrase des données. Pour restaurer :
```bash
git log -- 01_🧠Profil/  # trouver le commit
```
> Ne pas snapshot si `01_🧠Profil/` n'a pas changé (git ne commit pas de toute façon).

### 4c. Transfer merge (required)

Read existing `00_📥Inbox/00_TRANSFERT.md` → merge current state :
- **Resolved** → remove
- **Progressed** → update
- **New** → add
- **Unchanged** → keep

Format :
```markdown
# TRANSFERT — {{DATE}}

**Session:** {{TOPIC}}

---

## 🔶 In progress

> 3-5 items max, prioritized. "Nothing — session wrapped" if empty.

-

## 📁 Modified files

> Exact paths.

-

## 🧠 System changes

> New rules, created/deleted files.

-
```
