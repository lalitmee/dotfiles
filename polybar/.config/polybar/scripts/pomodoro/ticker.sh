#!/bin/bash

STATE_FILE="${XDG_CACHE_HOME:-$HOME/.cache}/pomodoro_state"

WORK_SEC=1500       # 25 min
SHORT_BREAK_SEC=300 # 5 min
LONG_BREAK_SEC=900  # 15 min
MAX_POMODOROS=4     # long break after 4 sessions

tick() {
    [[ ! -f "$STATE_FILE" ]] && return
    source "$STATE_FILE"

    # 1️⃣ If paused, do nothing at all
    [[ "${PAUSED:-0}" == "1" ]] && return

    if ((TIME_LEFT > 0)); then
        # just decrement
        {
            echo "STATUS=\"$STATUS\""
            echo "TIME_LEFT=$((TIME_LEFT - 1))"
            echo "PAUSED=$PAUSED"
            echo "POMO_COUNT=${POMO_COUNT:-0}"
        } > "$STATE_FILE"
    else
        # session ended: check what ended
        status_text="${STATUS#* }" # drop icon, keep text

        if [[ "$status_text" == "Working" ]]; then
            # work done → increment count & choose break
            POMO_COUNT=$(((${POMO_COUNT:-0} + 1)))
            if ((POMO_COUNT % MAX_POMODOROS == 0)); then
                duration=$LONG_BREAK_SEC
                label="Long Break"
            else
                duration=$SHORT_BREAK_SEC
                label="Break"
            fi
            notify-send -i "face-smile-symbolic" "Pomodoro Done ✅" "Time for a $label: $(duration/60) minutes"
            canberra-gtk-play -i complete &> /dev/null &
            {
                echo 'STATUS="☕ '"$label\""
                echo "TIME_LEFT=$duration"
                echo "PAUSED=0"
                echo "POMO_COUNT=$POMO_COUNT"
            } > "$STATE_FILE"

        else
            # break done → back to work
            notify-send -i "alarm-symbolic" "Break's Over ⏰" "Time to get back to work 🔴"
            canberra-gtk-play -i complete &> /dev/null &
            {
                echo 'STATUS="🔴 Working"'
                echo "TIME_LEFT=$WORK_SEC"
                echo "PAUSED=0"
                echo "POMO_COUNT=${POMO_COUNT:-0}"
            } > "$STATE_FILE"
        fi
    fi
}

while true; do
    tick
    sleep 1
done
