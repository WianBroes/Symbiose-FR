# Sécurité

## Checks automatiques

Chaque mise à jour du repo passe automatiquement par :

- **ShellCheck** — vérifie que les scripts shell ne contiennent pas de patterns dangereux
- **Semgrep** — détecte les appels réseau cachés, exécutions dynamiques, et patterns de sécurité connus
- **detect-secrets** — scanne tous les fichiers pour des clés API, tokens ou credentials accidentellement commités

Le statut de ces vérifications est visible dans l'onglet **Actions** du repo GitHub.

## Signaler un problème

Si tu identifies un problème de sécurité dans ce repo :

→ Ouvre une **issue privée** ou contacte directement le mainteneur avant de le rendre public.

## Philosophie

Symbiose est un framework `.md` pur. Les seuls fichiers exécutables sont les scripts dans `_SYSTEM/kernel/` — leur rôle est documenté et leur code est lisible.
