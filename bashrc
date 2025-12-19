## Olle K bashrc. Needs to work with zsh as well

## Drop non-interactive shells
[[ ${-} != *i* ]] && return

## Make the shell exit if it receives an EOF (Ctrl + D)
## You can also export IGNOREEOF=5 to require 5 presses
set +o ignoreeof

## Add extra paths
for p in \
    "${HOME}/.local/bin" \
    "${HOME}/.rd/bin" \
    "${HOME}/bin" \
    "${HOME}/dotfiles/bin" \
    "${HOME}/go/bin"
do
    if [[ -d "${p}" && ${PATH} != *"${p}"* ]]; then
        export PATH="${p}:${PATH}"
    fi
done
unset p

export HISTFILE="${HOME}/.histfile"
export HISTSIZE='50000'
export PAGER='less'
export LS_COLORS='di=34:ln=35:so=32:pi=33:ex=31:bd=34;46:cd=34;43:su=0;41:sg=0;46:tw=0;42:ow=0;43:'

if type nvim &> /dev/null; then
    export EDITOR=nvim
elif type vim &> /dev/null; then
    export EDITOR=vim
else
    export EDITOR=vi
fi

export VISUAL="${EDITOR}"
export GOPATH="${HOME}/go"

case $(uname) in
    Linux)
        alias ls='ls --color=auto --group-directories-first'
        alias chmod='chmod -c'
        alias chown='chown -c'
        alias chgrp='chgrp -c'
        alias grep='grep --color=auto'
        ;;

    SunOS)
        alias ls='ls --color=auto'
        alias emacs='emacs --color=always'
        alias grep='grep --color=auto'
        unset LESS
        export LS_COLORS="${LS_COLORS//:su*}"
        if [[ ${TERM} == screen ]]; then
            export TERM='xterm'
        fi
        ;;

    FreeBSD|Darwin)
        alias ls='ls -G'
        alias grep='grep --color=auto'
        ;;
esac

alias '.1'='cd ..'
alias '.2'='cd ../..'
alias '.3'='cd ../../..'
alias '.4'='cd ../../../..'
alias '.5'='cd ../../../../..'
alias ..='cd ..'
alias l='ls -lh'
alias la='ls -A'
alias ll='ls -lh'
alias rg=rg.fzf

