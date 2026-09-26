# Workmux OpenCode V2 Port Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Port Workmux's OpenCode status plugin to the V2 plugin API and keep the fix on a dedicated personal-fork branch for the user's own use.

**Architecture:** Keep the change within Workmux's OpenCode plugin. Preserve its existing aggregate session state logic and best-effort Workmux CLI calls while replacing V1 plugin initialization/event handling with V2 APIs.

**Tech Stack:** OpenCode V2 plugin API, TypeScript, Workmux CLI, repository test tooling, GitHub CLI.

**Spec:** `docs/superpowers/specs/2026-09-27-opencode-v2-plugins-design.md`

## Global Constraints

- Create the fork under the `lalitmee` GitHub account and clone it under `~/Projects/Personal/Github/`.
- Keep this port isolated on its own dedicated branch and limit changes to Workmux's OpenCode integration.
- Preserve status aggregation, waiting/working/done behavior, session handling, and best-effort Workmux CLI integration.
- Do not prepare or open an upstream PR; this fix is for personal use.
- Ask before pushing branch changes to GitHub.
- Do not commit changes without explicit user authorization; repository guidance prohibits auto-committing.

## Review Focus

- Parent and child sessions must be aggregated; one idle/deleted session must not mark the pane done while another remains active.
- `waiting` must take precedence over `working`, and `working` over `done`; test the aggregate priority and transition behavior.
- A stale `busy` event after `idle` must not restart a completed turn; a subsequent user message must re-arm it.
- Missing session IDs and Workmux command failures must not crash plugin event processing; preserve best-effort command behavior.
- V2 loading and registration must be verified, and the final diff must exclude unrelated Workmux changes.

---

### Task 1: Create and baseline the Workmux fork

**Files:**
- Clone repository: `~/Projects/Personal/Github/workmux`
- Inspect: `resources/opencode/plugins/workmux-status.ts`, package/build/test configuration, and contributor instructions

**Interfaces:**
- Consumes: upstream Workmux repository and `lalitmee` GitHub access.
- Produces: a clean dedicated working branch named `opencode-v2` in the personal fork, with upstream as a comparison base.

- [ ] **Step 1: Create the personal fork and clone it**

Run `gh repo fork raine/workmux --clone=false`, then clone the fork to `~/Projects/Personal/Github/workmux` and add/retain the upstream remote.

Expected: origin points to `lalitmee/workmux`; upstream points to `raine/workmux`.

- [ ] **Step 2: Create the isolated branch**

Run `git switch -c opencode-v2` from the fork's default branch.

Expected: clean working tree on `opencode-v2`.

- [ ] **Step 3: Record the baseline contract and checks**

Read the upstream plugin and its consumers, package scripts, test coverage, and repository contribution instructions. Run documented relevant test/typecheck/lint/build commands without changing files.

Expected: baseline results and current event-to-status behavior are recorded; pre-existing failures are separated from regressions.

### Task 2: Port Workmux status tracking to V2

**Files:**
- Modify: `resources/opencode/plugins/workmux-status.ts`
- Modify/create tests: in the repository's existing test structure for this integration

**Interfaces:**
- Consumes: Task 1's upstream source map, test commands, and baseline.
- Produces: a V2-loadable status plugin retaining its existing Workmux CLI and aggregate-status semantics.

- [ ] **Step 1: Add tests for the existing status contract and V2 event hook**

Cover event-to-status mapping for busy/idle, permission/question waiting and replies, session deletion, user-message rearming, and aggregate status precedence. Add a case with concurrent sessions and a case for stale `busy` after `idle`. Assert required Workmux commands and their best-effort failure behavior using the repository's test conventions.

- [ ] **Step 2: Run focused tests and confirm they fail against the V1 plugin**

Run the repository's focused test command for the new/updated tests.

Expected: V2 plugin registration/hook assertions fail against the V1 implementation; existing status behavior assertions identify any baseline gaps.

- [ ] **Step 3: Migrate initialization and event handling to the V2 plugin API**

Replace the V1 `Plugin` factory/returned `event` hook with V2 plugin exports, context, and supported lifecycle/event hooks. Retain the session maps, aggregate priority, serialized Workmux status writes, and registration attempt.

- [ ] **Step 4: Run focused tests and all relevant upstream checks**

Run the focused tests and all applicable test/typecheck/lint/build commands recorded in Task 1.

Expected: migration tests and applicable checks pass; unchanged baseline failures are documented.

### Task 3: Validate the personal Workmux port

**Files:**
- Modify: Workmux OpenCode plugin and tests only
- Inspect: full branch diff against upstream

**Interfaces:**
- Consumes: validated Task 2 branch.
- Produces: a validated, focused personal-fork branch; no upstream PR materials are prepared.

- [ ] **Step 1: Check branch scope and patch quality**

Run `git diff --check` and inspect the full working-tree diff against `upstream/main`, including untracked files separately. The upstream remote may not provide an `upstream/HEAD` symbolic ref; record the actual fetched default branch and use it as the comparison base.

Expected: no whitespace errors, unrelated changes, or accidental generated files.

- [ ] **Step 2: Record personal-fork usage and test evidence**

Summarize the API migration, preserved state behavior, exact checks run, and how the user can use the fixed version from this branch. Do not write upstream PR content.

- [ ] **Step 3: Keep the result local unless the user authorizes a push**

Do not prepare or open an upstream PR. Ask the user before pushing the branch to the personal GitHub fork.
