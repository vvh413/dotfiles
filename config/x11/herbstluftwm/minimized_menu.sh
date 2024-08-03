#!/bin/env bash

minimized() {
  herbstclient foreach CLIENT clients. \
    sprintf MINATT "%c.minimized" CLIENT \
    sprintf WINID "%{%c.winid}" CLIENT \
    and , compare MINATT = true , echo WINID
}

titles() {
  a=($@)
  for client in ${a[@]}; do
    herbstclient get_attr "clients.$client.title"
  done
}

clients=($(minimized))
sel=$(titles "${clients[@]}" | rofi -dmenu -i -format i -p "Minimized clients")

if [[ -n "$sel" ]]; then
  herbstclient bring ${clients[$sel]}
fi
