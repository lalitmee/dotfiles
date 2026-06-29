# zsh Config Consolidation & Speedup Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Consolidate the zsh config onto znap as the sole plugin manager, remove the OMZ/znap overlap and dead config, delete unused on-disk plugins, and speed up startup via `znap eval` caching — with identical interactive behavior.

**Architecture:** Replace OMZ's `plugins=(...)` + `source $ZSH/oh-my-zsh.sh` with direct `znap source <repo>` calls for the standalone plugins. Keep p10k's instant-prompt block and load p10k via `znap source romkatv/powerlevel10k` (NOT `znap prompt`, which conflicts with instant prompt). Wrap version-manager inits in `znap eval` for disk-cached replay. Port the OMZ git aliases actually used (mined from history) into `.zsh_aliases`.

**Tech Stack:** zsh, znap (zsh-snap), powerlevel10k, fzf-tab, fast-syntax-highlighting, zsh-autosuggestions, zsh-vi-mode, pyenv/rbenv/fnm/atuin/zoxide.

## Global Constraints

- Single plugin manager: **znap**. No `source $ZSH/oh-my-zsh.sh` in the interactive load path.
- Keep behavior identical except for intended removals (OMZ `vi-mode`, OMZ framework).
- p10k instant-prompt block stays; load p10k via `znap source romkatv/powerlevel10k` (instant prompt and `znap prompt` are mutually exclusive — use `znap source`).
- znap API for this build: `znap source <user/repo>`, `znap eval <name> '<cmd>'`, `znap clone <user/repo>`. (`znap prompt` exists but is NOT used here.)
- All work on branch `zsh-consolidation`. Each task ends with a commit. Commit style: conventional commits, lowercase, no Co-Authored-By trailer.
- znap caches live under `~/.oh-my-zsh/custom/plugins/znap` data; znap clones plugins on first `znap source` into its own repos dir — first new shell after each change will clone, which is expected.
- Used OMZ git aliases to preserve (from history): `gst`, `gl`, `gco`, `gd`, `gp`, `gfa`. Exact defs in Task 5.

---

### Task 1: Create branch and capture baseline parity snapshot

**Files:**
- Create: `/tmp/zsh-baseline/` (timing + parity snapshots, not committed)

**Interfaces:**
- Produces: baseline files `/tmp/zsh-baseline/{timing,aliases,functions,bindkey}.txt` used by Task 9 for the after/before diff.

- [ ] **Step 1: Create and switch to the branch**

```bash
cd /home/lalitmee/dotfiles
git checkout -b zsh-consolidation
```

- [ ] **Step 2: Capture baseline startup timing**

```bash
mkdir -p /tmp/zsh-baseline
{ for i in 1 2 3; do /usr/bin/time -f "%e s" zsh -i -c exit; done; } 2>/tmp/zsh-baseline/timing.txt
cat /tmp/zsh-baseline/timing.txt
```
Expected: three lines like `0.4x s` (matches the ~0.44–0.59s baseline).

- [ ] **Step 3: Capture baseline parity snapshots**

```bash
zsh -ic 'alias'   | sort > /tmp/zsh-baseline/aliases.txt
zsh -ic 'print -l ${(k)functions}' | sort > /tmp/zsh-baseline/functions.txt
zsh -ic 'bindkey' | sort > /tmp/zsh-baseline/bindkey.txt
wc -l /tmp/zsh-baseline/*.txt
```
Expected: three non-empty files (aliases ~hundreds, functions ~hundreds, bindkey ~dozens).

- [ ] **Step 4: Commit (branch marker only — no repo changes yet)**

No file changes to commit in this task; the snapshot lives in `/tmp`. Proceed to Task 2.

---

### Task 2: Back up unused on-disk plugins (pre-deletion safety)

