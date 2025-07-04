#!/bin/bash

STATE_FILE="${XDG_CACHE_HOME:-$HOME/.cache}/pomodoro_state"

WORK_SEC=1500       # 25 minutes
SHORT_BREAK_SEC=300 # 5 minutes
LONG_BREAK_SEC=900  # 15 minutes
MAX_POMODOROS=4     # Long break after 4 pomodoros

tick() {
    if [[ -f "$STATE_FILE" ]]; then
        source "$STATE_FILE"

        if [[ "$PAUSED" == "1" ]]; then
            return
        fi

        if ((TIME_LEFT > 0)); then
            {
                echo "STATUS=\"$STATUS\""
                echo "TIME_LEFT=$((TIME_LEFT - 1))"
                echo "PAUSED=$PAUSED"
                echo "POMO_COUNT=${POMO_COUNT:-0}"
            } > "$STATE_FILE"
        else
            status_text="${STATUS#* }" # remove icon, keep text only
            if [[ "$status_text" == "Working" ]]; then
                # Increase pomodoro count
                POMO_COUNT=$((${POMO_COUNT:-0} + 1))

                if ((POMO_COUNT % MAX_POMODOROS == 0)); then
                    notify-send "Pomodoro Done ✅" "Time for a long break ⏳ ($((LONG_BREAK_SEC / 60)) mins)"
                    canberra-gtk-play -i complete &> /dev/null &
                    {
                        echo 'STATUS=" Long Break"'
                        echo "TIME_LEFT=$LONG_BREAK_SEC"
                        echo "PAUSED=0"
                        echo "POMO_COUNT=$POMO_COUNT"
                    } > "$STATE_FILE"
                else
                    notify-send "Pomodoro Done ✅" "Take a short break ☕ ($((SHORT_BREAK_SEC / 60)) mins)"
                    canberra-gtk-play -i complete &> /dev/null &
                    {
                        echo 'STATUS="☕ Break"'
                        echo "TIME_LEFT=$SHORT_BREAK_SEC"
                        echo "PAUSED=0"
                        echo "POMO_COUNT=$POMO_COUNT"
                    } > "$STATE_FILE"
                fi

            else
                # After any break (short or long), resume work
                notify-send "Break’s Over ⏰" "Time to get back to work 🔴"
                canberra-gtk-play -i complete &> /dev/null &
                {
                    echo 'STATUS="🔴 Working"'
                    echo "TIME_LEFT=$WORK_SEC"
                    echo "PAUSED=0"
                    echo "POMO_COUNT=$POMO_COUNT"
                } > "$STATE_FILE"
            fi
        fi
    fi
}

while true; do
    tick
    sleep 1
done
