# Setup Key Bindings
if [[ -f "$HOME/.fzf/shell/key-bindings.zsh" ]]; then
  source "$HOME/.fzf/shell/key-bindings.zsh"
fi

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# fzf config
[[ -f ~/.fzf_config ]] && source ~/.fzf_config

# great functions for fzf from
# https://gist.github.com/junegunn/8b572b8d4b5eddd8b85e5f4d40f17236
[[ -f ~/Desktop/Github/fzf-git.sh/fzf-git.sh ]] && source ~/Desktop/Github/fzf-git.sh/fzf-git.sh