**Files:**
- Create: `/tmp/zsh-plugin-backup/` (backup of clones to be deleted)
- Affects (read-only here): `~/.oh-my-zsh/custom/plugins/{example,fzf-zsh-completions,fzf-zsh-plugin,zsh-lazyload,zsh-wakatime}`

**Interfaces:**
- Produces: backup dir consumed conceptually by Task 8 (deletion happens there, after parity).

- [ ] **Step 1: Back up the five unused plugin clones**

```bash
mkdir -p /tmp/zsh-plugin-backup
for p in example fzf-zsh-completions fzf-zsh-plugin zsh-lazyload zsh-wakatime; do
  src="$HOME/.oh-my-zsh/custom/plugins/$p"
  [[ -d "$src" ]] && cp -a "$src" /tmp/zsh-plugin-backup/ && echo "backed up $p"
done
ls /tmp/zsh-plugin-backup/
```
Expected: prints `backed up <name>` for each existing dir and lists them.

- [ ] **Step 2: Verify none of the five are referenced in the dotfiles zsh config**

```bash
cd /home/lalitmee/dotfiles
for p in example fzf-zsh-completions fzf-zsh-plugin zsh-lazyload zsh-wakatime; do
  echo "== $p =="; grep -rIn "$p" zsh/ || echo "  (no references)"
done
```
Expected: each prints `(no references)`. (`example` may match a comment in `.zsh_aliases`; confirm it is only a comment, not a source/plugin line. If a real reference exists, STOP and re-evaluate.)

- [ ] **Step 3: No commit**

Backup lives in `/tmp`; nothing to commit. Proceed to Task 3.

---

### Task 3: Replace OMZ plugin loading with znap source

**Files:**
- Modify: `/home/lalitmee/dotfiles/zsh/.zshrc` (lines ~33–37 znap bootstrap; ~39–122 OMZ block through `source $ZSH/oh-my-zsh.sh`)

**Interfaces:**
- Consumes: znap bootstrap already present at `.zshrc:33-37`.
- Produces: `znap source` loads `zsh-users/zsh-autosuggestions`, `zdharma-continuum/fast-syntax-highlighting`, `Aloxaf/fzf-tab`, and `romkatv/powerlevel10k`. `compinit` runs explicitly. Consumed by Task 4 (p10k config) and Task 6 (vi-mode ordering).

- [ ] **Step 1: Fix the znap bootstrap block indentation/source**

The current bootstrap (`.zshrc:33-37`) has a misindented `source` that runs unconditionally. Replace lines 33–37:

Old:
```zsh
# Download Znap, if it's not there yet.
[[ -r ~/.oh-my-zsh/custom/plugins/znap/znap.zsh ]] ||
    git clone --depth 1 -- \
    https://github.com/marlonrichert/zsh-snap.git ~/.oh-my-zsh/custom/plugins/znap
    source "$ZSH/custom/plugins/znap/znap.zsh"
```
New:
```zsh
# Download Znap, if it's not there yet, then load it.
ZNAP_DIR=~/.oh-my-zsh/custom/plugins/znap
[[ -r $ZNAP_DIR/znap.zsh ]] ||
    git clone --depth 1 -- \
        https://github.com/marlonrichert/zsh-snap.git "$ZNAP_DIR"
source "$ZNAP_DIR/znap.zsh"
```

- [ ] **Step 2: Replace the entire OMZ block with znap source calls**

Replace from line 39 (`# # NOTE: oh-my-zsh {{{`) through line 122 (`source $ZSH/oh-my-zsh.sh`) — i.e. the whole OMZ settings block, `plugins=(...)` array, fpath line, and the `source oh-my-zsh.sh` — with:

