#/bin/sh

firefox &
sleep 1
# bspc node -f west
bspc node -d 21
bspc node -p west
bspc node -o 0.282
wezterm &
sleep 0.5
bspc desktop -f 21
bspc node -o 0.6
telegram-desktop &
