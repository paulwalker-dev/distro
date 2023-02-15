#!/bin/sh

kiss b 3-filesystem
kiss b 3-essential
kiss b 3-meta
rm -rf /usr/share/{info,man,doc}/*
find /usr/{lib,libexec} -name \*.la -delete
rm -rf /tools
