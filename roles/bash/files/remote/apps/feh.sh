# Show all the images in a directory with feh
which feh &>/dev/null || return

show() {
    if [ -f "$1" ]; then
        command feh -Tshow --start-at "$(dirname "$1")/$1" "$(dirname "$1")"
    else
        command feh -Tshow "$@"
    fi
}

declare -f show
