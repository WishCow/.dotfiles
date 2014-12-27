which hg &>/dev/null || return

# Show diffs when commiting with hg
HGEDITOR=~/.scripts/hg/hgeditor

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

declare -f hgr
