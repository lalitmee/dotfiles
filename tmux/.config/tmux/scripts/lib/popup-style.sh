# Shared popup styling: keys blue, values yellow, table labels pink.
# Source from any popup script (bash or zsh).

popup_key=$'\033[1;38;2;102;179;255m'
popup_value=$'\033[38;2;255;198;0m'
popup_label=$'\033[1;38;2;255;98;140m'
popup_reset=$'\033[0m'

# Popups do not run interactive Zsh, so read the generated palette directly.
# Keep color arguments separate from layout/bindings and apply them last.
popup_fzf_colors=(--color='fg:#FFFFFF,bg:#193549,hl:#FFC600,fg+:#FFFFFF,bg+:#185294,hl+:#FF9D00,info:#8fbfdc,prompt:#3AD900,pointer:#00AAFF')
_popup_theme="${XDG_STATE_HOME:-$HOME/.local/state}/omarchy/current/theme"
if [[ -r "$_popup_theme/fzf-colors" ]]; then
    popup_fzf_colors=()
    while IFS= read -r _popup_line || [[ -n "$_popup_line" ]]; do
        [[ "$_popup_line" == --color=* ]] && popup_fzf_colors+=("$_popup_line")
    done < "$_popup_theme/fzf-colors"
fi
for _popup_color in "${popup_fzf_colors[@]}"; do
    export FZF_DEFAULT_OPTS="${FZF_DEFAULT_OPTS:-} $_popup_color"
done
if [[ -r "$_popup_theme/bat-config" ]]; then
    export BAT_CONFIG_PATH="$_popup_theme/bat-config"
fi

_popup_ansi() {
    local hex
    hex=$(sed -n "s/^[[:space:]]*$1[[:space:]]*=[[:space:]]*\"#\([[:xdigit:]]\{6\}\)\".*/\1/p" "$_popup_theme/colors.toml")
    [[ ${#hex} == 6 && "$hex" != *[![:xdigit:]]* ]] || return 1
    printf '\033[1;38;2;%d;%d;%dm' "$((16#${hex:0:2}))" "$((16#${hex:2:2}))" "$((16#${hex:4:2}))"
}
if [[ -r "$_popup_theme/colors.toml" ]]; then
    popup_key="$(_popup_ansi accent)" || popup_key=$'\033[1;38;2;102;179;255m'
    popup_value="$(_popup_ansi yellow)" || popup_value=$'\033[38;2;255;198;0m'
    popup_label="$(_popup_ansi magenta)" || popup_label=$'\033[1;38;2;255;98;140m'
fi
unset _popup_theme _popup_line _popup_color
unset -f _popup_ansi

# popup_hints "Enter:switch" "Esc:close" -> "Enter: switch   Esc: close"
# Prints a single styled line; extra whitespace between pairs is not honoured.
popup_hints() {
    local item hint=''
    for item in "$@"; do
        hint+="${popup_key}${item%%:*}${popup_reset}: ${popup_value}${item#*:}${popup_reset}   "
    done
    printf '%s' "${hint%   }"
}
