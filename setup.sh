#!/bin/bash

if [ ! -d "${HOME}/.local/bin" ]; then
    mkdir -p "${HOME}/.local/bin"
fi

export PRDIR="${HOME}/.local/zutils"

if [ -d $PRDIR ]; then
    rm -rf $PRDIR
fi

git clone git@github.com:locnguyenvu/zutils.git $PRDIR
cd $PRDIR

cd "${HOME}/.local/bin"

ln -Fs "$PRDIR/zalora/oms/bin/zoms" 

if [[ ! "$PATH" == *$HOME/.local/bin* ]]; then
    echo 'if [[ ! "$PATH" == *'"$HOME"'/.local/bin* ]]; then 
    export PATH="${PATH:+${PATH}:}'"$HOME"'/.local/bin" 
fi' >> ~/.zshrc
fi
