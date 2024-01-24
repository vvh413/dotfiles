#!/bin/sh

chsh -s $(which zsh)
curl -fsSL https://raw.githubusercontent.com/zimfw/install/master/install.zsh | zsh
