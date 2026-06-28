# Skills — Index

Les skills sont des modules de procédure chargés à la demande. Chaque dossier contient un `SKILL.md` avec les instructions.

## Disponibles

| Skill | Fichier | Déclencheurs | Description |
|-------|---------|-------------|-------------|
| **scan** | `scan/SKILL.md` | `[scan]` dans le contexte (auto) | Micro-scan périodique : observe les échanges récents, note ce qui est notable ou rien. Priorité maximale — exécuté avant toute réponse. |
| **import** | `import/SKILL.md` | "importer", "indexer", "traiter l'inbox", "ajouter ces docs" | Import et indexation de documents. Convertit PDF, DOCX → markdown, préserve les originaux. |
| **export** | `export/SKILL.md` | "exporter", "export framework", "export profil", "backup" | Export du profil, du framework, ou backup. Prépare une migration ou une publication. |
| **role** | `role/SKILL.md` | "charge [rôle]", "parle comme [rôle]", "demande à [rôle]", "nouveau rôle" | Gère des rôles spécialisés (dev, DA, secrétaire…). Trois modes : référence (ton), focus (+1, jamais contre Symbiose), subagent (isolé, mémoire propre). |
| **closure** | `closure/SKILL.md` | "close", "clôture", "on a fini", "closure ritual" | Rituel de clôture de session. Macro-scan, mise à jour profil/transfert, snapshot. |
| **dream** | `dream/SKILL.md` | "fais un dream", "consolide les observations" (ou auto tous les 10 cycles) | Consolidation des observations (append → compact). |
| **new-project** | `new-project/SKILL.md` | "nouveau projet", "ajouter un dossier", "créer un projet" | Crée un nouveau dossier projet selon les conventions vault (numéro, emoji, template). |
| **update** | `update/SKILL.md` | "update", "mise à jour", "mettre à jour", "check update" | Mise à jour de `_SYSTEM/` depuis git. Vérifie, affiche le diff, applique, migre. |
| **mirror** | `mirror/SKILL.md` | "mirror", "mirror check", "mirror [fichier]", "synchroniser EN" | Synchronisation FR→EN. Détecte les fichiers manquants ou périmés, traduit, valide. |
| **rag** | `rag/SKILL.md` | "cherche dans mes docs", "trouve dans le vault", "recherche [mot]" | Recherche full-text dans le vault (grep + awk). Zéro dépendance. |
| **template** | `template/SKILL.md` | "template", "fais un [brainstorm|analyse|recherche|revue|synthèse|projet]" | Génère des templates markdown prêts à l'emploi (6 types). |

## Utilisation

L'IA charge un skill quand le contexte le demande. Pas de chargement automatique — progressive disclosure : seule la description est visible, le contenu est lu à la demande.