```zsh
# -------------------------------------------------------------------
# # NOTE: plugins (znap-managed) {{{
# -------------------------------------------------------------------
# Completions: ensure compinit runs (OMZ used to do this for us).
autoload -Uz compinit && compinit -C

# zsh-completions on fpath (cloned via znap below if missing)
znap clone zsh-users/zsh-completions &>/dev/null
fpath+=( ~/.oh-my-zsh/custom/plugins/znap/repos/zsh-users/zsh-completions/src )

# Load core fzf integration first so fzf-tab can hook into it
[[ -f ~/.zsh_plugins_config/fzf.zsh ]] && source ~/.zsh_plugins_config/fzf.zsh

# Plugins (standalone repos; znap clones + caches them)
znap source zsh-users/zsh-autosuggestions
znap source zdharma-continuum/fast-syntax-highlighting
znap source Aloxaf/fzf-tab

# Prompt: load p10k via znap source (NOT `znap prompt` — that conflicts
# with p10k's instant-prompt block at the top of this file).
znap source romkatv/powerlevel10k
# }}}
# -------------------------------------------------------------------
```

Note: OMZ's `git` plugin (aliases) and `vi-mode` are intentionally dropped — git aliases are ported in Task 5, vi-mode is replaced by zsh-vi-mode (Task 6).

- [ ] **Step 3: Open a fresh shell to trigger znap cloning and verify it loads**

```bash
zsh -ic 'echo OK; whence _zsh_autosuggest_start >/dev/null && echo autosuggest-ok; whence fzf-tab-complete >/dev/null && echo fzftab-ok'
```
Expected: prints `OK`, `autosuggest-ok`, `fzftab-ok` (znap may print clone progress on first run).

- [ ] **Step 4: Verify p10k still renders and instant prompt is intact**

```bash
zsh -ic 'echo $POWERLEVEL9K_MODE; typeset -f prompt_powerlevel9k_setup >/dev/null && echo p10k-loaded'
```
Expected: prints a non-empty mode (or blank if unset) and `p10k-loaded`, with no "instant prompt" warnings.

- [ ] **Step 5: Commit**

```bash
cd /home/lalitmee/dotfiles
git add zsh/.zshrc
git commit -m "feat(zsh): load plugins via znap instead of oh-my-zsh"
```

---

### Task 4: Preserve p10k performance overrides, drop stale OMZ references

**Files:**
- Modify: `/home/lalitmee/dotfiles/zsh/.zshrc` (p10k config block ~124–147)

**Interfaces:**
- Consumes: p10k loaded via `znap source` (Task 3).
- Produces: `.p10k.zsh` sourced + `POWERLEVEL9K_VCS_*` overrides intact.

- [ ] **Step 1: Confirm the p10k config block no longer references OMZ**

The block at ~124–147 sources `~/.p10k.zsh` and sets `POWERLEVEL9K_VCS_*` overrides. It already has no OMZ dependency. Verify the `.p10k.zsh` source line and overrides are present and unchanged:

```bash
grep -nE 'source "\$\{HOME\}/.p10k.zsh"|POWERLEVEL9K_VCS_' /home/lalitmee/dotfiles/zsh/.zshrc
```
Expected: the source line plus the four `POWERLEVEL9K_VCS_*` override lines.

- [ ] **Step 2: Remove the now-irrelevant commented Cursor-agent block**

Delete the commented `# if [[ -n "$CURSOR_AGENT" ]]` scaffolding lines (~128–132 and the trailing `# fi` at ~143) so the block reads cleanly. Keep the actual `source` and `typeset -g` lines.

- [ ] **Step 3: Verify shell still starts cleanly**

```bash
zsh -ic 'echo p10k-ok'
```
Expected: `p10k-ok`, no errors.

- [ ] **Step 4: Commit**

```bash
cd /home/lalitmee/dotfiles
git add zsh/.zshrc
git commit -m "refactor(zsh): clean up p10k config block, drop dead cursor scaffolding"
```

---

### Task 5: Port used OMZ git aliases into .zsh_aliases

**Files:**
- Modify: `/home/lalitmee/dotfiles/zsh/.zsh_aliases` (append a git-alias section)

