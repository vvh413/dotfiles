#!/bin/sh

bspc node -f west
bspc node -c
sleep 0.1
bspc node -p west
bspc node -o 0.3
firefox --private-window &
