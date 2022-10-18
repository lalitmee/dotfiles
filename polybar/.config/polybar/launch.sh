#!/usr/bin/env bash

killall -q polybar

BAR_NAME=mainbar
BAR_CONFIG=$HOME/.config/polybar/config.ini

PRIMARY=$(xrandr --query | grep " connected" | grep "primary" | cut -d" " -f1)
OTHERS=$(xrandr --query | grep " connected" | grep -v "primary" | cut -d" " -f1)

# Launch on primary monitor
MONITOR=$PRIMARY polybar -c "$BAR_CONFIG" $BAR_NAME &
sleep 1

# Launch on all other monitors
for m in $OTHERS; do
 MONITOR=$m polybar -c "$BAR_CONFIG" $BAR_NAME &
done
