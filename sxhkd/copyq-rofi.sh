#!/bin/sh

entry=$(copyq '
tab(config("clipboard_tab"));
for (var i = 0; i < size(); i++) {
    print(str(read(i)).split("\\n").join("\\\\"));
    print("\\n");
}
' | rofi -dmenu -i -format i -p "$1")

[[ $entry == "" ]] || copyq $1 $entry

