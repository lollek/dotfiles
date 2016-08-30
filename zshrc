## Olle K zshrc

# Drop non-interactive shells
[[ $- != *i* ]] && return

# Load stuff
zstyle :compinstall filename '~/.zshrc'
zmodload zsh/complist
autoload -Uz compinit && compinit
autoload -Uz promptinit && promptinit
autoload -Uz bashcompinit && bashcompinit

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


## See man zshoptions
setopt HIST_IGNORE_DUPS    # Don't add duplicates to hist
setopt NOTIFY              # Report background job status immediately
setopt NOMATCH             # Error no failed pattern matching

