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

export BAAM=1
export TERMINAL=urxvt

echo "Available commands:"
echo "Run (S)creen"
echo "Run (X)11"
echo "Do (N)othing"
read -p "What do you want to do? (S/x/n) " yn
while true; do
  case $yn in
    ""|"S"|"s") screen -URD; break;;
    "X"|"x")    startx; break;;
    "N"|"n")    break;;
    *)          read -p "Please answer s, x or n: " yn
  esac
done

source .bashrc
