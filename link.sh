#!/bin/sh

DIRS=(
  bspwm
  polybar
  rofi
  sxhkd
  wezterm
)

for dir in ${DIRS[@]}; do
  mv ~/.config/$dir ~/.config/$dir-bak 2>/dev/null
  ln -s $PWD/$dir ~/.config/$dir
done
