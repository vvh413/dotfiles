#/bin/sh

herbstclient load 11 "$(cat ~/.config/herbstluftwm/layouts/11)"
herbstclient load 21 "$(cat ~/.config/herbstluftwm/layouts/21)"

herbstclient rule once maxage=10 class="org.wezfurlong.wezterm" tag=11 index=0
herbstclient rule once maxage=11 class="firefox" tag=11 index=1
herbstclient rule once maxage=10 class="TelegramDesktop" floating=false tag=21 index=1

herbstclient spawn wezterm
herbstclient spawn firefox
herbstclient spawn telegram-desktop
