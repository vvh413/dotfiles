#!/bin/sh

pathtoname() {
	udevadm info -p /sys/"$1" | awk -v FS== '/DEVNAME/ {print $2}'
}

stdbuf -oL -- udevadm monitor --udev -s block | while read -r -- _ _ event devpath _; do
	if [ "$event" = add ]; then
		devname=$(pathtoname "$devpath")
		msg=$(udisksctl mount --block-device "$devname" --no-user-interaction)
		notify-send automount "$msg"
	fi
done
