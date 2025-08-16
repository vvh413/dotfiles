#!/bin/sh

OPTS=allow_other,auto_cache

for drive in {a,c,d,e,f,r,v}; do
	umount /media/$drive
	sshfs -o $OPTS karl:/media/$drive /media/$drive
done
