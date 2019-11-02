#!/bin/bash

DIR="$(cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd)"

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

rm -f $HOME/.conky_ips.sh
cp "$DIR/.conky_ips.sh" $HOME/.dotfiles/.conky_ips.sh
ln -s -f "$HOME/.dotfiles/.conky_ips.sh" $HOME/.conky_ips.sh
chmod +x "$HOME/.dotfiles/.conky_ips.sh"

rm -f $HOME/.conkyrc
cp "$DIR/.conkyrc" $HOME/.dotfiles/.conkyrc
ln -s -f "$HOME/.dotfiles/.conkyrc" $HOME/.conkyrc
