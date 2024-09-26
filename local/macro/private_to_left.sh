#!/bin/sh

if [ $(bspc query -d focused -N | wc -l) -eq 1 ]; then
	bspc node -p west -o 0.282 -i
fi
bspc rule -a firefox:Navigator -o node=@/1
firefox --private-window &
