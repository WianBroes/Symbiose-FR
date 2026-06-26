# subagents DeepSeek Flash

**Palier :** 🔬 ALPHA
**Créé :** 2026-06-04

## Contexte
pi-subagents installé et configuré sur DeepSeek Flash (plus de Claude).
3 agents : scout (codebase), researcher (web), worker (généraliste).

## Fichiers concernés
- `~/.pi/agent/git/github.com/amosblomqvist/pi-subagents/agents/{scout,researcher,worker}.md`
- `~/.pi/agent/git/github.com/amosblomqvist/pi-subagents/config.json` (maxConcurrency: 6)

## Sessions
- 2026-06-04 : installation + adaptation DeepSeek Flash + test researcher ✅

## Scope — pi local uniquement

**Ces subagents sont sur le pi local (raw-pc), pas sur le bot Debian.**
- raw-pc : pi principal + pi-subagents (scout/researcher/worker) + extensions
- raw-proxamd5 (Debian) : bot Telegram autonome (pi_agent.py + pi.sh → DeepSeek)
  → Pas de subagents, pas de spawn. Boucle indépendante.

## Bugs connus
- **Impossible d'appeler le subagent comme outil depuis l'agent principal** —
  nécessite un spawn bash en mode json (voir Workaround ci-dessous)
- Le researcher dépend de web-search (maintenant fixé)

## Workaround — spawn bash JSON

Quand l'agent principal ne peut pas appeler un subagent directement via l'API
pi, contournement : appeler le script via `bash` avec sortie JSON structurée.

```bash
# Exemple : appeler le scout
subagent_output=$(cd ~/.pi && npx tsx agent/git/github.com/amosblomqvist/pi-subagents/agents/scout.md --json 2>/dev/null)
echo "$subagent_output"
```

Si un subagent est un script bash/Node/ Python autonome, on peut le spawn
depuis l'agent principal via un appel bash, parser le JSON, et injecter le
résultat dans le contexte. Moins intégré mais fonctionnel.
