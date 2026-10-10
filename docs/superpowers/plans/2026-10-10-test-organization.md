# Script Test Organization Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Organize script tests by tool/subsystem, use concise behavior-focused names, and document the mapping from each test to its target and behavior.

**Architecture:** Keep `scripts/test/` as the test root, grouping test entry points under focused subsystem directories (`tmux/`, `bin/`, `config/`, `security/`, `install/`). Keep a single top-level README as the index and clearly distinguish executable tests from support harnesses, validators, and fixtures.

**Tech Stack:** Existing Zsh, Bash, and Python scripts; Markdown; shell filesystem operations. No new dependencies or test framework.

**Spec:** `docs/superpowers/specs/2026-10-10-test-organization-design.md`

## Global Constraints

- “Preserve test logic and behavior during path/name changes.”
- “Search for and update active references in project instructions and current documentation/plans.”
- “Leave historical/archive references alone unless they remain operational instructions.”
- “Do not touch unrelated existing worktree changes.”
- “Do not add a framework, generic runner, or abstraction unless discovery during planning demonstrates a concrete need.”
- Do not run the interactive installer; Docker install checks are optional and only run when practical.

## Review Focus

- A moved test may leave stale invocations in current docs/plans; search old paths across the repository after moves.
- A grouped directory may make a test ambiguous when the same tool has multiple behaviors; index each behavior and exact command separately.
- A multi-mode suite may be incorrectly split and change its behavior; preserve `test_global_worktree_manager.zsh`'s `discovery`, `actions`, and `interface` modes when relocating it.
- Validators and harnesses may be mistaken for tests; explicitly classify each in the README and retain their standalone invocations.
- Existing local edits may be overwritten by broad moves or cleanup; inspect status and diffs before editing and preserve all unrelated modifications.

---

## File Structure

| Current path | Planned path | Responsibility |
|---|---|---|
| `scripts/test/test_global_worktree_manager.zsh` | `scripts/test/tmux/worktree/manager.zsh` | Global worktree manager discovery/actions/interface modes |
| `scripts/test/test_worktree_deps.zsh` | `scripts/test/tmux/worktree/dependencies.zsh` | Worktree dependency detection and launch behavior |
| `scripts/test/test_worktree_js_flows.zsh` | `scripts/test/tmux/worktree/flows.zsh` | Git worktree command flows |
| `scripts/test/test_worktree_setup_runner.zsh` | `scripts/test/tmux/worktree/setup-runner.zsh` | Worktree setup runner success/failure behavior |
| `scripts/test/test_workmux_palette.zsh` | `scripts/test/tmux/workmux/palette.zsh` | Workmux palette behavior |
| `scripts/test/test_file_picker.zsh` | `scripts/test/tmux/file-picker.zsh` | Tmux file-picker argument handling |
| `scripts/test/test_install_tmux.zsh` | `scripts/test/tmux/install.zsh` | Tmux installer behavior |
| `scripts/test/test_check_tmux_update.zsh` | `scripts/test/tmux/update-check.zsh` | Tmux update checker behavior |
| `scripts/test/test-auto-bluetooth-audio.zsh` | `scripts/test/bin/bluetooth/audio-selection.zsh` | Bluetooth audio sink selection |
| `scripts/test/test_git_email_guard.zsh` | `scripts/test/bin/git/email-guard.zsh` | Git email guard behavior |
| `scripts/test/verify_settings.sh` | `scripts/test/config/settings.sh` | Settings configuration validation |
| `scripts/test/verify_linear_mcp.sh` | `scripts/test/config/linear-mcp.sh` | Linear MCP configuration validation |
| `scripts/test/gitleaks_precommit_test.py` | `scripts/test/security/gitleaks-precommit.py` | Gitleaks/pre-commit fixture checks |
| `scripts/test/docker-test.sh` | `scripts/test/install/docker.sh` | Docker-based installation test harness |
| `scripts/test/verify-installation.sh` | `scripts/test/install/verify.sh` | Installed environment validation |
| `scripts/test/test-home` | `scripts/test/fixtures/test-home` | Test fixture data, not an executable test |
| `scripts/test/README.md` | unchanged | Catalog, classifications, and Docker harness guidance |

