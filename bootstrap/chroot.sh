#!/bin/sh

export KISS_PROMPT=0

rm -rf "$KISS_ROOT"
kiss b 0-filesystem
kiss b 0-meta

export     AR="$KISS_TGT-ar"
export     CC="$KISS_TGT-gcc"
export    CXX="$KISS_TGT-g++"
export     NM="$KISS_TGT-nm"
export RANLIB="$KISS_TGT-ranlib"
kiss b 1-meta
kiss b 2-meta

sandbox="$(dirname "$0")"/../sandbox.sh
alias sandbox="${sandbox}"
sandbox kiss b 3-meta
sandbox rm -rf /usr/share/{info,man,doc}/\*
sandbox find /usr/{lib,libexec} -name \*.la -delete
sandbox rm -rf /tools
