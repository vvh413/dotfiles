#!/bin/sh

BUF=$(((${1:-0} * 1024) >> 8))
xclip -sel clip -o | python -c "s = ''.join(dict(zip('йцукенгшщзхъфывапролджэячсмитьбюЙЦУКЕНГШЩЗХЪФЫВАПРОЛДЖЭЯЧСМИТЬБЮ','qwertyuiop[]asdfghjkl;\'zxcvbnm,./QWERTYUIOP[]ASDFGHJKL:\"ZXCVBNM<>')).get(c,c) for c in input()) + '\0'; print(*(str((i >> 8) + $BUF) + ' ' + str(i & 0xff) + ' ' + str(len(s[i:i+27])) + ' ' + ' '.join([str(ord(c)) for c in s[i:i+26]]) for i in range(0, len(s), 26)), sep='\n')" | xargs -L1 via-cli --vid 0x3434 --pid 0x0960 set-custom-menu-value 0 5
