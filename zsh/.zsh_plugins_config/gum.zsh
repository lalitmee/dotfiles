# Refresh before prompts; already-open Gum widgets retain their palette.
_gum_refresh_theme() {
    [[ -r "$HOME/.config/bin/gum-theme.sh" ]] && source "$HOME/.config/bin/gum-theme.sh"
    return 0
}
autoload -Uz add-zsh-hook
add-zsh-hook precmd _gum_refresh_theme
_gum_refresh_theme
