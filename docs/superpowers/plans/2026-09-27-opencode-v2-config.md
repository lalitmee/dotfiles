# OpenCode V2 Dotfiles Configuration Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Convert the dotfiles OpenCode plugin configuration to V2 and keep the installer-managed Herdr integration disabled without changing its file.

**Architecture:** Update `opencode/.config/opencode/opencode.json` to V2 while preserving unrelated settings, and align the local Workmux plugin with its V2 fork. Add a Herdr disable rule only after confirming Herdr's actual V2 plugin ID; load Ponytail from its V2 fork rather than the still-V1 npm release.

**Tech Stack:** OpenCode V2 JSON configuration and plugin discovery, JSON validation, OpenCode CLI/runtime.

**Spec:** `docs/superpowers/specs/2026-09-27-opencode-v2-plugins-design.md`

## Global Constraints

- Preserve all currently configured plugins and unrelated settings.
- Keep the Herdr integration disabled, and do not edit, delete, or replace its installer-managed JavaScript file.
- Verify the actual Herdr plugin identity from V2 discovery/identity; the filename is not authoritative.
- Do not run `./install.sh` without explicit user confirmation.
- Do not commit changes without explicit user authorization; repository guidance prohibits auto-committing.
- Do not prepare or submit upstream pull requests for either personal plugin port.

## Review Focus

- An incorrect Herdr ID could leave the plugin active; verify the resolved V2 identity and confirm it is excluded after config reload.
- Converting the plugin-list property must not drop Superpowers, DCP, or Ponytail; compare the before/after plugin sources.
- A syntactically valid config could still have the wrong V2 shape; validate using OpenCode V2 rather than relying only on JSON parsing.
- Unrelated agents, provider configuration, MCP servers, and permissions must remain unchanged; review the exact config diff.
- The Herdr file is installer-managed; verify its contents remain byte-for-byte unchanged.

---

### Task 1: Identify Herdr's V2 plugin identity

**Files:**
- Inspect: `opencode/.config/opencode/plugins/herdr-agent-state.js`
- Inspect: V2 plugin discovery output/logs or other authoritative V2 identity information

**Interfaces:**
- Consumes: currently active V2 OpenCode runtime and local plugin discovery.
- Produces: exact plugin ID accepted by the V2 `plugins` disable rule.

- [ ] **Step 1: Inspect V2's discovered plugin identity**

Use the supported OpenCode V2 plugin diagnostic/discovery mechanism and compare its identity to the Herdr integration source. Do not infer the ID solely from `herdr-agent-state.js`.

Expected: record the exact ID and evidence tying it to Herdr's local integration; if the ID cannot be established, stop before editing configuration and ask for clarification.

### Task 2: Migrate and validate the global OpenCode plugin config

**Files:**
- Modify: `opencode/.config/opencode/opencode.json`
- Do not modify: `opencode/.config/opencode/plugins/herdr-agent-state.js`

**Interfaces:**
- Consumes: Task 1's verified Herdr plugin ID and the approved V2 config/plugin-control schema.
- Produces: a valid V2 `plugins` list preserving the configured plugins and containing a rule disabling the verified Herdr identity.

- [ ] **Step 1: Capture the config baseline and Herdr file checksum**

Record the existing plugin entries and unrelated top-level settings; compute a checksum for the Herdr file so it can be compared after editing.

- [ ] **Step 2: Update the plugin list in the config**

Replace the V1 `plugin` field with the V2 `plugins` field as documented, retain `superpowers@git+https://github.com/obra/superpowers.git`, `@tarquinen/opencode-dcp@latest`, and `@dietrichgebert/ponytail`, and add the V2 disable rule for Task 1's verified Herdr ID.

- [ ] **Step 3: Validate syntax and V2 configuration semantics**

Parse the JSON and run the supported OpenCode V2 config validation/plugin discovery command. Confirm all intended plugin sources remain and the Herdr integration is disabled.

Expected: valid config, existing plugin sources preserved, Herdr absent/disabled in discovery.

- [ ] **Step 4: Verify scope and protected file**

Compare the config diff against the baseline, confirm unrelated settings are unchanged, and recompute the Herdr plugin checksum.

Expected: only the plugin configuration changed and the Herdr file checksum matches.

### Task 3: Integrate the V2-compatible plugin ports locally

**Files:**
- Modify: `opencode/.config/opencode/opencode.json` to load the V2 Ponytail fork through a supported V2 source mechanism
- Modify: `opencode/.config/opencode/plugins/workmux-status.ts` only if required to align with the validated Workmux fork implementation

**Interfaces:**
- Consumes: the separately validated Ponytail and Workmux V2 ports and their stable fork paths/APIs.
- Produces: the active global OpenCode config and local Workmux plugin use the V2-compatible implementations without changing unrelated config or Herdr files.

- [ ] **Step 1: Select a supported V2 source for the Ponytail fork**

Use the V2 plugin configuration documentation to determine whether this fork should be loaded from its local clone or through a supported remote Git source. Select the mechanism that loads the actual V2 port from `~/Projects/Personal/Github/ponytail`, not the still-V1 npm release. Record the exact config entry and verify that it resolves to the port branch.

- [ ] **Step 2: Align local Workmux with the reviewed V2 port**

Compare the local plugin with the validated Workmux fork and update it to track the V2 implementation, following the existing dotfiles package layout. Preserve local behavior. Do not run `./install.sh`.

- [ ] **Step 3: Validate both plugins and the OpenCode config together**

Run focused checks for both ports and OpenCode V2 config/plugin loading validation. Confirm Ponytail resolves to the port, Workmux loads from the local V2 implementation, and Herdr remains disabled. Reload the affected runtime only by a supported normal mechanism.

Expected: config loads, both intended plugins are V2-compatible and active, and Herdr remains disabled.
