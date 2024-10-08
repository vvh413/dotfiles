#!/bin/sh

restart() {
	pkill "$1"
	$1 >/dev/null &
}

xsetroot -cursor_name left_ptr

nvidia-settings --load-config-only
numlockx
# openrgb -p 1

# hsetroot -solid "#2E2641"
~/.fehbg

/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1 &
restart nm-applet
restart blueman-applet
restart dunst
restart birdtray
pkill kdeconnect-indi
kdeconnect-indicator >/dev/null &
pkill copyq
copyq --start-server &

killall -q sshfs
~/.local/bin/mount_karl.sh &

pkill automount.sh
~/.local/bin/automount.sh &
