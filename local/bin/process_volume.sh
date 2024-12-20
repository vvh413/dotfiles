#!/bin/bash

FOCUSED_PID=$(xprop -id $(xprop -root _NET_ACTIVE_WINDOW | cut -d' ' -f5) |
	grep '_NET_WM_PID' | grep -oE '[[:digit:]]*$')
PARENT_PID=$(ps -o ppid= $FOCUSED_PID | xargs)
if [ "$PARENT_PID" == "1" ]; then
	PID_LIST="$(pgrep -P $FOCUSED_PID)"
else
	PID_LIST="$(pgrep -P $PARENT_PID)"
fi

current_sink=''
current_pid=''

get_param() {
	pactl list sink-inputs |
		grep -P "(Sink Input #$1|$2)" |
		grep -A1 "Sink Input #$1" |
		tail -n1
}

get_volume() {
	get_param $1 "Volume" |
		sed -e 's,.* \([0-9][0-9]*\)%.*,\1,'
}

get_app_name() {
	get_param $1 "application.name" | sed 's/^.* = "\(.*\)"/\1/'
}

command_selection() {
	case "$2" in
	toggle) pactl set-sink-input-mute "$1" toggle ;;
	inc) pactl set-sink-input-volume "$1" +2% ;;
	dec) pactl set-sink-input-volume "$1" -2% ;;
	esac

	app_name=$(get_app_name $1)
	if get_param $1 "Mute:" | grep "yes" >/dev/null; then
		text="MUTED"
	else
		volume=$(get_volume $1)
		text="$volume% -h int:value:$volume -h string:hlcolor:#00ff00"
	fi
	notify-send -t 1000 -r $1 "$app_name (#$1)" $text
}

while read line; do
	sink_num=$(echo "$line" | sed -rn 's/^Sink Input #(.*)/\1/p')
	if [ "$sink_num" != "" ]; then
		current_sink="$sink_num"
	else
		client_pid=$(echo "$line" | sed -rn 's/application.process.id = "([^"]*)"/\1/p')
		if [ "$client_pid" != "" ] && printf '%s\0' "${PID_LIST[@]}" | grep -qw "$client_pid"; then
			current_pid="$client_pid"
			echo $current_sink
			command_selection "$current_sink" "$1"
		fi
	fi
done < <(pactl list sink-inputs | grep -oP "(Sink Input .*|application\.process\.id.*)")

if [ "$current_pid" == "" ]; then
	current_sink=$(pactl list sink-inputs |
		grep -E "(Sink Input|application.name = )" |
		grep -m1 -B1 -P 'application.name = "(?!speech-dispatcher)' |
		head -1 |
		sed -rn 's/^Sink Input #(.*)/\1/p')
	[ "$current_sink" != "" ] && command_selection "$current_sink" "$1"
fi
