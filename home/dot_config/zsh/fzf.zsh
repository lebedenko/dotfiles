export FZF_DEFAULT_OPTS="${FZF_DEFAULT_OPTS:-}
  --color=fg:#c0caf5,bg:#1e2030,hl:#bb9af7
  --color=fg+:#c0caf5,bg+:#1a1b26,hl+:#7dcfff
  --color=info:#7aa2f7,prompt:#7dcfff,pointer:#7dcfff
  --color=marker:#9ece6a,spinner:#9ece6a,header:#9ece6a"

if (( $+commands[fd] )); then
  export FZF_DEFAULT_COMMAND='fd --type f --hidden --exclude .git'
  export FZF_ALT_C_COMMAND='fd --type d --exclude .git'
elif (( $+commands[fdfind] )); then
  export FZF_DEFAULT_COMMAND='fdfind --type f --hidden --exclude .git'
  export FZF_ALT_C_COMMAND='fdfind --type d --exclude .git'
fi
[[ -n ${FZF_DEFAULT_COMMAND:-} ]] && export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
if (( $+commands[bat] )); then
  export FZF_CTRL_T_OPTS="--preview 'bat --color=always --style=numbers --line-range=:50 {}'"
elif (( $+commands[batcat] )); then
  export FZF_CTRL_T_OPTS="--preview 'batcat --color=always --style=numbers --line-range=:50 {}'"
fi
export FZF_CTRL_R_OPTS="--preview 'echo {}' --preview-window down:4:hidden:wrap --bind '?:toggle-preview'"
(( $+commands[eza] )) && export FZF_ALT_C_OPTS="--preview 'eza -T --icons {} | head -60'"

# Oh My Zsh normally loads these; support its absence on both package families.
if [[ -o zle && -t 0 ]] && (( ! $+widgets[fzf-file-widget] )); then
  for bindings in /usr/share/fzf/key-bindings.zsh /usr/share/doc/fzf/examples/key-bindings.zsh; do
    if [[ -r $bindings ]]; then
      source "$bindings"
      break
    fi
  done
  unset bindings
fi
true
