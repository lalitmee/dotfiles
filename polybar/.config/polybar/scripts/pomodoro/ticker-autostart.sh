#!/usr/bin/env zsh

pgrep -f ticker.sh > /dev/null || ~/.config/polybar/scripts/pomodoro/ticker.sh >> ~/.pomodoro-ticker.log 2>&1 &
