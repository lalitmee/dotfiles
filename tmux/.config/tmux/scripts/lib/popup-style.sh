# Shared popup styling: keys blue, values yellow, table labels pink.
# Source from any popup script (bash or zsh).

popup_key=$'\033[1;38;2;102;179;255m'
popup_value=$'\033[38;2;255;198;0m'
popup_label=$'\033[1;38;2;255;98;140m'
popup_reset=$'\033[0m'

# popup_hints "Enter:switch" "Esc:close" -> "Enter: switch   Esc: close"
# Prints a single styled line; extra whitespace between pairs is not honoured.
popup_hints() {
    local item hint=''
    for item in "$@"; do
        hint+="${popup_key}${item%%:*}${popup_reset}: ${popup_value}${item#*:}${popup_reset}   "
    done
    printf '%s' "${hint%   }"
}
