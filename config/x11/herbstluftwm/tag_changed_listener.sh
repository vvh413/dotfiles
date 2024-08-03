#/bin/sh

herbstclient -i '(tag_changed|tag_flags)' | while read -r event; do
  polybar-msg -p $1 action hlwm0 hook 0
  polybar-msg -p $2 action hlwm1 hook 0
done
