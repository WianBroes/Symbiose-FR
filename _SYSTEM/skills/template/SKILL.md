---
name: template
description: Génère des templates markdown prêts à l'emploi pour structurer la réflexion. Brainstorm, analyse, recherche, revue, synthèse.
trigger: "template", "structure", "squelette", "trame", "fais un [brainstorm|analyse|recherche|revue|synthèse]", "prépare un doc"
déclenchement_proactif: true — l'IA peut proposer un template quand elle détecte que l'utilisateur fait une activité qui s'y prête (brainstorm, analyse…)
---

# Template — Trames markdown prêtes à l'emploi

> Inspiré de Markdown-Agent (dakshjain-1616) et des conventions vault Symbiose.
> Chaque template produit un fichier `.md` prêt à être rempli dans le dossier cible.

---

## Déclencheurs

| Mot-clé | Template chargé |
|---------|----------------|
| "brainstorm", "idées", "brain dump" | `brainstorm.md` |
| "analyse", "problème", "diagnostic" | `analyse.md` |
| "recherche", "sujet", "étude" | `recherche.md` |
| "revue", "révision", "retour" | `revue.md` |
| "synthèse", "résumé", "compte-rendu" | `synthese.md` |
| "projet", "fiche projet" | `projet.md` |

---

## Procédure

### Phase 1 — Déterminer le template

1. Si l'utilisateur dit explicitement le type → charger le template correspondant
2. Si l'utilisateur dit "template" sans préciser → proposer la liste : *"Brainstorm · Analyse · Recherche · Revue · Synthèse · Projet"*
3. Si le contexte permet d'inférer (ex: "j'ai besoin de réfléchir à X" → brainstorm), proposer sans demander

### Phase 2 — Déterminer la cible

- Si dans un dossier projet existant → créer le fichier dedans
- Si pas de dossier → demander : *"Je le crée où ?"*
- Si "je sais pas" → créer dans `00_📥Inbox/` avec le nom du template + date

### Phase 3 — Générer le fichier

1. Lire le template depuis `_SYSTEM/skills/template/templates/[nom].md`
2. Remplacer les placeholders : `[titre]`, `[date]`, `[contexte]`
3. Si l'utilisateur a donné des infos → les pré-remplir dans la structure
4. Écrire le fichier dans le dossier cible
5. Confirmer : *"✅ Template [type] créé dans [chemin]"*

### Phase 4 — Remplir (optionnel)

Proposer : *"Tu veux que je commence à le remplir avec ce qu'on a dit, ou tu préfères le faire à la main ?"*

- Si oui → remplir la structure avec le contenu de la conversation
- Si non → laisser le squelette, l'utilisateur remplit

---

## Templates disponibles

Chaque template est dans `_SYSTEM/skills/template/templates/[nom].md`.

### brainstorm.md
```
# Brainstorm — [sujet]

> Date : [date]
> Contexte : [contexte]

## Idées

- [ ] Idée 1
  - Pour :
  - Contre :

- [ ] Idée 2
  - Pour :
  - Contre :

## Pistes à creuser
- [ ]

## Décisions
- [ ]
```

### analyse.md
```
# Analyse — [sujet]

> Date : [date]
> Contexte : [contexte]

## Problème
[description]

## Causes possibles
1.
2.
3.

## Solutions envisagées
| Solution | Effort | Impact | Risque |
|----------|--------|--------|--------|
|          |        |        |        |

## Recommandation
[ ]
```

### recherche.md
```
# Recherche — [sujet]

> Date : [date]
> Contexte : [contexte]

## Question de recherche
[ ]

## Sources consultées
| Source | Type | Pertinence | Résumé |
|--------|------|------------|--------|
|        |      |            |        |

## Résultats clés
1.
2.
3.

## Questions ouvertes
- [ ]
```

### revue.md
```
# Revue — [sujet]

> Date : [date]
> Contexte : [contexte]

## Ce qui a marché 👍
- [ ]

## Ce qui n'a pas marché 👎
- [ ]

## À améliorer 🔧
- [ ]

## Actions
- [ ]
```

### synthese.md
```
# Synthèse — [sujet]

> Date : [date]
> Contexte : [contexte]

## Points clés
1.
2.
3.

## Décisions
- [ ]

## Prochaines étapes
- [ ]
```

### projet.md
```
# Projet — [nom]

> Date : [date]
> Status : [idée / en cours / terminé / abandonné]

## Objectif
[ ]

## Ressources
- Budget :
- Matériel :
- Temps estimé :

## Étapes
- [ ] Étape 1
- [ ] Étape 2

## Notes
[ ]
```
