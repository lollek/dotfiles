## Last Updated 2013-03-04
# Olle K bashrc

# Drop non-interactive shells
[[ $- != *i* ]] && return

# Export home-bin if it doesn't exist
if [[ ! $PATH =~ "$HOME/bin" ]]; then
  export PATH=$HOME/bin:$PATH
fi

# Import bash-completion if they exist
if [[ $SHELL == "/bin/bash" && -f /etc/bash_completion ]]; then
  . /etc/bash_completion
fi

# Try to set locale to en_US.UTF-8
if [[ ! $BASH_SCRIPTS_ARE_SOURCED ]]; then
  export BASH_SCRIPTS_ARE_SOURCED=1
  . $HOME/dotfiles/bash_scripts
fi
_set_locale

# Variables
set +o ignoreeof
unset LESS
HISTFILE=~/.histfile
HISTSIZE=10000
VISUAL=vim
EDITOR=vim
PAGER=less
GPGKEY=02FDDED4

# This has worked on all systems so far
stty sane
stty stop undef
stty start undef

_set_ps1() {
  local host
  [[ -z $SSH_TTY ]] || host="\[\033[0;31m\]$HOSTNAME "
  PS1="$host\[\033[0;34m\][\d \t] [j:\j|s:$?]
\[\033[0;33m\]\u \w \$ \[\033[0m\]"
}
_set_ps1

# Aliases
alias ..='cd ..'
alias chmod='chmod -v'
alias chown='chown -v'
alias chgrp='chgrp -v'
alias cp='cp -v'
alias ln='ln -v'
alias mv='mv -v'
alias rm='rm -v'
alias la='ls -A'
alias l='ls -lh'
alias ll='ls -alh'
alias grep='grep --color=auto'

case $(uname) in
  Linux)
    alias ls='ls --color=auto --group-directories-first'
    ;;
  SunOS)
    alias ls='ls --color=auto'
    alias emacs='emacs --color=always'
    [[ $TERM == screen ]] && TERM=xterm
    ;;
  *BSD)
    alias ls='ls -G'
    ;;
esac

# Minifuns
function pushtmp() { cd $(mktemp -d); }
function poptmp() { rmdir $PWD && cd ->/dev/null; }
function youtube() { [[ -z $1 ]] || mplayer $(youtube-dl -g "$1") -vo null; }

# Special application aliases
alias gcc='gcc -Wall -Wextra -Werror -pedantic -g'
alias g++='g++ -Wall -Wextra -Werror -pedantic -Weffc++ -g'
alias g++11='g++ -std=c++11'
alias clang++11='clang++ -std=c++11'
alias ghc='ghc --make -Wall'

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
