#! /usr/bin/env bash    

boxed_bash_ps1() {
    local host="$(hostname -f 2>/dev/null || hostname)"
    local line1="\[\033[0;31m\]${host} \[\033[0;34m\][\w]\[\033[0m\]"
    local line2="\$ "
    PS1="${line1}"$'\n'"${line2}"
}
boxed_bash_ps1
unset boxed_bash_ps1 

