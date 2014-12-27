#!/bin/bash

DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

. "$DIR/variables.sh"
for f in "$DIR"/apps/*.sh; do
    . "$f"
done
