#!/bin/bash

export PRDIR=$HOME/.wpscripts

git clone git@github.com:locnguyenvu/wpscripts.git $PRDIR
cd $PRDIR

mkdir $PRDIR/bin

cd bin

ln -Fs "$PRDIR/zalora/oms/bin/zoms" 


echo "export PATH=\$PATH:$PRDIR//bin"
