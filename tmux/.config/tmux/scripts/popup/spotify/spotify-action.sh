#!/usr/bin/env zsh

ACTION=$1
MESSAGE=$2 # Optional message for notification

# Function to send system notifications
send_notification() {
    local title="Spotify"
    local message="$1"
    if [[ "$(uname)" == "Darwin" ]]; then
        # macOS notification
        osascript -e "display notification \"${message}\" with title \"${title}\""
    elif command -v notify-send &> /dev/null; then
        # Linux notification (requires notify-send)
        notify-send "${title}" "${message}"
    else
        # Fallback to tmux display-message if no system notification tool
        tmux display-message "${title}: ${message}"
    fi
}

# Function to get current playback status
get_playback_status() {
    spotify_player get key playback 2>/dev/null | jq -r '
        if .item.name and .item.artists[0].name then
            if .is_playing == true then
                "▶️ Now playing: \(.item.name) by \(.item.artists[0].name)"
            else
                "⏸️ Paused: \(.item.name) by \(.item.artists[0].name)"
            end
        else
            empty
        end
    ' 2>/dev/null
}

# Check if spotify_player is installed
if ! command -v spotify_player &> /dev/null; then
    send_notification "Error: spotify_player is not installed."
    exit 1
fi

# Execute spotify_player command and capture output
OUTPUT=""
ERROR_CODE=0
case "$ACTION" in
    play-pause) OUTPUT=$(spotify_player playback play-pause 2>&1); ERROR_CODE=$? ;;
    next) OUTPUT=$(spotify_player playback next 2>&1); ERROR_CODE=$? ;;
    previous) OUTPUT=$(spotify_player playback previous 2>&1); ERROR_CODE=$? ;;
    volume-up) OUTPUT=$(spotify_player playback volume --offset 5 2>&1); ERROR_CODE=$? ;;
    volume-down) OUTPUT=$(spotify_player playback volume --offset -- -5 2>&1); ERROR_CODE=$? ;;
    *) send_notification "Unknown action: $ACTION"; exit 1 ;;
esac

if [[ $ERROR_CODE -eq 0 ]]; then
    case "$ACTION" in
        play-pause)
            STATUS=$(get_playback_status)
            if [[ -n "$STATUS" ]]; then
                send_notification "$STATUS"
            else
                send_notification "Playback toggled"
            fi
            ;;
        *)
            send_notification "Action: ${ACTION} successful."
            ;;
    esac
else
    send_notification "Action: ${ACTION} failed. Error: ${OUTPUT}"
fi
