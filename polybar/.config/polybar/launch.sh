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
# List all monitors with valid modes
MONITORS=$(xrandr --query | grep " connected" | grep -E "[0-9]+x[0-9]+\+" | cut -d" " -f1)

# Definition of (monitor, tray, center modules) via labels
# Monitor with the system tray (only ONE tray is possible per X session)
TRAY_MONITOR="eDP-1"

# Monitor where the music/spotify center modules are hidden
NO_MUSIC_MONITORS="DP-1"

echo "Launching Polybar..."
echo "Detected monitors: $MONITORS"
echo "Tray monitor: $TRAY_MONITOR"
echo "Music hidden on: $NO_MUSIC_MONITORS"

# Launch on all monitors
for m in $MONITORS; do
    echo "Starting polybar on monitor: $m"

    MODULES="volume calendar time powermenu"
    CENTER_MODULES=" "

    # Add the tray to the tray monitor (only one allowed per session)
    if [[ "$m" == "$TRAY_MONITOR" ]]; then
        MODULES="volume calendar time tray powermenu"
    fi

    # Default center modules unless music is hidden on this monitor
    if [[ "$NO_MUSIC_MONITORS" != *"$m"* ]]; then
        CENTER_MODULES="spotify-prev spotify spotify-next"
    fi

    MONITOR=$m CENTER_MODULES="$CENTER_MODULES" RIGHT_MODULES="$MODULES" polybar -c "$BAR_CONFIG" $BAR_NAME 2>&1 | tee -a "$LOG_FILE" &
    sleep 0.5
done

echo "Polybar launch complete. Check logs at: $LOG_FILE"