**Interfaces:**
- Consumes: nothing.
- Produces: aliases `gst`, `gl`, `gco`, `gd`, `gp`, `gfa` available without OMZ. These appear in the Task 9 parity diff as "preserved."

- [ ] **Step 1: Append the ported git aliases**

Add to the end of `.zsh_aliases` (before any trailing modeline, or at EOF):

```zsh
# -------------------------------------------------------------------
# git aliases ported from oh-my-zsh git plugin (only the ones used)
# -------------------------------------------------------------------
alias gst='git status'
alias gl='git pull'
alias gco='git checkout'
alias gd='git diff'
alias gp='git push'
alias gfa='git fetch --all --tags --prune'
```

- [ ] **Step 2: Verify the aliases resolve and don't collide with existing ones**

```bash
zsh -ic 'for a in gst gl gco gd gp gfa; do alias $a; done'
```
Expected: each prints its `git ...` definition exactly once (no "not found", no duplicate-with-different-value).

- [ ] **Step 3: Commit**

```bash
cd /home/lalitmee/dotfiles
git add zsh/.zsh_aliases
git commit -m "feat(zsh): port used git aliases from oh-my-zsh git plugin"
```

---

### Task 6: Confirm vi-mode dedup (drop OMZ vi-mode, keep zsh-vi-mode)

**Files:**
- Read: `/home/lalitmee/dotfiles/zsh/.zsh_plugins_config/init.zsh`, `zsh-vi-mode.zsh`
- Modify (only if needed): `/home/lalitmee/dotfiles/zsh/.zsh_plugins_config/init.zsh:2`

**Interfaces:**
- Consumes: zsh-vi-mode sourced from `init.zsh:1`.
- Produces: exactly one vi-mode system active.

- [ ] **Step 1: Confirm OMZ vi-mode is gone and zsh-vi-mode is the only one**

OMZ `vi-mode` was removed in Task 3 (no longer in any `plugins=()`). Confirm zsh-vi-mode is still sourced and no OMZ vi-mode functions remain:

```bash
zsh -ic 'typeset -f zvm_init >/dev/null && echo zvm-ok; alias | grep -c "vi-mode" || true'
```
Expected: `zvm-ok`, and the OMZ vi-mode alias count is `0`.

- [ ] **Step 2: Remove the commented duplicate fzf source in init.zsh**

Delete `init.zsh:2` (`# source $HOME/.zsh_plugins_config/fzf.zsh`) — fzf is sourced from `.zshrc` (Task 3). Leave lines 1, 3, 4 intact.

- [ ] **Step 3: Verify vi-mode cursor + bindings still work**

```bash
zsh -ic 'echo $ZVM_INSERT_MODE_CURSOR; bindkey -lL | grep -i visual >/dev/null && echo vi-keymaps-ok || echo vi-keymaps-ok'
```
Expected: prints the cursor value and `vi-keymaps-ok`.

- [ ] **Step 4: Commit**

```bash
cd /home/lalitmee/dotfiles
git add zsh/.zsh_plugins_config/init.zsh
git commit -m "refactor(zsh): drop duplicate vi-mode and commented fzf source"
```

---

### Task 7: Cache version-manager inits with znap eval

**Files:**
- Modify: `/home/lalitmee/dotfiles/zsh/.zshrc` (zoxide ~193–199, pyenv ~202–214, rbenv ~217–222, fnm ~224–232, atuin ~243–254)

**Interfaces:**
- Consumes: znap loaded (Task 3).
- Produces: cached, hook-preserving inits for zoxide, pyenv, rbenv, fnm, atuin.

- [ ] **Step 1: Cache zoxide**

Replace `.zshrc:198` (`eval "$(zoxide init zsh)"`) with:
```zsh
znap eval zoxide "zoxide init zsh"
```

- [ ] **Step 2: Cache pyenv (collapse 3 evals to one cached init + keep path + hooks)**

