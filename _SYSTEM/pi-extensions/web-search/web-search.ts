/**
 * web-search.ts — Recherche web (DuckDuckGo via Python) + Fetch URL
 *
 * web_search : utilise web_search.py (DDGS) dans le même dossier.
 * fetch_url  : Readability + Turndown + linkedom pour HTML→Markdown,
 *              unpdf pour PDFs, Jina Reader en fallback JS.
 *
 * Installation :
 *   1. Copier ce dossier dans ~/.pi/agent/extensions/web-search/
 *   2. pip install duckduckgo-search
 *   3. npm install (dans ~/.pi/agent/extensions/)
 */

import type { ExtensionAPI } from "@earendil-works/pi-coding-agent";
import { Type } from "typebox";
import { Text } from "@earendil-works/pi-tui";
import { execFile } from "node:child_process";
import { promisify } from "node:util";
import { fileURLToPath } from "node:url";
import { dirname, join } from "node:path";

const asyncExecFile = promisify(execFile);
const __filename = fileURLToPath(import.meta.url);
const __dirname = dirname(__filename);
const SEARCH_SCRIPT = join(__dirname, "web_search.py");

// ── Helpers de construction de requête ───────────────────────────────

function stripWrappingQuotes(value: string): string {
  return value.length >= 2 && value.startsWith('"') && value.endsWith('"')
    ? value.slice(1, -1).trim()
    : value;
}

function cleanItems(values?: string[]): string[] {
  if (!values) return [];
  return values
    .map((v) => stripWrappingQuotes(v.trim().replace(/\s+/g, " ")))
    .filter(Boolean);
}

function cleanQuery(value?: string): string | undefined {
  if (typeof value !== "string") return undefined;
  const cleaned = value.trim().replace(/\s+/g, " ");
  return cleaned || undefined;
}

function normalizeSite(site?: string): string | undefined {
  if (typeof site !== "string") return undefined;
  let value = site.trim().replace(/^site:/i, "").trim();
  if (!value) return undefined;
  try {
    const candidate = /^[a-z]+:\/\//i.test(value) ? value : `https://${value}`;
    const url = new URL(candidate);
    if (url.hostname) value = url.hostname;
  } catch { /* ignore */ }
  return value.replace(/\/+$/, "") || undefined;
}

function buildSearchQuery(args: {
  query?: string;
  exactPhrases?: string[];
  excludeTerms?: string[];
  site?: string;
}): string {
  const baseQuery = cleanQuery(args.query);
  const exactPhrases = cleanItems(args.exactPhrases);
  const excludeTerms = cleanItems(args.excludeTerms);
  const site = normalizeSite(args.site);

  if (!baseQuery && exactPhrases.length === 0) {
    throw new Error("Au moins 'query' ou 'exactPhrases' est requis.");
  }

  const parts: string[] = [];
  if (baseQuery) parts.push(baseQuery);
  for (const phrase of exactPhrases) parts.push(`"${phrase.replace(/"/g, '\\"')}"`);
  for (const term of excludeTerms) {
    parts.push(term.includes(" ") ? `-"${term}"` : `-${term}`);
  }
  if (site) parts.push(`site:${site}`);
  return parts.join(" ");
}

// ── Fetch URL — Readability + Turndown + PDF + Jina ──────────────────

const USER_AGENT = "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/128.0.0.0 Safari/537.36";
const TIMEOUT_MS = 30000;
const MAX_HTML_SIZE = 5 * 1024 * 1024;
const MAX_PDF_SIZE = 20 * 1024 * 1024;
const JINA_BASE = "https://r.jina.ai/";

function isPDF(url: string, contentType?: string): boolean {
  if (contentType?.includes("application/pdf")) return true;
  try { return new URL(url).pathname.toLowerCase().endsWith(".pdf"); } catch { return false; }
}

