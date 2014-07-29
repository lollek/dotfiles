## Olle K bashrc
## Last Updated 2014-07-28

## Drop non-interactive shells
[[ $- != *i* ]] && return

## ENVIRONMENT
[[ $PATH == *$HOME/bin* ]] || export PATH=$HOME/bin:$PATH
export EDITOR=$(type vim &>/dev/null && echo vim || echo vi)
export VISUAL=$EDITOR
export PAGER=less
export LS_COLORS="di=34:ln=35:so=32:pi=33:ex=31:bd=34;46:cd=34;43:su=0;41:sg=0;46:tw=0;42:ow=0;43:"
export HISTFILE=~/.histfile
export HISTSIZE=10000
export GPGKEY=02FDDED4

## This has worked on all systems so far
stty sane
stty stop undef
stty start undef

## BASH
if [[ $SHELL == *bash ]]; then
  set +o ignoreeof

  # PS1
  [[ -z $SSH_TTY ]] && host= || host="\[\033[0;31m\]$HOSTNAME "
  PS1="$host\[\033[0;34m\][\d \t] [j:\j|s:\$?]
\[\033[0;33m\]\u \w \$ \[\033[0m\]"
  unset host

  # Autocomplete
  [[ -f /etc/bash_completion ]] && source /etc/bash_completion
fi

## LOCALE
utf8="[Uu][Tt][Ff]-?8"
us_utf8="^en_US\.$utf8$"
warn() { echo -e "\033[1;33mWarning:\033[0m $@"; }

if [[ ! $LANG =~ $us_utf8 ]]; then
  wanted_locale=$(locale -a | awk "/$us_utf8/{print;exit}")
  if [[ -z $wanted_locale ]]; then
    warn "Could not find any en_US.UTF-8 locale. (Currently: $LANG)"
  else
    export LANG=$wanted_locale
    if [[ ! $(locale LC_TIME | tail -n 1)  == "UTF-8" ]]; then
      warn "Had to force set LC_ALL, encoding might not work"
      export LC_ALL=$wanted_locale
    fi
  fi
fi

charmap=$(locale charmap)
[[ $charmap =~ $utf8 ]] || warn "Charmap is $charmap"
unset utf8 us_utf8 warn wanted_charmap charmap

## ALIASES
alias ..='cd ..'
alias :e="$EDITOR"

alias la='ls -A'
alias ll='ls -lh'
alias grep='grep --color=auto'

alias gcc='gcc -Wall -Wextra -Werror -pedantic'
alias gcc89='gcc -std=c89'
alias gcc99='gcc -std=c99'
alias gcc11='gcc -std=c11'
alias g++='g++ -Wall -Wextra -Werror -pedantic -Weffc++'
alias g++11='g++ -std=c++11'
alias clang='clang -Weverything -Werror'
alias clang++='clang++ -Weverything -Werror'
alias clang++11='clang++ -std=c++11'
alias ghc='ghc --make -Wall'

alias pushtmp='cd $(mktemp -d)'
alias poptmp='\rm -ri "$PWD" && cd -'

case $(uname) in
  Linux)
    alias ls='ls --color=auto --group-directories-first'
    alias chmod='chmod -c'
    alias chown='chown -c'
    alias chgrp='chgrp -c'
    ;;
  SunOS)
    unset LESS
    alias ls='ls --color=auto'
    alias emacs='emacs --color=always'
    # SunOS treats screen as a stupid shell and removes features
    [[ $TERM == screen ]] && export TERM=xterm
    # SunOS doesn't recognize the last bit of colors
    [[ -z $LS_COLORS ]] || export LS_COLORS=${LS_COLORS//:su*}
    ;;
  *BSD)
    alias ls='ls -G'
    ;;
esac

## FUNCTIONS
isempty() { (shopt -s nullglob dotglob; f=($1/*); ((! ${#f[@]}))); }
retry() { while ! $@; do sleep 1; done; }

# Colored man-pages
man() {
  env LESS_TERMCAP_mb=$'\E[01;31m' \
  LESS_TERMCAP_md=$'\E[01;38;5;74m' \
  LESS_TERMCAP_me=$'\E[0m' \
  LESS_TERMCAP_se=$'\E[0m' \
  LESS_TERMCAP_ue=$'\E[0m' \
  LESS_TERMCAP_us=$'\E[04;38;5;146m' \
  man "$@"
}
