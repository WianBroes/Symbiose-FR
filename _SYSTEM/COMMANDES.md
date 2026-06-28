# Commandes & Triggers — Symbiose

> Tout se dit en langage naturel. Cette page liste les mots-clés reconnus et ce qu'ils déclenchent.

---

## Démarrage

| Ce que vous dites | Ce qui se passe |
|-------------------|-----------------|
| `yo` | Démarrage complet — ASCII art + validation + salut |
| `salut`, `hey`, `hi` | Démarrage discret — pas d'ASCII art, mais même logique |

---

## Fermeture

| Ce que vous dites | Ce qui se passe |
|-------------------|-----------------|
| `close` | Skill closure — macro-scan, mise à jour profil, TRANSFERT, snapshot |
| `on a fini` | Idem |
| `clôture` | Idem |

---

## Skills

| Trigger | Skill chargé | Effet |
|---------|--------------|-------|
| "importer", "indexer", "traiter l'inbox" | `import` | Convertit et indexe les fichiers de `00_📥Inbox/` |
| "exporter", "backup", "préparer pour GitHub" | `export` | Export profil + framework, prépare migration |
| "fais un dream", "consolide les observations" | `dream` | Compacte `observations.md` — appelé aussi auto toutes les 10 clôtures |
| "nouveau projet", "ajouter un dossier" | `new-project` | Crée un dossier projet selon les conventions vault |

---

## Profil & mémoire

| Ce que vous dites | Ce qui se passe |
|-------------------|-----------------|
| "analyse mes traits" | Micro-scan immédiat — met à jour `🧬 Traits` dans le profil |
| "fais le point" | Idem |
| "qu'est-ce que tu sais de moi" | Affiche le profil actif (traits + skills) |

---

## Rôles

| Ce que vous dites | Effet |
|-------------------|-------|
| "charge [nom]" | Ajoute un rôle focus à Symbiose (règles en +, jamais contre) |
| "parle comme [nom]" | Adopte le ton du rôle sans ses règles (référence légère) |
| "reviens normal" | Retire le focus, retour à Symbiose seul |
| "demande à [nom]" | Invoque un rôle en subagent (tâche isolée) |
| "nouveau rôle : [nom]" | Crée un nouveau rôle avec sa voix et sa mémoire |
| "quels sont mes rôles" | Liste les rôles disponibles |

Par défaut : rôle **Symbiose** (créé au premier démarrage).
Les rôles partagent le profil utilisateur mais ont chacun leur mémoire.

---

## Scans automatiques

- **Micro-scan** — toutes les 7 messages (kernel) → met à jour traits/skills si signal détecté
- **Macro-scan** — à chaque `close` → analyse globale de la session
- **Dream** — toutes les 10 clôtures → compacte les observations accumulées
