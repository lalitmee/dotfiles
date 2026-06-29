# zsh Config Consolidation & Speedup — Design

**Date:** 2026-06-29
**Status:** Approved (pending spec review)

## Goal

Consolidate the zsh configuration onto **znap as the single plugin manager**, remove the
oh-my-zsh (OMZ) / znap overlap and dead config, delete unused on-disk plugins, and cut
interactive startup time using `znap eval` caching — all while keeping shell behavior
identical.

Baseline startup (`zsh -i -c exit`, ×3): ~0.44–0.59s.

## Problem Statement

The current setup runs three plugin-management mechanisms with overlapping responsibilities:

- **oh-my-zsh** loads plugins via `plugins=(git fast-syntax-highlighting fzf-tab vi-mode
  zsh-autosuggestions)` + `source $ZSH/oh-my-zsh.sh`.
- **znap (zsh-snap)** is installed and sourced, but only used for `znap eval` / `znap compadd`
  caching of pyenv/rbenv/fnm/brew. It manages no plugins.
- Prompt is OMZ's `ZSH_THEME="powerlevel10k/powerlevel10k"`; the `znap prompt` / starship
  blocks are commented out.

This produces concrete redundancies and conflicts:

- **Two vi-mode systems loaded simultaneously:** OMZ's `vi-mode` plugin *and* `zsh-vi-mode`
  (sourced from `init.zsh`). `zsh-vi-mode` is the superior, intended one.
- **Duplicate `fast-syntax-highlighting`** installed in both
  `~/.oh-my-zsh/custom/plugins/` and `~/.config/zdharma-continuum/`.
- **Eager, uncached `eval`s** dominate startup: `pyenv init` runs 3× uncached, plus
  `rbenv`, `fnm`, `atuin`, `zoxide`.
- **OMZ framework overhead:** `oh-my-zsh.sh` load + auto-update machinery
  (`UPDATE_ZSH_DAYS=5`).
- **Dead on-disk plugins** in `~/.oh-my-zsh/custom/plugins/`.
- **Duplicate PATH/env lines:** the "Antigravity CLI installer" PATH export appears in
  `.profile`, `.zprofile`, and `.zshrc`; `.zshenv` sources `$HOME/.cargo/env` twice.

## Target Architecture

### Plugin loading (znap-native)

Replace `plugins=(...)` + `source $ZSH/oh-my-zsh.sh` with direct znap calls:

```zsh
znap source zsh-users/zsh-autosuggestions
znap source zdharma-continuum/fast-syntax-highlighting
znap source Aloxaf/fzf-tab
# zsh-vi-mode continues to be sourced as today (init.zsh)
znap prompt romkatv/powerlevel10k   # replaces ZSH_THEME + source oh-my-zsh.sh
```

- `compinit` is invoked explicitly (znap manages completion init / caching), replacing the
  implicit `compinit` that `oh-my-zsh.sh` provided.
- The `$ZSH` / `~/.oh-my-zsh` dependency is removed from the load path. Standalone plugins
  are referenced by git repo and cached by znap, so the duplicate
  `fast-syntax-highlighting` location no longer matters.
- `zsh-completions` fpath entry is preserved (or replaced with the znap equivalent).

### Prompt

p10k loads via `znap prompt romkatv/powerlevel10k`. `.p10k.zsh` is sourced unchanged, and
the existing performance overrides (`POWERLEVEL9K_VCS_*`) are preserved.

## Detailed Changes

### 1. Remove redundancy / conflicts
- Remove OMZ's `vi-mode` from plugin loading (keep `zsh-vi-mode`).
- Remove `source $ZSH/oh-my-zsh.sh`, `ZSH_THEME`, `UPDATE_ZSH_DAYS`,
  `COMPLETION_WAITING_DOTS`, and the large commented OMZ configuration block.
- Resolve the duplicate `fast-syntax-highlighting` — znap owns one canonical copy.
- Remove `init.zsh` line 2 (commented duplicate fzf source).

### 2. Port what we keep from OMZ
- **Git aliases:** The user relies on OMZ `git`-plugin aliases (`gst`, `gco`, `gp`, `gd`,
  `gaa`, `glog`, `gb`, `gc`, …) which are **not** in `.zsh_aliases` today. Before
  finalizing, confirm the exact subset actually used (check atuin/shell history for `g*`
  invocations), then add that subset to `.zsh_aliases` alongside the existing
  worktree/custom git aliases (`gwl`, `gwa`, `gcn`, `gpn`, `gm`, …).
- p10k prompt via `znap prompt` (above).

### 3. Speed — `znap eval` caching
Wrap eager inits so output is cached to disk and replayed instantly; shell hooks still
register live on each session:
- `pyenv` (currently 3× uncached → single cached eval), preserving the deliberate
  `add-zsh-hook -d precmd _pyenv_virtualenv_hook` latency fix.
- `rbenv`, `fnm`, `atuin`, `zoxide` — cached via `znap eval`.
- Keep `FNM_RESOLVE_ENGINES=false` and atuin's forced `Ctrl+R` rebindings.

### 4. On-disk cleanup
Delete genuinely unused plugin clones from `~/.oh-my-zsh/custom/plugins/`:
- `example/`
- `fzf-zsh-completions/`
- `fzf-zsh-plugin/`
- `zsh-lazyload/`
- `zsh-wakatime/`

These are git clones, **not** tracked in the dotfiles repo, so deletion is real
(re-cloneable but real). Back them up to a temp location during migration; delete only
after parity is confirmed.

**Note:** After full migration, the remaining standalone plugins become znap-managed, so the
entire `~/.oh-my-zsh` tree *could* be removed. That full removal is treated as a final,
**optional** step — not bundled with the unused-plugin deletion — so parity can be verified
first.

### 5. Duplicate env/PATH cleanup
- Consolidate the triplicate "Antigravity CLI installer" PATH export
  (`.profile`, `.zprofile`, `.zshrc`).
- Remove the duplicate trailing `. "$HOME/.cargo/env"` in `.zshenv` (already sourced earlier
  in the file).

## Out of Scope (YAGNI)
- No edits to `.p10k.zsh`, `.fzf_config`, `.zsh_functions` internals, or keybinding logic.
- No switch to lazy-loading version managers (caching was chosen instead).
- Full `~/.oh-my-zsh` removal deferred to an optional post-parity step.

## Testing & Safety
- All work on a dedicated git branch; rollback = discard branch.
- **Startup timing:** measure `zsh -i -c exit` ×3 before and after.
- **Parity diff:** capture the set of available aliases, functions, and `bindkey` output
  before and after; diff to prove no regressions (beyond intended removals).
- **Live functional checks:** `pyenv versions`, `fnm use`/`--use-on-cd`, `z <dir>`, atuin
  `Ctrl+R`, fzf-tab completion, vi-mode cursor behavior, syntax highlighting, autosuggestions.
- On-disk plugin clones backed up to a temp dir before deletion; removed only after the above
  pass.

## Success Criteria
- Single plugin manager (znap); no `source oh-my-zsh.sh` in the load path.
- No duplicate vi-mode or fast-syntax-highlighting loading.
- Used git aliases preserved.
- Measurable startup-time reduction with identical interactive behavior.
- Unused custom plugins removed from disk; env/PATH duplicates consolidated.
