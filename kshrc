# vim: ft=sh
export HOME TERM
export PATH="$HOME/bin:/bin:/sbin:/usr/bin:/usr/sbin:/usr/X11R6/bin:/usr/local/bin:/usr/local/sbin:/usr/games"
export LANG='en_US.UTF-8'
export PAGER='less'

PS1='\[\033[0;31m\]\H\[\033[0;34m\] [\w]\[\033[0m\] \D{%a %b %d %R W%V}
\$ '

alias ..='cd ..'
alias l='ls -lh'
alias la='ls -A'

if type git > /dev/null; then
  alias s='git status -bs'
fi

