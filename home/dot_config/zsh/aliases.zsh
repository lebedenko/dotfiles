if (( $+commands[eza] )); then
  alias ls='eza --group-directories-first --icons'
  alias lt='ls -lT'
fi
alias l='ls -l'
alias ll='ls -la'
if (( $+commands[bat] )); then
  alias cat='bat --style=numbers'
elif (( $+commands[batcat] )); then
  alias cat='batcat --style=numbers'
fi
(( $+commands[ncdu] )) && alias ncdu='ncdu --color dark'
true
