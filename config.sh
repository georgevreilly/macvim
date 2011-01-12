#!/bin/bash
cd src
./configure \
    --with-features=huge \
    --enable-perlinterp \
    --enable-pythoninterp \
    --enable-tclinterp --with-tcl=tclsh8.4 \
    --enable-rubyinterp \
    --disable-mzschemeinterp \
    --with-plthome=/usr/local/plt \
    --enable-cscope \
    --enable-multibyte \
    --with-compiledby=george@reilly.org \

#   --enable-gnome-check \
