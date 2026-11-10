# Source from Bash or Zsh: Cobalt2 defaults, optional validated Omarchy colors.
gum_background=''
gum_foreground='#FFFFFF'
gum_accent='#66B3FF'
gum_border='#00AAFF'
gum_label='#FF628C'
gum_value='#FFC600'
gum_quote='220'
gum_muted='#9E9E9E'
gum_selection='#0050A4'
gum_theme_file="${XDG_STATE_HOME:-$HOME/.local/state}/omarchy/current/theme/colors.toml"
if [[ -r "$gum_theme_file" ]]; then
    while read -r gum_name gum_color; do
        case "$gum_name" in
            background) gum_background="$gum_color" ;;
            foreground) gum_foreground="$gum_color" ;;
            accent) gum_accent="$gum_color"; gum_border="$gum_color" ;;
            magenta) gum_label="$gum_color" ;;
            yellow) gum_value="$gum_color"; gum_quote="$gum_color" ;;
            muted) gum_muted="$gum_color" ;;
            selection_background) gum_selection="$gum_color" ;;
        esac
    done < <(sed -n 's/^[[:space:]]*\([a-z_]*\)[[:space:]]*=[[:space:]]*"\(#[[:xdigit:]]\{6\}\)"[[:space:]]*\(#.*\)\{0,1\}$/\1 \2/p' "$gum_theme_file")
fi
unset gum_theme_file gum_name gum_color

# Own the colors we supply so a theme switch cannot leave stale backgrounds.
for gum_part in INPUT_HEADER INPUT_PROMPT INPUT_CURSOR INPUT_PLACEHOLDER \
    WRITE_HEADER WRITE_BASE WRITE_PROMPT WRITE_CURSOR WRITE_PLACEHOLDER \
    FILTER_HEADER FILTER_TEXT FILTER_PROMPT FILTER_PLACEHOLDER FILTER_MATCH \
    FILTER_INDICATOR FILTER_CURSOR_TEXT FILTER_SELECTED_PREFIX FILTER_UNSELECTED_PREFIX \
    CHOOSE_CURSOR CHOOSE_HEADER CHOOSE_SELECTED CONFIRM_PROMPT CONFIRM_SELECTED \
    CONFIRM_UNSELECTED SPIN_SPINNER SPIN_TITLE; do
    export "GUM_${gum_part}_BACKGROUND=$gum_background"
done
for gum_pair in \
    "INPUT_HEADER:$gum_label" "WRITE_HEADER:$gum_label" \
    "INPUT_PROMPT:$gum_accent" "WRITE_PROMPT:$gum_accent" \
    "INPUT_CURSOR:$gum_accent" "WRITE_CURSOR:$gum_accent" \
    "INPUT_PLACEHOLDER:$gum_muted" "WRITE_PLACEHOLDER:$gum_muted" \
    "WRITE_BASE:$gum_foreground" "FILTER_HEADER:$gum_value" \
    "FILTER_MATCH:$gum_value" "FILTER_TEXT:${gum_background:+$gum_foreground}" \
    "FILTER_PROMPT:${gum_background:+$gum_accent}" \
    "FILTER_INDICATOR:$gum_border" "FILTER_SELECTED_PREFIX:$gum_border" \
    "FILTER_UNSELECTED_PREFIX:$gum_muted" "FILTER_CURSOR_TEXT:$gum_value" \
    "FILTER_PLACEHOLDER:$gum_muted" "CHOOSE_CURSOR:$gum_value" \
    "CHOOSE_HEADER:$gum_value" "CHOOSE_SELECTED:$gum_border" \
    "CONFIRM_PROMPT:$gum_value" "CONFIRM_SELECTED:$gum_border" \
    "CONFIRM_UNSELECTED:$gum_muted" "SPIN_SPINNER:$gum_accent" "SPIN_TITLE:$gum_value"; do
    export "GUM_${gum_pair%%:*}_FOREGROUND=${gum_pair#*:}"
done
export GUM_FILTER_TEXT_FOREGROUND="${GUM_FILTER_TEXT_FOREGROUND:-#e4e4e4}"
export GUM_FILTER_PROMPT_FOREGROUND="${GUM_FILTER_PROMPT_FOREGROUND:-#3AD900}"
export GUM_FILTER_CURSOR_TEXT_BACKGROUND="$gum_selection"
export GUM_STYLE_FOREGROUND="$gum_value" GUM_STYLE_BORDER_FOREGROUND="$gum_border"
unset gum_part gum_pair

gum_theme_ansi() {
    local hex="${1#\#}"
    printf '\033[%s38;2;%d;%d;%dm' "${2:-}" "$((16#${hex:0:2}))" "$((16#${hex:2:2}))" "$((16#${hex:4:2}))"
}
