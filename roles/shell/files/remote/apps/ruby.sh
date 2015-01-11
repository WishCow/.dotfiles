#!/bin/bash

# Ruby gem stuff
PATH+=":`ruby -e 'print Gem.user_dir'`/bin"
GEM_HOME=$(ruby -e 'print Gem.user_dir')
