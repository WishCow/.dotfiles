#!/bin/bash -eu

MARKFILE="$SCRATCHDIR/marks"
if [ ! -f $MARKFILE ]; then
    echo "declare -A _DIRMARKS='()'" > $MARKFILE
fi

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