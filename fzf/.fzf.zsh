# source <(fzf --zsh)
#
# if [[ -n "${FZF_PATH}" && ! "$PATH" == *${FZF_PATH}/bin* ]]; then
#   export PATH="$PATH:${FZF_PATH}/bin"
# fi
#
# # Auto-completion
# # ---------------
# if [[ $- == *i* && -n "${FZF_PATH}" && -f "${FZF_PATH}/shell/completion.zsh" ]]; then
#   source "${FZF_PATH}/shell/completion.zsh" 2>/dev/null
# fi
#
# # Key bindings
# # ------------
# if [[ -n "${FZF_PATH}" && -f "${FZF_PATH}/shell/key-bindings.zsh" ]]; then
#   source "${FZF_PATH}/shell/key-bindings.zsh" 2>/dev/null
# fi

# Setup fzf PATH using $HOME
if [[ ! "$PATH" == *"$HOME"/.fzf/bin* ]]; then
  PATH="${PATH:+${PATH}:}$HOME/.fzf/bin"
fi

# Ensure FZF_PATH is defined using $HOME
# This variable points to the fzf installation directory.
export FZF_PATH="$HOME/.fzf"