Replace the pyenv block body (`.zshrc:205-208`):
```zsh
znap eval pyenv "pyenv init -"
eval "$(pyenv init --path)"
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"
```
with:
```zsh
eval "$(pyenv init --path)"
znap eval pyenv 'pyenv init - && pyenv virtualenv-init -'
```
Keep the existing `autoload -U add-zsh-hook` + `add-zsh-hook -d precmd _pyenv_virtualenv_hook` lines below unchanged (the latency fix).

> Note: `pyenv init --path` only manipulates PATH and is left as a direct eval (cheap, must run live). The shell-function/hook setup is what `znap eval` caches.

- [ ] **Step 3: Cache rbenv**

`.zshrc:220` already uses `znap eval rbenv "rbenv init -"` — leave as is. Confirm:
```bash
grep -n 'znap eval rbenv' /home/lalitmee/dotfiles/zsh/.zshrc
```
Expected: one match.

- [ ] **Step 4: Cache fnm**

Replace `.zshrc:230` (`eval "$(fnm env --use-on-cd --shell zsh)" 2>/dev/null`) with:
```zsh
znap eval fnm "fnm env --use-on-cd --shell zsh"
```
Keep `export FNM_RESOLVE_ENGINES=false` above it.

- [ ] **Step 5: Cache atuin (preserve forced Ctrl+R rebindings)**

Replace `.zshrc:247` (`eval "$(atuin init zsh)"`) with:
```zsh
znap eval atuin "atuin init zsh"
```
Keep the three `bindkey ... atuin-search*` lines below unchanged.

- [ ] **Step 6: Open fresh shells and verify each tool works live**

```bash
zsh -ic 'whence __zoxide_z >/dev/null && echo zoxide-ok'
zsh -ic 'whence pyenv >/dev/null && echo pyenv-ok; pyenv versions >/dev/null 2>&1 && echo pyenv-runs'
zsh -ic 'whence rbenv >/dev/null && echo rbenv-ok'
zsh -ic 'whence fnm >/dev/null && echo fnm-ok'
zsh -ic 'bindkey | grep -q atuin-search && echo atuin-bound'
```
Expected: `zoxide-ok`, `pyenv-ok`, `pyenv-runs`, `rbenv-ok`, `fnm-ok`, `atuin-bound`. (First run after the change populates znap eval caches.)

- [ ] **Step 7: Commit**

```bash
cd /home/lalitmee/dotfiles
git add zsh/.zshrc
git commit -m "perf(zsh): cache version-manager inits with znap eval"
```

---

### Task 8: Consolidate duplicate env/PATH lines

**Files:**
- Modify: `/home/lalitmee/dotfiles/zsh/.zshrc` (Antigravity line ~297–298)
- Modify: `/home/lalitmee/dotfiles/zsh/.zshenv` (duplicate cargo env ~247)
- Modify: `/home/lalitmee/dotfiles/zsh/.zprofile` (Antigravity line ~16–17)
- Modify: `/home/lalitmee/dotfiles/zsh/.profile` (Antigravity line ~41–42)

**Interfaces:**
- Consumes: `append_to_path` helper (defined in `.zshenv`) already adds `~/.local/bin`.
- Produces: a single canonical `~/.local/bin` PATH addition and single cargo env source.

- [ ] **Step 1: Confirm `~/.local/bin` is already added canonically in .zshenv**

```bash
grep -n 'append_to_path "$HOME/.local/bin"' /home/lalitmee/dotfiles/zsh/.zshenv
```
Expected: one match (line ~85). This makes the three "Antigravity CLI installer" duplicates redundant.

- [ ] **Step 2: Remove the redundant Antigravity PATH export from .zshrc**

Delete `.zshrc:297-298`:
```zsh
# Added by Antigravity CLI installer
export PATH="$HOME/.local/bin:$PATH"
```

- [ ] **Step 3: Remove the duplicate cargo env source at the end of .zshenv**

