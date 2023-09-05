#!/bin/sh

if [[ "$2" == "" ]]; then
	exit 1
fi

is_active() {
	nmcli -f GENERAL.STATE con show $1 | grep -q activated
}

status() {
	if is_active $1; then
		echo "up"
	else
		echo "down"
	fi
}

monitor() {
	status $1
	nmcli m | while read event; do
		if [[ $event == *"$1"* ]]; then
			status $1
		fi
	done
}

toggle() {
	if is_active $1; then
		nmcli con down $1
	else
		nmcli con up $1
	fi
}

case "$1" in
monitor) monitor $2 ;;
toggle) toggle $2 ;;
*) exit 1 ;;
esac
