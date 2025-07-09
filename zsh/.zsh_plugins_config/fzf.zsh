# ~/.zsh_plugins_config/fzf.zsh

# Source fzf's core Zsh integration.
# This command sets up key bindings (like C-r for history, C-t for files)
# and also sources completion.zsh and key-bindings.zsh from fzf's installation.
source <(fzf --zsh)

# Source your fzf config (the one with FZF_DEFAULT_OPTS, FZF_CTRL_R_OPTS).
# This must come *after* 'source <(fzf --zsh)' so your customizations
# can override fzf's defaults.
[[ -f ~/.fzf_config ]] && source ~/.fzf_config

# Source other fzf-related scripts that you use, like fzf-git.sh.
# These should also come after the main fzf integration.
[[ -f ~/Projects/Personal/Github/fzf-git.sh/fzf-git.sh ]] && source ~/Projects/Personal/Github/fzf-git.sh/fzf-git.sh
