## Last Updated 2013-12-23
# Olle K bashrc

# Drop non-interactive shells
[[ $- != *i* ]] && return

### ENVIRONMENT SETUP
# Export home-bin if it doesn't exist
if [[ ! $PATH =~ "$HOME/bin" ]]; then
  export PATH=$HOME/bin:$PATH
fi

# Import bash-completion if they exist
if [[ $SHELL == "/bin/bash" && -f /etc/bash_completion ]]; then
  . /etc/bash_completion
fi

_check_locale()
{
  # If encoding is not en_US.UTF-8, try to set it
  local utf8_regex="^en_US\.[Uu][Tt][Ff][-]?8$"
  if [[ ! $LANG =~ $utf8_regex ]]; then
    local test_lang
    if test_lang=$(locale -a | grep -E $utf8_regex); then
      export LANG=$test_lang
    else
      echo -e "\033[1;33mEncoding Warning\033[0m"
      echo -e "Failed to change from $LANG to UTF-8"
    fi
  fi

  # Check if charmap is UTF-8
  if [[ ! $(locale charmap) =~ [Uu][Tt][Ff][-]?8 ]]; then
    echo -e "\033[1;33mEncoding Warning\033[0m"
    echo -e "LANG is UTF-8, but charmap is $(locale charmap)"
  fi
}
_check_locale

### VARIABLES
unset LESS
HISTFILE=~/.histfile
HISTSIZE=10000
VISUAL=vim
EDITOR=vim

if command -v __git_ps1 &>/dev/null; then
  PS1='\[\033[0;31m\]\h \[\033[0;34m\][\d \t] [\j jobs] [status $?] $(__git_ps1 "[git %s]")
\[\033[0;33m\]\u@\s(\v) \w \$ \[\033[0m\]'
else
  PS1='\[\033[0;31m\]\h \[\033[0;34m\][\d \t] [\j jobs] [status $?]
\[\033[0;33m\]\u@\s(\v) \w \$ \[\033[0m\]'
fi

### ALIAS
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

case `uname` in
  Linux)
    alias ls='ls --color=auto --group-directories-first'
    ;;
  SunOS)
    alias ls='ls --color=auto'
    alias emacs='emacs --color=always'
    ;;
  *BSD)
    alias ls='ls -G'
    ;;
esac

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
  LESS_TERMCAP_so=$'\E[38;5;246m' \
  LESS_TERMCAP_ue=$'\E[0m' \
  LESS_TERMCAP_us=$'\E[04;38;5;146m' \
  man "$@"
}
