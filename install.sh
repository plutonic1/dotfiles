#!/bin/bash

rm ~/.bashrc
ln -s "$PWD/.bashrc" ~/.bashrc
. ~/.bashrc

rm ~/.gitconfig
ln -s "$PWD/.gitconfig" ~/.gitconfig