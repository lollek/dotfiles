# vim:set ft=sh:
umask 022

# Start ssh-agent if supported and it's not started by this user
ssh_agent=$(type -p ssh-agent)
args="-s"
if [[ -x "$ssh_agent" && -z "$SSH_AUTH_SOCK" ]] &&
   ! pgrep -xu $USER ssh-agent &>/dev/null; then
  eval "$($ssh_agent $args)"
  trap "kill $SSH_AGENT_PID" 0
  ssh-add
fi
unset ssh_agent args

source .bashrc

while true; do
  read -p "Do you want to start screen? (Y/n) " yn
  case $yn in
    [Yy]*|"") screen; break;;
    [Nn]*) break;;
  esac
done

