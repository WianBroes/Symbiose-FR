# Web Search — Extension pi

Donne à [pi](https://pi.dev) la capacité de chercher sur le web et de lire des pages.

## Contenu

| Fichier | Rôle |
|---------|------|
| `web-search.ts` | Extension pi — enregistre les outils `web_search` et `fetch_url` |
| `web_search.py` | Script Python — recherche DuckDuckGo via `ddgs` |

## Installation

```bash
# 1. Copier les fichiers dans les extensions pi
cp -r pi-extensions/web-search ~/.pi/agent/extensions/web-search

# 2. Dépendance Python
pip install duckduckgo-search

# 3. Dépendances npm (dans ~/.pi/agent/extensions/)
cd ~/.pi/agent/extensions
cat > package.json << 'EOF'
{
  "private": true,
  "type": "module",
  "dependencies": {
    "@mozilla/readability": "^0.5.0",
    "linkedom": "^0.18.0",
    "turndown": "^7.2.0",
    "unpdf": "^0.11.0"
  }
}
EOF
npm install
```

Puis relancer pi.

## Outils fournis

- **`web_search`** — recherche DuckDuckGo (avec phrases exactes, exclusion, filtre site)
- **`fetch_url`** — lit une page web en markdown (PDF supporté)
