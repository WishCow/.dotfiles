# Don't store duplicates in history
HISTCONTROL="erasedups:ignoreboth"
HISTFILESIZE=500000
HISTSIZE=100000
HISTTIMEFORMAT="%Y-%m-%d %H:%M:%S : "

PROMPT_COMMAND="prompt_command"
EDITOR="vim"
PAGER=less

# Trapd00r's dircolors
eval $(dircolors -b "$DIR"/lscolors/LS_COLORS)

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


# J: Mark rows that match a search string
# F: Exit immediately if output is less than one page
# R: Interpret colors
# i: Smart ignore case when searching
# X: Don't clear the screen
# M: Awlays show status line
# Q: Disable terminal bells
export LESS=' -JFRiXMQ '

prompt_command() {
    # Save history after each command
    history -a

    # If we are running under tmux, set the current dir in an env variable
    if [ -n "$TMUX" ]; then
        tmux setenv -g "TMUX_PWD_$(tmux display -p "#D")" "$PWD"
    fi
}


# File to store marks
MARKFILE="$SCRATCHDIR/marks"

if [ ! -f $MARKFILE ]; then
    echo "declare -A _DIRMARKS='()'" > $MARKFILE
fi

# Colorize output, and display hidden files
function ls() {
    command ls -lhA --group-directories-first --color=force "$@"
}

# Alias cd to pushd
cd() {
  if [ $# -eq 0 ]; then
    DIR="${HOME}"
  else
    DIR="$1"
  fi

  builtin pushd "${DIR}" > /dev/null
}

# Go back to previous directory, or to given mark
back() {
    local MARK="${1-}"
    eval $(cat $MARKFILE)
    if [ -n "$MARK" ]; then
        if [ -n "${_DIRMARKS[$MARK]}" ]; then
            cd "${_DIRMARKS[$MARK]}"
        else
            echo "Mark $MARK is not set"
        fi
    else
        builtin popd > /dev/null
    fi
}

# Display marked directories
marks() {
    eval $(cat $MARKFILE)
    for KEY in "${!_DIRMARKS[@]}"; do
        printf "%s => %s\n" "$KEY" "${_DIRMARKS[$KEY]}"
    done
}

mark() {
    local MARK="${1-}"
    eval $(cat $MARKFILE)
    if [ -z "$MARK" ]; then
        echo "Provide a mark name"
    else
        _DIRMARKS[$MARK]="$PWD"
        rm $MARKFILE && declare -p _DIRMARKS > $MARKFILE
    fi
}

dmark() {
    eval $(cat $MARKFILE)
    local MARKS="$@"
    for KEY in $MARKS; do
        unset _DIRMARKS["$KEY"]
    done
    rm $MARKFILE && declare -p _DIRMARKS > $MARKFILE
}

# List terminal colors
colorpalette() {
    e="\033["
    for f in 0 7 `seq 6`; do
      no="" bo=""
      for b in n 7 0 `seq 6`; do
        co="3$f"; p="  "
        [ $b = n ] || { co="$co;4$b";p=""; }
        no="${no}${e}${co}m   ${p}${co} ${e}0m"
        bo="${bo}${e}1;${co}m ${p}1;${co} ${e}0m"
      done
      echo -e "$no\n$bo"
    done
}

export -f ls cd back marks mark dmark colorpalette
