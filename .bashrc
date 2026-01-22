### EXPORT
export TERM="xterm-256color"           
export HISTCONTROL=ignoredups:erasedups
export EDITOR="vim"   
export VISUAL="vim"

### SET MANPAGER

### "nvim" as manpager
export MANPAGER="nvim +Man!"

### SET VI MODE ###
# Comment this line out to enable default emacs-like bindings
set -o vi
bind -m vi-command 'Control-l: clear-screen'
bind -m vi-insert 'Control-l: clear-screen'

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

### PATH
if [ -d "$HOME/.bin" ] ;
  then PATH="$HOME/.bin:$PATH"
fi

if [ -d "$HOME/.local/bin" ] ;
  then PATH="$HOME/.local/bin:$PATH"
fi

# BUN
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

### SETTING OTHER ENVIRONMENT VARIABLES
if [ -z "$XDG_CONFIG_HOME" ] ; then
    export XDG_CONFIG_HOME="$HOME/.config"
fi
if [ -z "$XDG_DATA_HOME" ] ; then
    export XDG_DATA_HOME="$HOME/.local/share"
fi
if [ -z "$XDG_CACHE_HOME" ] ; then
    export XDG_CACHE_HOME="$HOME/.cache"
fi

### SHOPT
shopt -s autocd
shopt -s cdspell
shopt -s cmdhist
shopt -s dotglob
shopt -s histappend
shopt -s expand_aliases
shopt -s checkwinsize

#ignore upper and lowercase when TAB completion
bind "set completion-ignore-case on"

### ALIASES ###

# Changin "cat" to "bat"
alias cat="bat"

# vifmrun to vifm
alias vifm="$XDG_CONFIG_HOME/vifm/scripts/vifmrun"

# Changing "ls" to "lsd"
alias l="lsd -la"
alias lt="lsd --tree"

# ps
alias psa="ps auxf"
alias psgrep="ps aux | grep -v grep | grep -i -e VSZ -e"
alias psmem='ps auxf | sort -nr -k 4'
alias pscpu='ps auxf | sort -nr -k 3'

# Merge Xresources
alias merge='xrdb -merge ~/.Xresources'

### SETTING THE STARSHIP PROMPT ###
eval "$(starship init bash)"

### FZF ###
# Enables the following keybindings:
# CTRL-t = fzf select
# CTRL-r = fzf history
# ALT-c  = fzf cd
eval "$(fzf --bash)"

. "/home/jc/.deno/env"
# fnm
FNM_PATH="/home/jc/.local/share/fnm"
if [ -d "$FNM_PATH" ]; then
  export PATH="$FNM_PATH:$PATH"
  eval "`fnm env`"
fi
