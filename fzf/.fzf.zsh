# Setup fzf
# ---------
if [[ ! "$PATH" == */Users/lalit.kumar1/.fzf/bin* ]]; then
  PATH="${PATH:+${PATH}:}/Users/lalit.kumar1/.fzf/bin"
fi

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

source <(fzf --zsh)
