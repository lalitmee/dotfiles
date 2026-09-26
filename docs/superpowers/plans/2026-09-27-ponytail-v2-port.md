# Ponytail OpenCode V2 Port Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Port Ponytail's OpenCode integration to the V2 plugin API and keep the fix on a dedicated personal-fork branch for the user's own use.

**Architecture:** Keep the V2 changes limited to Ponytail's OpenCode integration. Work in a dedicated branch of a fork under `lalitmee`, preserving the existing feature behavior and using the upstream repository's test/build conventions.

**Tech Stack:** OpenCode V2 plugin API, Ponytail's existing language/runtime and package tooling, GitHub CLI.

**Spec:** `docs/superpowers/specs/2026-09-27-opencode-v2-plugins-design.md`

## Global Constraints

- Create the fork under the `lalitmee` GitHub account and clone it under `~/Projects/Personal/Github/`.
- Keep this port isolated on its own dedicated branch and limit changes to Ponytail's OpenCode integration.
- Preserve Ponytail's existing supported behavior.
- Do not prepare or open an upstream PR; this fix is for personal use.
- Ask before pushing branch changes to GitHub.
- Do not commit changes without explicit user authorization; repository guidance prohibits auto-committing.

## Review Focus

- Legacy V1 hooks must not silently remain as the active entrypoint; test that OpenCode V2 can load and invoke the migrated integration.
- Existing Ponytail behaviors must survive the API conversion; run the upstream regression suite and add/update focused tests for changed hooks.
- Errors or unavailable optional context should retain Ponytail's existing graceful behavior; exercise any such paths covered by current tests.
- Package/build metadata must continue to expose the OpenCode plugin entrypoint; verify the repository's own packaging/build checks.
- Keep the personal branch limited to the V2 port; inspect the final branch diff against its upstream base.

---

### Task 1: Create and baseline the Ponytail fork

**Files:**
- Clone repository: `~/Projects/Personal/Github/ponytail`
- Inspect: upstream package manifest, OpenCode plugin entrypoint, tests, and contributor guidance

**Interfaces:**
- Consumes: upstream Ponytail repository and `lalitmee` GitHub access.
- Produces: a clean dedicated working branch named `opencode-v2` in the personal fork, with upstream as a comparison base.

- [ ] **Step 1: Create the personal fork and clone it**

Run `gh repo fork DietrichGebert/ponytail --clone=false`, then clone the fork to `~/Projects/Personal/Github/ponytail` and add/retain the upstream remote.

Expected: origin points to `lalitmee/ponytail`; upstream points to `DietrichGebert/ponytail`.

- [ ] **Step 2: Create the isolated branch**

Run `git switch -c opencode-v2` from the fork's default branch.

Expected: clean working tree on `opencode-v2`.

- [ ] **Step 3: Record the baseline contract and checks**

Read the plugin entrypoint and its callers, package scripts, tests, and repository contribution instructions. Run the repository's documented test/build/lint commands without changing files.

Expected: baseline results and the current V1 hook-to-behavior mapping are recorded for the implementation task; any pre-existing failures are distinguished from regressions.

### Task 2: Port and validate Ponytail's OpenCode integration

**Files:**
- Modify: the OpenCode plugin entrypoint identified in Task 1
- Modify/create tests: alongside the repository's existing tests, only where needed to cover migrated behavior

**Interfaces:**
- Consumes: Task 1's upstream source map, test commands, and baseline.
- Produces: the same supported Ponytail integration behavior exposed through V2 plugin hooks and context.

- [ ] **Step 1: Add or update tests for the V2 hook contract**

Use the exact V2 lifecycle/hook shapes from the approved OpenCode V2 docs and current Ponytail behavior. Cover each migrated hook's existing observable behavior; assert V2 hook registration and expected effect. Include a regression test for the highest-risk existing behavior identified during Task 1.

- [ ] **Step 2: Run the focused tests and confirm the migration tests fail**

Run the repository's documented focused test command for the added/updated tests.

Expected: failures demonstrate that the old V1 integration does not satisfy the V2 hook contract.

- [ ] **Step 3: Migrate the integration entrypoint to V2**

Replace only the V1 OpenCode API usage in the integration with V2 plugin exports/context and event hooks. Preserve behavior; do not redesign non-OpenCode Ponytail features.

- [ ] **Step 4: Run focused tests, then the full upstream checks**

Run the focused tests and every applicable baseline test/build/lint command from Task 1.

Expected: all migration tests and applicable repository checks pass; document any baseline failure that remains unchanged.

### Task 3: Validate the personal Ponytail port

**Files:**
- Modify: Ponytail OpenCode integration and tests only
- Inspect: complete branch diff against upstream

**Interfaces:**
- Consumes: validated Task 2 branch.
- Produces: a validated, focused personal-fork branch; no upstream PR materials are prepared.

- [ ] **Step 1: Check branch scope and patch quality**

Run `git diff --check` and inspect the complete working-tree diff against `upstream/main`, including the untracked lockfile separately. The upstream remote has no `upstream/HEAD` symbolic ref.

Expected: no whitespace errors, unrelated changes, or accidental generated files.

- [ ] **Step 2: Record the personal-fork usage and validation notes**

Record the V1-to-V2 API changes, preserved behavior, exact checks run, and how the user can use the fixed version from this branch. Do not write upstream PR content.

- [ ] **Step 3: Keep the result local unless the user authorizes a push**

Do not prepare or open an upstream PR. Ask the user before pushing the branch to the personal GitHub fork.
