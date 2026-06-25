# Work Sessions Zero Binding Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Add a hard-coded `0` launcher for `~/.work-sessions-dirs.txt` in the tmux `work-sessions` table while reducing the visible tmux preset bindings to `0..5` and keeping script support for `1..9`.

**Architecture:** The change stays inside the existing tmux work-sessions entrypoints. `tmux/.tmux.conf.local` will expose a new `0` binding and trim visible bindings after `5`, while `work-sessions.sh` gets a dedicated `0` dispatch path that reads `~/.work-sessions-dirs.txt` as a direct repo list and reuses the script's current full-path session creation flow. The help table and script help output must be updated so the on-screen keymap matches reality.

**Tech Stack:** tmux config, Zsh script, fzf-based popup workflow, plain text help table

---

### Task 1: Update tmux work-sessions bindings and help copy

**Files:**
- Modify: `tmux/.tmux.conf.local:1544-1570`
- Modify: `tmux/.config/tmux/scripts/popup/help/tables/work-sessions.txt:1-8`

- [ ] **Step 1: Capture the current work-sessions keymap and help text**

Run:

```bash
sed -n '1538,1605p' tmux/.tmux.conf.local
sed -n '1,40p' tmux/.config/tmux/scripts/popup/help/tables/work-sessions.txt
```

Expected:
- `tmux/.tmux.conf.local` shows numeric bindings `1` through `9`
- the help table still lists the current launcher labels and does not mention `0`

- [ ] **Step 2: Edit the tmux binding block to expose only `0..5`**

Apply this shape in `tmux/.tmux.conf.local`:

```tmux
# Custom file-based launcher
bind-key -T work-sessions 0 display-popup -E -w 80% -h 80% "~/.config/tmux/scripts/work-sessions/work-sessions.sh 0"

# Preset 1: Work Github
bind-key -T work-sessions 1 display-popup -E -w 80% -h 80% "~/.config/tmux/scripts/work-sessions/work-sessions.sh 1"

# Preset 2: Personal Github
bind-key -T work-sessions 2 display-popup -E -w 80% -h 80% "~/.config/tmux/scripts/work-sessions/work-sessions.sh 2"

# Preset 3: All Projects
bind-key -T work-sessions 3 display-popup -E -w 80% -h 80% "~/.config/tmux/scripts/work-sessions/work-sessions.sh 3"

# Preset 4-5: Available for customization
bind-key -T work-sessions 4 display-popup -E -w 80% -h 80% "~/.config/tmux/scripts/work-sessions/work-sessions.sh 4"
bind-key -T work-sessions 5 display-popup -E -w 80% -h 80% "~/.config/tmux/scripts/work-sessions/work-sessions.sh 5"
```

Requirements:
- add a comment that makes `0` clearly special-purpose
- remove bindings `6`, `7`, `8`, and `9`
- do not alter `p`, `l`, `k`, `q`, or `?`

- [ ] **Step 3: Update the work-sessions help table so it matches the keymap**

Replace the stale top rows in `tmux/.config/tmux/scripts/popup/help/tables/work-sessions.txt` with:

```text
Key	Description
0	Open custom repo list from ~/.work-sessions-dirs.txt
1	Open Preset 1: Work Github (fzf picker)
2	Open Preset 2: Custom Dirs (file based)
3	Open Preset 3: Personal Github (fzf picker)
4	Open Preset 4 (configured preset)
5	Open Preset 5 (configured preset)
p	Pick preset (interactive)
l	List existing sessions
k	Kill sessions (multi-select)
q	Quit work-sessions mode
?	Show this help
```

Constraint:
- keep the table format as tab-separated plain text

- [ ] **Step 4: Reload tmux and verify the live keymap**

Run:

```bash
tmux source-file ~/.config/tmux/.tmux.conf
tmux list-keys -T work-sessions
```

Expected:
- reload succeeds with no tmux parse errors
- `list-keys` shows bindings for `0`, `1`, `2`, `3`, `4`, `5`
- `list-keys` does not show bindings for `6`, `7`, `8`, or `9`

