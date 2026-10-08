# Global tmux Worktree Manager Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Add a dedicated tmux window that discovers and manages every worktree registered by repositories under `~/Projects`.

**Architecture:** A standalone zsh manager scans Git repositories under `~/Projects`, deduplicates their shared Git common directories, and aggregates `git worktree list --porcelain -z` records. It presents them with fzf and dispatches Git operations against the selected worktree's owning repository. A new `git-mode` binding launches the manager in a `worktree-manager` window, leaving the existing Workmux palette and repository-local actions unchanged.

**Tech Stack:** zsh, Git worktree porcelain with `-z`, tmux, fzf, existing shell test conventions. The inspected environment has Git 2.43, tmux 3.7c, and fzf 0.59.

**Spec:** `docs/superpowers/specs/2026-10-09-global-tmux-worktree-manager-design.md`

## Global Constraints

- Discover repositories beneath `~/Projects`; include all worktrees registered by those repositories even when their paths are elsewhere.
- Do not modify or replace the existing Workmux palette.
- Launch from a new tmux key binding in a dedicated named window, not a popup.
- Keep Git operations scoped to the selected worktree's owning repository.
- Parse Git porcelain records and preserve spaces in paths.
- Normal removal refuses dirty worktrees; forced removal requires a separate explicit confirmation.
- Worktree removal never deletes its branch.
- Do not auto-prune stale registrations or run the system installer.

## Review Focus

- A linked worktree and its main repository both appear under `~/Projects`: deduplicate by canonical Git common directory and list each worktree once.
- A linked worktree lives outside `~/Projects`: include it based on the in-scope repository's registry.
- Repository and worktree paths contain spaces: preserve record boundaries through scan, selection, and actions.
- A branch is already checked out in another worktree: prevent checkout and explain the conflict.
- A selected worktree is dirty or its path disappeared after discovery: revalidate and refuse unsafe or unverifiable removal.

---

## File Structure

- Create `tmux/.config/tmux/scripts/worktree-manager.sh` as the user-facing zsh entry point. It owns the interactive loop, fzf key/action dispatch, prompts, and tmux window actions.
- Create `tmux/.config/tmux/scripts/lib/worktree-manager/discovery.zsh` for repository discovery, common-directory deduplication, porcelain parsing, branch availability, and worktree status records.
- Create `tmux/.config/tmux/scripts/lib/worktree-manager/actions.zsh` for open, checkout, move, remove, and revalidation functions. Each Git command receives explicit repository and worktree paths.
- Modify `tmux/.tmux.conf.local` to add an unused `git-mode` key and launch or focus a window named `worktree-manager`.
- Modify `tmux/.config/tmux/scripts/popup/help/tables/git-mode.txt` to document the binding.
- Create `scripts/test/test_global_worktree_manager.zsh` following the existing zsh fixture and mock conventions.

## Task 1: Build and verify global discovery

**Files:**
- Create: `tmux/.config/tmux/scripts/lib/worktree-manager/discovery.zsh`
- Create: `scripts/test/test_global_worktree_manager.zsh`

**Interfaces:**
- `discover_worktrees <projects_root>` emits a NUL-delimited stream of fields in a stable schema: `repo_root`, `repo_group`, `repo_name`, `worktree_path`, `branch`, `state_flags`, `dirty_state`, repeated for each worktree. `state_flags` includes `main`, `detached`, `locked`, `prunable`, or `bare` as applicable; an empty branch denotes detached HEAD.
- `parse_worktree_porcelain <repo_root> <porcelain_file>` emits the same stream for one repository. The file argument exists to make parsing testable without mocking Git output.
- `worktree_status <worktree_path>` prints `clean`, `dirty`, `missing`, or `unknown`.
- The manager reads NUL-delimited fields into zsh arrays and gives fzf a line-based display containing only a numeric row ID and human-readable fields. fzf returns the row ID; the manager uses it to retrieve the original path without parsing display text.

- [ ] **Step 1: Create isolated Git fixtures and failing discovery checks.** Build temporary `Personal` and `Work` directories with two repositories, a linked worktree under a path containing spaces outside the fixture root, and a nested linked-worktree candidate. Assert each registry's entries appear once, the external path is present, and group/project/branch fields are correct.
- [ ] **Step 2: Add porcelain parser fixtures.** Cover attached, detached, locked, prunable, and bare records; paths with spaces; empty input; and malformed/incomplete records. Assert malformed records are skipped with an error recorded for their repository rather than terminating the entire scan.
- [ ] **Step 3: Run the focused discovery test.** Run `zsh scripts/test/test_global_worktree_manager.zsh discovery`; confirm the new assertions fail before implementation.
- [ ] **Step 4: Implement traversal and deduplication.** Walk `~/Projects` while pruning `.git`, `node_modules`, and common generated directories; identify `.git` directories and files; resolve candidates through `git -C <candidate> rev-parse --path-format=absolute --git-common-dir`; canonicalize and deduplicate common directories.
- [ ] **Step 5: Implement porcelain aggregation.** For each unique repository, run `git -C <candidate> worktree list --porcelain -z`, parse records without line splitting, and retain every registered path. Preserve Git's detached, locked, prunable, and bare metadata; mark the main worktree by comparing its canonical path with `git -C <candidate> rev-parse --show-toplevel`.
- [ ] **Step 6: Implement status collection and repository-level errors.** Use `git -C <worktree> status --porcelain --untracked-files=normal`; classify empty as clean and non-empty as dirty. Missing paths are `missing`; command errors are `unknown`. Continue scanning remaining repositories after per-repository failures.
- [ ] **Step 7: Re-run discovery checks.** Run `zsh scripts/test/test_global_worktree_manager.zsh discovery`; confirm all fixture assertions pass, including external paths and deduplication.

