#!/usr/bin/env zsh

source "$(dirname "$0")/config.sh"

STATE_FILE="${XDG_CACHE_HOME:-$HOME/.cache}/pomodoro_state"

tick() {
    [[ ! -f "$STATE_FILE" ]] && return
    source "$STATE_FILE"

    # If reset to Ready state, do nothing
    [[ "$STATUS" == *"Ready"* ]] && return

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

        # Play ticking sound in last 5 seconds
        if ((TIME_LEFT <= 5 && TIME_LEFT > 0)); then
            canberra-gtk-play -f "./clock-ticking-down.wav" &> /dev/null &
        fi
    else
        # session ended: check what ended
        status_text="${STATUS#* }" # drop icon, keep text

        if [[ "$status_text" == "Working" ]]; then
            # work done → increment count & choose break
            POMO_COUNT=$(((${POMO_COUNT:-0} + 1)))
            if ((POMO_COUNT % MAX_POMODOROS == 0)); then
                duration=$((LONG_BREAK_MIN * 60))
                label="Long Break"
            else
                duration=$((BREAK_MIN * 60))
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
            notify-send -i "appointment-new-symbolic" "Break's Over ⏰" "Time to get back to work 🔴"
            canberra-gtk-play -i complete &> /dev/null &

            local new_pomo_count=${POMO_COUNT:-0}
            # Check if the break that just ended was a long break
            if [[ "$status_text" == "Long Break" ]]; then
                # Reset the pomodoro count
                new_pomo_count=0
            fi

            {
                echo 'STATUS="⏱ Working"'
                echo "TIME_LEFT=$((WORK_MIN * 60))"
                echo "PAUSED=0"
                echo "POMO_COUNT=$new_pomo_count"
            } > "$STATE_FILE"
        fi
    fi
}

while true; do
    tick
    sleep 1
done
