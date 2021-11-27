#!/bin/bash

DIR="$(cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd)"

rm -rf $HOME/.dotfiles
rm -f $HOME/.gitconfig
rm -f $HOME/.tmux.conf
rm -f $HOME/.bashrc
rm -f $HOME/.conky_ips.sh
rm -f $HOME/.conkyrc