#!/bin/sh

mkdir -p tmp
bwrap \
    --dev-bind "$KISS_ROOT" / \
    --dev /dev \
    --proc /proc \
    --tmpfs /run \
    --ro-bind "$KISS_PATH/../chroot" /repo \
    --ro-bind $(which kiss) /bin/kiss \
    --ro-bind shell.sh /root/shell.sh \
    --ro-bind bashrc /root/.bashrc \
    --dev-bind chroot/db /var/db \
    --share-net \
    -- /usr/bin/env -i \
        HOME=/root \
        TERM="$TERM" \
        PATH=/usr/bin:/usr/sbin \
        CHROOT=1 \
        /root/shell.sh

rm -rf "$KISS_ROOT/"{dev,proc,repo,run,root}
