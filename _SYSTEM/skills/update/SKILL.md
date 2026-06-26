---
name: update
description: Mise à jour de _SYSTEM/ depuis le repo git. Vérifie si une mise à jour est disponible, applique si confirmé, gère la migration si nécessaire.
trigger: "update", "mise à jour", "mettre à jour", "check update"
---

# Skill — update

> Met à jour `_SYSTEM/` depuis le repo git origin.
> Déclenché manuellement ou depuis la notification de démarrage.

---

## 1. Vérifier le contexte

```bash
git -C . rev-parse --is-inside-work-tree 2>/dev/null
```

- **Pas un repo git** → afficher :
  > *"Ce vault n'est pas un repo git. Pour mettre à jour, télécharge la dernière version sur GitHub et remplace le dossier `_SYSTEM/` manuellement."*
  → Arrêter ici.

- **Repo git** → continuer.

---

## 2. Fetch silencieux

```bash
git fetch origin 2>/dev/null
BEHIND=$(git rev-list HEAD..origin/master --count 2>/dev/null)
```

- `BEHIND=0` → afficher : *"Déjà à jour."* → arrêter.
- `BEHIND>0` → continuer.

---

## 3. Afficher le diff CHANGELOG

```bash
git diff HEAD origin/master -- CHANGELOG.md 2>/dev/null | grep "^+" | grep -v "^+++" | head -20
```

Afficher les lignes ajoutées du CHANGELOG depuis la version courante.
Si CHANGELOG vide ou indisponible → afficher : *"`BEHIND` commit(s) disponibles."*

---

## 4. Confirmer

```
X commit(s) disponibles. Appliquer la mise à jour ?
  1. Oui
  2. Non
```

---

## 5. Appliquer

```bash
git pull origin master
```

Si conflit sur `_SYSTEM/` → afficher le fichier en conflit et demander quoi faire (garder local / prendre origin).

---

## 6. Migration (si nécessaire)

Vérifier si des dossiers vault sont encore trackés (anciens setups pré-v1.1) :

```bash
git ls-files | grep -E "^0[2-7]_|^00_📥Inbox/" 2>/dev/null
```

Si résultat non vide :
```bash
git rm -r --cached 00_📥Inbox/ 02_* 03_* 04_* 05_* 06_* 07_* 2>/dev/null
git commit -m "chore: désindexer vault personnel (migration v1.1)"
```

Confirmer : *"Migration appliquée — vault personnel désindexé du repo."*

---

## 7. Confirmer

Afficher : *"Mise à jour appliquée. Redémarre la session pour que les changements prennent effet."*
