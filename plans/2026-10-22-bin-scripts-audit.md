# bin/.config/bin audit — fix plan (2026-10-22)

Scope: 76 entries in `bin/.config/bin/`, audited on macOS 26 (arm64, zsh at `/bin/zsh`).
Method: read every script, ran each non-interactive one, probed missing deps and BSD vs GNU behaviour.

Result: **~45 of 76 misbehave on this machine**, but they collapse into five root causes.
Fixing categories beats patching 45 files.

| # | Root cause | Count | Fix shape |
|---|------------|-------|-----------|
| 1 | Linux-desktop-only stack (i3/sxhkd/polybar/PulseAudio/apt) | 20 | move to `linux/`, off PATH |
| 2 | GNU coreutils used on BSD (`shuf`, `xargs -d`, `find -printf`, `stat -c`, `sed -i`, 3-arg awk `match`) | 6 | portable rewrite (one-liners) |
| 3 | Hardcoded absolute paths (`/usr/bin/zsh`, `/usr/bin/peek.real`, `grealpath`, `/opt`) | 4 | `command -v` / `env` |
| 4 | Silent failure — no dep check, exits 0 with empty output | 5 | fail loudly or fix dep |
| 5 | Duplicate implementations that drifted | 10 | delete the dead/older copy |

## A. Broken on macOS (behaviour, not platform)

| Script | Symptom (verified) | Root cause |
|---|---|---|
| `quote` | prints nothing at every shell start | `shuf` absent → `selected_line=""` (quote:65) |
| `tsnv` | no-op, wired at tmux.conf.local:926 | `xargs -d` unsupported on BSD (tsnv:43) |
| `tmux-file-picker` | path/`-g` args yield empty list | `grealpath` absent, `--relative-to` call unguarded (tmux-file-picker:99-103, 187-197) |
| `make-exec` | never finds files | `find -printf` + `md5sum`; hash cache never rescans after chmod |
| `kitty-font` | edit fails | GNU `sed -i` on BSD sed |
| `check-keys` | rc=127 bad interpreter | shebang `/usr/bin/zsh` (does not exist on macOS) |
| `memory` | prints ` RAM` | `free` absent |
| `upt` | `illegal option -- pretty` | GNU `uptime --pretty` |
| `vol` | no-op | `amixer` absent (portable path exists: `osascript`) |
| `alert-battery` | exits 0 with empty output (silent) | reads `/sys/class/power_supply` |
| `battery-capacity` | rc=127 | same + `notify-send` |
| `delete-nvim-sessions` | exits immediately; deletes the sessions dir if `.` picked | `~/.local/share/nvim/sessions` missing; `find .` includes `.` |
| `peek` | prints "no such file", exits 0 | `/usr/bin/peek.real`, `stat -c %Y` |
| `emoji` | HTTP 403 | `git.io/JXXO7` retired |
| `howdoi`, `keep` | ModuleNotFoundError | pip shims, modules not installed |
| `install-deb` | dies at line 1 | sources broken symlink `utils.zsh` → Linux path; dpkg-only |
| `install-dots` | runs `.md` files with bash | `find … ! -name '*.sh' ! -name '*.zsh'` keeps README.md/TROUBLESHOOTING.md |
| `themer` | does nothing | stub: only echoes `gum choose` result |
| `vectorize-control` | dead | no consumer of `.vectorize-trigger`/`.vectorize-disable` in repo |
| `pomodoro-reset` | rc=127 | calls absent polybar script |
| `fzf-menu`, `fzfub` | unusable | `/proc/$$/fd` + kitty; ueberzug |
| `utils.zsh` (symlink) | broken | points to `/home/lalitmee/...` |

### Git family (8 files, 3 distinct bugs)

| Bug | Files | Detail |
|---|---|---|
| `git rev-parse HEAD` used as repo check | `git-branch`, `git-commit`, `git-stage`, `git-status`, `git-stash`, `git-tag`, `git-remote` (line 8 each) | rc=128 in any repo with no commits → "Not inside a git repository" |
| porcelain parsed by line/column | `git-status` (uses `--short`, takes `$NF`), `git-stage` (`${line:3}`) | `## main` header listed as a file (`status.branch=true`); `"a b.txt"` → `b.txt"`; `R  old -> new` mangled |
| argv executed as command | `git-merge-branch` | `main_branch="$(git symbolic-ref …)" "$@"` |
| no validation, destructive | `git-rename-branch` | renames + force-pushes + deletes remote old branch under `set -e` |

## B. Linux-desktop-only (20) → move to `linux/`

`auto-bluetooth-audio`, `pulsedevices`, `pulsevolctrl`, `select-mic`, `toggle-headset-profile`,
`dictate`, `dictate-whisper`, `dictate-process.py`, `i3info`, `lockscreen`, `peek`,
`peek-toggle-audio`, `sxhkd-cheatsheet`, `sxhkd-reload`, `test-noti`, `walls`,
`build-neovim`, `install-flutter`, `install-font`, `remove-apt-repository`,
`update-colorscripts`, `install-deb`, `pomodoro-reset`.

