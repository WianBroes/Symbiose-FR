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
| "passe en mode [nom]" | Incarne le rôle — l'IA change de voix (DA, secrétaire…) |
| "reviens [nom]" | Revient au rôle précédent |
| "demande à [nom]" | Invoque un rôle en subagent (tâche isolée) |
| "nouveau rôle : [nom]" | Crée un nouveau rôle avec sa voix et sa mémoire |
| "quels sont mes rôles" | Liste les rôles disponibles |

Par défaut : rôle **Symbiose** (créé au premier démarrage).
Les rôles partagent le profil utilisateur mais ont chacun leur mémoire.

## Modes

| Ce que vous dites | Effet |
|-------------------|-------|
| "passe en autonome" | Mode AUTONOME — l'IA exécute puis documente |
| "passe en sécurisé" | Mode SÉCURISÉ — résume → valide → exécute |
| "passe en critique" | Mode CRITIQUE — challenge → valide → exécute |

Les modes sont aussi auto-détectés par les signaux de session (fichiers ouverts, type de tâche).

---

## Scans automatiques

- **Micro-scan** — toutes les 7 messages (kernel) → met à jour traits/skills si signal détecté
- **Macro-scan** — à chaque `close` → analyse globale de la session
- **Dream** — toutes les 10 clôtures → compacte les observations accumulées
