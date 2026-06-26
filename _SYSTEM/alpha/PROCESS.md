# ⚙️ Pipeline Alpha — Processus

**Contexte :** toute modification du métasystème Symbiose (règles, extensions, scripts, structure du vault,
nouveaux outils) passe par ce cycle de vie. Ça évite :
- Les features qui meurent après une session
- Les bugs silencieux qui contaminent le système
- Les décisions non documentées

---

## Cycle de vie

```
💡 IDÉE → 🔬 ALPHA → 🧪 BETA → 🚦 PRERELEASE → ✅ RELEASE → 🏁 ARCHIVE
                                  ↓                        ↓
                               ❌ ABANDON              🔄 REMPLACÉ

🔧 FIX RAPIDE → implémenté directement (pas de cycle)
```

**FIX RAPIDE :** modification isolée, <30 lignes, sans dépendance à d'autres features. Ne passe pas par le cycle ALPHA→RELEASE. Noté dans `00_INDEX.md` section "Fix rapides" pour traçabilité.

| Palier | Critère d'entrée | Risque | Action à la clôture |
|--------|-----------------|--------|---------------------|
| **💡 IDÉE** | Wian dit "on devrait" | Aucun | Rien — reste dans la liste |
| **🔬 ALPHA** | Le code/script/extension existe et tourne | Bugs probables, cas non testés | Vérifier : bugs rencontrés ? Si oui, corriger ou ❌ ABANDON |
| **🧪 BETA** | 3 sessions sans bug en ALPHA | Bugs rares, usages limites | Vérifier : 3 sessions sans bug → promouvoir |
| **🚦 PRERELEASE** | 5 sessions sans bug en BETA | Stable, usage courant | Vérifier : 5 sessions sans bug → promouvoir |
| **✅ RELEASE** | Adopté comme standard | Aucun (dette technique normale) | Documenter dans CORE.md si pertinent |
| **❌ ABANDON** | Bloqué, trop risqué, obsolète | — | Déplacer dans `99_🗄️ Archives/` |
| **🔄 REMPLACÉ** | Remplacé par une meilleure solution | — | Archiver l'ancien, référencer le nouveau |

---

## Règles

### Entrée dans le pipeline

1. Wian dit "on ajoute en alpha" → créer une entrée dans `00_INDEX.md` avec `💡 IDÉE`
2. Décrire la feature en une ligne — assez pour savoir de quoi on parle dans 3 mois
3. Optionnel : créer un fichier `alpha/NOM_FEATURE.md` pour la description détaillée

### Promotion

1. À chaque **clôture de session**, le fichier `00_INDEX.md` est révisé
2. L'IA examine chaque feature ALPHA/BETA/PRERELEASE : bugs rencontrés cette session ?
3. Si aucune entrée de bug depuis la promotion précédente : compter +1 session
4. Au seuil : proposer la promotion à Wian → "On promeut X en Y ?"
5. Wian décide. Pas de promotion sans validation explicite.

### Abandon

1. Une feature peut être abandonnée à tout moment (trop risquée, obsolète, pas utile)
2. Déplacer vers ❌ ABANDON dans `00_INDEX.md`
3. Si du code existe : le déplacer dans `99_🗄️ Archives/` avec référence

### Contenu d'une entrée

```
| [nom] | [palier actuel] | [date entrée palier] | [sessions sans bug] |
```

### Fichier de feature détaillé (optionnel)

Pour les features complexes, créer `alpha/NOM.md` :

```markdown
# 🔬 NOM

**Palier :** ALPHA
**Créé :** 2026-06-05
**Description :** ...

## Implémentation

- Fichier : `_SYSTEM/scripts/truc.py`
- Extension : `~/.pi/agent/extensions/truc.ts`

## Historique

| Date | Événement |
|------|-----------|
| 2026-06-05 | 💡 IDÉE |
| 2026-06-06 | 🔬 ALPHA — implémenté |
```

---

## Intégration à la clôture

À chaque clôture (dans la checklist) :

```
- [ ] Pipeline alpha révisé (propositions de promotion)
```

Et dans le corps de la clôture, section à remplir si pertinent :

```markdown
## Pipeline alpha

- [feature] : [palier] — [sessions sans bug / bug rencontré cette session]
- Proposition : [promotion / abandon / rien]
```

---

## Exemple concret

```
| Évaluation externe | 💡 IDÉE | 2026-06-05 | — |
```

→ Prochaine session où on code : passage en 🔬 ALPHA
→ 3 sessions sans bug avec l'évaluateur : proposition 🧪 BETA
→ Wian valide ou non
