#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

rm -rf $HOME/.dotfiles
mkdir -p $HOME/.dotfiles

rm -f $HOME/.gitconfig
cp "$DIR/.gitconfig" $HOME/.dotfiles/.gitconfig
ln -s -f "$HOME/.dotfiles/.gitconfig" $HOME/.gitconfig

rm -f $HOME/.tmux.conf
cp "$DIR/.tmux.conf" $HOME/.dotfiles/.tmux.conf
ln -s -f "$HOME/.dotfiles/.tmux.conf" $HOME/.tmux.conf

rm -f $HOME/.bashrc
cp "$DIR/.bashrc" $HOME/.dotfiles/.bashrc
ln -s -f $HOME/.dotfiles/.bashrc $HOME/.bashrc
. $HOME/.bashrc
