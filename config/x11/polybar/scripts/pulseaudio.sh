#!/bin/sh

TYPE=sink
PAMIXER_ARG=

if [[ "$MIC" == "1" ]]; then
	TYPE=source
	PAMIXER_ARG=--default-source
fi

send_status() {
	if [[ "$MIC" != "1" ]]; then
		return
	fi

	status=$([[ "$1" == "muted" ]] && echo 0 || echo 1)
	vvh-via-cli set-mic-state $status
}

get_volume() {
	volume=$(pamixer $PAMIXER_ARG --get-volume-human)
	send_status "$volume"
	echo $volume
}

listen() {
	get_volume
	pactl subscribe | while read -r event; do
		if echo "$event" | grep -q $TYPE || echo "$event" | grep -q "server"; then
			get_volume
		fi
	done
}

if [[ $1 == "" ]]; then
	listen
else
	pamixer $PAMIXER_ARG $@
fi
