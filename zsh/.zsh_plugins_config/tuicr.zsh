# Keep the portable config unchanged; explicit CLI themes always win.
tuicr() {
    local arg
    for arg in "$@"; do
        [[ "$arg" == -- ]] && break
        if [[ "$arg" == --theme || "$arg" == --theme=* ]]; then
            command tuicr "$@"
            return $?
        fi
    done
    if [[ -r "${XDG_CONFIG_HOME:-$HOME/.config}/tuicr/themes/omarchy.toml" ]]; then
        command tuicr --theme omarchy "$@"
    else
        command tuicr "$@"
    fi
}
