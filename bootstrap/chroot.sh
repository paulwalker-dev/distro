#!/bin/sh

export KISS_PROMPT=0

rm -rf "$KISS_ROOT"
kiss b 0-filesystem
kiss b 1-meta

export     AR="$KISS_TGT-ar"
export     CC="$KISS_TGT-gcc"
export    CXX="$KISS_TGT-g++"
export     NM="$KISS_TGT-nm"
export RANLIB="$KISS_TGT-ranlib"
kiss b 2-meta
