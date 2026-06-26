#!/usr/bin/env python3
"""
web_search.py — Recherche web DuckDuckGo
Utilisation : python3 web_search.py "ma requête"
             python3 web_search.py "ma requête" --max 10
             python3 web_search.py "ma requête" --site github.com
             python3 web_search.py "ma requête" --json
"""

import sys
import json
import argparse
from ddgs import DDGS

def search(query: str, max_results: int = 5, site: str = None):
    """Recherche DuckDuckGo et retourne résultats structurés."""
    if site:
        query = f"{query} site:{site}"

    try:
        with DDGS() as ddgs:
            results = list(ddgs.text(query, max_results=max_results))
        return results
    except Exception as e:
        return [{"error": str(e)}]

def format_results(results: list) -> str:
    """Formate les résultats pour lecture dans le terminal."""
    if not results:
        return "Aucun résultat."

    if "error" in results[0]:
        return f"❌ Erreur : {results[0]['error']}"

    output = []
    for i, r in enumerate(results, 1):
        title = r.get("title", "Sans titre")
        href = r.get("href", r.get("url", ""))
        body = r.get("body", r.get("snippet", ""))
        output.append(f"[{i}] {title}")
        output.append(f"    URL : {href}")
        if body:
            output.append(f"    → {body[:200]}{'...' if len(body) > 200 else ''}")
        output.append("")
    return "\n".join(output)

def search_and_print(query: str, max_results: int = 5, site: str = None):
    """Recherche et affiche."""
    results = search(query, max_results, site)
    print(f"🔍 Recherche : {query}")
    print(f"📊 {len(results) if isinstance(results, list) else 0} résultats trouvés\n")
    print(format_results(results))

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Recherche web via DuckDuckGo")
    parser.add_argument("query", nargs="+", help="Termes de recherche")
    parser.add_argument("--max", type=int, default=5, help="Nombre max de résultats (défaut: 5)")
    parser.add_argument("--site", type=str, help="Filtrer par site (ex: github.com)")
    parser.add_argument("--json", action="store_true", help="Sortie JSON pour parsing")
    args = parser.parse_args()

    query = " ".join(args.query)

    if args.json:
        results = search(query, args.max, args.site)
        print(json.dumps(results, ensure_ascii=False, indent=2))
    else:
        search_and_print(query, args.max, args.site)
