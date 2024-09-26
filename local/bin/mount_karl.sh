#!/bin/sh

OPTS=allow_other,auto_cache

for drive in {a,c,d,r,v}; do
	umount /media/$drive
	sshfs -o $OPTS karl:/media/$drive /media/$drive
done
