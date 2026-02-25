<h1 align="center">dotfiles</h1>

<p align="center">
  <a href="LICENSE"><img src="https://img.shields.io/github/license/PierreLouisPAUGAM/dotfiles?color=blue&style=flat-square" alt="License"></a>
  <img src="https://img.shields.io/badge/platform-WSL2%20%7C%20macOS-informational?style=flat-square" alt="Platform">
  <img src="https://img.shields.io/badge/theme-catppuccin-mauve?style=flat-square&logo=data:image/svg+xml;base64,PHN2ZyB3aWR0aD0iNjQiIGhlaWdodD0iNjQiIHZpZXdCb3g9IjAgMCA2NCA2NCIgZmlsbD0ibm9uZSIgeG1sbnM9Imh0dHA6Ly93d3cudzMub3JnLzIwMDAvc3ZnIj48cGF0aCBkPSJNNjMuMTQgMzIuMDRjMCAxNy4xNi0xMy45IDMxLjA2LTMxLjA2IDMxLjA2UzEuMDIgNDkuMiAxLjAyIDMyLjA0IDEQuOTIuOTggMzIuMDguOTggNjMuMTQgMTQuODggNjMuMTQgMzIuMDR6IiBmaWxsPSIjZmZmIi8+PC9zdmc+" alt="Catppuccin">
</p>

<p align="center">
  Configuration cross-platform pour un environnement terminal unifié.<br>
  Bare git repo — un seul <code>dot checkout</code> et tout est en place.
</p>

---

## Stack

