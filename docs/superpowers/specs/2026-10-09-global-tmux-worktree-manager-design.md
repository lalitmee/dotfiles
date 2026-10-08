# Global tmux Worktree Manager Design

## Goal

Provide one tmux-native interface for discovering and managing Git worktrees registered by repositories inside `~/Projects`, including worktrees stored outside that directory. The manager supports the user's daily workflow of opening active worktrees, checking out a different branch in a worktree, renaming a worktree directory, and cleaning up completed worktrees.

## User constraints

- The manager is global across personal and work projects under `~/Projects`.
- Discovery is based on repositories under `~/Projects`, not on where each linked worktree directory lives.
- Do not modify or replace the existing Workmux command palette.
- Launch the manager using a new tmux key binding and a dedicated tmux window, not a popup.
- Keep operations scoped to the selected worktree's owning repository.

## Existing configuration

- `tmux/.tmux.conf.local` already has a `git-mode` entered with `C-a C-g`, per-repository Git worktree bindings, and Workmux dashboard and palette bindings.
- `tmux/.config/tmux/scripts/popup/workmux-palette.sh` has lifecycle actions, including open, remove, and rename, but gets worktrees from the repository associated with its current context.
- `tmux/.config/tmux/scripts/git/git-worktree.sh` also assumes the current directory is inside one repository.
- Neovim's `git-worktree.nvim` picker is likewise scoped to the current repository.
- Existing Workmux and Neovim flows should remain unchanged; the global manager is a separate entry point.

## Proposed interface

Add a new key in tmux `git-mode`. The binding creates or switches to a dedicated window named `worktree-manager`, running an interactive manager script. The manager stays in a normal tmux window so it can be revisited and does not cover the active window as a popup.

The manager shows a searchable list of discovered worktrees. Each row includes at least:

- `Work` or `Personal` grouping, derived from the repository's path relative to `~/Projects`;
- repository/project name;
- branch name, or detached state;
- worktree path;
- working-tree state (clean or modified/untracked), and whether the path exists.

The list is refreshed when the manager opens and after a successful mutation. Search applies across the whole list; grouping and context remain visible in each result. Empty, inaccessible, malformed, or stale repositories should be reported without hiding valid results.

## Discovery model

1. Traverse `~/Projects` and identify Git working directories, including normal repositories and linked worktrees whose `.git` entry is a file.
2. Resolve each candidate's Git common directory and deduplicate by that canonical identity, since multiple linked worktrees can expose the same repository registry.
3. For each unique repository, invoke `git worktree list --porcelain` from a known worktree in that repository.
4. Aggregate every registered worktree returned by Git, including paths outside `~/Projects`.
5. Parse porcelain records rather than human-formatted output. Preserve paths containing spaces and identify bare, detached, locked, prunable, and missing entries where Git reports them.
6. Determine status for existing worktrees with Git commands scoped to their path. A repository error is attached to that repository's results and does not abort the full scan.

The discovery layer should avoid recursively walking repository internals and common generated/dependency directories. Canonical paths should be used for identity and operations while display paths may retain a useful `~/Projects/...` form.

## Actions

### Open

Open the selected existing worktree in a new tmux window with its working directory set to the selected path. Give the window a useful, collision-safe name based on project and branch. The manager window remains available.

### Check out another branch in this worktree

Offer local and remote-tracking branches belonging to the selected repository. Check out through `git -C <worktree> switch ...`. Exclude or mark branches already checked out in another worktree of the same repository. Require an explicit confirmation when the selected worktree has modifications; Git errors remain visible and do not trigger force behavior. Checking out a remote-only branch should create a local tracking branch only after the user selects it.

### Rename worktree directory

Rename a linked worktree directory using Git's worktree-aware move operation, never a raw filesystem move. Preserve its current branch. The primary/main worktree is not eligible for this action. Prompt for a destination and reject existing paths. Refresh discovery after success.

Branch renaming is not part of the initial rename action. It has different repository-wide effects and can conflict with branches checked out in other worktrees.

### Remove worktree

Remove only the selected linked worktree through Git's worktree removal operation. Show the full path and status before confirmation. Refuse by default if there are tracked or untracked changes; offer a separate, explicit force path with a second confirmation. Never force-remove implicitly. Do not delete the associated branch as part of worktree removal. The main worktree cannot be removed by this manager.

### Refresh / quit

Provide a refresh action to rescan repositories and a direct quit action that returns to the tmux window the user came from.

## Error handling and safety

- All Git invocations use argument arrays or safe quoting; paths are never split on whitespace.
- Mutating actions revalidate the selected repository/worktree immediately before execution, since the list may be stale.
- Missing worktree paths and prunable registrations are shown as stale states. Pruning is not automatic; a separate prune action can be considered later.
- Dirty state includes untracked files. Normal removal is blocked if status cannot be determined.
- Refuse operations on the main worktree where Git does not support the requested operation.
- If an action fails, keep the manager usable and show the command's useful error output.
- The manager must not run the system installer or change existing Workmux behavior.

## Implementation shape

- Add a standalone script under `tmux/.config/tmux/scripts/` for discovery, selection, and actions.
- Add one non-conflicting binding in the existing `git-mode` section of `tmux/.tmux.conf.local` that launches or focuses the `worktree-manager` window.
- Update the existing git-mode help table with the new binding.
- Keep the first version self-contained and use the repository's existing terminal UI tools where suitable; do not add a new dependency without evidence it is needed.

## Initial acceptance criteria

- A single manager invocation lists registered worktrees from repositories under both `~/Projects/Personal` and `~/Projects/Work`.
- A worktree registered by one of those repositories appears even if its path is outside `~/Projects`.
- A repository with several linked worktrees is scanned once and each worktree is listed once.
- Paths containing spaces survive discovery and actions.
- The manager opens a selected worktree in its own tmux window.
- Branch checkout respects Git's one-worktree-per-branch rule and does not discard modifications silently.
- Rename uses Git's worktree-aware operation and preserves the checked-out branch.
- Removal refuses dirty worktrees unless the user takes the explicit force path, and does not delete the branch.
- The existing Workmux palette and existing per-repository worktree flows are unchanged.
- The new binding is documented in the git-mode help table and does not conflict with existing bindings.

## Out of scope for the first version

- Creating worktrees or branches (existing Workmux and Neovim flows already support creation).
- Renaming branches.
- Deleting branches, merging, rebasing, PR management, or agent lifecycle operations.
- Automatically pruning stale registrations.
- Persistent metadata, a database, or a background daemon.
- Modifying the existing Workmux palette.

## Decisions to confirm during implementation planning

- Exact key within `git-mode`, after checking the full table and its help view for conflicts.
- Whether the manager UI uses `fzf` actions or a dedicated `gum` menu, based on the available versions and existing interaction patterns.
- Whether to permit renaming a directory outside `~/Projects`; Git supports moving linked worktrees, but path policy should be explicit in the UI.
