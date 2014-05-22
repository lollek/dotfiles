## Last Updated 2013-03-04
# Olle K bashrc

# Drop non-interactive shells
[[ $- != *i* ]] && return

# Look for bash_completion if shell is bash (I use this for zsh as well)
if [[ $SHELL =~ bash && -f /etc/bash_completion ]]; then
  . /etc/bash_completion
fi

if [[ ! $BASH_SCRIPTS_ARE_SOURCED ]]; then
  BASH_SCRIPTS_ARE_SOURCED=1
  . $HOME/dotfiles/bash_scripts
fi
_set_locale # Try to set locale to en_US.UTF-8
_set_ps1    # Try to set a nice PS1

# Variables
set +o ignoreeof
unset LESS        # I think this was a fix for some SunOS issue
export PATH=$HOME/bin:${PATH//:$HOME\/bin/} # Prioritize / add home-bin
export LS_COLORS="di=34:ln=35:so=32:pi=33:ex=31:bd=34;46:cd=34;43:su=0;41:sg=0;46:tw=0;42:ow=0;43:"
export HISTFILE=~/.histfile
export HISTSIZE=10000
export VISUAL=vim
export EDITOR=vim
export PAGER=less
export GPGKEY=02FDDED4

# This has worked on all systems so far
stty sane
stty stop undef
stty start undef

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

    # SunOS treats screen as a stupid shell and removes features
    [[ $TERM == screen ]] && export TERM=xterm

    # SunOS doesn't recognize the last bit of colors
    [[ -z $LS_COLORS ]] || export LS_COLORS=${LS_COLORS//:su*}
    ;;
  *BSD)
    alias ls='ls -G'
    ;;
esac

# Minifuns
function pushtmp() { cd $(mktemp -d); }
function poptmp() { rm -vi ./* ; rmdir -v $PWD && cd - >/dev/null; }

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
