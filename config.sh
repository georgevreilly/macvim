#!/bin/bash

cd src
CC=clang ./configure \
    --with-features=huge \
    --enable-perlinterp \
    --enable-pythoninterp \
    --enable-rubyinterp \
    --enable-cscope \
    --enable-multibyte \
    --with-compiledby=george@reilly.org \

#   --enable-tclinterp --with-tcl=tclsh8.4 \
#   --disable-mzschemeinterp \
#   --with-plthome=/usr/local/plt \
#   --enable-gnome-check \
