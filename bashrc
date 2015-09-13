## Olle K bashrc. Needs to work with zsh as well
## Last Updated 2015-09-13

## Drop non-interactive shells
[[ $- != *i* ]] && return

set +o ignoreeof

[[ $PATH == *$HOME/bin* ]] || export PATH="$HOME/bin:$PATH"
export HISTFILE="$HOME/.histfile"
export HISTSIZE="10000"
export GPGKEY="02FDDED4"
export PAGER="less"
export LS_COLORS="di=34:ln=35:so=32:pi=33:ex=31:bd=34;46:cd=34;43:su=0;41:sg=0;46:tw=0;42:ow=0;43:"

export EDITOR="$(type vim &>/dev/null && echo vim || echo vi)"
export VISUAL="$EDITOR"
alias :e='$EDITOR'

case $(uname) in
  Linux)
    alias ls='ls --color=auto --group-directories-first'
    alias chmod='chmod -c'
    alias chown='chown -c'
    alias chgrp='chgrp -c'
    ;;

  SunOS)
    alias ls='ls --color=auto'
    alias emacs='emacs --color=always'
    unset LESS
    export LS_COLORS="${LS_COLORS//:su*}"
    [[ $TERM == screen ]] && export TERM=xterm
    ;;

  *BSD|Darwin)
    alias ls='ls -G'
    ;;
esac

alias ..='cd ..'
alias l='ls -lh'
alias la='ls -A'
alias ll='ls -lh'
alias grep='grep --color=auto'

isempty() { (shopt -s nullglob dotglob; f=($1/*); ((! ${#f[@]}))); }
retry() { while ! "$@"; do sleep 1; done; }
man() {
  env LESS_TERMCAP_mb=$'\E[01;31m' \
  LESS_TERMCAP_md=$'\E[01;38;5;74m' \
  LESS_TERMCAP_me=$'\E[0m' \
  LESS_TERMCAP_se=$'\E[0m' \
  LESS_TERMCAP_ue=$'\E[0m' \
  LESS_TERMCAP_us=$'\E[04;38;5;146m' \
  man "$@"
}

reset_bash_ps1() {
  local host=""
  local color="\[\033[0;34m\]"

  if [[ -n $SSH_TTY ]]; then
    case "$(hostname -f)" in
      "phii.iix.se")    host="phii.iix.se ";    color="\[\033[0;35m\]" ;;
      "pikachu.iix.se") host="pikachu.iix.se "; color="\[\033[0;32m\]" ;;
      *)                host="$HOSTNAME ";      color="\[\033[0;37m\]" ;;
    esac
  fi
  PS1="${headerclr}${host}[\\d \\t] [j:\\j|s:\$?]\n\[\033[0;33m\]\\u \\w \\$ \[\033[0m\]"
}
[[ -n $BASH_VERSION  ]] && reset_bash_ps1


## LOCALE
tryfix_utf8() {
  local utf8 us_utf8 wanted_locale charmap
  utf8="[Uu][Tt][Ff]-?8"
  us_utf8="^en_US\.$utf8$"
  warn() { echo -e "\033[1;33mWarning:\033[0m $1"; }


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

  unset warn
}
tryfix_utf8

init_stty_settings() {
  local stty_settings="stty start undef; stty stop undef"
  alias reset="/usr/bin/reset; $stty_settings"
  alias reset1="/usr/bin/reset -e ^?; $stty_settings"
  alias reset2="/usr/bin/reset -e ^h; $stty_settings"
  eval "$stty_settings"
}
init_stty_settings

## Special application settings

if type apt-get &> /dev/null; then
  apt-sync() {
    sudo apt-get update &&
    sudo apt-get upgrade &&
    sudo apt-get autoremove &&
    sudo apt-get autoclean
  }
fi

if type as &> /dev/null; then
  asm() { as -o "${1%.*}.o" "$1" && ld -o "${1%.*}" "${1%.*}.o"; }
fi

if type clang &> /dev/null; then
  alias clang='clang -Weverything -Werror'
  alias clang++='clang++ -Weverything -Werror'
  alias clang++11='clang++ -std=c++11'
fi

if type g++ &> /dev/null; then
  alias g++='g++ -Wall -Wextra -Werror -pedantic -Weffc++'
  alias g++99='g++ -std=c++99'
  alias g++11='g++ -std=c++11'
fi

if type gcc &> /dev/null; then
  alias gcc='gcc -Wall -Wextra -Werror -pedantic'
  alias gcc89='gcc -std=c89'
  alias gcc99='gcc -std=c99'
  alias gcc11='gcc -std=c11'
fi

if type ghc &> /dev/null; then
  alias ghc='ghc --make -Wall'
fi

if type git &> /dev/null; then
  alias s='git status -bs'
fi

if type nasm &> /dev/null; then
  asm32() { nasm -f elf32 "$1" && ld -m elf_i386 -o "${1%.*}" "${1%.*}.o"; }
fi

if type pacman &> /dev/null; then
  alias pacman='pacman --color=auto'
fi

## Extra files to exec
[[ -f /etc/bash_completion ]] && source /etc/bash_completion
