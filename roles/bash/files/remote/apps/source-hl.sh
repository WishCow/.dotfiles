#!/bin/bash

# Syntax highlight for less, needs source-highlight pkg

which source-highlight &>/dev/null || return
export LESSOPEN="| $(which source-highlight) %s"