- [ ] **Step 5: Commit the binding/help sync**

```bash
git add tmux/.tmux.conf.local tmux/.config/tmux/scripts/popup/help/tables/work-sessions.txt
git commit -m "fix(tmux): add work-sessions zero launcher"
```

### Task 2: Add hard-coded `0` mode to the work-sessions launcher script

**Files:**
- Modify: `tmux/.config/tmux/scripts/work-sessions/work-sessions.sh:1-260`

- [ ] **Step 1: Snapshot the script entrypoints before changing behavior**

Run:

```bash
sed -n '1,260p' tmux/.config/tmux/scripts/work-sessions/work-sessions.sh
```

Expected:
- usage text mentions direct preset opening only for `1-9`
- the `case` dispatch only accepts `[1-9]`
- file-based path loading is currently tied to the preset config model

- [ ] **Step 2: Add dedicated constants and a helper for the custom file list**

Insert near the top of `work-sessions.sh`:

```zsh
CUSTOM_DIRS_FILE="$HOME/.work-sessions-dirs.txt"

read_custom_dirs_file() {
    if [[ ! -f "$CUSTOM_DIRS_FILE" ]]; then
        echo "Error: File not found at $CUSTOM_DIRS_FILE" >&2
        debug_log "read_custom_dirs_file: ERROR - File not found: $CUSTOM_DIRS_FILE"
        return 1
    fi

    while IFS= read -r path; do
        [[ "$path" =~ ^[[:space:]]*# ]] && continue
        [[ -z "${path// }" ]] && continue
        path="${path#"${path%%[![:space:]]*}"}"
        path="${path%"${path##*[![:space:]]}"}"
        [[ -z "$path" ]] && continue
        echo "${path/#\~/$HOME}"
    done < "$CUSTOM_DIRS_FILE"
}
```

Requirements:
- preserve the current comment/blank-line filtering semantics
- expand `~` before returning paths
- log missing-file failures through `debug_log`

- [ ] **Step 3: Extract or reuse the full-path session creation flow for `0`**

Refactor the existing "full paths" branch from `open_preset()` into a helper so both preset-file mode and custom-file mode can use the same logic:

```zsh
create_sessions_from_full_paths() {
    local selected_dirs="$1"
    local first_session=""
    local created_count=0

    while IFS= read -r full_path; do
        [[ -z "$full_path" ]] && continue
        [[ "$full_path" == \[* ]] && continue
        full_path="${full_path/#\~/$HOME}"

        if [[ -d "$full_path" ]]; then
            local session_name="$(basename "$full_path")"
            if tmux has-session -t "$session_name" 2>/dev/null; then
                echo "Skipping (exists): $session_name"
            else
                if tmux new-session -ds "$session_name" -c "$full_path" 2>/dev/null; then
                    echo "Created: $session_name"
                    created_count=$((created_count + 1))
                fi
            fi
            if [[ -z "$first_session" ]]; then
                first_session="$session_name"
            fi
        fi
    done <<< "$selected_dirs"

    if [[ -n "$first_session" ]]; then
        echo "Switching to: $first_session"
        tmux switch-client -t "$first_session"
    fi

    echo "Done. Created $created_count session(s)"
}
```

Requirements:
- keep the current session naming rule: basename of the repo path
- skip invalid directories instead of failing the whole run
- leave the single-parent preset path unchanged

- [ ] **Step 4: Add an `open_custom_dirs_file` command path**

Add a dedicated function:

```zsh
open_custom_dirs_file() {
    local selected_dirs
    selected_dirs="$(read_custom_dirs_file)"

    if [[ -z "$selected_dirs" ]]; then
        echo "Error: Could not load custom dirs from $CUSTOM_DIRS_FILE"
        read -p "Press Enter to close..."
        return 1
    fi

    create_sessions_from_full_paths "$selected_dirs"
}
```

Requirements:
- the custom mode should not invoke `load_config`
- the custom mode should not open `fzf`
- the popup should remain open on failure using the script's current prompt pattern

- [ ] **Step 5: Extend the usage text and main dispatch to accept `0`**

