#!/bin/bash

STATE_FILE="${XDG_CACHE_HOME:-$HOME/.cache}/pomodoro_state"
LOG_FILE="${XDG_DATA_HOME:-$HOME/.local/share}/pomodoro.log"
WORK_MIN=25
BREAK_MIN=5
LONG_BREAK_MIN=15
MAX_POMODOROS=4

# 🧠 Play alert sound
play_sound() {
    canberra-gtk-play -i complete &> /dev/null &
}

# 🧠 Log session
log_session() {
    local now
    now="$(date '+%Y-%m-%d %H:%M:%S')"
    echo "[$now] $1" >> "$LOG_FILE"
}

# 🖥 Display loop for Polybar
update_display() {
    while true; do
        if [[ -f "$STATE_FILE" ]]; then
            source "$STATE_FILE"
            mins=$((TIME_LEFT / 60))
            secs=$((TIME_LEFT % 60))
            mins=$(printf "%02d" $mins)
            secs=$(printf "%02d" $secs)

            session_info=""
            status_text="${STATUS#* }" # remove icon

            status_text="${STATUS#* }" # Remove icon
            count=${POMO_COUNT:-0}

            if [[ "$status_text" == "Working" ]]; then
                session_number=$((count + 1))
            else
                session_number=$count
            fi

            session_info=" (${session_number}/${MAX_POMODOROS})"

            if [[ "$PAUSED" == "1" ]]; then
                echo " $status_text $mins:$secs$session_info"
            else
                echo "$STATUS $mins:$secs$session_info"
            fi
        else
            echo " Ready"
        fi
        sleep 1
    done
}

# 🧠 Start a Pomodoro
start_pomodoro() {
    local count=0
    [[ -f "$STATE_FILE" ]] && source "$STATE_FILE" && count="${POMO_COUNT:-0}"

    {
        echo 'STATUS=" Working"'
        echo "TIME_LEFT=$((WORK_MIN * 60))"
        echo "PAUSED=0"
        echo "POMO_COUNT=$count"
    } > "$STATE_FILE"

    notify-send -i "timer-symbolic" "Pomodoro Started " "Focus for $WORK_MIN minutes"
    play_sound
    log_session "Started Pomodoro ($((count + 1)))"
}

# 🧠 Start a break (short or long)
start_break() {
    local mins="$1"
    local count="$2"
    local type="Break"
    [[ "$mins" -ge "$LONG_BREAK_MIN" ]] && type="Long Break"

    {
        echo 'STATUS=" Break"'
        echo "TIME_LEFT=$((mins * 60))"
        echo "PAUSED=0"
        echo "POMO_COUNT=$count"
    } > "$STATE_FILE"

    notify-send -i "coffee-symbolic" "$type Started " "Take a $mins-minute break"
    play_sound
    log_session "Started $type ($mins min)"
}

# 🧠 Adjust time (+/- minutes)
adjust_time() {
    if [[ -f "$STATE_FILE" ]]; then
        source "$STATE_FILE"
        local delta=$((60 * $1))
        local new_time=$((TIME_LEFT + delta))
        ((new_time < 60)) && new_time=60
        {
            echo "STATUS=\"$STATUS\""
            echo "TIME_LEFT=$new_time"
            echo "PAUSED=$PAUSED"
            echo "POMO_COUNT=${POMO_COUNT:-0}"
        } > "$STATE_FILE"
    fi
}

# 🧠 Toggle pause/resume
toggle_pause() {
    if [[ -f "$STATE_FILE" ]]; then
        source "$STATE_FILE"
        if [[ "$PAUSED" == "1" ]]; then
            PAUSED=0
            notify-send -i "timer-symbolic" "Pomodoro Resumed ▶️"
            log_session "Resumed"
        else
            PAUSED=1
            notify-send -i "media-playback-pause-symbolic" "Pomodoro Paused ⏸"
            log_session "Paused"
        fi
        {
            echo "STATUS=\"$STATUS\""
            echo "TIME_LEFT=$TIME_LEFT"
            echo "PAUSED=$PAUSED"
            echo "POMO_COUNT=${POMO_COUNT:-0}"
        } > "$STATE_FILE"
    fi
}

# 🧠 Reset timer and session
reset_timer() {
    {
        echo 'STATUS=" Ready"'
        echo "TIME_LEFT=0"
        echo "PAUSED=0"
        echo "POMO_COUNT=0"
    } > "$STATE_FILE"
    notify-send -i "timer-symbolic" "Pomodoro Reset" "Timer and session counter cleared"
    log_session "Reset timer"
}

# 🧠 Handle CLI input
case "$1" in
    --click-left) start_pomodoro ;;
    --click-middle) start_break $BREAK_MIN "${POMO_COUNT:-0}" ;;
    --click-right) toggle_pause ;;
    --add) adjust_time 1 ;;
    --sub) adjust_time -1 ;;
    --reset) reset_timer ;;
    *) update_display ;;
esac
