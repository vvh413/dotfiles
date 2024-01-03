#!/bin/sh

OPTS=allow_other,auto_cache

umount /media/{a,c,d}

sshfs -o $OPTS karl:/media/a /media/a
sshfs -o $OPTS karl:/media/c /media/c
sshfs -o $OPTS karl:/media/d /media/d
