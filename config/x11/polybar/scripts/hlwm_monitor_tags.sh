#!/bin/bash

mon_id=$1
selected_tags=("$(($mon_id + 1))"{1..5})
tags=$(herbstclient tag_status $mon_id)

ACTIVE_FG="#ffaaff"
ACTIVE_UL="#ffaaff"
URGENT_FG="#1e1e2e"
URGENT_BG="#ff0000"
OCCUPIED_FG="#d9e0ee"
EMPTY_FG="#6e6c7e"

tag_output() {
  text=" $1 "
  fg=$2
  bg=$3
  u=$4
  [[ "$fg" != "" ]] && text="%{F$fg}$text%{F-}"
  [[ "$bg" != "" ]] && text="%{B$bg}$text%{B-}"
  [[ "$u" != "" ]] && text="%{u$u}%{+u}$text%{-u}"
  echo "%{A1:herbstclient chain . focus_monitor $mon_id . use $1:}$text%{A}"
}

output=""
IFS=$'\t'
for tag in $tags; do
  tag_status=${tag:0:1}
  tag_name=${tag:1}

  fg=""
  bg=""
  u=""
  if [[ " ${selected_tags[@]} " =~ " ${tag_name} " ]]; then
    case $tag_status in
      '.') fg=$EMPTY_FG ;;
      ':' | '-' | '+') fg=$OCCUPIED_FG ;;
      '!') fg=$URGENT_FG bg=$URGENT_BG ;;
      '#') fg=$ACTIVE_FG u=$ACTIVE_UL ;;
      *) ;;
    esac
    output+=$(tag_output "$tag_name" "$fg" "$bg" "$u")
  fi
done

echo "$output"