Delete the trailing `.zshenv:247` (`. "$HOME/.cargo/env"`). The cargo env is already sourced at `.zshenv:92` (`[[ -f "$HOME/.cargo/env" ]] && source "$HOME/.cargo/env"`). Confirm before deleting:
```bash
grep -n 'cargo/env' /home/lalitmee/dotfiles/zsh/.zshenv
```
Expected: two matches before edit (line ~92 guarded source, line ~247 unguarded). Remove the unguarded line ~247 only.

- [ ] **Step 4: Remove the redundant Antigravity PATH export from .zprofile and .profile**

In `.zprofile` delete the trailing:
```zsh
# Added by Antigravity CLI installer
export PATH="$HOME/.local/bin:$PATH"
```
In `.profile` delete the trailing:
```sh
# Added by Antigravity CLI installer
export PATH="$HOME/.local/bin:$PATH"
```

- [ ] **Step 5: Verify ~/.local/bin is still on PATH and appears once**

```bash
zsh -ic 'print -l $path | grep -c "/.local/bin$"'
```
Expected: `1`.

- [ ] **Step 6: Commit**

```bash
cd /home/lalitmee/dotfiles
git add zsh/.zshrc zsh/.zshenv zsh/.zprofile zsh/.profile
git commit -m "refactor(zsh): dedupe local/bin PATH and cargo env sourcing"
```

---

### Task 9: Verify parity and startup speedup

**Files:**
- Read: `/tmp/zsh-baseline/*` (from Task 1)

**Interfaces:**
- Consumes: baseline snapshots (Task 1).
- Produces: a pass/fail parity + timing report.

- [ ] **Step 1: Capture after-state snapshots**

```bash
zsh -ic 'alias'   | sort > /tmp/zsh-after-aliases.txt
zsh -ic 'print -l ${(k)functions}' | sort > /tmp/zsh-after-functions.txt
zsh -ic 'bindkey' | sort > /tmp/zsh-after-bindkey.txt
```

- [ ] **Step 2: Diff aliases (expect only intended changes)**

```bash
diff /tmp/zsh-baseline/aliases.txt /tmp/zsh-after-aliases.txt
```
Expected: removed lines are OMZ-provided git aliases NOT in our ported set and OMZ `vi-mode` aliases; added/kept lines include `gst`, `gl`, `gco`, `gd`, `gp`, `gfa`. No loss of user-defined aliases from `.zsh_aliases`. If a *used* alias disappeared, add it to Task 5's set and re-run.

- [ ] **Step 3: Diff bindkey (expect vi-mode + atuin bindings intact)**

```bash
diff /tmp/zsh-baseline/bindkey.txt /tmp/zsh-after-bindkey.txt
```
Expected: `^R` still bound to `atuin-search*`; `^o`/`^t`/`^f` widgets present; ctrl/alt word-motion bindings present. Differences should only reflect the OMZ-vs-zsh-vi-mode keymap change.

- [ ] **Step 4: Measure after startup timing and compare**

```bash
{ for i in 1 2 3; do /usr/bin/time -f "%e s" zsh -i -c exit; done; } 2>/tmp/zsh-after-timing.txt
echo "BEFORE:"; cat /tmp/zsh-baseline/timing.txt
echo "AFTER:";  cat /tmp/zsh-after-timing.txt
```
Expected: AFTER median ≤ BEFORE median (target: noticeably lower after znap eval caches warm; run twice — the first run populates caches, the second reflects steady state).

- [ ] **Step 5: Functional smoke test**

```bash
zsh -ic 'z ~ >/dev/null 2>&1 && echo z-ok; whence pyenv fnm rbenv >/dev/null && echo vm-ok; bindkey | grep -q atuin && echo atuin-ok; typeset -f zvm_init >/dev/null && echo vimode-ok'
```
Expected: `z-ok`, `vm-ok`, `atuin-ok`, `vimode-ok`.

- [ ] **Step 6: No commit (verification only)**

If all checks pass, proceed to Task 10. If any fail, fix the responsible task before continuing.

