# ╔═══════════════════════════════════════════════════════════════╗
# ║  .zshrc                                                      ║
# ╚═══════════════════════════════════════════════════════════════╝
[[ ! -o interactive ]] && return

# ── SSH Agent auto-start + chargement des clés ───────────────
if [ -z "$SSH_AUTH_SOCK" ]; then
  eval "$(ssh-agent -s)" > /dev/null
fi
if ! ssh-add -l &>/dev/null; then
  for key in ~/.ssh/*; do
    [ -f "$key" ] || continue
    case "$key" in
      *.pub|*/config|*/known_hosts*|*/authorized_keys|*/agent|*/agent.env) continue ;;
    esac
    ssh-add "$key" 2>/dev/null
  done
fi

# ── PATH ──────────────────────────────────────────────────────
export PATH="$HOME/.local/bin:$HOME/.cargo/bin:$PATH"

# ── Historique ──────────────────────────────────────────────
HISTFILE="$HOME/.zsh_history"
HISTSIZE=10000
SAVEHIST=10000
setopt APPEND_HISTORY
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE
setopt SHARE_HISTORY
zshaddhistory() {
  [[ $(echo -n "$1" | wc -l) -le 3 && ${#1} -le 500 ]]
}

# ── Éditeur par défaut ────────────────────────────────────────
export EDITOR="nvim"
export VISUAL="$EDITOR"

# ── mise (gestionnaire de versions) ──────────────────────────
eval "$(~/.local/bin/mise activate zsh 2>/dev/null)" || true

# ── Starship : config runtime avec thème dynamique ─────────
_update_starship_theme() {
  local flavour runtime src
  flavour=$(command cat ~/.config/theme 2>/dev/null || echo macchiato)
  src="$HOME/.config/starship.toml"
  runtime="$HOME/.cache/starship.toml"
  if [[ ! -f "$runtime" ]] || [[ "$src" -nt "$runtime" ]] \
     || ! grep -q "^palette = 'catppuccin_$flavour'" "$runtime" 2>/dev/null; then
    sed "s/palette = 'catppuccin_.*'/palette = 'catppuccin_$flavour'/" "$src" > "$runtime"
  fi
}
export STARSHIP_CONFIG="$HOME/.cache/starship.toml"
_update_starship_theme
precmd_functions+=(_update_starship_theme)

# ── Starship prompt ──────────────────────────────────────────
eval "$(starship init zsh)"

# ── Zoxide (cd intelligent) ──────────────────────────────────
eval "$(zoxide init zsh)"

# ── fzf ──────────────────────────────────────────────────────
source <(fzf --zsh)

# ── Plugins zsh ──────────────────────────────────────────────
for _zsh_plugin_dir in /opt/homebrew/share /usr/local/share /usr/share; do
  if [[ -f "$_zsh_plugin_dir/zsh-autosuggestions/zsh-autosuggestions.zsh" ]]; then
    source "$_zsh_plugin_dir/zsh-autosuggestions/zsh-autosuggestions.zsh"
    source "$_zsh_plugin_dir/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
    break
  fi
done
unset _zsh_plugin_dir

# ── Aliases : fichiers & navigation ──────────────────────────
alias ls='eza --icons --group-directories-first'
alias ll='eza -la --icons --group-directories-first'
alias lt='eza -la --icons -TL2'
alias cat='bat --style=plain --paging=never --theme=$BAT_THEME'
alias grep='rg'
alias find='fd'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

# ── Aliases : Git ────────────────────────────────────────────
alias g='git'
alias gs='git status -sb'
alias ga='git add'
alias gc='git commit'
alias gp='git push'
alias gl='git log --oneline --graph --decorate -20'
alias gd='git diff'
alias gco='git checkout'

# ── Aliases : Docker ─────────────────────────────────────────
alias d='docker'
alias dc='docker compose'
alias dps='docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"'
lzd() {
  if [ -n "$1" ]; then
    docker context use "$1" &>/dev/null || { echo "Context '$1' introuvable. Lance docker-sync ?"; return 1; }
  fi
  lazydocker
}

# ── Aliases : divers ─────────────────────────────────────────
alias reload='source ~/.zshrc'
alias path='echo $PATH | tr ":" "\n"'
alias dot='git --git-dir=$HOME/.dotfiles --work-tree=$HOME'
capi() { curl -s "$@" | jq .; }

# ── Docker contexts auto (depuis ~/.ssh/config # docker) ────
docker-sync() {
  local ssh_hosts=""

  while read -r name; do
    ssh_hosts="$ssh_hosts $name"
    docker context inspect "$name" &>/dev/null \
      && docker context update "$name" --docker "host=ssh://${name}" &>/dev/null \
      || docker context create "$name" --docker "host=ssh://${name}" &>/dev/null
  done < <(awk '
    /^# docker/     { tagged=1; next }
    /^Host / && tagged && !/\*/ { print $2; tagged=0 }
  ' ~/.ssh/config)

  for ctx in $(docker context ls --format '{{.Name}}' | grep -v default); do
    echo "$ssh_hosts" | grep -qw "$ctx" || docker context rm "$ctx" &>/dev/null
  done

  docker context ls
}

# ── bat : thème dynamique ──────────────────────────────────
_update_bat_theme() {
  local flavour
  flavour=$(cat ~/.config/theme 2>/dev/null || echo macchiato)
  case "$flavour" in
    latte)     export BAT_THEME="Catppuccin Latte" ;;
    *)         export BAT_THEME="Catppuccin Macchiato" ;;
  esac
}
_update_bat_theme
precmd_functions+=(_update_bat_theme)

# ── fzf : configuration ─────────────────────────────────────
export FZF_DEFAULT_COMMAND='fd --type f --hidden --exclude .git'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND='fd --type d --hidden --exclude .git'
_update_fzf_theme() {
  local flavour
  flavour=$(cat ~/.config/theme 2>/dev/null || echo macchiato)
  export FZF_DEFAULT_OPTS=" \
    --height 40% \
    --layout=reverse \
    --border \
    $(tr '\n' ' ' < ~/.config/fzf/catppuccin-"$flavour")"
}
_update_fzf_theme
precmd_functions+=(_update_fzf_theme)

# ── Wezterm config sync (WSL only) ───────────────────────────
if [[ "$(uname)" == "Linux" ]]; then
  _wsl_win_home=$(wslpath "$(cmd.exe /c 'echo %USERPROFILE%' 2>/dev/null | tr -d '\r')")
  _sync_wezterm() {
    local src="$HOME/.config/wezterm/wezterm.lua"
    local marker="$HOME/.config/wezterm/.last_sync"
    if [[ -f "$src" ]] && [[ "$src" -nt "$marker" ]]; then
      touch "$_wsl_win_home/.config/wezterm/wezterm.lua"
      touch "$marker"
    fi
  }
  precmd_functions+=(_sync_wezterm)
fi
