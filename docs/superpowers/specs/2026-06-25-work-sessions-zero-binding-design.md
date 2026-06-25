# Work Sessions Zero Binding Design

Date: 2026-06-25
Status: Drafted after design approval

## Summary

Add a new `0` binding in the tmux `work-sessions` key table so `C-a C-w 0`
opens work sessions from a hard-coded file at `~/.work-sessions-dirs.txt`.

At the same time, reduce the exposed preset bindings in tmux config to `0..5`.
This is a UI change only. The underlying launcher script must continue to
support presets `1..9`.

## Current State

- The tmux work-sessions table is defined in
  `tmux/.tmux.conf.local`.
- The table currently exposes numeric bindings for `1..9`.
- Those bindings call `~/.config/tmux/scripts/work-sessions/work-sessions.sh`
  with the matching preset number.
- The launcher script already supports:
  - interactive preset picking
  - direct preset opening for `1..9`
  - file-backed preset loading via the existing preset config model
- The custom file `~/.work-sessions-dirs.txt` contains direct repository paths,
  one per line, with comments and blank lines mixed in.

## Goals

- Add a dedicated `0` binding in tmux for the custom file launcher.
- Make `0` read only from `~/.work-sessions-dirs.txt`.
- Keep the user workflow explicit: `C-a C-w 0` means "open repos from my custom
  list file".
- Keep tmux-exposed preset bindings limited to `0..5`.
- Preserve the existing script support for presets `6..9`.

## Non-Goals

- Do not migrate the custom file into `work-sessions.conf`.
- Do not remove or refactor script support for presets `6..9`.
- Do not change the existing preset config format.
- Do not change the work-sessions popup UI beyond the new `0` entry point.

## Design

### Tmux Binding Layer

Update `tmux/.tmux.conf.local` so the `work-sessions` table:

- adds `bind-key -T work-sessions 0 ... work-sessions.sh 0`
- retains bindings `1..5`
- removes bindings `6..9`

This keeps the visible key surface small while preserving backward-compatible
script support for direct CLI use or future bindings.

### Script Behavior

Update `tmux/.config/tmux/scripts/work-sessions/work-sessions.sh` to accept
`0` as a special command.

When invoked as `work-sessions.sh 0`, the script must:

- read `~/.work-sessions-dirs.txt`
- ignore comment lines and empty lines
- trim surrounding whitespace from each remaining line
- expand `~` to `$HOME`
- treat each remaining line as a direct repository directory path
- reuse the existing full-path session creation flow

This mode is intentionally hard-coded and separate from the preset config
system.

### Help Text

Update the script help output so it documents:

- `work-sessions.sh 0` as the custom file-based launcher
- `~/.work-sessions-dirs.txt` as the source file for that mode
- `work-sessions.sh <1-9>` continuing to represent the existing preset model

## Data Flow

For `C-a C-w 0`:

1. tmux enters the `work-sessions` table.
2. Pressing `0` launches `work-sessions.sh 0` in the existing popup flow.
3. The script loads repo paths from `~/.work-sessions-dirs.txt`.
4. Each valid path is treated as a candidate session directory.
5. The script creates missing tmux sessions and skips existing ones.
6. The client switches to the first resolved session, matching current
   launcher behavior.

For `C-a C-w 1..5`:

1. tmux launches the existing preset flow unchanged.
2. Parent-based presets still use `fzf`.
3. File-backed preset logic in the current config model remains intact.

## Error Handling

- If `~/.work-sessions-dirs.txt` is missing, the script should show a clear
  error and exit without creating sessions.
- Invalid or non-directory paths should be skipped rather than causing the
  whole run to fail.
- If no valid paths remain after filtering, the script should surface a clear
  "could not load" or "no repos selected" style message consistent with the
  current popup behavior.

## Testing

Verification should cover:

- tmux config reload succeeds
- `tmux list-keys -T work-sessions` shows `0..5` and no `6..9`
- `work-sessions.sh 0` parses `~/.work-sessions-dirs.txt` correctly
- comment and blank lines are ignored
- `~` expansion works
- existing `work-sessions.sh 1` behavior is unchanged
- script still accepts `6..9` from the command line

## Risks

- Adding `0` only in tmux config but not in script dispatch would create a dead
  binding, so both layers must be updated together.
- The custom file contains user-maintained paths, so invalid entries are
  expected and should be tolerated.
- Help text can drift from real behavior if the new mode is not documented.