Kept and referenced by the Linux half of this repo (i3 autostart, sxhkd, polybar, systemd),
so delete is wrong — but they must leave macOS `PATH`.

## C. Redundant / duplicates

| Redundant | Superseded by | Action |
|---|---|---|
| `battery-capacity` | `alert-battery` | merge into one portable script |
| `gcmg` | `git-commit conventional` | delete |
| `git-branch-clean` | `git-branch delete` (fold in protected-branch filter) | delete |
| `git-status` (`stage` mode) | `git-stage stage` | delete |
| `git-status` (whole tool) | `git-stage --view` | merge, then delete |
| `git/.config/bin/{git-branch,git-commit,git-remote,git-stash,git-status,git-tag}.zsh` | `bin/.config/bin/git-*` | delete (stale, not on PATH) |
| `install-dots` | `install.sh` | delete |
| `stow-config` | `scripts/symlinks` + install phase 7 | delete |
| `gh-wrapper` | `/opt/homebrew/bin/gh` (PATH order) | delete |
| `howdoi`, `keep` | — (modules absent) | delete + drop `alias hi` |
| `vectorize-control` | — (no consumer) | delete |
| `themer`, `fzfub`, `fzf-menu` | — | delete |
| `utils.zsh` broken symlink | — | remove |

## Phases

### Phase 0 — wired scripts (highest user impact, ~45 min)
- [ ] `quote:65` → `awk 'BEGIN{srand()} {a[NR]=$0} END{if(NR) print a[int(rand()*NR)+1]}' "$file_path"`
- [ ] `tsnv:43` → zsh `while IFS=: read -r path line; do args+=("+$line" "$path"); done` then `nvim "${args[@]}"`
- [ ] `tmux-file-picker` → drop `realpath`/`grealpath`; relative path via `"${full#$base/}"`; keep `:A` for canonicalisation
- [ ] `memory` → `vm_stat` on Darwin, `free` on Linux
- [ ] `upt` → plain `uptime`
- [ ] `vol` → `osascript -e 'set volume output volume N'` on Darwin
- [ ] `alert-battery` + `battery-capacity` → one script: `pmset -g batt` (Darwin) / `/sys` (Linux); exit non-zero when it cannot read
- [ ] `delete-nvim-sessions` → create dir if missing, `find . -mindepth 1 -maxdepth 1`
- [ ] `check-keys` → `#!/usr/bin/env zsh`, gate `xev` behind Linux
- [ ] `kitty-font` → `sed -i.bak` (or `perl -pi -e`)
- [ ] `make-exec` → delete the hash cache; `find … ! -perm -u+x`
- [ ] remove `utils.zsh` symlink

### Phase 1 — git family (~2 h)
- [ ] all seven: `git rev-parse HEAD` → `git rev-parse --git-dir`
- [ ] `git-stage`: parse `git status --porcelain=v1 -z`; NUL-safe records; split renames on ` -> `; drop `2>/dev/null`
- [ ] `git-status`: add `--view`/`--diff` modes to `git-stage`, repoint `git-utils`, delete `git-status`
- [ ] `git-merge-branch`: assign `main_branch` first, then run `"$@"`; fix diff direction to `"$main_branch"...origin/"$main_branch"`
- [ ] `git-rename-branch`: require `$1`, confirm before push/delete
- [ ] fold `git-branch-clean` protection into `git-branch delete`; delete `git-branch-clean`
- [ ] delete `gcmg` and `git/.config/bin/*.zsh` six copies

### Phase 2 — platform split (~30 min)
- [ ] `mkdir bin/.config/bin/linux`; `git mv` the list in §B
- [ ] confirm nothing at root sources them; `git-utils`/tmux/zsh references are Linux-only
- [ ] Linux stow target gains `linux/` subdir (still same package, just off PATH on mac)

### Phase 3 — deletions (~20 min)
- [ ] §C delete list, one commit
- [ ] grep for remaining references: `rg -n 'gcmg|git-status|git-branch-clean|install-dots|stow-config|gh-wrapper|howdoi|themer|fzfub'`

### Phase 4 — guardrails (~1 h)
- [ ] `scripts/test/bin/smoke.zsh`: for each root-level script — interpreter exists, `zsh -n`/`bash -n` parses, no unguarded `shuf|pactl|notify-send|/sys/|grealpath|/usr/bin/zsh`
- [ ] focused tests: `quote` (non-empty), `tsnv` (tab parse), `tmux-file-picker` (path arg case), `make-exec` (idempotent), `git-status/stage` (fresh repo + space + rename)
- [ ] document in `scripts/test/README.md`

## Verify

```bash
zsh -n bin/.config/bin/*(.) 2>&1 | head
zsh scripts/test/bin/smoke.zsh
zsh scripts/test/tmux/file-picker.zsh
zsh scripts/test/bin/git/status-stage.zsh   # new
quote | head -1
```

Skipped: shared `lib.zsh` for dep checks (one smoke test covers the class), per-script platform guards (one directory move instead).
