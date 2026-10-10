# Script Test Organization Design

## Problem

The flat `scripts/test/` directory mixes executable tests, configuration validators, a Docker installation harness, and test data. Test filenames use inconsistent styles and often do not make both the target tool and tested behavior easy to identify. The README documents the Docker harness but does not catalog the other checks.

## Goals

- Make tests discoverable by the tool or subsystem they exercise.
- Keep individual test names concise and behavior-focused.
- Make each test's target, covered behavior, and run command discoverable from one index.
- Preserve test behavior and update active references when paths change.

## Non-goals

- Introducing a test framework or a repository-wide test runner.
- Rewriting test assertions or expanding test coverage as part of reorganization.
- Forcing support utilities, validators, or test fixtures to appear as tests.
- Rewriting historical/archive documentation that is no longer operational guidance.

## Structure

Organize tests in `scripts/test/` by tool or subsystem, using only as much nesting as needed to make ownership clear. Candidate groups include `tmux/`, `bin/`, `config/`, `security/`, and `install/`. Put test behavior in concise filenames under those groups; for example, tmux worktree checks may use `tmux/worktree/discovery.zsh` and `tmux/worktree/actions.zsh`, while the Bluetooth audio selection test may use `bin/bluetooth/audio-selection.zsh`.

Do not split an existing test merely to create more files. Split only when the existing file combines independently runnable behaviors that benefit from focused execution. Otherwise, keep its behavior together and choose a concise descriptive name.

Keep the top-level `scripts/test/README.md` as the index. For every test, list its target tool, behavior covered, and exact invocation. Keep Docker installation instructions in the README but distinguish the harness from focused tests. Clearly identify validators and fixture/data files as support artifacts rather than tests.

## Migration constraints

- Preserve test logic and behavior during path/name changes.
- Search for and update active references in project instructions and current documentation/plans.
- Leave historical/archive references alone unless they remain operational instructions.
- Do not touch unrelated existing worktree changes.
- Do not add a framework, generic runner, or abstraction unless discovery during planning demonstrates a concrete need.

## Validation

- Run each renamed test using its documented command.
- Run affected validators and the Docker harness only where practical and relevant; do not run interactive installation commands without explicit confirmation.
- Search the repository for old paths and ensure remaining occurrences are intentional historical references.
- Review the final diff to confirm only the test organization, index, and necessary active references changed.
