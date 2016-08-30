## Olle K zshrc

# Drop non-interactive shells
[[ $- != *i* ]] && return

# Load stuff
zstyle :compinstall filename '~/.zshrc'
zmodload zsh/complist
autoload -Uz compinit && compinit
autoload -Uz promptinit && promptinit
autoload -Uz bashcompinit && bashcompinit             # Handle bash completions

# Basic settings
source ~/.bashrc                                      # Import from bash
export SAVEHIST=10000
export PS1="%n%# "
prompt bart
bindkey -e                                            # Emacs-mode

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
zstyle ':vcs_info:*' actionformats '%F{green}%b%f|%F{yellow}%c%F{red}%u (%a)%f '
zstyle ':vcs_info:*' formats '%F{green}%b%f|%F{green}%c%F{red}%u%f '
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
precmd () { vcs_info; }
PROMPT='${vcs_info_msg_0_}%# '


## See man zshoptions
setopt HIST_IGNORE_DUPS    # Don't add duplicates to hist
setopt NOTIFY              # Report background job status immediately
setopt NOMATCH             # Error no failed pattern matching

