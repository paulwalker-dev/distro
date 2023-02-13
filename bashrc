set +h
umask 022
if [ -d "/repo" ]; then
    KISS_PATH="/repo"
else
    KISS_ROOT="$(pwd)/sysroot"
    KISS_PATH="$(pwd)/repo/cross"
fi
LC_ALL=POSIX
KISS_TGT="$(uname -m)-lfs-linux-gnu"
PATH="/usr/bin"
if [ ! -L /bin ]; then PATH="/bin:$PATH"; fi
PATH="$KISS_ROOT/tools/bin:$PATH"
PATH="$(pwd)/kiss:$PATH"
CONFIG_SITE=$KISS_ROOT/usr/share/config.site
export KISS_ROOT KISS_PATH LC_ALL KISS_TGT PATH CONFIG_SITE
export MAKEFLAGS="-j12"
export LOGNAME=$(whoami)