async function extractPDF(buffer: ArrayBuffer, url: string) {
  const { getDocumentProxy } = await import("unpdf");
  const pdf = await getDocumentProxy(new Uint8Array(buffer));
  const meta = (await pdf.getMetadata()).info as Record<string, unknown> | null;
  const metaTitle = typeof meta?.Title === "string" ? meta.Title.trim() : "";
  let urlTitle = "document";
  try {
    const { basename } = await import("node:path");
    urlTitle = basename(new URL(url).pathname, ".pdf").replace(/[_-]+/g, " ").trim() || "document";
  } catch { /* ignore */ }

  const maxPages = Math.min(pdf.numPages, 100);
  const pages: string[] = [];
  for (let i = 1; i <= maxPages; i++) {
    const page = await pdf.getPage(i);
    const text = (page.getTextContent() as unknown as Array<{ str?: string }>)
      .map((t) => t.str || "").join(" ").replace(/\s+/g, " ").trim();
    if (text) pages.push(text);
  }

  const lines = [
    `# ${metaTitle || urlTitle}`,
    `> Source: ${url}`,
    `> Pages: ${pdf.numPages}${pdf.numPages > maxPages ? ` (first ${maxPages})` : ""}`,
    ...(typeof meta?.Author === "string" ? [`> Author: ${meta.Author}`] : []),
    "", "---", "", ...pages,
  ];
  if (pdf.numPages > maxPages) lines.push("", "---", "", `*[Truncated: first ${maxPages} of ${pdf.numPages} pages]*`);
  return { url, title: metaTitle || urlTitle, content: lines.join("\n"), error: null };
}

async function extractWithJinaReader(url: string, signal?: AbortSignal) {
  try {
    const res = await fetch(JINA_BASE + url, {
      headers: { Accept: "text/markdown", "X-No-Cache": "true" },
      signal: AbortSignal.any([AbortSignal.timeout(30000), ...(signal ? [signal] : [])]),
    });
    if (!res.ok) return null;
    const text = await res.text();
    const start = text.indexOf("Markdown Content:");
    if (start === -1) return text.length > 100 ? { title: "", content: text } : null;
    const title = text.match(/^Title:\s*(.+)/m)?.[1]?.trim() || "";
    return { title, content: text.slice(start + "Markdown Content:".length).trim() };
  } catch { return null; }
}

async function fetchAndExtract(url: string, signal?: AbortSignal) {
  try { new URL(url); } catch { return { url, title: "", content: "", error: "Invalid URL" }; }
  if (signal?.aborted) return { url, title: "", content: "", error: "Aborted" };

  const controller = new AbortController();
  const timeout = setTimeout(() => controller.abort(), TIMEOUT_MS);
  const unsub = () => { clearTimeout(timeout); signal?.removeEventListener("abort", unsub); };
  signal?.addEventListener("abort", unsub);

  try {
    const response = await fetch(url, {
      signal: controller.signal,
      headers: {
        "User-Agent": USER_AGENT,
        Accept: "text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8",
        "Accept-Language": "fr,en;q=0.9",
      },
    });
    if (!response.ok) return { url, title: "", content: "", error: `HTTP ${response.status}` };

    const contentType = response.headers.get("content-type") || "";
    const contentLength = parseInt(response.headers.get("content-length") || "0", 10);
    const isPDFContent = isPDF(url, contentType);
    const maxSize = isPDFContent ? MAX_PDF_SIZE : MAX_HTML_SIZE;

    if (contentLength > maxSize) {
      return { url, title: "", content: "", error: `Fichier trop volumineux (${Math.round(contentLength / 1024 / 1024)}MB)` };
    }
    if (isPDFContent) {
      const buffer = await response.arrayBuffer();
      return await extractPDF(buffer, url);
    }
    if (/^(application\/octet-stream|image\/|audio\/|video\/)/.test(contentType)) {
      return { url, title: "", content: "", error: `Type non supporté : ${contentType.split(";")[0]}` };
    }

    const text = await response.text();
    if (!contentType.includes("text/html") && !contentType.includes("application/xhtml+xml")) {
      return { url, title: new URL(url).pathname.split("/").pop() || url, content: text, error: null };
    }

    // Readability + Turndown
    const { parseHTML } = await import("linkedom");
    const { Readability } = await import("@mozilla/readability");
    const TurndownService = (await import("turndown")).default;
    const { document } = parseHTML(text);
    const article = new Readability(document as unknown as Document).parse();

    if (article) {
      const md = new TurndownService({ headingStyle: "atx", codeBlockStyle: "fenced" }).turndown(article.content);
      if (md.length >= 500) return { url, title: article.title || "", content: md, error: null };
      // Trop court → fallback Jina
      const jina = await extractWithJinaReader(url, signal);
      if (jina) return { url, title: jina.title || article.title || "", content: jina.content, error: null };
    }

    // Fallback Jina
    const jina = await extractWithJinaReader(url, signal);
    if (jina) return { url, title: jina.title, content: jina.content, error: null };

    const isJSRendered = (text.match(/<script/g) || []).length > 3 &&
      text.replace(/<script[\s\S]*?<\/script>/gi, "").replace(/<[^>]+>/g, "").trim().length < 300;

    return {
      url, title: "", content: "",
      error: isJSRendered ? "Page JS-rendered (contenu chargé dynamiquement)" : "Impossible d'extraire le contenu",
    };
  } finally {
    clearTimeout(timeout);
    signal?.removeEventListener("abort", unsub);
  }
}

