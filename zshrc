## Last Updated 2013-12-23
## Olle K zshrc

# Drop non-interactive shells
[[ $- != *i* ]] && return
source ~/.bashrc

### VARIABLES
SAVEHIST=10000

### Special zsh
zstyle :compinstall filename '~/.zshrc'

autoload -Uz compinit && compinit
autoload -U promptinit && promptinit

## See man zshoptions
# Completion
setopt ALWAYS_TO_END       # Move cursor to the end of a completed word.
setopt AUTO_LIST           # Automatically list choices on ambiguous completion.
setopt AUTO_MENU           # Show completion menu on a succesive tab press.
setopt AUTO_PARAM_SLASH    # If parameter is a directory, add a trailing slash.
setopt COMPLETE_IN_WORD    # Complete from both ends of a word.
unsetopt MENU_COMPLETE     # Do not autoselect the first completion entry.
# Expansion and globbing
unsetopt CASE_GLOB         # Make globbing case insensitive
setopt EXTENDEDGLOB        # Glob # ^ ~
# History
setopt APPENDHISTORY       # Add to hist instead of replacing it
setopt HIST_IGNORE_DUPS    # Don't add duplicates to hist
# Input / Output
unsetopt FLOW_CONTROL      # Disable XON/XOFF characters in shell editor.
setopt PATH_DIRS           # Path search even on command names with slashes.
# Job control
setopt NOTIFY              # Report background job status immediately
# Emacs-style
bindkey -e
setopt nomatch 

# Use caching to make completion for cammands such as dpkg and apt usable.
zstyle ':completion::complete:*' use-cache on
zstyle ':completion::complete:*' cache-path "${ZDOTDIR:-$HOME}/.zcompcache"
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'

export PS1="%n@%m:%~%# "
prompt bart
