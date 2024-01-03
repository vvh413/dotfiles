#!/bin/sh

set -e

FILENAME=/media/c/pic/_screens/$(date +%Y%m%d%H%M%S).png

grim -g "$(slurp)" "$FILENAME"
wl-copy <$FILENAME