// ── Extension ─────────────────────────────────────────────────────────

export default function (pi: ExtensionAPI) {
  // ─── Outil : web_search ───────────────────────────────────
  pi.registerTool({
    name: "web_search",
    label: "Web Search",
    description:
      "Recherche sur le web via DuckDuckGo (Python DDGS). " +
      "Options : query, exactPhrases, excludeTerms, site, numResults.",
    promptSnippet: "Search the web for recent information",
    promptGuidelines: [
      "Use web_search when you need current information",
      "Utilise exactPhrases pour des recherches de phrases exactes",
      "Utilise excludeTerms pour exclure des termes",
      "Utilise site pour restreindre à un domaine",
      "Utilise fetch_url après web_search pour lire le contenu",
    ],
    parameters: Type.Object({
      query: Type.Optional(Type.String({ description: "Termes de recherche (mots-clés)" })),
      exactPhrases: Type.Optional(Type.Array(Type.String(), {
        description: "Phrases exactes à rechercher (seront mises entre guillemets)",
      })),
      excludeTerms: Type.Optional(Type.Array(Type.String(), {
        description: "Termes à exclure de la recherche",
      })),
      site: Type.Optional(Type.String({ description: "Restreindre à un domaine (ex: docs.python.org)" })),
      numResults: Type.Optional(Type.Number({ description: "Nombre de résultats (max 10, défaut: 5)" })),
    }),

    async execute(_toolCallId, params, _signal, onUpdate, _ctx) {
      const query = buildSearchQuery(params);
      const num = Math.min(params.numResults ?? 5, 10);

      onUpdate?.({ content: [{ type: "text", text: `🔍 Recherche : "${query}"...` }] });

      try {
        const { stdout } = await asyncExecFile("python3", [SEARCH_SCRIPT, query, "--max", String(num), "--json"], {
          timeout: 15000,
        });
        const results = JSON.parse(stdout.trim());

        if (!Array.isArray(results) || results.length === 0) {
          return {
            content: [{ type: "text", text: `Aucun résultat trouvé pour "${query}".` }],
            details: { composedQuery: query, resultCount: 0 },
          };
        }

        if (results[0]?.error) {
          return {
            content: [{ type: "text", text: `❌ Erreur recherche : ${results[0].error}` }],
            details: { composedQuery: query, error: results[0].error },
          };
        }

        const formatted = results.map((r: any, i: number) =>
          `${i + 1}. **${r.title}**\n   ${r.href || r.url}\n   ${(r.body || r.snippet || "").slice(0, 300)}`
        ).join("\n\n");

        return {
          content: [{ type: "text", text: `🔍 Résultats pour "${query}" :\n\n${formatted}` }],
          details: { composedQuery: query, resultCount: results.length, results },
        };
      } catch (err: any) {
        return {
          content: [{ type: "text", text: `❌ Erreur recherche : ${err.message || err}` }],
          details: { composedQuery: query, error: err.message },
        };
      }
    },

    renderCall(args, theme, context) {
      const t = (context.lastComponent as Text | undefined) ?? new Text("", 0, 0);
      try {
        const q = buildSearchQuery(args as any);
        t.setText(theme.fg("toolTitle", "search ") + theme.fg("accent", `"${q.length > 70 ? q.slice(0, 67) + "…" : q}"`));
      } catch {
        t.setText(theme.fg("toolTitle", "search ") + theme.fg("error", "(invalide)"));
      }
      return t;
    },

    renderResult(result, { expanded, isPartial }, theme, context) {
      const t = (context.lastComponent as Text | undefined) ?? new Text("", 0, 0);
      if (isPartial) { t.setText(theme.fg("warning", "🔍 Recherche…")); return t; }
      if (context.isError) { t.setText(theme.fg("error", result.content[0]?.text || "Erreur")); return t; }
      const count = (result.details as any)?.resultCount ?? 0;
      const status = theme.fg("success", `${count} résultats`);
      if (!expanded) { t.setText(status); return t; }
      const content = result.content.find((c: any) => c.type === "text")?.text || "";
      t.setText(content.length > 500 ? status + "\n" + theme.fg("dim", content.slice(0, 500) + "…") : status + "\n" + theme.fg("dim", content));
      return t;
    },
  });

  // ─── Outil : fetch_url ────────────────────────────────────
  pi.registerTool({
    name: "fetch_url",
    label: "Fetch URL",
    description:
      "Récupère une page web et extrait le contenu lisible en markdown. " +
      "Readability + Turndown pour HTML, unpdf pour PDFs, Jina Reader en fallback JS.",
    promptSnippet: "Fetch and read the text content of a web page",
    promptGuidelines: [
      "Use fetch_url after web_search to read the full content of a specific result page.",
      "Le contenu est converti en markdown propre (mode lecture).",
    ],
    parameters: Type.Object({ url: Type.String({ description: "URL complète de la page à lire" }) }),

    async execute(_toolCallId, params, signal, onUpdate, _ctx) {
      const url = params.url;
      onUpdate?.({ content: [{ type: "text", text: `📄 Récupération de ${url}...` }] });

      const result = await fetchAndExtract(url, signal);
      if (result.error) return { content: [{ type: "text", text: `❌ ${url}: ${result.error}` }], details: {}, isError: true };

      const header = result.title ? `# ${result.title}\n\nSource: ${result.url}\n\n---\n\n` : "";
      const full = header + result.content;
      const truncated = full.length > 50000
        ? full.slice(0, 50000) + `\n\n[... tronqué — ${full.length - 50000} caractères de plus ...]`
        : full;

      return { content: [{ type: "text", text: truncated }], details: { url: result.url, title: result.title, chars: result.content.length } };
    },

    renderCall(args, theme, context) {
      const t = (context.lastComponent as Text | undefined) ?? new Text("", 0, 0);
      const url = (args as { url?: string }).url;
      if (!url) { t.setText(theme.fg("toolTitle", "fetch ") + theme.fg("error", "(no URL)")); return t; }
      t.setText(theme.fg("toolTitle", "fetch ") + theme.fg("accent", url.length > 70 ? url.slice(0, 67) + "…" : url));
      return t;
    },

    renderResult(result, { expanded, isPartial }, theme, context) {
      const t = (context.lastComponent as Text | undefined) ?? new Text("", 0, 0);
      if (isPartial) { t.setText(theme.fg("warning", "📄 Récupération…")); return t; }
      if (context.isError) { t.setText(theme.fg("error", result.content[0]?.text || "Erreur")); return t; }
      const d = (result.details as any) ?? {};
      const status = theme.fg("success", d.title || "Sans titre") + theme.fg("muted", ` (${d.chars ?? 0} car.)`);
      if (!expanded) { t.setText(status); return t; }
      const content = result.content.find((c: any) => c.type === "text")?.text || "";
      t.setText(content.length > 500 ? status + "\n" + theme.fg("dim", content.slice(0, 500) + "…") : status + "\n" + theme.fg("dim", content));
      return t;
    },
  });
}
