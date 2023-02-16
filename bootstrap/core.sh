#!/bin/sh

cd "$(dirname "$0")/.."

if [ "$EUID" -ne 0 ]; then
    echo "Please run as root"
    exit
fi

TARBALL="$(pwd)/tmp/tools.tar.xz"
if [ ! -f "${TARBALL}" ]; then
    echo "Please run bootstrap/chroot.sh"
fi

sudo rm -rf chroot

export KISS_ROOT=chroot/lower
mkdir -p $KISS_ROOT
pushd $KISS_ROOT
    tar xvf "${TARBALL}"
popd

./sandbox.sh /root/stage4.sh
