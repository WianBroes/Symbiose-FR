# Contributing to Symbiose

## 🐛 Report a bug

Open a [GitHub issue](https://github.com/WianBroes/Symbiose-FR/issues) with:
- The affected file
- What happens vs what should happen
- If possible, the command or message that triggered it

## 💡 Suggest an improvement

1. **Fork** the repo
2. **Create a branch**: `git checkout -b feature/my-change`
3. **Edit** the relevant files
4. **Commit and push**: `git commit -m "clear description" && git push origin feature/my-change`
5. **Open a Pull Request** with a description of what you changed and why

## 📐 Rules

- **Structure**: respect `_SYSTEM/` organization (CORE.md, skills/, kernel/)
- **.md files**: explain why, not what
- **Behavior**: don't break the startup sequence (`AUTOSTART.md` → `CORE.md`)
- **Memory**: don't touch `01_🧠Profil/` in PRs — it's user-specific and gitignored
- **Cross-platform**: bash commands must work on Linux, macOS, and Windows (git-bash)

## 📝 Style

- **Language**: French (the framework is French-first)
- **Format**: readable Markdown, no excessive formatting
- **AGENTS.md**: core behavior stays agnostic — tool-specific content goes in dedicated sections

---

*Thanks for contributing 🙌*
