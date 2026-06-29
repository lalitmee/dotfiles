# -------------------------------------------------------------------
# NOTE: zsh-vi-mode plugin settings {{{
# -------------------------------------------------------------------
# Cursor style for insert mode
ZVM_INSERT_MODE_CURSOR=$ZVM_CURSOR_BLOCK

# zsh-vi-mode resets keymaps on init; re-apply our custom keybindings
# (and anything keymap-dependent) AFTER it finishes initializing.
function zvm_after_init() {
    [[ -f ~/.zsh_keybindings ]] && source ~/.zsh_keybindings
    # Re-assert atuin's Ctrl+R AFTER zsh-vi-mode resets keymaps, so atuin wins.
    if zle -l | grep -q '^atuin-search '; then
        bindkey -M emacs '^R' atuin-search
        bindkey -M viins '^R' atuin-search-viins
        bindkey -M vicmd '^R' atuin-search
    fi
}
# }}}
# -------------------------------------------------------------------
