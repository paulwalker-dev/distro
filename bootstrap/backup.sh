#!/bin/sh

if [ "$EUID" -ne 0 ]; then
    echo "Please run as root"
    exit
fi

mkdir -p chroot/{fakeroot,upper,work,db}
fuse-overlayfs -o lowerdir=sysroot,upperdir=chroot/upper,workdir=chroot/work chroot/fakeroot

pushd chroot/fakeroot
tar -cJpf "../../tmp/tools.tar.xz" .
popd

sync
umount -R chroot/fakeroot
