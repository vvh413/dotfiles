#!/bin/sh

# backup if exists
bak() {
  [ -e "$1" ] && mv "$1" "$1-bak"
}

# symlink file or dir
link_() {
  [ "$DEBUG" == "1" ] && echo "linking $2 -> $1"
  if [ ! -L "$2" ]; then
    bak "$2"
    ln -s "$1" "$2"
  fi
}

# symlink each file or dir in dir
link_dir() {
  for conf in $(ls -A "$PWD/$1"); do
    link_ "$PWD/$1/$conf" "$2/$conf"
  done
}

git submodule update --init --recursive 1>/dev/null

link_dir config/common "$HOME/.config"
link_dir config/x11 "$HOME/.config"
# link_dir config/wayland "$HOME/.config"

link_dir home "$HOME"
link_dir local/bin "$HOME/.local/bin"
link_ "$PWD/local/macro" "$HOME/.local/macro"
