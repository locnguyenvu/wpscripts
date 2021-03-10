#!/bin/bash

export PRDIR=$HOME/.wpscripts

if [ -d $PRDIR ]; then
    rm -rf $PRDIR
fi

git clone git@github.com:locnguyenvu/wpscripts.git $PRDIR
cd $PRDIR

mkdir $PRDIR/bin

cd bin

ln -Fs "$PRDIR/zalora/oms/bin/zoms" 

echo $'\n# locnguyenvu/wpscripts commands' >> ~/.zshrc
echo "export PATH=\$PATH:\$HOME/.wpscripts/bin" >> ~/.zshrc
