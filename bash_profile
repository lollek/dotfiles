# vim:set ft=sh:
umask 022

# Start ssh-agent if support and it's not started by this user
_start_ssh_agent()
{
  SSHAGENT=$(command -v ssh-agent)
  SSHAGENTARGS="-s"
  if ! pgrep -xu $USER ssh-agent &>/dev/null; then
    if [[ -z "$SSH_AUTH_SOCK" && -x "$SSHAGENT" ]]; then
      eval "$($SSHAGENT $SSHAGENTARGS)"
      trap "kill $SSH_AGENT_PID" 0
      ssh-add
    fi
  fi
}
#_start_ssh_agent

# Set up environment
# sudo setfont Uni3-Fixed13
# sudo loadkeys ./us-intl.key

source .bashrc
