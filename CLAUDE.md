# Dotfiles

Ce repo est géré via un bare git repo (`~/.dotfiles`).
Utiliser `dot` (alias de `git --git-dir=$HOME/.dotfiles --work-tree=$HOME`) pour toutes les opérations git.

Voir `~/README.md` pour la documentation complète.

## Fichiers de configuration

- `~/.zshrc` — Config shell (cross-platform WSL/macOS)
- `~/.config/starship.toml` — Prompt template (palette par défaut: macchiato)
- `~/.config/nvim/` — Neovim (LazyVim)
- `~/.config/wezterm/wezterm.lua` — Terminal (cross-platform via `wezterm.target_triple`)
- `~/.config/fzf/` — Couleurs fzf par flavour
- `~/.local/bin/theme-toggle` — Script de bascule dark/light
- `~/.config/theme` — Flavour actif, **non traqué** (état runtime)
- `~/.cache/starship.toml` — Config starship runtime générée (non traquée)

## Theme toggle (Ctrl+Shift+P)

`theme-toggle` met à jour `~/.config/theme` et touche le fichier wezterm (reload). Les autres outils se mettent à jour via les hooks `precmd` du shell :
- starship : config runtime régénérée dans `~/.cache/starship.toml`
- bat : `BAT_THEME` mis à jour
- fzf : couleurs relues
- nvim : relit le thème via autocmd `FocusGained`

Aucun fichier traqué n'est modifié par un toggle → `dot status` reste propre.

Sur WSL, wezterm utilise un stub Windows qui fait `dofile` vers le fichier WSL.

## Git

Ne jamais ajouter de `Co-Authored-By` dans les commits.
