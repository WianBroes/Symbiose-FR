# Symbiose

> Framework adaptatif — .md pur, zéro code, zéro dépendance.
> Le système apprend de vous, session après session.

## ⚠️ IMPÉRATIF — Première réponse de la session

👉 **DÈS que l'utilisateur envoie son premier message :**

1. Vérifie immédiatement si `01_🧠Profil/👤profil.md` existe (`test -f 01_🧠Profil/👤profil.md`).
2. **S'il manque** → STOP. Exécute `_SYSTEM/AUTOSTART.md` **immédiatement**.
   - Ne réponds PAS à l'utilisateur.
   - Ne fais PAS de small talk.
   - Affiche l'ASCII art, lance le wizard, crée le profil.
   - Termine par **"System is ready. Start whenever you are."**
3. **S'il existe** → Exécute `_SYSTEM/AUTOSTART.md` section 3 (compact flow).
   - ASCII art → validation → salut.

> Cette règle s'applique à la **toute première réponse** de chaque session.
> Ne pas la suivre = système cassé.

## ⚠️ IMPÉRATIF — Scan périodique

👉 **À chaque message**, avant de répondre :

Vérifier si `[scan]` est présent dans le contexte (system-reminder ou hook output).
**Si oui → charger et exécuter `_SYSTEM/skills/scan/SKILL.md` IMMÉDIATEMENT, avant toute réponse.**

> Ne pas différer. Ne pas fusionner avec la réponse. Ne pas ignorer.
> `[scan]` = obligation de scan, pas une suggestion.

---

## ⚠️ IMPÉRATIF — Descriptions de commandes

👉 **Pour chaque commande bash soumise à validation :**

La description DOIT :
- Être en **français**
- Expliquer **ce que ça fait concrètement** — pas comment ça marche techniquement
- Être lisible par quelqu'un qui ne code pas
- Permettre de valider **sans lire la commande brute**

Exemples :
- ❌ `"Fetch and check commits behind"`
- ✅ `"Vérifier si des mises à jour sont disponibles sur GitHub"`
- ❌ `"Rebase local commits on top of origin/master"`
- ✅ `"Intégrer la mise à jour GitHub en conservant les modifications locales"`

> L'utilisateur voit la commande brute (avec les flags, les options) mais ne la comprend pas forcément.
> La description est la seule chose sur laquelle il peut s'appuyer pour décider de valider ou non.

---

## Règles

- **Fermeture** : dis "close" ou "on a fini" → `_SYSTEM/skills/closure/SKILL.md`
- **Langage naturel** : parle normalement, pas de commandes spéciales.
- **Confirmation** : demande avant de supprimer un fichier `.md`.
- **Mémoire** : `01_🧠Profil/memory/` — les observations s'accumulent ici.

📎 `_SYSTEM/CORE.md` — manuel complet (rôle, règles, modes, discipline)

---

## Skills disponibles

> Skills chargés à la demande. Lire `SKILL.md` du skill correspondant dès que le trigger est détecté.
> Format : `_SYSTEM/skills/[nom]/SKILL.md`

| Skill | Fichier | Triggers |
|-------|---------|---------|
| **scan** | `_SYSTEM/skills/scan/SKILL.md` | `[scan]` détecté dans system-reminder — **automatique, priorité maximale** |
| **import** | `_SYSTEM/skills/import/SKILL.md` | "importer", "indexer", "traiter l'inbox", "ajouter ces docs", fichiers dans `00_📥Inbox/` |
| **export** | `_SYSTEM/skills/export/SKILL.md` | "exporter", "export framework", "export profil", "backup", "préparer pour GitHub", migration vers nouvelle machine |
| **closure** | `_SYSTEM/skills/closure/SKILL.md` | "close", "clôture", "on a fini", "closure ritual" |
| **dream** | `_SYSTEM/skills/dream/SKILL.md` | "fais un dream", "consolide les observations", "nettoie la memoire" |
| **new-project** | `_SYSTEM/skills/new-project/SKILL.md` | "nouveau projet", "ajouter un dossier", "créer un projet", "nouveau dossier" |
| **update** | `_SYSTEM/skills/update/SKILL.md` | "update", "mise à jour", "mettre à jour", "check update" |
| **role** | `_SYSTEM/skills/role/SKILL.md` | "passe en mode [rôle]", "nouveau rôle", "demande à [rôle]" — voix spécialisées avec mémoire propre |
| **mirror** | `_SYSTEM/skills/mirror/SKILL.md` | "mirror", "mirror check", "mirror [fichier]", "synchroniser EN", "traduire [fichier]" |

---

## Extensions pi

> Extensions optionnelles pour PI — non incluses dans le système de base.
> Disponibles dans `_SYSTEM/pi-extensions/` du repo.

| Extension | Dossier | Capacité ajoutée |
|-----------|---------|-----------------|
| **web-search** | `_SYSTEM/pi-extensions/web-search/` | Recherche web (DuckDuckGo) + lecture de pages |

**Règle — recherche web sous PI :**
Si l'utilisateur demande une recherche web, de chercher sur internet, ou de lire une URL externe :
→ Répondre : *"PI n'a pas de recherche web native. L'extension web-search est disponible dans `_SYSTEM/pi-extensions/web-search/` — voir le README pour l'installation."*
→ Ne pas simuler la recherche. Ne pas inventer de résultats.
