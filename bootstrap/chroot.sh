#!/bin/sh

if [ "$EUID" -eq 0 ]; then
    echo "Please don't run as root"
    exit
fi

export KISS_PROMPT=0

sudo rm -rf "$KISS_ROOT"
kiss b 0-filesystem
kiss b 0-meta

export     AR="$KISS_TGT-ar"
export     CC="$KISS_TGT-gcc"
export    CXX="$KISS_TGT-g++"
export     NM="$KISS_TGT-nm"
export RANLIB="$KISS_TGT-ranlib"
kiss b 1-meta
kiss b 2-meta

sandbox="$(dirname "$0")/../sandbox.sh"
sudo rm -rf chroot
sudo KISS_REPO=chroot "${sandbox}" /root/stage3.sh
sudo "$(dirname "$0")/backup.sh"
