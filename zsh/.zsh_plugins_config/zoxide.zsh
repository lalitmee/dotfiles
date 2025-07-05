# -------------------------------------------------------------------
# NOTE: fzf-tab configuration for zoxide {{{
# -------------------------------------------------------------------
# Configure fzf-tab to show current directory contents for z command
zstyle ':fzf-tab:complete:z:*' fzf-preview 'ls -la $realpath'
zstyle ':fzf-tab:complete:z:*' fzf-flags '--height=40%'
# }}}
# -------------------------------------------------------------------
