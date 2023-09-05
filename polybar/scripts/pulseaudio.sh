#!/bin/sh

TYPE=sink
PAMIXER_ARG=

if [[ $MIC = "1" ]]; then
	TYPE=source
	PAMIXER_ARG=--default-source
fi

listen() {
	pamixer $PAMIXER_ARG --get-volume-human
	pactl subscribe | while read -r event; do
		if echo "$event" | grep -q $TYPE || echo "$event" | grep -q "server"; then
			pamixer $PAMIXER_ARG --get-volume-human
		fi
	done
}

if [[ $1 == "" ]]; then
	listen
else
	pamixer $PAMIXER_ARG $@
fi
