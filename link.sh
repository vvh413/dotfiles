#!/bin/sh

CONFIG_DIR=$HOME/.config

for dir in $(ls -d */ | tr -d '/'); do
  if [ ! -L "$CONFIG_DIR/$dir" ]; then
    [ -d "$CONFIG_DIR/$dir" ] && mv "$CONFIG_DIR/$dir" "$CONFIG_DIR/$dir-bak"
    ln -s "$PWD/$dir" "$CONFIG_DIR/$dir"
  fi
done