| Outil | Rôle |
|---|---|
| [WezTerm](https://wezfurlong.org/wezterm/) | Émulateur de terminal (Windows / macOS) |
| [zsh](https://www.zsh.org/) | Shell |
| [Starship](https://starship.rs/) | Prompt (config custom inspirée Catppuccin powerline) |
| [Neovim](https://neovim.io/) + [LazyVim](https://www.lazyvim.org/) | Éditeur |
| [fzf](https://github.com/junegunn/fzf) | Fuzzy finder |
| [zoxide](https://github.com/ajeetdsouza/zoxide) | Navigation intelligente (`cd`) |
| [mise](https://mise.jdx.dev/) | Gestionnaire de versions (node, python, go…) |
| [eza](https://github.com/eza-community/eza) | Remplacement de `ls` |
| [bat](https://github.com/sharkdp/bat) | Remplacement de `cat` |
| [ripgrep](https://github.com/BurntSushi/ripgrep) | Remplacement de `grep` |
| [fd](https://github.com/sharkdp/fd) | Remplacement de `find` |
| [jq](https://github.com/jqlang/jq) | Traitement JSON |
| [lazydocker](https://github.com/jesseduffield/lazydocker) | TUI Docker (optionnel) |
| [Claude Code](https://docs.anthropic.com/en/docs/claude-code) | Assistant CLI (statusline custom theme-aware) |

## Prérequis

<details>
<summary><strong>CLI tools</strong></summary>

```bash
# Debian/Ubuntu (WSL)
sudo apt install zsh fzf bat ripgrep fd-find jq
# bat s'installe sous le nom batcat, créer un lien :
# ln -s /usr/bin/batcat ~/.local/bin/bat
# fd s'installe sous le nom fdfind :
# ln -s /usr/bin/fdfind ~/.local/bin/fd

# macOS
brew install zsh fzf bat ripgrep fd jq
```

Les outils suivants s'installent indépendamment :
[starship](https://starship.rs/#install) ·
[neovim](https://github.com/neovim/neovim/blob/master/INSTALL.md) ·
[zoxide](https://github.com/ajeetdsouza/zoxide#installation) ·
[mise](https://mise.jdx.dev/getting-started.html) ·
[eza](https://github.com/eza-community/eza#installation) ·
[lazydocker](https://github.com/jesseduffield/lazydocker#installation) (optionnel)

</details>

<details>
<summary><strong>Plugins zsh</strong></summary>

```bash
# Debian/Ubuntu (WSL)
sudo apt install zsh-autosuggestions zsh-syntax-highlighting

# macOS
brew install zsh-autosuggestions zsh-syntax-highlighting
```

</details>

<details>
<summary><strong>Thèmes bat Catppuccin</strong></summary>

```bash
mkdir -p "$(bat --config-dir)/themes"
cd "$(bat --config-dir)/themes"
curl -sLO https://github.com/catppuccin/bat/raw/main/themes/Catppuccin%20Latte.tmTheme
curl -sLO https://github.com/catppuccin/bat/raw/main/themes/Catppuccin%20Macchiato.tmTheme
bat cache --build
```

</details>

**Font** — [JetBrainsMono Nerd Font](https://www.nerdfonts.com/font-downloads), à installer côté hôte (Windows ou macOS).

**Terminal** — [WezTerm](https://wezfurlong.org/wezterm/installation.html), installé côté hôte.

## Installation

```bash
git clone --bare https://github.com/PierreLouisPAUGAM/dotfiles.git ~/.dotfiles
alias dot='git --git-dir=$HOME/.dotfiles --work-tree=$HOME'
dot config status.showUntrackedFiles no
dot checkout
```

> Si `dot checkout` échoue à cause de fichiers existants, les sauvegarder ou les supprimer puis relancer.

Initialiser le thème :

```bash
mkdir -p ~/.config
echo macchiato > ~/.config/theme
```

<details>
<summary><strong>WSL — stub WezTerm côté Windows</strong></summary>

```bash
mkdir -p /mnt/c/Users/<USERNAME>/.config/wezterm
cat > /mnt/c/Users/<USERNAME>/.config/wezterm/wezterm.lua << 'EOF'
return dofile("\\\\wsl$\\Ubuntu-24.04\\home\\<USERNAME>\\.config\\wezterm\\wezterm.lua")
EOF
```

Remplacer `<USERNAME>` par le nom d'utilisateur Windows et Linux correspondant.

</details>

**macOS** — rien de spécial, tout fonctionne directement après le clone.

## Usage quotidien

```bash
dot status                    # voir les changements
dot add ~/.zshrc              # stager un fichier modifié
dot commit -m "update zshrc"  # commiter
dot push                      # pousser
dot pull                      # récupérer depuis l'autre machine
```

## Theme toggle

> **`Ctrl+Shift+P`** dans WezTerm bascule l'ensemble de la stack entre dark et light.

Catppuccin **Macchiato** (dark) / **Latte** (light), appliqué de manière cohérente sur tous les outils.

Le fichier `~/.config/theme` (non traqué) contient le flavour actif et sert de source de vérité :

```
~/.config/theme        ← "macchiato" ou "latte" (runtime, non traqué)
       │
       ├── starship    : config runtime régénérée dans ~/.cache/starship.toml (precmd)
       ├── wezterm     : lit le fichier au chargement de la config
       ├── nvim        : lit le fichier au démarrage + FocusGained
       ├── bat         : BAT_THEME mis à jour à chaque prompt (precmd)
       └── fzf         : couleurs relues à chaque prompt (precmd)
```

`theme-toggle` écrit la nouvelle flaveur dans `~/.config/theme` et touche le fichier WezTerm pour déclencher un reload. Les mises à jour de starship, bat et fzf sont gérées par les hooks `precmd` du shell — aucun fichier traqué n'est modifié.

## Highlights

| Fonctionnalité | Description |
|---|---|
| **dot-status** | Notification WezTerm au démarrage si des changements dotfiles sont en attente |
| **Smart padding** | Le padding WezTerm est retiré automatiquement pour les TUI fullscreen (nvim, htop, btop, tmux…) |
| **docker-sync** | Crée/met à jour les contextes Docker depuis les hosts marqués `# docker` dans `~/.ssh/config` |
| **hardtime.nvim** | Hints pour améliorer les habitudes Vim (mode hint, seuil à 4 répétitions) |
| **Claude Code statusline** | Statusline custom theme-aware : répertoire, branche, modèle, barre de contexte, lignes +/−, durée |

## Fichiers traqués

```
.zshrc                              Shell config (cross-platform)
.config/
├── starship.toml                   Prompt template (palette par défaut : macchiato)
├── fzf/
│   ├── catppuccin-macchiato        Couleurs fzf dark
│   └── catppuccin-latte            Couleurs fzf light
├── wezterm/
│   └── wezterm.lua                 Terminal config (cross-platform)
└── nvim/                           Neovim (LazyVim)
.local/bin/
├── theme-toggle                    Bascule de thème
└── dot-status                      État dotfiles (toast wezterm)
.claude/
├── settings.json                   Config Claude Code (statusline)
└── statusline.sh                   Statusline custom theme-aware
```

<details>
<summary><strong>Fichiers runtime (non traqués)</strong></summary>

| Fichier | Rôle |
|---|---|
| `~/.config/theme` | Flavour actif (`macchiato` ou `latte`) |
| `~/.cache/starship.toml` | Config starship générée avec la bonne palette |

</details>

## Cross-platform

| Aspect | WSL | macOS |
|---|---|---|
| Plugins zsh | `/usr/share/` (apt) | `/opt/homebrew/share/` (brew) |
| `sed -i` | `sed -i "..."` | `sed -i '' "..."` |
| WezTerm config | Stub Windows → dofile vers WSL | Directement `~/.config/wezterm/wezterm.lua` |
| WezTerm `default_prog` | `wsl.exe -d Ubuntu-24.04` | Non nécessaire |
| WezTerm `front_end` | `Software` | Default (WebGpu) |

Les conditions OS sont gérées dans les fichiers eux-mêmes (`uname`, `wezterm.target_triple`).

## License

Distribué sous licence [MIT](LICENSE).
