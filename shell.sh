#!/bin/sh

PRJ_DIR="$(pwd)"

mkdir -p home
cp .bashrc "$PRJ_DIR/home/"
env -i HOME="$PRJ_DIR/home" TERM=$TERM PS1='\u:\w$ ' /bin/bash
