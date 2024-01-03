#!/bin/sh

count() {
  pcount=$(pactl list source-outputs short | wc -l)
  if [[ $pcount -ne "0" ]]; then
    echo $pcount
  else
    echo ""
  fi
}

monitor() {
  count
  pactl subscribe | while read -r event; do
    if echo "$event" | grep -q "source" || echo "$event" | grep -q "server"; then
      count
    fi
  done
}

rofi_kill() {
  SOURCES=$(pactl -f json list source-outputs)
  IDX=$(echo $SOURCES | jq -r '.[] | .properties."application.name" + ": " + .properties."media.name"' | rofi -dmenu -i -format i -p "$1")
  [[ $IDX == "" ]] || echo $SOURCES | jq ".[$IDX].properties.\"application.process.id\" | tonumber" | xargs kill
}

case "$1" in
  kill) rofi_kill ;;
  *) monitor ;;
esac
