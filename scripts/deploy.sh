#!/bin/bash

export WORKING_DIR=`pwd`
for i in .vimrc .bashrc .conkyrc .conky .tmux.conf .vimrc;
do cp -r $WORKING_DIR/$i $HOME/$i;
done;
