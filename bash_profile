# vim:set ft=sh:

# Start ssh-agent if support and it's not started by this user
_start_ssh_agent()
{
  SSHAGENT=$(command -v ssh-agent)
  SSHAGENTARGS="-s"
  if ! ps ux | grep [s]sh-agent &>/dev/null; then
    if [[ -z "$SSH_AUTH_SOCK" && -x "$SSHAGENT" ]]; then
      eval "$($SSHAGENT $SSHAGENTARGS)"
      trap "kill $SSH_AGENT_PID" 0
    fi
  fi
}
_start_ssh_agent

umask 022

source .bashrc
