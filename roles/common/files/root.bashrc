[[ $- != *i* ]] && return

alias ls='ls --color=auto'
PS1='\[\e[1;31m\][\u@\h \w]\$\[\e[0m\] '
