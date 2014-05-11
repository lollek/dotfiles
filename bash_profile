# vim:set ft=sh:
umask 022

# Start ssh-agent if supported and it's not started by this user
export BASH_SCRIPTS_ARE_SOURCED=1
. $HOME/dotfiles/bash_scripts
_set_ssh_agent

source .bashrc
