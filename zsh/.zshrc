# zmodload zsh/zprof

unsetopt INC_APPEND_HISTORY
unsetopt SHARE_HISTORY
HISTFILE="${XDG_STATE_HOME:-$HOME/.local/state}/zsh/history"
mkdir -p "${HISTFILE:h}"
HISTSIZE=10000
SAVEHIST=10000
setopt APPEND_HISTORY HIST_IGNORE_DUPS

# Keep Omarchy's mise-managed tools available in interactive Zsh too.
if [[ -r /usr/share/omarchy/default/bash/env-bootstrap ]] && command -v mise &>/dev/null; then
    eval "$(mise activate zsh)"
fi

# -------------------------------------------------------------------
# # NOTE: auto start tmux {{{
# start tmux while starting new terminal
# -------------------------------------------------------------------
_not_inside_tmux() { [[ -z "$TMUX" ]]; }

_inside_herdr() {
    [[ -n "${HERDR_ENV:-}" || \
       -n "${HERDR_PANE_ID:-}" || \
       -n "${HERDR_SOCKET_PATH:-}" || \
       -n "${HERDR_SESSION:-}" || \
       -n "${HERDR_WORKSPACE_ID:-}" || \
       -n "${HERDR_TAB_ID:-}" || \
       -n "${HC_TERMINAL_ID:-}" || \
       -n "${HC_TERMINAL_SOCKET:-}" || \
       -n "${HC_SCOPE:-}" || \
       "${__CFBundleIdentifier:-}" == "dev.herdr.app" || \
       "${XPC_SERVICE_NAME:-}" == application.dev.herdr.app* || \
       "${TERM_PROGRAM:-}" == *herdr* ]]
}

_skip_tmux_autostart() {
    [[ -n "${REX_SESSION:-}" ]] || _inside_herdr
}

ensure_tmux_is_running() {
    ZSH_TMUX_AUTOSTART=1
    local autostart="${ZSH_TMUX_AUTOSTART:-1}"
    if [[ -r /usr/share/omarchy/default/bash/env-bootstrap ]]; then
        autostart="${ZSH_TMUX_AUTOSTART:-0}"
    fi
    if [[ "$autostart" == 1 && -t 0 && -t 1 ]] && command -v tmux &>/dev/null && [[ -x ~/.tat ]] && _not_inside_tmux && ! _skip_tmux_autostart; then
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


# Allow SSH on hosts that need it; HTTPS works without GitHub SSH credentials.
ZSH_PLUGIN_GIT_SERVER="${ZSH_PLUGIN_GIT_SERVER:-https://github.com/}"
ZNAP_DIR="$HOME/.znap/znap"
if [[ ! -r "$ZNAP_DIR/znap.zsh" ]]; then
    if ! git clone --depth 1 -- \
        "${ZSH_PLUGIN_GIT_SERVER}marlonrichert/zsh-snap.git" "$ZNAP_DIR"; then
        print -u2 "zsh: failed to install Znap; skipping remaining startup config"
        return 1
    fi
fi
source "$ZNAP_DIR/znap.zsh" || return 1
# Use the same transport for shorthand plugin URLs.
zstyle ':znap:clone:' default-server "$ZSH_PLUGIN_GIT_SERVER"

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
FAST_HIGHLIGHT_STYLES[path-to-dir]='fg=#00aaff,underline'

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
# TERM belongs to the terminal emulator or tmux, not shell initialization.
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
if command -v pyenv &>/dev/null && ! [[ -r /usr/share/omarchy/default/bash/env-bootstrap ]]; then
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
fi
# }}}
# -------------------------------------------------------------------

# -------------------------------------------------------------------
# # NOTE: rbenv {{{
# -------------------------------------------------------------------
if command -v rbenv &>/dev/null && ! [[ -r /usr/share/omarchy/default/bash/env-bootstrap ]]; then
    znap eval rbenv "rbenv init -"
fi
# }}}
# -------------------------------------------------------------------

# -------------------------------------------------------------------
# # NOTE: fnm {{{
# -------------------------------------------------------------------

# Clean up stale fnm_multishells entries (PIDs that no longer exist).
# fnm creates a new per-shell symlink on every shell start but never
# removes them, causing thousands of stale entries that slow startup.
_fnm_cleanup_multishells() {
    local multishells_dir="${HOME}/.local/state/fnm_multishells"
    [[ -d "$multishells_dir" ]] || return
    local entry pid
    for entry in "$multishells_dir"/*(N); do
        pid='${${entry:t}%%_*}'
        # Remove if the PID is purely numeric and no longer alive
        if [[ "$pid" =~ ^[0-9]+$ ]] && ! kill -0 "$pid" 2>/dev/null; then
            rm -f "$entry"
        fi
    done
}
if command -v fnm &>/dev/null && ! [[ -r /usr/share/omarchy/default/bash/env-bootstrap ]]; then
_fnm_cleanup_multishells

# Then load fnm silently
export FNM_RESOLVE_ENGINES=false
eval "$(fnm env --shell zsh)"
fi

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
if command -v atuin &>/dev/null; then
eval "$(atuin init zsh)"

# --- FORCE ATUIN BINDING ---
# This block runs LAST, ensuring Atuin wins the fight for Ctrl+R
bindkey -M emacs '^R' atuin-search
bindkey -M viins '^R' atuin-search-viins
bindkey -M vicmd '^R' atuin-search
fi
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

[[ -r ~/.config/tmux/plugins/tmux-session-dots/bell-notify.zsh ]] && source ~/.config/tmux/plugins/tmux-session-dots/bell-notify.zsh

#-------------------------------------------------------------------------------
# }}}
#-------------------------------------------------------------------------------

#-------------------------------------------------------------------------------
# # NOTE: Daily Quote Startup Hook {{{
#-------------------------------------------------------------------------------

# Show daily quote on interactive shell startup (once on first prompt)
_show_startup_quote() {
    # Remove ourselves immediately so we only run once
    add-zsh-hook -d precmd _show_startup_quote
    # Keep Herdr terminals quiet; the quote command remains available manually.
    if _inside_herdr; then
        return 0
    fi
    if command -v quote &>/dev/null; then
        quote
    fi
}
if [[ -o interactive ]]; then
    autoload -U add-zsh-hook
    add-zsh-hook precmd _show_startup_quote
fi

#-------------------------------------------------------------------------------
# }}}
#-------------------------------------------------------------------------------

#-------------------------------------------------------------------------------
# # NOTE: deno {{{
#-------------------------------------------------------------------------------

[[ -f "${DENO_INSTALL:-$HOME/.deno}/env" ]] && . "${DENO_INSTALL:-$HOME/.deno}/env"

#-------------------------------------------------------------------------------
# }}}
#-------------------------------------------------------------------------------

# zprof

# vim:foldmethod=marker


# Added by Antigravity CLI installer
export PATH="/home/lalitmee/.local/bin:$PATH"
