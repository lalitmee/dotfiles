# tmux Installer Hardening and Update Check Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Make `install-tmux` safe and predictable, remove the redundant Ubuntu-packaged tmux after verifying the `/usr/local` build, then provide an opt-in scheduled check that notifies when a newer stable release is available without installing it automatically.

**Architecture:** Keep compilation and installation in the existing user-facing script, but validate arguments, fail closed on lookup/build errors, avoid deleting user data, and verify the installed version. After successful verification, provide a separate explicit cleanup operation for the distro-managed duplicate; never remove it before the replacement works. Add a separate read-only checker for scheduled use and a systemd user timer that runs it periodically. The timer never runs `sudo`, installs dependencies, builds tmux, or removes packages.

**Tech Stack:** zsh, git, GNU coreutils, systemd user service/timer, `notify-send` when available.

**Spec:** User requests: harden security and fix problems in `bin/.config/bin/install-tmux`; plan an automation approach; avoid keeping multiple tmux versions. Current host has `/usr/local/bin/tmux` 3.7c and Ubuntu `/usr/bin/tmux` 3.4. Automation decision: opt-in weekly notification-only check; installation and distro-package cleanup remain manual/explicit.

## Automation Method Decision

Use a **systemd user timer**, not cron, for this machine: PID 1 is systemd, `systemctl --user` is running, and the user manager has the session D-Bus/display environment needed by `notify-send`. User timers also provide journal logs and `Persistent=true` catch-up after downtime. Cron is viable but has no built-in missed-run catch-up and typically needs extra environment handling for desktop notifications. Keep the timer disabled until the user explicitly opts in; if they later need checks while logged out with no user manager, revisit a system timer or cron instead.

## Global Constraints

- Do not run `./install.sh` without explicit user confirmation.
- Do not delete or overwrite an existing checkout or unrelated path.
- Scheduled automation must be read-only and must not invoke `sudo` or install packages.
- Keep only the `/usr/local` tmux after a successful replacement; remove distro copies via their package manager, never by manually deleting package-owned files.
- Do not remove the distro package unless the `/usr/local/bin/tmux` binary passes version verification and the package manager confirms the exact removal set.
- Preserve stable-release installation to `/usr/local`; do not make prerelease installation automatic.
- Do not add a dependency for update checking; use existing `git` and optional desktop `notify-send`.
- Keep script style consistent with this repository (quoted variables, `[[ ... ]]`, snake_case functions, 4-space indentation).

## Review Focus

- Malformed or unsupported command-line arguments must exit nonzero before side effects; test unknown, duplicate, and extra arguments.
- Missing network/GitHub response must not be interpreted as an empty/latest version or continue into a build; test lookup failure.
- A pre-existing non-repository checkout path must be preserved; test using a temporary directory containing a sentinel file.
- Interrupted or failed compilation must leave the currently installed tmux untouched; test failures before install and assert no build command runs as root.
- Distro cleanup must never run after a failed or mismatched install; inspect package ownership and simulated package-removal effects before removing anything.
- The scheduled check must work without a graphical notification daemon and without an interactive shell; test absent `notify-send` and verify stdout/status.

---

### Task 1: Harden the source installer

**Files:**
- Modify: `bin/.config/bin/install-tmux`
- Create: `scripts/test/test_install_tmux.zsh`

**Interfaces:**
- Keep the executable interface `install-tmux [--next|-n] [--help|-h]`.
- Add a testable main guard/function boundary so tests can source or run the script with mock commands in `PATH`; production behavior remains command-line execution.

- [ ] **Step 1: Add regression tests for argument validation and latest-tag lookup failure**

Test that unknown options and extra arguments fail without invoking dependency installation; make mocked `git ls-remote` fail and assert the installer exits nonzero before creating a checkout or invoking `make`.

- [ ] **Step 2: Run the tests and confirm the relevant cases fail against current behavior**

Run: `zsh scripts/test/test_install_tmux.zsh`
Expected: nonzero test result identifying the unsupported-argument / lookup-failure regressions.

- [ ] **Step 3: Validate arguments before side effects and make release lookup fail closed**

In `bin/.config/bin/install-tmux`, accept only help, stable install (no args), or one `--next`/`-n` argument. Check command failures and nonempty version result. For `--next`, explicitly fetch and checkout the upstream development branch rather than relying on the checkout's current branch. For stable, fetch tags and checkout the exact selected tag.

- [ ] **Step 4: Add tests for unsafe checkout paths and install verification**

Use a temporary home and mock commands. Assert a pre-existing non-Git `$HOME/Projects/Personal/Github/tmux` with a sentinel file is not removed or changed. Assert success requires `/usr/local/bin/tmux -V` to report the requested tag version, and a failed build never invokes a privileged build/install command.

- [ ] **Step 5: Run tests and implement the minimum fixes**

Run: `zsh scripts/test/test_install_tmux.zsh`
Expected: PASS. Replace the `rm -rf` recovery with a clear error for a conflicting checkout path; never run `git pull` after a failed update; propagate package-manager, `autogen.sh`, configure, make, and install failures. Run `make DESTDIR=<temporary-staging-directory> install` unprivileged, then use narrowly scoped `sudo install` commands to copy only the staged tmux executable and manual page into `/usr/local`; never execute the upstream Makefile as root. Verify the actual installed version, not merely file existence. Keep dependency caching only if it cannot suppress required checks; otherwise remove the marker shortcut.

- [ ] **Step 6: Re-run the test and syntax checks**

Run: `zsh scripts/test/test_install_tmux.zsh && zsh -n bin/.config/bin/install-tmux`
Expected: both commands exit zero. Do not run the installer itself as a test because it installs system-wide.

### Task 2: Add a read-only stable-release checker

