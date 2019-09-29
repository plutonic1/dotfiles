#!/bin/bash

rm -f /tmp/dotfiles && mkdir -p /tmp/dotfiles && git clone https://github.com/plutonic1/dotfiles.git && bash /tmp/dotfiles/install.sh