#!/bin/sh

polybar-msg cmd quit
killall -q polybar
polybar bar0 &
polybar bar1 &
