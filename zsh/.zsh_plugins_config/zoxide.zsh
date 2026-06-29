# -------------------------------------------------------------------
# NOTE: fzf-tab configuration for zoxide {{{
# -------------------------------------------------------------------
# fzf-tab ignores FZF_DEFAULT_OPTS by default; this makes the tab-completion
# menu pick up our cobalt2 colors/layout from ~/.fzf_config.
zstyle ':fzf-tab:*' use-fzf-default-opts yes

# Configure fzf-tab to show current directory contents for z command
zstyle ':fzf-tab:complete:(cd|z|__zoxide_z):*' fzf-preview 'ls -la $realpath'
zstyle ':fzf-tab:complete:(cd|z|__zoxide_z):*' fzf-flags '--height=40%'
# }}}
# -------------------------------------------------------------------