**Files:**
- Create: `bin/.config/bin/check-tmux-update`
- Create: `scripts/test/test_check_tmux_update.zsh`

**Interfaces:**
- `check-tmux-update [--quiet]`; exit `0` when the check succeeds (whether current or update available), and exit `1` when it cannot determine a release. Print a concise status in all non-quiet cases. This keeps a successful systemd oneshot from being marked failed merely because an update exists.
- Checker reads the installed `tmux -V`, queries upstream stable tags, and optionally calls `notify-send` only when an update is available.

- [ ] **Step 1: Test current, update-available, lookup-failure, and no-notification-daemon cases**

Mock `tmux`, `git`, and `notify-send` through a temporary `PATH`. Assert exact statuses: current `0`, update available `0` with a notification, lookup failure `1`; assert missing `notify-send` does not turn a successful check into an error.

- [ ] **Step 2: Run tests to confirm they fail because the checker does not exist**

Run: `zsh scripts/test/test_check_tmux_update.zsh`
Expected: FAIL because `check-tmux-update` is absent.

- [ ] **Step 3: Implement the smallest read-only checker**

Use the same stable version/tag selection logic as Task 1 without sourcing the installer or calling its dependency/build/install flow. Handle missing tmux, failed network lookup, malformed version output, and optional `notify-send` gracefully. `--quiet` suppresses normal status text but preserves exit codes and errors.

- [ ] **Step 4: Run the checker tests and syntax check**

Run: `zsh scripts/test/test_check_tmux_update.zsh && zsh -n bin/.config/bin/check-tmux-update`
Expected: both commands exit zero.

### Task 3: Remove the duplicate distro package safely

**Files:**
- Modify: `bin/.config/bin/install-tmux` (explicit cleanup option, if cleanup is kept in the installer)
- Modify: `README.md` (document the one-time Ubuntu cleanup and how to confirm the single active executable)
- Extend: `scripts/test/test_install_tmux.zsh`

**Interfaces:**
- Add explicit `--cleanup-distro` option; it only removes the package-managed tmux after confirming `/usr/local/bin/tmux -V` is valid and `dpkg-query` reports the Ubuntu `tmux` package installed.
- Cleanup uses `apt-get -s remove tmux` for a preview, displays the proposed package removals, and requires an interactive confirmation before `sudo apt-get remove tmux`. It never uses `rm` on `/usr/bin/tmux` or `/bin/tmux`.

- [ ] **Step 1: Add tests proving cleanup is guarded and non-destructive by default**

Mock `dpkg-query`, `/usr/local/bin/tmux`, `apt-get`, and `sudo`. Assert normal install/check paths never remove a package; invalid replacement version, failed simulation, or non-interactive mode exits before `sudo`; cancellation makes no package changes.

- [ ] **Step 2: Run tests and verify the safety cases fail before implementation**

Run: `zsh scripts/test/test_install_tmux.zsh`
Expected: new cleanup cases fail because the explicit cleanup option is not implemented.

- [ ] **Step 3: Implement the explicit, confirmation-gated distro cleanup**

Before any removal, verify `/usr/local/bin/tmux -V`, confirm the distro package owns `/usr/bin/tmux`, run `apt-get -s remove tmux`, and parse its `Remv` lines; abort unless the only package listed for removal is `tmux`. Show the simulation output, reject non-interactive execution, read confirmation from `/dev/tty`, and only then call `sudo apt-get remove tmux`. Keep this cleanup independent from the automated update checker and timer.

- [ ] **Step 4: Run cleanup tests and document one-time use**

Run: `zsh scripts/test/test_install_tmux.zsh && zsh -n bin/.config/bin/install-tmux`
Expected: PASS. Document running `install-tmux --cleanup-distro` only after the local build has been verified, then checking `whence -a tmux`, `tmux -V`, and `dpkg-query -W tmux` (package query should report it absent).

### Task 4: Add an opt-in systemd user timer

**Files:**
- Create: `systemd/.config/systemd/user/tmux-update-check.service`
- Create: `systemd/.config/systemd/user/tmux-update-check.timer`
- Modify: `README.md` (document opt-in enable/disable commands and behavior)

**Interfaces:**
- Service runs `check-tmux-update` as the logged-in user, with no privilege escalation.
- Timer uses `OnCalendar=weekly`, `Persistent=true`, and a short randomized delay; it is installed but not enabled automatically.

- [ ] **Step 1: Add a static check for timer safety and schedule settings**

Verify the unit has `User`-level execution (no `User=root`, `sudo`, or installer invocation), weekly calendar scheduling, and `Persistent=true`.

- [ ] **Step 2: Create the service and timer units**

Service executes the checker by absolute path under the user's home. Timer targets the service and is opt-in; document `systemctl --user daemon-reload`, `enable --now tmux-update-check.timer`, status/log inspection, and `disable --now` to opt out.

- [ ] **Step 3: Validate units and install linkage without enabling the timer**

Run: `systemd-analyze --user verify systemd/.config/systemd/user/tmux-update-check.service systemd/.config/systemd/user/tmux-update-check.timer` when available; otherwise inspect with `systemd-analyze verify` in a user-systemd environment. Confirm dotfile package linkage follows existing Stow layout. Do not run `./install.sh` and do not enable the timer during implementation.

### Completion check

- [ ] Run `zsh scripts/test/test_install_tmux.zsh && zsh scripts/test/test_check_tmux_update.zsh`.
- [ ] Run `zsh -n` on both scripts and validate the systemd units.
- [ ] Inspect the diff to confirm no unattended installation, privileged build, automatic package removal, destructive cleanup, or timer enablement was added.
- [ ] Commit in separate reviewable commits: `fix(tmux): harden source installer` and `feat(tmux): add opt-in update check timer`.
