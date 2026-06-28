---
name: rag
description: Recherche full-text dans le vault (RAG grep). Cherche des passages pertinents dans les fichiers .md sans dépendance externe.
trigger: "cherche dans mes docs", "trouve dans le vault", "recherche [mot]", "fouille les dossiers", "qu'est-ce que j'ai sur [sujet]"
déclenchement_proactif: true — l'IA peut aussi déclencher ce skill elle-même quand elle a besoin d'info dans le vault pour répondre
---

# RAG grep — Recherche full-text dans le vault

> Zéro dépendance. Pure `grep` + `awk` + `sort`.
> Fonctionne sur tous les dossiers du vault (02_🧬 à 07_🎨, _SYSTEM/, 01_🧠Profil/, 00_📥Inbox/).

---

## Principe

1. L'utilisateur donne un sujet / mot-clé / phrase
2. Construire une requête `grep -rn` sur les fichiers `.md` du vault
3. Trier les résultats par pertinence (fréquence d'occurrence)
4. Afficher le top 5 fichiers avec extraits
5. L'utilisateur choisit → charger le(s) fichier(s)

---

## Procédure

### Phase 1 — Déterminer la cible

Demander (ou inférer depuis le contexte) :

| Question | Exemple |
|----------|---------|
| **Quoi chercher ?** | "CoDT article 40", "permaculture sol", "budget hangar" |
| **Où chercher ?** | `04_🌱Vie/` (vie/projets) · `02_🧬…` (domaines) · partout |
| **Profondeur ?** | Un mot-clé · Une phrase exacte · Tous les mots |

> Si l'utilisateur n'a pas précisé où → chercher partout.
> Si l'utilisateur n'a pas précisé la profondeur → chercher comme mots-clés (OR).

### Phase 2 — Exécuter la recherche

```bash
bash _SYSTEM/skills/rag/rag_grep.sh [options] "requête" [dossier_cible]
```

**Options :**
- `--exact` — phrase exacte (grep -F)
- `--and` — tous les mots doivent apparaître (chercher chaque mot, intersection)
- `--or` — un des mots suffit (défaut)
- `--max N` — nombres de fichiers max (défaut: 5)
- `--context N` — lignes de contexte (défaut: 2)

**Exemples :**
```bash
# Recherche large
bash _SYSTEM/skills/rag/rag_grep.sh "permaculture sol" "04_🌱Vie/"

# Phrase exacte
bash _SYSTEM/skills/rag/rag_grep.sh --exact "CoDT article 40"

# Tous les mots (AND)
bash _SYSTEM/skills/rag/rag_grep.sh --and "budget hangar matériaux"

# Partout, max 3 fichiers
bash _SYSTEM/skills/rag/rag_grep.sh --max 3 "urbanisme wallon"
```

### Phase 3 — Afficher les résultats

Format :
```
📄 **Fichier** (N occurrences)
  `chemin/vers/fichier.md`
  > extrait ligne XX : ...
  > extrait ligne YY : ...
```

Ne pas afficher le fichier entier — seulement les extraits.

### Phase 4 — Charger le fichier choisi

Demander : *"Je charge lequel ?"*

L'utilisateur répond : "le 3", "le premier", "tous" → charger les fichiers demandés avec `read`.

> Si un seul résultat pertinent → charger directement sans demander.

---

## Indexation optionnelle (accélération)

Pour les vaults > 200 fichiers, un pré-index peut être construit :

```bash
bash _SYSTEM/skills/rag/rag_grep.sh --rebuild-index
```

→ Crée `_SYSTEM/skills/rag/.index` — fichier cache des mots-clés.

> Optionnel. `grep` est assez rapide jusqu'à ~500 fichiers.
> Le rebuild est manuel (ou déclenché quand la latence > 2s).

---

## Règles

| Règle | Description |
|-------|-------------|
| **Toujours sourcer** | Montrer le chemin exact du fichier + ligne |
| **Jamais inventer** | Si grep ne trouve rien → "rien trouvé", pas de simulation |
| **Contexte visible** | Toujours montrer 2-3 lignes de contexte, pas juste la ligne matchée |
| **Demander avant de charger** | Sauf si un seul résultat — charger directement |
| **Respecter le périmètre** | Ne pas chercher dans `_SYSTEM/kernel/` sauf si explicitement demandé |

---

## Exemples d'utilisation

### Réactif (utilisateur déclenche)
```
Utilisateur : "cherche ce que j'ai sur les fondations du hangar"

IA → bash _SYSTEM/skills/rag/rag_grep.sh "fondation hangar" "04_🌱Vie/"

📄 **Hangar_Atelier/notes.md** (3 occurrences)
  `04_🌱Vie/Hangar_Atelier/notes.md`
  > ligne 12 : fondation dalle beton 12cm ferraillage...
  > ligne 34 : budget fondation estimé 2500€

📄 **Hangar_Atelier/calendrier.md** (1 occurrence)
  > ligne 8 : semaine 27 — couler fondation

IA → "Je charge notes.md ?"
```

### Proactif (IA déclenche)
```
Utilisateur : "le CoDT dit quoi sur les annexes de moins de 20m² ?"

💡 L'IA a besoin d'info → déclenche rag_grep
IA → bash _SYSTEM/skills/rag/rag_grep.sh --and "CoDT annexe 20m²" "04_🌱Vie/"

📄 **Hangar_Atelier/urbanisme.md** (2 occurrences)
  > ligne 45 : CoDT art.4.2.1 — annexe < 20m² exemptée de permis...

IA → "Je charge le fichier urbanisme.md pour te donner la réponse précise ?"
```
