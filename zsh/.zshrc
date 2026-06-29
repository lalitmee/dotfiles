# zmodload zsh/zprof

unsetopt INC_APPEND_HISTORY
unsetopt SHARE_HISTORY
SAVEHIST=0

# -------------------------------------------------------------------
# # NOTE: auto start tmux {{{
# start tmux while starting new terminal
# -------------------------------------------------------------------
_not_inside_tmux() { [[ -z "$TMUX" ]]; }

ensure_tmux_is_running() {
    if _not_inside_tmux; then
        ~/.tat
    fi
}

ensure_tmux_is_running
# -------------------------------------------------------------------
# }}}
# -------------------------------------------------------------------

# -------------------------------------------------------------------
# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
# if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
#   source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
# fi


# Download Znap, if it's not there yet, then load it.
ZNAP_DIR=~/.oh-my-zsh/custom/plugins/znap
[[ -r $ZNAP_DIR/znap.zsh ]] ||
    git clone --depth 1 -- \
        https://github.com/marlonrichert/zsh-snap.git "$ZNAP_DIR"
source "$ZNAP_DIR/znap.zsh"

# -------------------------------------------------------------------
# # NOTE: plugins (znap-managed) {{{
# -------------------------------------------------------------------
znap source zsh-users/zsh-completions
# Local completions (tracked in dotfiles, e.g. _z for zoxide).
# Must be on fpath BEFORE compinit runs.
fpath=(~/.zsh_completions $fpath)

# Ensure compinit runs (OMZ used to do this for us). Built-in zsh and
# plugin completions are picked up; the heavy zsh-users/zsh-completions
# pack is intentionally not loaded (it ~doubled startup for 383 extra files).
autoload -Uz compinit && compinit -i

# Load core fzf integration first so fzf-tab can hook into it
[[ -f ~/.zsh_plugins_config/fzf.zsh ]] && source ~/.zsh_plugins_config/fzf.zsh

# Plugins (standalone repos; znap clones + caches them)
znap source zsh-users/zsh-autosuggestions
znap source Aloxaf/fzf-tab
znap source jeffreytse/zsh-vi-mode
znap source zdharma-continuum/fast-syntax-highlighting

# Prompt: load p10k via znap source (NOT `znap prompt` — that conflicts
# with p10k's instant-prompt block at the top of this file).
# znap source romkatv/powerlevel10k
# }}}
# -------------------------------------------------------------------

#-------------------------------------------------------------------------------
# # NOTE: p10k config {{{
#-------------------------------------------------------------------------------

# Load p10k prompt first (no output)
# [[ -r "${HOME}/.p10k.zsh" ]] && source "${HOME}/.p10k.zsh"

# # --- powerlevel10k performance overrides (worktree-friendly) ---
# typeset -g POWERLEVEL9K_VCS_SHOW_UNTRACKED=false
# typeset -g POWERLEVEL9K_VCS_SHOW_STASH=false
# typeset -g POWERLEVEL9K_VCS_MAX_SYNC_LATENCY_SECONDS=0.4
# typeset -g POWERLEVEL9K_VCS_DISABLE_GITSTATUS_FORMATTING=true

# # --- powerlevel10k: hide untracked & stash in custom formatter ---
# typeset -g POWERLEVEL9K_VCS_{UNTRACKED,STASH}_MAX_NUM=0

#-------------------------------------------------------------------------------
# }}}
#-------------------------------------------------------------------------------

# }}}
# -------------------------------------------------------------------

# }}}
# -------------------------------------------------------------------

# -------------------------------------------------------------------
# # NOTE: user configurations {{{
# -------------------------------------------------------------------
if [[ $TERM == xterm ]]; then
    TERM=screen-256color
fi
# }}}
# -------------------------------------------------------------------

# -------------------------------------------------------------------
# # NOTE: sourcing some of the other things {{{
# -------------------------------------------------------------------

# aliases
[[ -f ~/.zsh_aliases ]] && source ~/.zsh_aliases

# secrete tokens
[[ -f ~/.secret-tokens ]] && source ~/.secret-tokens

# awesome zsh functions
[[ -f ~/.zsh_functions ]] && source ~/.zsh_functions

# keybindings
[[ -f ~/.zsh_keybindings ]] && source ~/.zsh_keybindings

