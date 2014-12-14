#!/bin/bash

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

. "$DIR/variables.sh"
. "$DIR/functions.sh"
. "$DIR/general.sh"
eval $(dircolors -b "$DIR"/lscolors/LS_COLORS)