Do not split the global worktree manager suite or change its behavior. Keep the Docker README guidance and update its command examples to the relocated harness. Preserve helper script executable bits. This plan’s names are explicit; if repository inspection shows a destination collision, stop and revise the plan rather than silently choosing another name.

## Tasks

### Task 1: Relocate tmux tests

**Files:**
- Move the eight test scripts in the `tmux/` rows of the file map to their planned paths.
- Modify active references to those paths in `AGENTS.md`, docs, and current plans.

- [ ] **Step 1: Record baseline and inspect current references.** Check `git status --short`, `git diff -- scripts/test/test_global_worktree_manager.zsh`, and search for each old path in active instructions/docs/plans. Preserve the existing user modification to `test_global_worktree_manager.zsh`.
- [ ] **Step 2: Move the files without editing their contents.** Use `git mv` for the eight paths. Expected: each script exists at its destination with its original content and executable mode.
- [ ] **Step 3: Update active path references.** Update only current operational documentation and plans found in Step 1; leave archived/historical material alone unless it contains live instructions.
- [ ] **Step 4: Run the relocated tests.** Run each script by its new path, including the manager default/all mode and each supported mode (`discovery`, `actions`, `interface`). Expected: same pass/fail behavior as before relocation.

### Task 2: Relocate bin tests

**Files:**
- Move `test-auto-bluetooth-audio.zsh` and `test_git_email_guard.zsh` to the `bin/` destinations in the file map.
- Modify active references to those paths, if any.

- [ ] **Step 1: Search for old paths.** Find references to both source paths; classify each as active or historical.
- [ ] **Step 2: Move the two scripts unchanged.** Use `git mv`; preserve executable bits.
- [ ] **Step 3: Update active references.** Do not rewrite archival examples unless they remain operational guidance.
- [ ] **Step 4: Run both relocated scripts.** Expected: each exits successfully and reports its existing success result.

### Task 3: Classify support files and complete the index

**Files:**
- Move validators, security fixture test, Docker harness, and fixture data to the planned destinations in the file map.
- Modify `scripts/test/README.md`.
- Modify active references found in Task 1/2 searches and a fresh whole-repository search.

- [ ] **Step 1: Search all old paths and classify references.** Include README examples, `AGENTS.md`, docs/plans, and repository scripts. Treat `scripts/test/README.md`'s Docker invocations as active.
- [ ] **Step 2: Move support files unchanged.** Relocate the two validators, Gitleaks test, Docker harness, installation verifier, and `test-home` fixture to the mapped paths; preserve modes and data.
- [ ] **Step 3: Update active references.** Update references to moved files in `AGENTS.md`, current docs/plans, and all runnable commands; retain intentional historical/archive references.
- [ ] **Step 4: Write the README catalog.** For every focused test, include target tool, behavior, and exact command. Add separate sections for validators, the Docker install harness, and fixtures/support files. Preserve Docker quick-start, phase, validation, and troubleshooting guidance with updated harness paths.
- [ ] **Step 5: Run relocated validators and test scripts.** Run the config validators, Gitleaks fixture test, `install/verify.sh`, and the focused tests from their indexed commands. Run Docker tests only if the environment supports them; do not invoke `full` or interactive installation without confirmation.

### Task 4: Repository-wide migration verification

**Files:**
- No new files. Review all moved paths, `scripts/test/README.md`, active references, and the final diff.

- [ ] **Step 1: Search for stale paths.** Search the repository for every old source path in the file map. Expected: no stale active references; any remaining archive/history occurrences are intentional.
- [ ] **Step 2: Verify the catalog.** Check every documented test command points to an executable file and every executable test is classified in the index.
- [ ] **Step 3: Review diff and status.** Confirm only intended file moves, README/reference updates, and this work’s files are included; ensure pre-existing user changes remain intact.
- [ ] **Step 4: Run relevant checks once more.** Execute the README-listed non-Docker tests and validators; report Docker checks as skipped if unavailable or not run.
