#!/bin/sh

awk '/^[a-z]/ && last {print "<small>",$0,"\t",last,"</small>"} {last=""} /^#/{last=$0}' ~/.config/sxhkd/sxhkdrc.d/* ~/.config/sxhkd/wm/* \
  | column -t -s $'\t' \
  | rofi -dmenu -i -markup-rows -no-show-icons -width 1000 -lines 15 -yoffset 40
