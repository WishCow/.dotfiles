#!/bin/bash

# Syntax highlight for less, needs source-highlight pkg

f=/usr/bin/src-hilite-lesspipe.sh
if [ -f "$f" ]; then
    export LESSOPEN="| $f %s"
fi
