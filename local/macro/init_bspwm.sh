#/bin/sh

bspc wm -l ~/.config/bspwm/states/default.json
bspc rule -a org.wezfurlong.wezterm:org.wezfurlong.wezterm -o node=@^1:^1:/1
bspc rule -a firefox:Navigator -o node=@^1:^1:/2
bspc rule -a firefox:Navigator -o node=@^2:^1:/1
bspc rule -a TelegramDesktop:Telegram -o node=@^2:^1:/2 state=tiled

wezterm &
firefox &
Telegram &
