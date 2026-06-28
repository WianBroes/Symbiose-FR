---
type: Symbiose.MemoryLog
---

# Observations Log — historique append-only

> Chaque micro-scan et macro-scan écrit ici **en plus** de `observations.md`.
> `observations.md` = compact courant · ce fichier = historique complet, jamais compacté.
> Permet de reconstruire l'évolution des observations session par session.

## Règles

- **Append-only** — on ne supprime jamais une ligne, on ne modifie pas.
- **Format** : `[AAAA-MM-JJ] [type] [source, confidence] description`
- **Types** : `micro-scan` · `macro-scan` · `dream` · `manual`
- **Sources** : `symbiose` · `IA` · `utilisateur`
- **Confidence** : `high` · `medium` · `low`

---

## 2026-06-28 — Session #4

- [macro-scan] [symbiose, high] Wian demande une recherche comparative complète — systèmes similaires, recherche académique, agents auto-évolutifs, métacognition.
- [macro-scan] [symbiose, high] Wian valide toutes les propositions d'amélioration d'un coup — approche "tout prendre".
- [macro-scan] [IA, medium] self-check : règle `précis` bien appliquée (vérification ligne par ligne des changements), règle `directif` respectée (mode SÉCURISÉ).
- [micro-scan] [symbiose, high] Quand l'IA fait une supposition sur ses paroles, il corrige : "j'ai pas dit non".
- [micro-scan] [symbiose, high] Questionne les estimations de l'IA et voit des angles non considérés.
- [micro-scan] [symbiose, high] Détecte le mauvais calibrage du dream — "j'ai l'impression que le dream se déclenche souvent now".
- [micro-scan] [IA, high] self-check : règle `précis` respectée (scan exécuté avant réponse), `directif` respecté (modifications validées via l'action).
- [macro-scan] [IA, high] Question libre : Wian ne dit jamais "non" — il dit "je sais pas" ou "on verra". Porte ouverte pour que l'idée fasse ses preuves.
- [macro-scan] [symbiose, confirmed] Synergie `systémique + précis` active (3 sessions) — calibrage système.


## [2026-06-28]
- [micro-scan] 2026-06-28 : [symbiose, medium] Wian ne laisse pas passer une procédure mal exécutée même si l'intention était bonne — le respect du protocole est un signal en soi.

## [2026-06-28] — macro-scan
- [macro-scan] 2026-06-28 : [symbiose, high] Wian valide sec et enchaîne — ne s'arrête pas sur la confirmation.
- [macro-scan] 2026-06-28 : [symbiose, high] Teste les limites par des edge cases (protokine, simulation), pas par des démos.
- [macro-scan] 2026-06-28 : [symbiose, high] Reformule jusqu'à ce que l'IA comprenne son intention exacte.
- [macro-scan] 2026-06-28 : [symbiose, medium] Une fois l'architecture claire, donne carte blanche sur l'exécution.
- [macro-scan] 2026-06-28 : [symbiose, high] Raisonnement par démonstrations concrètes → principes généraux.
- [macro-scan] 2026-06-28 : [symbiose, high] Le bord du système l'intéresse plus que le centre.
- [macro-scan] 2026-06-28 : [symbiose, medium] Wian ne se contente pas de tester si ça marche — il teste où ça casse.

## [2026-06-28] — micro-scan
- [micro-scan] 2026-06-28 : [symbiose, high] Quand la proposition est dans le bon axe mais pas le bon cadre, il corrige le cadre — pas le contenu.

## [2026-06-28] — micro-scan
- [micro-scan] 2026-06-28 : [symbiose, high] Démantele le "switch de rôle" en une phrase — le switch n'existe pas, c'est un cumul. Redirige vers le vrai problème : les contradictions entre rôles.
- [micro-scan] 2026-06-28 : [symbiose, medium] Une fois le cadre corrigé, valide et enchaîne — pas de micro-gestion, pas de retour.
- [micro-scan] 2026-06-28 : [symbiose, medium] Suit la liste de Dev dans l'ordre, un chantier à la fois — priorité donnée par le diagnostic, pas par l'urgence.

## [2026-06-28] — macro-scan
- [macro-scan] 2026-06-28 : [symbiose, high] Corrige le cadre avant le contenu — redresse la posture, pas le détail.
- [macro-scan] 2026-06-28 : [symbiose, high] Démantele les mécanismes cosmétiques en une phrase — "le switch n'existe pas".
- [macro-scan] 2026-06-28 : [symbiose, high] Suit un diagnostic externe (Dev) dans l'ordre — priorité par l'analyse, pas par l'urgence.
- [macro-scan] 2026-06-28 : [symbiose, medium] Valide sec et enchaîne — "oui" suffit, pas de retour.
- [macro-scan] 2026-06-28 : [symbiose, high] Session : 7 chantiers système traités (rôles v2, tests, redondances, entrées, backup, règle, modes supprimés).

## [2026-06-28] — macro-scan (session 7)
- [micro-scan] 2026-06-28 : [symbiose, medium] Quand un mécanisme ne s'est pas déclenché, Wian remonte la chaîne de causalité lui-même, valide la correction et enchaîne immédiatement.
- [macro-scan] 2026-06-28 : [symbiose, medium] Il a détecté un écart entre l'attendu (dream lancé) et le réel, remonté la chaîne de causalité jusqu'à la racine (extension non installée).
- [macro-scan] 2026-06-28 : [symbiose, medium] Il creuse plus profond que la réponse donnée — il veut comprendre pourquoi le système a permis ce trou.
- [macro-scan] 2026-06-28 : [symbiose, medium] Domaine : conception système Symbiose (kernel, extensions, dream), infrastructure PI (extensions, hooks).
- [macro-scan] 2026-06-28 : [symbiose, medium] Raisonnement : de l'effet à la cause racine, pas de l'hypothèse à la vérification.
[2026-06-28] [dream] Consolidation terminée : 45 observations compactées en 35, 0 archivées (low confidence), 10 motifs confirmés, H5 créée.
[2026-06-28] [micro-scan] [symbiose, high] Utilise le pipeline CI comme filet de sécurité système — push en sachant que ça fail, la correction suit dans le flux.

## [2026-06-28] — macro-scan
- [macro-scan] [2026-06-28] : [symbiose, high] Comportement : quand il savait que le CI échouait, a demandé la correction et vérifié le résultat — pas le détail de l'erreur.
- [macro-scan] [2026-06-28] : [symbiose, high] Comportement : a posé 3 fois une question d'infrastructure sous des angles différents jusqu'à réponse satisfaisante.
- [macro-scan] [2026-06-28] : [symbiose, high] Comportement : a clos immédiatement après validation — pas de micro-gestion.
- [macro-scan] [2026-06-28] : [symbiose, high] Domaine : infrastructure PI (extensions, hooks, loading cycle).
- [macro-scan] [2026-06-28] : [symbiose, high] Domaine : CI/CD GitHub Actions (workflow, ShellCheck).
- [macro-scan] [2026-06-28] : [symbiose, high] Domaine : Shell scripting (SC2034, SC2206).
- [macro-scan] [2026-06-28] : [symbiose, high] Raisonnement : part d'une certitude (CI fail) → remonte la chaîne scripts → extension → hook.
- [macro-scan] [2026-06-28] : [symbiose, high] Question libre : Wian utilise la vérification comme mode de pilotage — ne s'arrête pas à 'c'est réparé', remonte jusqu'à cohérence complète. Un maillon non vérifié = un système pas fini.