## Task 2: Implement interactive worktree actions

**Files:**
- Create: `tmux/.config/tmux/scripts/lib/worktree-manager/actions.zsh`
- Modify: `tmux/.config/tmux/scripts/lib/worktree-manager/discovery.zsh`
- Modify: `scripts/test/test_global_worktree_manager.zsh`

**Interfaces:**
- `open_worktree <worktree_path> <repo_name> <branch>` asks tmux to open a collision-safe named window rooted at the worktree.
- `list_repository_branches <repo_root>` returns local and remote-tracking branch records with an `occupied_by` path when another worktree has that branch checked out.
- `checkout_branch <repo_root> <worktree_path> <branch_ref> <create_tracking>` revalidates status and branch occupancy before invoking `git -C <worktree_path> switch`.
- `rename_worktree <repo_root> <worktree_path> <destination>` revalidates that the selected path is a linked worktree and invokes `git -C <repo_root> worktree move`.
- `remove_worktree <repo_root> <worktree_path> <force>` revalidates dirty/missing/main-worktree state and invokes normal or force removal only after the UI confirms the matching action.

- [ ] **Step 1: Add action tests and command mocks.** Assert every Git mutation receives explicit `-C` paths and arguments; test occupied-branch rejection, tracking-branch selection, main-worktree rejection for move/remove, destination-exists rejection, dirty-state block, force confirmation gating, and no branch deletion.
- [ ] **Step 2: Run the focused action checks.** Run `zsh scripts/test/test_global_worktree_manager.zsh actions`; confirm expected failures before implementation.
- [ ] **Step 3: Implement branch inventory and occupancy mapping.** Read local and remote-tracking refs using `git for-each-ref` and map checked-out branches from the repository's porcelain worktree list. Do not offer occupied branches as checkout targets.
- [ ] **Step 4: Implement checkout, move, and removal functions.** Use argument-safe command invocations; refuse unknown status; require the caller to pass a force flag only after its second confirmation; never remove a branch.
- [ ] **Step 5: Implement tmux open behavior.** Create a new window targeting the selected path, named from project plus branch; detect and disambiguate existing window names. Keep the manager window alive while opening the worktree window.
- [ ] **Step 6: Re-run focused action checks.** Run `zsh scripts/test/test_global_worktree_manager.zsh actions`; confirm all action checks pass.

## Task 3: Add the manager interface and tmux integration

**Files:**
- Create: `tmux/.config/tmux/scripts/worktree-manager.sh`
- Modify: `tmux/.tmux.conf.local`
- Modify: `tmux/.config/tmux/scripts/popup/help/tables/git-mode.txt`
- Modify: `scripts/test/test_global_worktree_manager.zsh`

**Interfaces:**
- `worktree-manager.sh [--projects-root <path>]` sources discovery and actions, then runs the manager against `~/Projects` by default. The optional root is for isolated fixture use.
- fzf receives newline-delimited display rows prefixed by numeric IDs. Only the selected numeric ID is parsed; all filesystem paths remain in the manager's arrays. Action keys are `enter` open, `ctrl-b` checkout branch, `ctrl-r` rename directory, `ctrl-d` remove, `ctrl-f` refresh, and `esc`/`ctrl-c` quit.

- [ ] **Step 1: Add interface behavior checks.** Verify empty inventory, list formatting, exact selected record recovery, cancellation, refresh, and each action dispatch using mock fzf/tmux/Git commands.
- [ ] **Step 2: Run the focused interface checks.** Run `zsh scripts/test/test_global_worktree_manager.zsh interface`; confirm expected failures before implementation.
- [ ] **Step 3: Implement fzf presentation and action loop.** Read NUL-delimited fields into zsh arrays; show group, repository, branch, status, and path on one fzf display row prefixed by a numeric ID. Resolve the returned ID back to the arrays instead of parsing paths from display text. Keep the manager usable after failed actions and refresh the inventory after successful mutations.
- [ ] **Step 4: Add prompts and safety copy.** Show exact path and status for move/remove; require typed or explicit confirmation for removal, and an additional distinct confirmation for force removal. For checkout on a dirty worktree, require confirmation and still let Git refuse conflicts without force options.
- [ ] **Step 5: Add tmux binding and help.** Use the unused `m` key in `git-mode`; focus an existing `worktree-manager` window in the current session if one exists, otherwise create it with `new-window -n worktree-manager -c ~/Projects`. Add `m` to the help table. Do not edit the Workmux palette.
- [ ] **Step 6: Re-run all focused manager checks.** Run `zsh scripts/test/test_global_worktree_manager.zsh`; confirm discovery, actions, and interface checks pass.
- [ ] **Step 7: Review the final diff and configuration references.** Confirm the only product changes are the new manager script/library, tmux binding, help entry, and focused test file; check key conflicts and verify shell syntax.

## Execution Notes

- The repository guidance says not to auto-commit; commits are excluded unless the user requests them.
- Never run `./install.sh` or the main installer.
- Implementation should preserve the current tmux session's window context when the manager is quit and leave the existing Workmux palette untouched.
- Verify the installed Git's `worktree list --porcelain -z` support before implementation; Git 2.43 in the inspected environment advertises this option. If older Git must be supported, establish a minimum version or add a tested parser for its quoted porcelain output before coding the fallback.