isempty() { (shopt -s nullglob dotglob; f=(${1}/*); ((! ${#f[@]}))); }
retry() { while ! "${@}"; do sleep 1; done; }
man() {
    env LESS_TERMCAP_mb=$'\E[01;31m' \
        LESS_TERMCAP_md=$'\E[01;38;5;74m' \
        LESS_TERMCAP_me=$'\E[0m' \
        LESS_TERMCAP_se=$'\E[0m' \
        LESS_TERMCAP_ue=$'\E[0m' \
        LESS_TERMCAP_us=$'\E[04;38;5;146m' \
        man "${@}"
}
maybe_source() {
    if [[ -f "$1" ]]; then
        source "$1"
    fi
}

maybe_source "$HOME/dotfiles/scripts/z.sh"
maybe_source "$HOME/dotfiles/scripts/fzf-git.sh"
maybe_source "$HOME/dotfiles/bashrc.local"

if [[ -d /etc/profile.d ]]; then
    for file in /etc/profile.d/*.sh; do
	source "${file}"
    done
    unset file
fi

## Extra files to exec
if [[ -n ${BASH_VERSION} ]]; then
    maybe_source "/etc/bash_completion"
    if [[ -d /etc/bash_completion.d ]]; then
	for file in /etc/bash_completion.d/*; do
	    source "${file}"
	done
    fi
    unset file
    maybe_source "$HOME/dotfiles/scripts/bash_ps1.sh"
    
    shopt -s direxpand ## Prevent escaping dollar sign in tab completion
    shopt -s globstar  ## Allow recursive globbing with **
fi

## LOCALE
# Ideally, we would want these values in the future:
#
# LANG=en_US.UTF-8                  # To make everything use the same language
# LANGUAGE=en_US:en                 # To make everything use the same language
# LC_ADDRESS=sv_SE.UTF-8
# LC_COLLATE=C                      # There are sometimes weird bugs when not C
# LC_CTYPE=C                        # There are sometimes weird bugs when not C
# LC_IDENTIFICATION=sv_SE.UTF-8
# LC_MONETARY=sv_SE.UTF-8
# LC_MESSAGES=en_US.UTF-8           # To make everything use the same language
# LC_MEASUREMENT=sv_SE.UTF-8        # Anything exception en_US is fine here
# LC_NAME=sv_SE.UTF-8
# LC_NUMERIC=en_US.UTF-8            # Can cause a lot of bugs when not US
# LC_PAPER=sv_SE.UTF-8
# LC_TELEPHONE=sv_SE.UTF-8
# LC_TIME=sv_SE.UTF-8
##
o_init_locale() {
    warn() { echo -e "\033[1;33mWarning:\033[0m ${1}"; }

    local utf8='[Uu][Tt][Ff]-?8'
    local us_utf8="en_US\.${utf8}"

    local wanted_locale="$(locale -a | awk "/^${us_utf8}$/{print;exit}")"
    if [[ -n ${wanted_locale} ]]; then
        export LANG="${wanted_locale}"
    else
        warn "Could not find any en_US.UTF-8 locale. (Currently: ${LANG})"
    fi

    local charmap="$(locale charmap 2>/dev/null)"
    if [[ ! ${charmap} =~ ${utf8} && ! -z ${charmap} ]]; then
        warn "Charmap is ${charmap}"
    fi

    unset warn
}
o_init_locale
unset o_init_locale

o_init_stty_settings() {
    local stty_settings='stty start undef; stty stop undef'
    alias reset="/usr/bin/reset; ${stty_settings}"
    alias reset1="/usr/bin/reset -e ^?; ${stty_settings}"
    alias reset2="/usr/bin/reset -e ^h; ${stty_settings}"
    eval "${stty_settings}"
}
o_init_stty_settings
unset o_init_stty_settings

##################################
## Special application settings ##
##################################

if type clang &> /dev/null; then
    alias clang='clang -Weverything -Werror'
    alias clang++='clang++ -Weverything -Werror'
    alias clang++11='clang++ -std=c++11'
fi

if type ctags &> /dev/null; then
    alias ctags-generate='ctags -R . --exclude .git'
fi

if type delta &> /dev/null; then
    export DELTA_FEATURES="+side-by-side hyperlinks"
fi

if type fzf &> /dev/null; then
    if [[ -n ${BASH_VERSION} ]]; then
        eval "$(fzf --bash)"
    elif [[ -n ${ZSH_VERSION} ]]; then
        source <(fzf --zsh)
    fi
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

if type git &> /dev/null; then
    alias s='git status -bs'
fi

if type helm &> /dev/null; then
    if [[ -n ${BASH_VERSION} ]]; then
        source <(helm completion bash)
    elif [[ -n ${ZSH_VERSION} ]]; then
        source <(helm completion zsh)
    fi
fi

if type jq &> /dev/null; then
    jwt() { jq -R 'split(".") | .[0:2] | map(@base64d) | map(fromjson)'; }
fi

if type kubectl &> /dev/null; then
    alias kube=kube.fzf
    if [[ -n ${BASH_VERSION} ]]; then
        source <(kubectl completion bash)
    elif [[ -n ${ZSH_VERSION} ]]; then
        source <(kubectl completion zsh)
    fi
fi

if type nix &> /dev/null; then
    maybe_source '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh'
fi

if type pyenv &> /dev/null; then
    export PYENV_ROOT="$HOME/.pyenv"
    [[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
    if [[ -n ${BASH_VERSION} ]]; then
        eval "$(pyenv init - bash)"
    elif [[ -n ${ZSH_VERSION} ]]; then
        eval "$(pyenv init - zsh)"
    fi
fi
