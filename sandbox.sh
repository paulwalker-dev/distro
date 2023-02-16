#!/bin/sh

cd "$(dirname "$0")"

if [ "$EUID" -ne 0 ]; then
    echo "Please run as root"
    exit
fi

# General chroot preperation
mkdir -p chroot/{fakeroot,upper,work,db}
fuse-overlayfs -o lowerdir="${KISS_ROOT:-sysroot}",upperdir=chroot/upper,workdir=chroot/work chroot/fakeroot

export FAKEROOT=chroot/fakeroot

mkdir -p "$FAKEROOT/"{dev,proc,sys,run}
mount -v --bind /dev "$FAKEROOT/dev"

mount -v --bind /dev/pts "$FAKEROOT/dev/pts"
mount -vt proc proc "$FAKEROOT/proc"
mount -vt sysfs sysfs "$FAKEROOT/sys"
mount -vt tmpfs tmpfs "$FAKEROOT/run"

if [ -h "$FAKEROOT/dev/shm" ]; then
  mkdir -pv "$FAKEROOT/$(readlink "$FAKEROOT/dev/shm")"
fi

# Bootstrap specific
mkdir -p "$FAKEROOT"/{repo,root,tmp/bin}

bind_file() {
    mkdir -p "$(dirname "$FAKEROOT/$2")"
    touch "$FAKEROOT/$2"
    mount -v --bind \
        "$(dirname "$0")/$1" \
        "$FAKEROOT/$2"
}

bind_folder() {
    mkdir -p "$FAKEROOT/$2"
    mount -v --bind $EXTRA \
        "$(dirname "$0")/$1" \
        "$FAKEROOT$2"
}

bind_folder \
    "tmp/.cache" \
    "/root/.cache"

bind_folder \
    "chroot/db" \
    "/var/db"

export EXTRA="-o ro"
bind_folder \
    "repo/${KISS_REPO:-core}" \
    "/repo"

bind_file \
    "shell.sh" \
    "/root/shell.sh"

bind_file \
    "bashrc" \
    "/root/.bashrc"

bind_file \
    "bootstrap/stage3.sh" \
    "/root/stage3.sh"

bind_file \
    "bootstrap/stage4.sh" \
    "/root/stage4.sh"

bind_file \
    "kiss/kiss" \
    "/tmp/bin/kiss"

ln -s ../../bin/sh "$FAKEROOT/tmp/bin/su"
ln -s ../../bin/echo "$FAKEROOT/tmp/bin/wget"

chown -R root:root $FAKEROOT/{usr,lib,var,etc,bin,sbin,tools}
case $(uname -m) in
  x86_64) chown -R root:root $FAKEROOT/lib64 ;;
esac

# chroot
chroot "$FAKEROOT" \
    /usr/bin/env -i \
        HOME=/root \
        TERM="$TERM" \
        PATH=/usr/bin:/usr/sbin:/tmp/bin \
        CHROOT=1 \
        /root/shell.sh "$@"

sync
rm -rf chroot/fakeroot/tmp
umount -R chroot/fakeroot
