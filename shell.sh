#!/bin/sh

PRJ_DIR="$(dirname "$0")"

PS1='\u:\w$ '
if [ ! -z "$CHROOT" ]; then
    PS1="(chroot) $PS1"
else
    mkdir -p "$PRJ_DIR/tmp"
    cp bashrc "$PRJ_DIR/tmp/.bashrc"
    HOME="$(realpath "$PRJ_DIR/tmp")"
fi

CMD=$@

env -i HOME=$HOME TERM=$TERM PS1="$PS1" CHROOT=$CHROOT CMD="$CMD" bash
