#!/bin/sh

delta=$1

current_layer() {
	bspc query -n .focused -T -n | jq -r .client.layer
}

if [[ $delta = "watch" ]]; then
	bspc subscribe node_{focus,layer} | while read -r event; do
		current_layer
	done
	exit 0
fi

layer=$(current_layer)

change() {
	case "$delta" in
	'+') echo $1 ;;
	'-') echo $2 ;;
	*) echo $layer ;;
	esac
}

case "$layer" in
above)
	new_layer=$(change above normal)
	;;
normal)
	new_layer=$(change above below)
	;;
below)
	new_layer=$(change normal below)
	;;
*)
	echo Unexpected layer
	exit 1
	;;
esac

echo $new_layer
bspc node -l $new_layer
