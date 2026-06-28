# AUTOSTART — Startup sequence

> Runs at the beginning of **every session**, triggered by the first user message.
> The user saying **"yo"** is the canonical startup signal.

---

### 1. Check

- `01_🧠Profil/👤profil.md` exists? → **Yes** → proceed to **Compact flow (section 3)**
- `01_🧠Profil/👤profil.md` exists? → **No** → proceed to **First startup (section 2)**

---

### 2. First startup 👶

1. **Display** `_SYSTEM/startup_ascii.md`
2. Run **`_SYSTEM/00_FIRST_STARTUP.md`** which:
   - Asks language preference (English / Français)
   - Scans the machine (OS, CPU, RAM, shell)
   - Asks name and short description
   - Creates user profile in `01_🧠Profil/`
   - `01_🧠Profil/👤profil.md` now serves as init marker
   - Updates `00_📥Inbox/00_TRANSFERT.md`
3. **Enchaîner immédiatement avec la validation compact** — dans la même réponse, sans rupture :
   ```
   ✓ CORE · ENV · memory · TRANSFERT · TRAITS · SKILLS | [nom]
   ```
   > Ne pas attendre un nouveau message. Le wizard et la validation forment une séquence continue.
4. **Finish with:**
   ```
   Yo [nom], système prêt.
   ```

---

### 3. Subsequent sessions — compact flow 🔁

Triggered when `👤profil.md` exists.

1. **Display** `_SYSTEM/startup_ascii.md`
2. **Detect harness** (session only — not persisted) :
   - `PI_CODING_AGENT=true` → PI
   - `CLAUDECODE=1` → Claude Code
   - sinon → Inconnu
3. **Check dream** : si `_SYSTEM/kernel/.dream_requested` existe → charger et exécuter `_SYSTEM/skills/dream/SKILL.md` avant d'appliquer le profil.
4. **Read & validate** silently:
   - `_SYSTEM/CORE.md` (section 0 — identité & projet)
   - `01_🧠Profil/👤profil.md` ← machine, user, language, traits, skills
   - `01_🧠Profil/memory/observations.md`
   - `00_📥Inbox/00_TRANSFERT.md`
5. **Read & apply profile** (cf. CORE.md section 2b) :
   - `01_🧠Profil/👤profil.md` (section 🧬 Traits) ← generate behavioral rules
   - `01_🧠Profil/👤profil.md` (section 🎯 Compétences) ← adjust depth per domain
5b. **Load active role** (focus — pas de switch) :
   - Symbiose est toujours chargé en premier : `01_🧠Profil/roles/symbiose.md` (voix racine)
   - Lire `01_🧠Profil/👤profil.md` → champ `active_role`
   - Si `active_role` est défini : charger `01_🧠Profil/roles/[active_role].md` (règles additionnelles, en + de Symbiose)
   - Si `active_role` est défini : charger `01_🧠Profil/roles/[active_role]/memory/observations.md` (mémoire propre du focus)
   - Si le fichier focus n'existe pas ou que `active_role` est vide → Symbiose seul
6. **Budget check** (silencieux) :
   ```bash
   SIZE=$(wc -c 01_🧠Profil/memory/observations.md 2>/dev/null | cut -d' ' -f1 || echo 0)
   if [ "$SIZE" -gt 10000 ]; then
     echo "BUDGET_CRITIQUE"
   elif [ "$SIZE" -gt 7000 ]; then
     echo "BUDGET_ALERTE"
   fi
   ```
   - Si `BUDGET_CRITIQUE` → avant le greeting, afficher : `🚨 Mémoire observations saturée (>10KB) — un dream de consolidation est nécessaire.`
   - Si `BUDGET_ALERTE` → sous le greeting : `⚠️ Mémoire observations ~[N]KB — pense au dream bientôt.`
   - Sinon → skip silencieux.
7. **Output** — validation compact :
   ```
   ✓ CORE · ENV · memory · TRANSFERT · TRAITS · ROLES · SKILLS | [name]
   Yo [name], système prêt.
   ```
8. **Check update** (silencieux) :
   ```bash
   git -C . rev-parse --is-inside-work-tree 2>/dev/null && \
   git fetch origin 2>/dev/null
   BEHIND=$(git rev-list HEAD..origin/master --count 2>/dev/null)
   AHEAD=$(git rev-list origin/master..HEAD --count 2>/dev/null)
   ```
   - Si `BEHIND` > 0 → afficher sous le greeting : `⬆️ Mise à jour disponible — dis "update" pour l'appliquer.`
   - Si `AHEAD` > 0 → afficher sous le greeting : `⬆️ Tu as [N] commit(s) local(aux) non poussés sur GitHub.`
   - Si les deux à 0 ou erreur (pas de git, pas de réseau) → skip silencieux, aucun message.
8b. **Check kernel** (silencieux) :
   ```bash
   KERNEL_MSG="_SYSTEM/kernel/.msg_count"
   if [ ! -f "$KERNEL_MSG" ] || [ "$(cat "$KERNEL_MSG" 2>/dev/null || echo 0)" -eq 0 ]; then
     echo "KERNEL_INACTIF"
   fi
   ```
   - Si `KERNEL_INACTIF` : l'IA analyse le harness (détecté à l'étape 2) et **propose l'installation adaptée** — pas un simple warning. Afficher sous le greeting : `⚠️ Kernel inactif — aucun micro-scan. Je te propose de l'activer pour [harness détecté].` Puis, après le greeting complet, l'IA propose l'installation avec la commande exacte (cf. `00_FIRST_STARTUP.md` section 3 pour les commandes selon le harness) et demande confirmation.
   - Si fichier présent et > 0 → skip silencieux, kernel actif.
9. **Display** TRANSFERT content visibly (below the greeting — shows current session context inline)
10. Wait for instructions. Profile rules (generated at step 5) apply for the rest of the session.

---

### 4. Greeting handler 🖐️

Applies **regardless** of startup type when the user's first message is a greeting.

| User says     | Behavior |
|---------------|----------|
| **"yo"**     | Full startup flow (ASCII + greeting) **always** — whether first or subsequent session |
| "salut", "hey", "hi", etc. | Casual greeting → normal response (no ASCII art), then execute sections 3.3 to 3.10 (read profile, validate, budget check, check update, kernel check, display TRANSFERT) |

> **Note:** "yo" is the canonical startup word. It triggers the full branded greeting every time.
> Other greetings are treated as casual conversation starter without ceremony.
