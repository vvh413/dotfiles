#!/bin/sh

MON_NAME=vmon
XRANDR_GEOMENTRY=2560/593x1440/334+880+0
BSPWM_GEOMENTRY=2560x1440+880+0

refresh() {
	xrandr --fb 6880x1440
}

create_mon() {
	xrandr --setmonitor "$1" "$2" none
	refresh
	bspc wm -a "$1" "$3"
	bspc monitor "$1" -d 31 32 33 34 35
}

delete_mon() {
	xrandr --delmonitor "$1"
	refresh
	bspc monitor "$1" -r
}

if [[ "$(xrandr --listmonitors | wc -l)" == "3" ]]; then
	create_mon "$MON_NAME" "$XRANDR_GEOMENTRY" "$BSPWM_GEOMENTRY"
else
	delete_mon "$MON_NAME"
fi
