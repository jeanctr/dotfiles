#  ▘  ▗
#  ▌▛▘▜▘▛▘ Jean Carlos (jctr)
#  ▌▙▖▐▖▌  https://github.com/jeanctr/
# ▙▌       https://jeanctr.me

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

### EXPORTS ###
export TERM="xterm-256color"
export HISTCONTROL=ignoredups:erasedups
export EDITOR="nvim"
export MANPAGER="nvim +Man!"

### XDG BASE DIRECTORIES ###
[ -z "$XDG_CONFIG_HOME" ] && export XDG_CONFIG_HOME="$HOME/.config"
[ -z "$XDG_DATA_HOME" ] && export XDG_DATA_HOME="$HOME/.local/share"
[ -z "$XDG_CACHE_HOME" ] && export XDG_CACHE_HOME="$HOME/.cache"

### PATH ###
[ -d "$HOME/.bin" ] && PATH="$HOME/.bin:$PATH"
[ -d "$HOME/.local/bin" ] && PATH="$HOME/.local/bin:$PATH"

PATH="$HOME/.local/share/fnm:$PATH"
FNM_PATH="$HOME/.local/share/fnm"
if [ -d "$FNM_PATH" ]; then
  export PATH="$FNM_PATH:$PATH"
  eval "$(fnm env)"
fi
PATH="/opt/nvim/bin:$PATH"
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

### VI MODE ###
# Comment out to use default emacs-like bindings
set -o vi
bind -m vi-command 'Control-l: clear-screen'
bind -m vi-insert 'Control-l: clear-screen'

### SHELL OPTIONS ###
shopt -s autocd            # cd into a directory just by typing its name
shopt -s cdspell           # autocorrect minor cd typos
shopt -s cmdhist           # save multi-line commands as one history entry
shopt -s dotglob           # include dotfiles in glob results
shopt -s histappend        # append to history, don't overwrite
shopt -s expand_aliases    # expand aliases
shopt -s checkwinsize      # update LINES/COLUMNS after each command

bind "set completion-ignore-case on"   # case-insensitive tab completion

### PROMPT ###
parse_git_branch() {
  git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ [\1]/'
}

export PS1="\n\[\e[38;2;98;114;164m\][\t]\[\e[m\] \[\e[38;2;189;147;249m\]\u\[\e[38;2;248;248;242m\]@\[\e[38;2;189;147;249m\]\h\[\e[m\] \[\e[38;2;139;233;253m\]\w\[\e[38;2;80;250;123m\]\$(parse_git_branch)\[\e[m\]\n\[\e[38;2;255;121;198m\]❯\[\e[m\] "

### ALIASES ###
alias ls="lsd -la"
alias lt="lsd --tree"
alias vifm="$XDG_CONFIG_HOME/vifm/scripts/vifmrun"
alias cat="batcat"

### THIRD-PARTY INIT ###
. "/home/jc/.deno/env"
source /home/jc/.local/share/bash-completion/completions/deno.bash
