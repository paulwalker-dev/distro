#!/bin/sh

if [ "$EUID" -ne 0 ]; then
    echo "Please run as root"
    exit
fi

mkdir -p chroot/{fakeroot,upper,work,db}
fuse-overlayfs -o lowerdir=${KISS_ROOT:-sysroot},upperdir=chroot/upper,workdir=chroot/work chroot/fakeroot

mount -t tmpfs tmpfs chroot/fakeroot/var/db
mount -t tmpfs tmpfs chroot/fakeroot/root
mount -t tmpfs tmpfs chroot/fakeroot/tmp

pushd chroot/fakeroot
tar -cpf - . | pixz > "../../tmp/${1:-tools}.tar.xz" 
popd

sync
umount -R chroot/fakeroot