# plugins config
[[ -f ~/.zsh_plugins_config/init.zsh ]] && source ~/.zsh_plugins_config/init.zsh
# }}}
# -------------------------------------------------------------------

# # -------------------------------------------------------------------
# # NOTE: starship prompt {{{
# # -------------------------------------------------------------------
znap eval starship "starship init zsh --print-full-init"
znap prompt
# # }}}
# # -------------------------------------------------------------------

# -------------------------------------------------------------------
# # NOTE: zoxide {{{
# -------------------------------------------------------------------
# znap eval zoxide "zoxide init zsh --cmd cd"
# NOTE: direct eval required — znap eval breaks `compdef __zoxide_z_complete z`
# (compdef for shell functions doesn't register via znap's compile path).
eval "$(zoxide init zsh)"
# }}}
# -------------------------------------------------------------------

# -------------------------------------------------------------------
# # NOTE: pyenv {{{
# -------------------------------------------------------------------
eval "$(pyenv init --path)"

# Lazy-load pyenv to prevent shell startup latency.
_load_pyenv() {
    znap eval pyenv 'pyenv init - && pyenv virtualenv-init -'
    # Disable pyenv-virtualenv auto-activation hook to prevent prompt latency.
    # Manual activation using 'pyenv activate <venv-name>' will still work.
    autoload -U add-zsh-hook
    add-zsh-hook -d precmd _pyenv_virtualenv_hook
}
znap function pyenv _load_pyenv
# }}}
# -------------------------------------------------------------------

# -------------------------------------------------------------------
# # NOTE: rbenv {{{
# -------------------------------------------------------------------
znap eval rbenv "rbenv init -"
# }}}
# -------------------------------------------------------------------

# -------------------------------------------------------------------
# # NOTE: fnm {{{
# -------------------------------------------------------------------

# Then load fnm silently
export FNM_RESOLVE_ENGINES=false
znap eval fnm "fnm env --use-on-cd --shell zsh"

# }}}
# -------------------------------------------------------------------

# -------------------------------------------------------------------
# # NOTE: linuxbrew {{{
# -------------------------------------------------------------------
# Load Homebrew shell environment if it's installed
znap compadd /home/linuxbrew/.linuxbrew/bin/brew &>/dev/null && eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
# }}}
# -------------------------------------------------------------------

# -------------------------------------------------------------------
# # NOTE: atuin {{{
# -------------------------------------------------------------------
# This line loads Atuin and defines the `atuin-search` widgets.
# NOTE: must be a direct eval, NOT `znap eval` — atuin registers its
# widgets with `zle -N`, which does not survive znap's cache/compile step
# (the atuin-search widget ends up undefined). Direct eval is ~cheap.
eval "$(atuin init zsh)"

# --- FORCE ATUIN BINDING ---
# This block runs LAST, ensuring Atuin wins the fight for Ctrl+R
bindkey -M emacs '^R' atuin-search
bindkey -M viins '^R' atuin-search-viins
bindkey -M vicmd '^R' atuin-search
# }}}
# -------------------------------------------------------------------

# # -------------------------------------------------------------------
# # # NOTE: dynamic REPOSITORY_PATH variable {{{
# # -------------------------------------------------------------------
#
# # Add the function to the precmd_functions hook array, ensuring it's loaded
# autoload -U add-zsh-hook
# add-zsh-hook precmd update_repo_path
#
# # -------------------------------------------------------------------
# # }}}
# # -------------------------------------------------------------------

#-------------------------------------------------------------------------------
# # NOTE: Extend Limitations {{{
#-------------------------------------------------------------------------------

# Increase file descriptor limit on macOS only
if [[ "$OSTYPE" == "darwin"* ]]; then
    ulimit -n 40480
fi

#-------------------------------------------------------------------------------
# }}}
#-------------------------------------------------------------------------------

#-------------------------------------------------------------------------------
# # NOTE: tmux-session-dots notify bell {{{
#-------------------------------------------------------------------------------

source ~/.tmux/plugins/tmux-session-dots/bell-notify.zsh

#-------------------------------------------------------------------------------
# }}}
#-------------------------------------------------------------------------------

# zprof

# vim:foldmethod=marker
