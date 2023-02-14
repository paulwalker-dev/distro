#!/bin/sh

mkdir -p chroot/{fakeroot,upper,work,db}
fuse-overlayfs -o lowerdir=sysroot,upperdir=chroot/upper,workdir=chroot/work chroot/fakeroot

bwrap \
    --dev-bind chroot/fakeroot / \
    --dev /dev \
    --proc /proc \
    --tmpfs /run \
    --ro-bind "$KISS_BASE"/chroot /repo \
    --ro-bind $(which kiss) /usr/bin/kiss \
    --ro-bind shell.sh /root/shell.sh \
    --ro-bind bashrc /root/.bashrc \
    --dev-bind tmp/.cache /root/.cache \
    --dev-bind chroot/db /var/db \
    --symlink /usr/bin/echo /tmp/bin/wget \
    --symlink /usr/bin/sh /tmp/bin/su \
    --share-net \
    --unshare-user \
    --uid 0 \
    --gid 0 \
    -- /usr/bin/env -i \
        HOME=/root \
        TERM="$TERM" \
        PATH=/usr/bin:/usr/sbin:/tmp/bin \
        CHROOT=1 \
        /root/shell.sh $@

rm -rf chroot/fakeroot/tmp
umount chroot/fakeroot
