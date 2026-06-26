# 🔬 Bug Cerebras — fallback pi

**Palier :** 🏁 ARCHIVE
**Créé :** 2026-06-05
**Type :** Bug — fiabilité du fallback
**Archivé :** 2026-06-18 — Wian change de modèle si besoin, pas de fallback à maintenir.

## Description

Erreur `invalid literal for int()` lors du fallback vers Cerebras/Qwen-3-235B via `pi.sh`.

Le fallback s'active quand DeepSeek est indisponible (erreur API, timeout, etc.). pi.sh tente d'appeler Cerebras via LiteLLM, et cette erreur apparaît dans les logs. Probablement un parsing de réponse non-standard côté LiteLLM/Cerebras.

## Impact

**Non bloquant** — pi.sh continue de fonctionner, DeepSeek reste le provider principal. Mais le fallback n'est pas fiable en l'état. Si DeepSeek tombe, pi pourrait rester sans réponse.

## Symptômes

```
invalid literal for int() with base 10
```

Pas de stacktrace complète documentée pour l'instant.

## Tentatives de résolution

- Aucune pour l'instant — non prioritaire tant que DeepSeek est stable.

## Prochaine action

1. Capturer une stacktrace complète quand le bug se reproduit
2. Vérifier la version LiteLLM sur raw-proxamd5
3. Tester un appel Cerebras direct (sans pi.sh) pour isoler la couche qui échoue
~~4. **Si 5+ sessions sans résolution :** l'IA propose en clôture de prioriser le fix~~ *(archivé)*

## Historique

| Date | Événement |
|------|-----------|
| 2026-06-05 | 🔬 ALPHA — documenté dans TRANSFERT |
| 2026-06-05 | 🔬 ALPHA — entrée créée dans pipeline alpha |
| 2026-06-18 | 🏁 ARCHIVE — Wian change de modèle si besoin |
