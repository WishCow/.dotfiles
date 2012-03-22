#!/bin/bash -eu

success() {
    local msg="$1"
    shift
    local args="$@"

    printf "[DONE] $msg\n" "$@"
}

fail() {
    local msg="$1"
    shift
    local args="$@"

    printf "[FAIL] $msg\n" "$@"
}

skip() {
    local msg="$1"
    shift
    local args="$@"

    printf "[SKIP] $msg\n" "$@"
}

declare -a dirs
declare -A links

dirs=(~/.config ~/.mpd ~/.mpd/playlists)

links[~/.inputrc]=~/.dotfiles/inputrc
links[~/.bashrc]=~/.dotfiles/bashrc
links[~/.config/feh]=~/.dotfiles/feh
links[~/.tmux.conf]=~/.dotfiles/tmux.conf
links[~/.Xresources]=~/.dotfiles/Xresources
links[~/.ackrc]=~/.dotfiles/ackrc
links[~/.gitconfig]=~/.dotfiles/gitconfig
links[~/.hgrc]=~/.dotfiles/hgrc
links[~/.mpdconf]=~/.dotfiles/mpdconf

for v in "${dirs[@]}"; do
    if [ -e "$v" ]; then
        skip "Dir $v already exists"
    else
        if mkdir -p "$v"; then
            success "Created dir $v"
        else
            fail "Could not create dir $v"
        fi
    fi
done 

for target in "${!links[@]}"; do
    source="${links[$target]}"
    if [ -e "$target" ]; then
        skip "File $target already exists"
    else
        if ln -s "$source" "$target"; then
            success "Created link $target"
        else
            fail "Could not create link $target"
        fi
    fi
done
