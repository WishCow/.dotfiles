#!/bin/bash -eu

vi() {
    vim "$@"
}

pacman() {
    pacman-color "$@"
}

# Run a command in a horizontal/vertical split tmux window, and keep/give focus
bgh() {
    local ARGS="$@"
    tmux split-window -dh "$ARGS"
}

bgv() {
    local ARGS="$@"
    tmux split-window -v "$ARGS"
}

bgH() {
    local ARGS="$@"
    tmux split-window -h "$ARGS"
}

# Show all the images in a directory with feh
show() {
    if [ -f "$1" ]; then
        command feh -Tshow --start-at "$(dirname "$1")/$1" "$(dirname "$1")"
    else
        command feh -Tshow "$@"
    fi
}

# Colorize output, and display hidden files
function ls() {
    command ls -lhA --group-directories-first --color=auto "$@"
}

# Test terminal colors 
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

# Run hg command recursively in current dir
hgr() {
    for i in $(find . -type d -name '.hg')
    do
        DIR=$(dirname $i)
        printf "[R] %s\n" $DIR
        hg "$@" -R $DIR
        printf "\n"
    done
}

cd() {
  if [ $# -eq 0 ]; then
    DIR="${HOME}"
  else
    DIR="$1"
  fi

  builtin pushd "${DIR}" > /dev/null
}

back() {
  builtin popd > /dev/null
}