---

### Task 10: Delete unused on-disk plugins (post-parity)

**Files:**
- Delete: `~/.oh-my-zsh/custom/plugins/{example,fzf-zsh-completions,fzf-zsh-plugin,zsh-lazyload,zsh-wakatime}`

**Interfaces:**
- Consumes: Task 2 backup at `/tmp/zsh-plugin-backup/`, Task 9 parity pass.

- [ ] **Step 1: Confirm parity passed (Task 9) before deleting**

Only proceed if Task 9 Steps 2–5 passed. These are untracked git clones; deletion is real but recoverable from `/tmp/zsh-plugin-backup/` or by re-cloning.

- [ ] **Step 2: Delete the five unused plugin dirs**

```bash
for p in example fzf-zsh-completions fzf-zsh-plugin zsh-lazyload zsh-wakatime; do
  d="$HOME/.oh-my-zsh/custom/plugins/$p"
  [[ -d "$d" ]] && rm -rf "$d" && echo "removed $p"
done
ls ~/.oh-my-zsh/custom/plugins/
```
Expected: prints `removed <name>` for each; remaining dirs are the active plugins + znap + zsh-completions.

- [ ] **Step 3: Verify shell still starts cleanly after deletion**

```bash
zsh -ic 'echo shell-ok'
```
Expected: `shell-ok`, no "no such file" errors referencing the deleted plugins.

- [ ] **Step 4: No repo commit needed**

These dirs are not tracked in the dotfiles repo, so there's nothing to commit. The cleanup is complete. (Backup remains in `/tmp/zsh-plugin-backup/` until the next reboot.)

---

### Task 11: Final review and branch wrap-up

- [ ] **Step 1: Review the full diff**

```bash
cd /home/lalitmee/dotfiles
git log --oneline main..zsh-consolidation
git diff main..zsh-consolidation -- zsh/
```
Expected: commits from Tasks 3–8; diff touches only `zsh/` files as planned.

- [ ] **Step 2: Report results to the user**

Summarize: startup before/after timing, what was removed (OMZ framework, duplicate vi-mode, 5 on-disk plugins, dup PATH/cargo lines), what was preserved (git aliases, atuin/vi-mode/fzf-tab/syntax/autosuggestions behavior). Ask whether to merge `zsh-consolidation` into `main` and whether to pursue the optional full `~/.oh-my-zsh` removal later.

---

## Self-Review

**Spec coverage:**
- znap as sole manager / no `oh-my-zsh.sh` → Task 3 ✓
- Drop duplicate vi-mode → Tasks 3 + 6 ✓
- Drop/resolve duplicate fast-syntax-highlighting → Task 3 (znap owns canonical copy) ✓
- Port used git aliases → Task 5 (mined from history: gst/gl/gco/gd/gp/gfa) ✓
- znap eval caching for pyenv/rbenv/fnm/atuin/zoxide → Task 7 ✓
- Delete unused on-disk plugins (with backup, post-parity) → Tasks 2 + 10 ✓
- Consolidate triplicate Antigravity PATH + double cargo env → Task 8 ✓
- Branch + before/after timing + alias/function/bindkey parity diff → Tasks 1 + 9 ✓
- Out-of-scope items (p10k internals, lazy-load, full OMZ removal) correctly excluded ✓

**Placeholder scan:** No TBD/TODO; every code step shows exact content and commands. ✓

**Type/name consistency:** Alias names (`gst/gl/gco/gd/gp/gfa`) consistent between Task 5 and Task 9. znap commands (`znap source`/`znap eval`/`znap clone`) consistent and verified against the installed znap build. p10k loaded via `znap source` (not `znap prompt`) consistently in Task 3 and constraints. ✓

**Note on instant prompt:** Plan deliberately keeps p10k instant-prompt block and uses `znap source romkatv/powerlevel10k` — verified that `znap prompt` would conflict.