Update the usage/help block and the `main()` case so it includes:

```zsh
#   work-sessions.sh 0                # Open custom repo list from ~/.work-sessions-dirs.txt
#   work-sessions.sh <preset_num>     # Open preset directly (1-9)
```

and:

```zsh
    case "$cmd" in
        --help|-h)
            show_help
            ;;
        --list|-l)
            list_presets
            ;;
        --kill|-k)
            kill_work_session
            ;;
        0)
            open_custom_dirs_file
            ;;
        [1-9])
            open_preset "$cmd"
            ;;
```

Also update `show_help()` to include:

```text
    work-sessions.sh 0           Open repos from ~/.work-sessions-dirs.txt
    work-sessions.sh <1-9>       Open preset directly
```

- [ ] **Step 6: Run script-level verification for the new mode and regression coverage**

Run:

```bash
zsh -n tmux/.config/tmux/scripts/work-sessions/work-sessions.sh
tmux/.config/tmux/scripts/work-sessions/work-sessions.sh --help
tmux/.config/tmux/scripts/work-sessions/work-sessions.sh --list
tmux/.config/tmux/scripts/work-sessions/work-sessions.sh 0
tmux/.config/tmux/scripts/work-sessions/work-sessions.sh 6
```

Expected:
- `zsh -n` returns no syntax errors
- help output mentions `0` and `~/.work-sessions-dirs.txt`
- `--list` still reports the configured presets
- `0` reads from `~/.work-sessions-dirs.txt`, creates/skips sessions, and switches to the first valid session
- `6` still reaches the numbered preset path instead of being rejected by the dispatcher

- [ ] **Step 7: Re-verify the live tmux binding launches the new mode**

Run:

```bash
tmux source-file ~/.config/tmux/.tmux.conf
tmux list-keys -T work-sessions | rg 'work-sessions\\.sh 0|work-sessions\\.sh [1-5]'
```

Expected:
- the `0` binding points at `work-sessions.sh 0`
- only `1` through `5` appear as numeric preset launchers in the live table

- [ ] **Step 8: Commit the script support**

```bash
git add tmux/.config/tmux/scripts/work-sessions/work-sessions.sh
git commit -m "fix(tmux): support custom work-sessions file"
```

### Task 3: Final verification and handoff

**Files:**
- Review: `tmux/.tmux.conf.local`
- Review: `tmux/.config/tmux/scripts/work-sessions/work-sessions.sh`
- Review: `tmux/.config/tmux/scripts/popup/help/tables/work-sessions.txt`

- [ ] **Step 1: Review the final diff**

Run:

```bash
git diff -- tmux/.tmux.conf.local tmux/.config/tmux/scripts/work-sessions/work-sessions.sh tmux/.config/tmux/scripts/popup/help/tables/work-sessions.txt
```

Expected:
- diff contains only the `0` launcher, numeric binding trim to `5`, script support for `0`, and help text sync

- [ ] **Step 2: Verify no accidental regressions in the work-sessions surface**

Run:

```bash
tmux/.config/tmux/scripts/work-sessions/work-sessions.sh --help
tmux/.config/tmux/scripts/work-sessions/work-sessions.sh --list
tmux list-keys -T work-sessions
```

Expected:
- help and live bindings describe the same numeric surface
- `--list` still represents the configured preset model
- no binding exists for `6..9` in tmux even though the script still supports those preset numbers

- [ ] **Step 3: Prepare the user-facing verification summary**

Record:

```text
- `C-a C-w 0` now reads ~/.work-sessions-dirs.txt directly
- tmux only exposes numeric bindings 0..5
- work-sessions.sh still accepts 6..9 from the command line
- help text matches the live keymap
```

- [ ] **Step 4: Commit any final sync adjustments if needed**

```bash
git add tmux/.tmux.conf.local tmux/.config/tmux/scripts/work-sessions/work-sessions.sh tmux/.config/tmux/scripts/popup/help/tables/work-sessions.txt
git commit -m "docs(tmux): sync work-sessions help"
```

Only do this step if Task 3 introduced additional file changes after the earlier commits.
