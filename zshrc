## Olle K zshrc

# Drop non-interactive shells
[[ $- != *i* ]] && return

# Load stuff
zstyle :compinstall filename '~/.zshrc'
zmodload zsh/complist
autoload -Uz colors && colors
autoload -Uz compinit && compinit
autoload -Uz bashcompinit && bashcompinit             # Handle bash completions

# Basic settings
source ~/.bashrc                                      # Import from bash
export SAVEHIST=10000
bindkey -e                                            # Emacs-mode
PROMPT='%F{red}%M %F{blue}[%~]%f ${vcs_info_msg_0_}
%# '
RPROMPT='%D{%a %b %d %R W%V}'

# Autocomplete
zstyle ':completion:*' menu select                    # Menu-like autocomplete
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS} # Autocomplete colors
bindkey -M menuselect '^[[Z' reverse-menu-complete    # Shift-Tab -> prev match

# VCS
setopt prompt_subst
autoload -Uz vcs_info
zstyle ':vcs_info:*' stagedstr 'M'
zstyle ':vcs_info:*' unstagedstr 'M'
zstyle ':vcs_info:*' check-for-changes true
zstyle ':vcs_info:*' actionformats '%F{green}%b%f %F{yellow}%c%F{red}%u (%a)%f '
zstyle ':vcs_info:*' formats '%F{green}%b%f %F{green}%c%F{red}%u%f '
zstyle ':vcs_info:git*+set-message:*' hooks git-extra
+vi-git-extra() {
  if  [[ $(git ls-files --other --no-empty-directory --exclude-standard) != '' ]]; then
    hook_com[unstaged]+='%F{red}??%f'
  fi

  if [[ $(git status -b --porcelain) =~ '\[(ahead [0-9]+)(, )?(behind [0-9]+)?\]' ]]; then
    if [[ $match[1] != '' ]]; then
      hook_com[branch]+=" %F{green}+${match[1]/ahead /}%f"
    fi
    if [[ $match[3] != '' ]]; then
      hook_com[branch]+=" %F{red}-${match[3]/behind /}%f"
    fi
  fi
}
zstyle ':vcs_info:*' enable git
precmd () {
  vcs_info
}


## See man zshoptions
setopt HIST_IGNORE_DUPS    # Don't add duplicates to hist
setopt NOTIFY              # Report background job status immediately
setopt NOMATCH             # Error no failed pattern matching

## PAST THIS IS ONLY FOR COMPUTER
if [[ -d "/opt/homebrew/opt/nvm" ]]; then
    export NVM_DIR="$HOME/.nvm"
    [ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"  # This loads nvm
    [ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completion
fi
