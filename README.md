# Symbiose — Framework d'interaction IA adaptatif

**Agnostique, portable, adaptatif — le système vit dans les fichiers, pas dans l'outil.**

![GitHub](https://img.shields.io/badge/status-stable-green)
![License](https://img.shields.io/badge/license-MIT-blue)

## ⬇️ [Télécharger Symbiose](https://github.com/WianBroes/Symbiose-FR/archive/refs/heads/master.zip)

---

## C'est quoi ?

Un **framework adaptatif** qui **apprend de toi** au fil des sessions.
Tu le poses dans un dossier, tu lances ton outil IA dedans, et le système :

- 🔄 **Se souvient** du contexte entre les sessions
- 🧠 **S'adapte** progressivement à ta façon de travailler
- 🔌 **Fonctionne avec** PI, Claude Code, Codex CLI…
- 📦 **Est réinitialisable** — clé en main pour un autre utilisateur

> **Idée centrale :** le système vit dans des fichiers `.md`, pas dans l'outil.
> Change d'outil en cours de route sans rien perdre.

---

## 🚀 Démarrage rapide

**1. Récupère les fichiers**
Clique sur **Download ZIP** en haut de cette page et décompresse le dossier.
*(ou `git clone` si tu sais ce que c'est)*

**2. Ouvre-le avec ton outil IA**
Lance ton outil IA (PI, Claude Code, Codex CLI…) dans le dossier Symbiose.

**3. Dis "yo"**
Le système prend le relais — il se configure, te demande ton prénom, et c'est parti.

**Pas de config, pas de dépendances, pas d'installation.**

---

## 📖 Comment ça marche

| Étape | Ce qui se passe |
|-------|-----------------|
| **1. Tu arrives** | Tu dis "yo" — le système démarre automatiquement |
| **2. Première fois** | Il scanne ton setup, te demande ton prénom, crée ton profil |
| **3. Tu travailles** | Tu donnes des instructions en langage naturel. L'IA annonce chaque action. |
| **4. Tu fermes** | Tu dis "close" ou "on a fini" → tout est sauvegardé pour la prochaine session |

---

## 🧠 Pourquoi l'utiliser ?

**Sans Symbiose :** Chaque nouvelle session repart de zéro. L'IA ne sait rien de toi, de tes projets, de tes préférences. Tu répètes les mêmes choses sans cesse.

**Avec Symbiose :**
- La mémoire persiste → l'IA est **plus pertinente à chaque session**
- Le profil s'affine → l'IA **s'adapte à ton rythme et ton style**
- Le contexte se transfère → **aucune perte entre les sessions**
- Plus tu l'utilises, **mieux ça fonctionne**

---

## 📂 Ce qu'il y a dans le dossier

```
Symbiose/                  ← ce que tu télécharges sur git
├── AGENTS.md              ← point d'entrée IA (chargé automatiquement)
├── CLAUDE.md              ← auto-chargement pour Claude Code
└── _SYSTEM/               ← framework complet
    ├── COMMANDES.md       ← triggers et mots-clés
    ├── FONCTIONNEMENT.md  ← architecture sous le capot
    ├── CORE.md            ← règles, modes, profil
    ├── AUTOSTART.md       ← séquence de démarrage
    ├── kernel/            ← compteur mécanique multi-outils
    ├── skills/            ← modules chargeables à la demande
    ├── tests/             ← tests d'intégrité du framework
    └── pi-extensions/     ← extensions optionnelles pour PI

⬇️ Créés au premier démarrage (gitignorés — ne jamais committer) :
├── 00_📥Inbox/            ← transfert de contexte entre sessions
├── 01_🧠Profil/           ← profil utilisateur, mémoire, traits
└── 02_🧬 … 07_🎨/         ← vault personnel (projets, vie, finances…)
```

Tout est en `.md` — tu peux ouvrir, lire et modifier n'importe quel fichier.

---

## 🔌 Extensions

Certains outils IA n'ont pas toutes les capacités nativement. Des extensions sont disponibles dans `_SYSTEM/pi-extensions/` :

| Extension | Pour qui | Ce qu'elle apporte |
|-----------|----------|--------------------|
| **web-search** | PI | Recherche DuckDuckGo + lecture de pages web |

Voir `_SYSTEM/pi-extensions/web-search/README.md` pour l'installation.

---

## 🔧 Personnalisation

Le système est fait pour être modifié :

1. **Ton profil** → édite `01_🧠Profil/👤profil.md`
2. **Les règles** → édite `_SYSTEM/CORE.md`
3. **Repartir à zéro** → supprime `01_🧠Profil/👤profil.md`

---

## 🤝 Contribuer

Une idée ou une correction ? Ouvre une **Issue** sur GitHub pour en discuter.
Si tu sais utiliser git : fork → modifie → Pull Request.

📋 [CHANGELOG](CHANGELOG.md) — historique des correctifs et ajouts.

---

## 📜 Licence

MIT — Libre d'utilisation, modification et partage.

---

**Construit pour durer. Conçu pour évoluer. Prêt à partager.**

---
*by [Wian Broes](https://github.com/WianBroes)*
