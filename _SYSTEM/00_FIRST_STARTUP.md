# First startup — Wizard Symbiose

> Exécuté une seule fois, au premier démarrage.
> Détecté par l'absence de `01_🧠Profil/👤profil.md`.

---

## 1. Salutation

Afficher l'ASCII art de Symbiose (startup_ascii.md).

## 2. Choix de la langue

```
[1] Français
[2] English
```

## 3. Scan machine

Exécuter :
```bash
echo "OS: $(uname -o 2>/dev/null || echo unknown)"
echo "Kernel: $(uname -r)"
echo "CPU: $(lscpu 2>/dev/null | grep 'Model name' | head -1 | cut -d: -f2 | xargs || echo unknown)"
echo "RAM: $(free -h 2>/dev/null | grep Mem | awk '{print $2}' || echo unknown)"
echo "Shell: $SHELL"
```

## 4. Profil utilisateur

Demander :
- Nom
- Description courte

Créer `01_🧠Profil/👤profil.md`.

## 5. Rôle Symbiose (obligatoire)

Créer le rôle **Symbiose** — l'IA générale du système :

```yaml
01_🧠Profil/roles/symbiose.md
01_🧠Profil/roles/symbiose/memory/observations.md
01_🧠Profil/roles/_INDEX.md
```

Symbiose est la voix par défaut. C'est l'IA qui t'accompagne au quotidien, qui apprend de toi, et que tu peux modifier à tout moment.

Elle commence vierge. C'est l'usage qui la forme.

## 6. Rôles supplémentaires (optionnel)

Proposer :

> *"Tu peux aussi créer des rôles spécialisés — un directeur artistique, un secrétaire, un chef de projet… Chacun aura sa propre voix et sa mémoire, mais ils sauront tous qui tu es."*

Si l'utilisateur en veut → lancer le skill `role` pour créer.
Si non → continuer.

## 7. Mode par défaut

```yaml
active_role: symbiose
```

Écrire dans `👤profil.md`.

## 8. Clôture

```
✓ Profil · Machine · Symbiose · Prêt

FR: Bienvenue [nom], Symbiose est prêt.
EN: Welcome [nom], Symbiose is ready.
```

---

> Le rôle Symbiose peut être modifié à tout moment dans `01_🧠Profil/roles/symbiose.md`.
> D'autres rôles peuvent être créés via le skill `role`.
> Chaque rôle a sa mémoire. Tous partagent le profil utilisateur.
