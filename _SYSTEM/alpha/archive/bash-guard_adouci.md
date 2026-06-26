# bash-guard adouci

**Palier :** 🔬 ALPHA
**Créé :** 2026-06-04

## Problème
bash-guard interceptait TOUTE commande git, pipe, et redirection `>` — rendant
les sessions pénibles avec des popups constants alors que Wian ne prend pas
de risques avec son repo.

## Solution
Retrait des alertes génériques :
- Git : plus d'alerte systématique — seuls les vrais dangereux restent
  (`push --force`, `reset --hard`, `clean -fdx`, `reflog expire`, `gc --prune`)
- Pipes `|` : alerte supprimée (sauf `curl|sh` pour RCE)
- Redirections `>` `>>` `2>` : alerte supprimée
- `lsblk` : retiré (read-only)

## Fichier modifié
- `~/.pi/agent/extensions/bash-guard/index.ts`

## Sessions
- 2026-06-04 : analyse des patterns + implémentation + validation ✅

## Bugs connus
- Aucun signalé après test
