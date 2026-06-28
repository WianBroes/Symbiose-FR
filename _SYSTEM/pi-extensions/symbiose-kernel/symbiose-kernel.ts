import type { ExtensionAPI } from "@earendil-works/pi-coding-agent";
import { execSync } from "node:child_process";
import { existsSync } from "node:fs";
import { resolve } from "node:path";

/**
 * Symbiose Kernel Extension
 *
 * Copier ce fichier dans .pi/extensions/symbiose-kernel.ts
 * Incrémente le kernel après chaque message utilisateur.
 * Délègue la logique de scan à scan-check.sh (source unique de vérité).
 *
 * Généré par le wizard Symbiose (00_FIRST_STARTUP.md).
 * Template système : _SYSTEM/pi-extensions/symbiose-kernel/symbiose-kernel.ts
 */
export default function (pi: ExtensionAPI) {
  pi.on("input", async (event, ctx) => {
    if (event.source !== "interactive") return;

    const cwd = ctx.cwd;
    const kernelPath = resolve(cwd, "_SYSTEM/kernel/kernel.sh");
    const scanCheckPath = resolve(cwd, "_SYSTEM/kernel/scan-check.sh");

    if (!existsSync(kernelPath) || !existsSync(scanCheckPath)) return;

    try {
      execSync(`bash "${kernelPath}"`, { cwd, stdio: "ignore", timeout: 5000 });
    } catch {
      return;
    }

    try {
      const output = execSync(`bash "${scanCheckPath}"`, { cwd, timeout: 5000 })
        .toString()
        .trim();
      if (output.startsWith("[scan]")) {
        pi.sendMessage({
          customType: "symbiose-scan",
          content: "[scan]",
          display: true,
        });
      }
    } catch {
      // scan-check exits 1 when no scan needed — not an error
    }
  });
}
