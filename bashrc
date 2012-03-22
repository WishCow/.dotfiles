#!/bin/bash

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

. ~/.dotfiles/bash_functions.sh
# Don't store duplicates and ?
export HISTCONTROL="erasedups:ignoreboth"
export HISTFILESIZE=500000
export HISTSIZE=100000
export HISTTIMEFORMAT="%Y-%m-%d %H:%M:%S : "
PS1='\[\e[0;32m\]\u\[\e[m\] \[\e[1;34m\]\w\[\e[m\] \[\e[1;32m\]\$\[\e[m\] '

# Save history after each command
export PROMPT_COMMAND="history -a"

export EDITOR="vim"

# Interpret colors in less
export LESS=' -R '

# Append to history
shopt -s histappend

# Multiline commands take only 1 line
shopt -s cmdhist 

# Extended globbing (**)
shopt -s extglob 

# Star matches dotfiles
shopt -s globstar

# Recheck window size after each command
shopt -s checkwinsize

# Avoid overwriting files with redirections (>)
set -o noclobber

# Disable CTRL-s freezing/CTRL-q starting program flow
stty stop ""

# Pathname expansion will be treated as case-insensitive
shopt -s nocaseglob         

# Serve the current directory through HTTP
alias serve="python -m SimpleHTTPServer"

# Show diffs when commiting with hg
export HGEDITOR=~/.scripts/hgeditor

# Syntax highlight for less, needs source-highlight pkg
SRCHL=/usr/bin/src-hilite-lesspipe.sh
if [ -f "$SRCHL" ]; then
    export LESSOPEN="| $SRCHL %s"
fi

PATH=${PATH}:~/bin/

export VIDIR_EDITOR_ARGS='-c :set nolist | :set ft=vidir-ls'

# Import per-host based settings if they exist
perhost=~/.dotfiles/perhost/"$(hostname)".bashrc
[ -f "$perhost" ] && . "$perhost"
