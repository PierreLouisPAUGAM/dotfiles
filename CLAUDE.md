# Dotfiles

Ce repo est géré via un bare git repo (`~/.dotfiles`).
Utiliser `dot` (alias de `git --git-dir=$HOME/.dotfiles --work-tree=$HOME`) pour toutes les opérations git.

Voir `~/README.md` pour la documentation complète.

## Fichiers de configuration

- `~/.zshrc` — Config shell (cross-platform WSL/macOS)
- `~/.config/starship.toml` — Prompt (preset catppuccin-powerline)
- `~/.config/nvim/` — Neovim (LazyVim)
- `~/.config/wezterm/wezterm.lua` — Terminal (cross-platform via `wezterm.target_triple`)
- `~/.config/fzf/` — Couleurs fzf par flavour
- `~/.config/theme` — Source de vérité du thème actif (`macchiato` ou `latte`)
- `~/.local/bin/theme-toggle` — Script de bascule dark/light

## Theme toggle (Ctrl+Shift+P)

`theme-toggle` met à jour `~/.config/theme`, puis :
- `sed` sur `starship.toml` (palette)
- `touch` sur le fichier wezterm (déclenche reload)
- fzf relit les couleurs via `precmd` zsh
- nvim relit le thème via autocmd `FocusGained`

Sur WSL, wezterm utilise un stub Windows qui fait `dofile` vers le fichier WSL.
