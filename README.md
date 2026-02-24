# dotfiles

Configuration cross-platform (WSL2 / macOS) pour un environnement terminal unifié.

## Stack

| Outil | Rôle |
|---|---|
| [wezterm](https://wezfurlong.org/wezterm/) | Émulateur de terminal (Windows / macOS) |
| [zsh](https://www.zsh.org/) | Shell |
| [starship](https://starship.rs/) | Prompt (preset catppuccin-powerline) |
| [nvim](https://neovim.io/) + [LazyVim](https://www.lazyvim.org/) | Éditeur |
| [fzf](https://github.com/junegunn/fzf) | Fuzzy finder |
| [zoxide](https://github.com/ajeetdsouza/zoxide) | Navigation intelligente (`cd`) |
| [mise](https://mise.jdx.dev/) | Gestionnaire de versions (node, python, go, etc.) |
| [eza](https://github.com/eza-community/eza) | Remplacement de `ls` |
| [bat](https://github.com/sharkdp/bat) | Remplacement de `cat` |
| [ripgrep](https://github.com/BurntSushi/ripgrep) | Remplacement de `grep` |
| [fd](https://github.com/sharkdp/fd) | Remplacement de `find` |
| [lazydocker](https://github.com/jesseduffield/lazydocker) | TUI Docker |

## Theme

Catppuccin Macchiato (dark) / Latte (light), appliqué de manière cohérente sur tous les outils.

**Toggle global** : `Ctrl+Shift+P` dans wezterm bascule l'ensemble de la stack entre dark et light mode.

Le fichier `~/.config/theme` (non traqué, état runtime) contient le flavour actif (`macchiato` ou `latte`) et sert de source de vérité pour tous les outils :

```
~/.config/theme        <-- "macchiato" ou "latte" (runtime, non traqué)
       |
       +-- starship    : config runtime générée dans ~/.cache/starship.toml (precmd)
       +-- wezterm     : lit le fichier au chargement de la config
       +-- nvim        : lit le fichier au démarrage + FocusGained
       +-- bat         : BAT_THEME mis à jour à chaque prompt (precmd)
       +-- fzf         : couleurs relues à chaque prompt (precmd)
```

`theme-toggle` écrit la nouvelle flaveur dans `~/.config/theme` et touche le fichier wezterm pour déclencher un reload. La mise à jour de starship, bat et fzf est gérée par les hooks `precmd` du shell, ce qui évite de modifier des fichiers traqués par le repo.

## Fichiers

```
~/.zshrc                                  Shell config (cross-platform)
~/.config/starship.toml                   Prompt template (palette par défaut : macchiato)
~/.config/fzf/catppuccin-macchiato        Couleurs fzf dark
~/.config/fzf/catppuccin-latte            Couleurs fzf light
~/.config/wezterm/wezterm.lua             Terminal config (cross-platform)
~/.config/nvim/                           Neovim (LazyVim)
~/.local/bin/theme-toggle                 Script de bascule de thème

# Fichiers runtime (non traqués)
~/.config/theme                           Flavour actif (macchiato|latte)
~/.cache/starship.toml                    Config starship générée avec la bonne palette
```

## Installation

### Machine existante (clone)

```bash
git clone --bare git@github.com:USER/dotfiles.git ~/.dotfiles
alias dot='git --git-dir=$HOME/.dotfiles --work-tree=$HOME'
dot config status.showUntrackedFiles no
dot checkout
```

Sur WSL, créer le stub wezterm côté Windows :

```bash
mkdir -p /mnt/c/Users/USERNAME/.config/wezterm
cat > /mnt/c/Users/USERNAME/.config/wezterm/wezterm.lua << 'EOF'
return dofile("\\\\wsl$\\Ubuntu-24.04\\home\\USERNAME\\.config\\wezterm\\wezterm.lua")
EOF
```

### Usage quotidien

```bash
dot status                    # voir les changements
dot add ~/.zshrc              # stager un fichier modifié
dot commit -m "update zshrc"  # commiter
dot push                      # pousser
dot pull                      # récupérer depuis l'autre machine
```

## Notes cross-platform

| Aspect | WSL | macOS |
|---|---|---|
| Plugins zsh | `/usr/share/` (apt) | `/opt/homebrew/share/` (brew) |
| `sed -i` (scripts) | `sed -i "..."` | `sed -i '' "..."` |
| wezterm config | Stub Windows + dofile vers WSL | Directement `~/.config/wezterm/wezterm.lua` |
| wezterm `default_prog` | `wsl.exe -d Ubuntu-24.04` | Non nécessaire |
| wezterm `front_end` | `Software` | Default (WebGpu) |

Les conditions OS sont gérées dans les fichiers eux-mêmes (`uname`, `wezterm.target_triple`).
