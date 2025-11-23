#!/usr/bin/env bash

# Kill existing polybar instances
killall -q polybar

# Wait for processes to shut down
while pgrep -u $UID -x polybar > /dev/null; do
    sleep 0.1
done

# Configuration
BAR_NAME=mainbar
BAR_CONFIG="$HOME/.config/polybar/config.ini"
LOG_FILE="/tmp/polybar.log"

# Clear previous log
> "$LOG_FILE"

# Get monitor information
PRIMARY=$(xrandr --query | grep " connected primary" | cut -d" " -f1)
OTHERS=$(xrandr --query | grep " connected" | grep -v "primary" | grep -E "[0-9]+x[0-9]+\+" | cut -d" " -f1)

echo "Launching Polybar..."
echo "Primary monitor: $PRIMARY"
echo "Other monitors: $OTHERS"

# Launch on primary monitor WITH tray
if [ -n "$PRIMARY" ]; then
    echo "Starting polybar on primary monitor: $PRIMARY"
    MONITOR=$PRIMARY RIGHT_MODULES="volume calendar time tray powermenu" polybar -c "$BAR_CONFIG" $BAR_NAME 2>&1 | tee -a "$LOG_FILE" &
    sleep 1
else
    echo "Warning: No primary monitor found"
fi

# Launch on other monitors WITHOUT tray
for m in $OTHERS; do
    echo "Starting polybar on monitor: $m"
    MONITOR=$m RIGHT_MODULES="volume calendar time powermenu" polybar -c "$BAR_CONFIG" $BAR_NAME 2>&1 | tee -a "$LOG_FILE" &
    sleep 0.5
done

echo "Polybar launch complete. Check logs at: $LOG_FILE"
