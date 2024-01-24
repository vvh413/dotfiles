#!/bin/sh

bspc node -f west
bspc node -c
sleep 0.2
bspc node -p west
bspc node -o 0.282
firefox --private-window &
