#!/bin/bash
PATH+=:~/.local/bin
which virtualenvwrapper.sh &>/dev/null || return
source "$(which virtualenvwrapper.sh)"
