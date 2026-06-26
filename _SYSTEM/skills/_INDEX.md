# Skills — Index

Les skills sont des modules de procédure chargés à la demande. Chaque dossier contient un `SKILL.md` avec les instructions.

## Disponibles

| Skill | Fichier | Description |
|-------|---------|-------------|
| **import** | `import/SKILL.md` | Import et indexation de documents. Convertit PDF, DOCX → markdown, préserve les originaux. |
| **export** | `export/SKILL.md` | Export du profil, du framework, ou backup. Prépare une migration ou une publication. |
| **closure** | `closure/SKILL.md` | Rituel de clôture de session. Macro-scan, traits, skills, TRANSFERT, snapshot. Déclenché par "close", "clôture", "on a fini". |
| **dream** | `dream/SKILL.md` | Consolidation des observations (append → compact). Déclenché automatiquement toutes les 10 clôtures, ou manuellement par "fais un dream". |
| **new-project** | `new-project/SKILL.md` | Créer un nouveau dossier projet selon les conventions vault (numéro, emoji, template, icône). Déclenché par "nouveau projet", "ajouter un dossier", "créer un projet". |
| **update** | `update/SKILL.md` | Mise à jour de `_SYSTEM/` depuis git. Vérifie, affiche le diff CHANGELOG, applique, migre si nécessaire. Déclenché par "update", "mise à jour". |
| **mirror** | `mirror/SKILL.md` | Synchronisation FR→EN. Détecte les fichiers manquants ou périmés, traduit à la demande via Claude, valide et commite dans Symbiose-EN. Déclenché par "mirror", "mirror check", "mirror [fichier]". |

## Utilisation

L'IA charge un skill quand le contexte le demande. Pas de chargement automatique — progressive disclosure : seule la description est visible, le contenu est lu à la demande.
