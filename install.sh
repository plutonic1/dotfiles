#!/bin/bash

# remove old dotfiles

rm -rf $HOME/.dotfiles
rm -f $HOME/.gitconfig
rm -f $HOME/.tmux.conf
rm -f $HOME/.bashrc
rm -f $HOME/.conky_ips.sh
rm -f $HOME/.conkyrc

echo "removed old dotfile links"