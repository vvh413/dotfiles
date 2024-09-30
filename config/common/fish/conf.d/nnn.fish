set COPY_PATH 'c:!echo "$PWD/$nnn" | xclip -sel c'
set COPY_IMAGE 'i:!convert $nnn png:- | xclip -sel clipboard -t image/png*'
set PLAY_AUDIO 'a:!pw-play $nnn'
set EDIT_SUDO 'e:-!sudo -E nvim $nnn*'
set OPEN_HEX 'h:-!hexedit $nnn*'
set -x NNN_PLUG "t:preview-tui;d:dragdrop;o:open_with;$COPY_PATH;$COPY_IMAGE;f:fzcd;$EDIT_SUDO;$OPEN_HEX;z:autojump;p:fzplug;x:xdgdefault;$PLAY_AUDIO"

BLK="0B" CHR="0B" DIR="04" EXE="06" REG="00" HARDLINK="06" SYMLINK="06" MISSING="00" ORPHAN="09" FIFO="06" SOCK="0B" OTHER="06" \
    set -x NNN_FCOLORS "$BLK$CHR$DIR$EXE$REG$HARDLINK$SYMLINK$MISSING$ORPHAN$FIFO$SOCK$OTHER"

set -x NNN_OPTS ABHdear
set -x NNN_ARCHIVE "\\.(7z|a|ace|alz|arc|arj|bz|bz2|cab|cpio|deb|gz|jar|lha|lz|lzh|lzma|lzo|rar|rpm|rz|t7z|tar|tbz|tbz2|tgz|tlz|txz|tZ|tzo|war|xpi|xz|Z|zip)\$"

set DEFAULT_ORDER v
function n
    if set -q NNNLVL; and test "$NNNLVL" -ge 1
        echo "nnn is already running"
        return
    end

    set -x NNN_TMPFILE "$HOME/.config/nnn/.lastd"

    nnn -T $DEFAULT_ORDER "$argv"

    if test -f "$NNN_TMPFILE"
        . "$NNN_TMPFILE"
        rm -f "$NNN_TMPFILE" >/dev/null
    end
end
