## Last Updated 2013-12-23
# Olle K bashrc

# Drop non-interactive shells
[[ $- != *i* ]] && return

### LOCALE
# If encoding is not en_US.UTF-8, try to set it
utf8_regex="^en_US\.[Uu][Tt][Ff][-]?8$"
if [[ ! $LANG =~ $utf8_regex ]]; then
  if test_lang=$(locale -a | grep -E $utf8_regex); then
    export LANG=$test_lang
  else
    echo -e "\033[1;33mEncoding Warning\033[0m"
    echo -e "Failed to change from $LANG to UTF-8"
  fi
  unset test_lang
fi
unset utf8_regex

# Check if charmap is UTF-8
if [[ ! $(locale charmap) =~ [Uu][Tt][Ff][-]?8 ]]; then
  echo -e "\033[1;33mEncoding Warning\033[0m"
  echo -e "LANG is UTF-8, but charmap is $(locale charmap)"
fi

### VARIABLES
unset LESS
HISTFILE=~/.histfile
HISTSIZE=10000
VISUAL=vim
EDITOR=vim
PS1='\[\033[0;31m\]\h \[\033[0;34m\][\d \t] [\j jobs] [status $?]
\[\033[0;33m\]\u@\s(\v) \w \$ \[\033[0m\]'

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

# Compiling
alias gcc='gcc -Wall -Wextra -Werror -pedantic -g'
alias g++='g++ -Wall -Wextra -Werror -pedantic -Weffc++ -g'
alias g++11='g++ -std=c++11'
alias clang++11='clang++ -std=c++11'
