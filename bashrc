set +h
umask 022
if [ -d "/repo" ]; then
    KISS_PATH="/repo"
else
    KISS_ROOT="$(pwd)/sysroot"
    KISS_BASE="$(pwd)/repo"
    KISS_PATH="$KISS_BASE/cross:$KISS_BASE/chroot"
fi
LC_ALL=POSIX
KISS_TGT="$(uname -m)-lfs-linux-gnu"
PATH="/usr/bin"
if [ ! -L /bin ]; then PATH="/bin:$PATH"; fi
if [ -d "/repo" ]; then
    PATH="$PATH:/tmp/bin"
else
    PATH="$KISS_ROOT/tools/bin:$PATH"
    PATH="$(pwd)/kiss:$PATH"
fi
CONFIG_SITE=$KISS_ROOT/usr/share/config.site
export KISS_BASE KISS_ROOT KISS_PATH LC_ALL KISS_TGT PATH CONFIG_SITE
export MAKEFLAGS="-j12"
export LOGNAME="builder"
