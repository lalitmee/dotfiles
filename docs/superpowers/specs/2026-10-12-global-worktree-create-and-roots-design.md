# Global Worktree Creation and Configurable Roots

## Goal

Extend the existing global tmux worktree manager so it can create worktrees in any configured repository root, while preserving its custom Git workflow and keeping Workmux completely separate.

## User intent

- Keep the manager's existing custom discovery and lifecycle actions; do not add a custom/Workmux backend toggle or integrate Workmux.
- Support creation from a global picker, including repositories whose main worktrees are normally hidden from the manager list.
- Make the directories scanned by the manager configurable so `~/dotfiles` and other locations can be included alongside `~/Projects`.
- Reuse the existing custom `git-worktree.sh create` flow and its `worktree-create.sh` worker rather than duplicating creation and provisioning logic.

## Existing behavior and constraints

- `tmux/.config/tmux/scripts/worktree-manager.sh` scans one projects root, displays linked worktrees by default, and can toggle main worktrees with `ctrl-t`.
- `tmux/.config/tmux/scripts/lib/worktree-manager/discovery.zsh` discovers repositories beneath a root and emits each repository's registered worktrees, including linked worktrees outside the scanned root.
- The existing manager's selection fields identify each row's owning/main repository root.
- `tmux/.config/tmux/scripts/git/git-worktree.sh create` provides the custom interactive creation flow and launches `git/workers/worktree-create.sh`, which creates the worktree, copies configured project files, sets Git identity, and starts dependency setup.
- Existing lifecycle actions and the Workmux palette remain unchanged.

## Configuration

- Add `$XDG_CONFIG_HOME/worktree-manager/roots` as the user-level configuration file (defaulting to `~/.config/worktree-manager/roots`) containing scan roots, one path per line. Blank lines and comment lines beginning with `#` are ignored.
- Expand `~` and resolve relative paths against the user's home directory; ignore duplicate canonical roots. Missing or inaccessible roots should produce a useful diagnostic without preventing valid roots from being scanned.
- When no configuration file exists, retain `~/Projects` as the default root. An existing but empty file means no roots are configured; it does not silently restore the default.
- Users can add `~/dotfiles` and any other desired directories to the file. The manager aggregates discoveries across configured roots and deduplicates repositories/worktrees already found through another root.
- Keep the configuration location and parsing behavior local to the manager; do not change the global installer or unrelated dotfile configuration.

## Creation flow

- Add a manager key binding for “create worktree.” It opens a dedicated tmux window rather than a popup, so the manager remains available and the repository picker has a normal terminal.
- Bind a dedicated non-navigation key in the manager's fzf picker for this action. Do not use `ctrl-n` or `ctrl-p`, which fzf uses for moving through results; verify the chosen key against the active fzf bindings before implementation. Keep the existing `git-mode` bindings unchanged.
- The creation window scans configured roots and presents an fzf picker containing main worktrees (repositories) only. This is independent of the normal list's main-worktree visibility toggle.
- Selecting a main worktree changes the creation window's working directory to that repository and launches the existing custom `git-worktree.sh create` flow there. That flow remains responsible for branch/base/folder prompts and opens its worker window via `worktree-create.sh` as it does today; do not add another intermediate window.
- Preserve paths with spaces and shell metacharacters by passing arguments safely; do not construct an unquoted command string from picker output.
- Cancelling repository selection returns cleanly without creating anything. Creation errors remain visible in the creation window. After successful creation, the global manager's next scan/refresh includes the new worktree.

## Existing manager behavior

- Keep main worktrees hidden by default in the regular worktree list; retain the existing main visibility toggle.
- Keep current open, checkout, rename, and remove semantics and safety checks unchanged.
- Do not alter `workmux-palette.sh`, Workmux configuration, or existing Workmux behavior.

## Testing and acceptance criteria

- A missing config uses `~/Projects`; configured roots include `~/dotfiles` and multiple additional directories.
- Blank/comment lines, duplicate roots, home expansion, paths containing spaces, and missing roots are handled safely.
- Discovery aggregates roots without duplicating a repository/worktree that is reachable through overlapping roots; deduplication uses the canonical Git common-directory identity across the combined scan.
- The normal manager still hides main worktrees by default and its toggle still works.
- The create picker includes main worktrees from all configured roots, independently of the regular-list toggle, and excludes linked worktrees as repository choices.
- The manager opens one dedicated repository-picker window; selecting a repository launches the existing custom create flow from it, preserving its path safely and without an extra intermediate window.
- Cancelling selection launches no creation command; all existing manager tests continue to pass.
- No Workmux calls or behavior are introduced.

## Out of scope

- Replacing custom manager lifecycle actions with Workmux or adding a backend toggle.
- Reimplementing the existing create prompts or worker provisioning.
- Changing the existing per-repository `git-worktree.sh` workflow beyond invoking it from the global manager.
- Adding automatic directory watching, persistent discovery state, or unrelated manager UI changes.
