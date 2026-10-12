# Global Agent Instructions Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Establish one portable source of shared agent instructions and load it in Codex, Cursor, OpenCode, Gemini CLI, and Claude Code.

**Architecture:** Store the canonical Markdown at `agents/instructions/global.md`. Use each tool's existing global configuration package to load or point to that source, retaining standalone text only where the tool has no file-based import mechanism. Keep repository-local policy in root `AGENTS.md` and brain logging in the relevant work/Cursor guidance.

**Tech Stack:** Markdown, GNU Stow, existing JSON/TOML/MD configuration; no new dependencies or generator.

**Spec:** `docs/superpowers/specs/2026-10-12-global-agent-instructions-design.md`

## Global Constraints

- The canonical instructions live at `agents/instructions/global.md`.
- Expose the canonical source to tools through `~/.agents/instructions/global.md`, as a Stow-managed link back to that source; imports must not hardcode the dotfiles clone location.
- Support Codex, Cursor, OpenCode, Gemini CLI, and Claude Code.
- Keep the dotfiles root `AGENTS.md` scoped to this repository.
- Keep brain repository records and logging rules outside the canonical global file.
- Avoid machine-specific paths and personal/work assumptions in the canonical instructions.
- Do not maintain divergent shared rules by hand; use a tool-supported reference or generated/copied adapter from the canonical source.
- Do not add speculative adapters, dependencies, or automation.

## Review Focus

- A tool silently ignores an instruction import or global file; verify the adapter now and runtime loading after safe activation.
- A symlink or imported relative path resolves differently after GNU Stow deployment; verify the repo target now and the deployed path after safe activation.
- Cursor only applies User Rules configured through its UI; verify whether the existing stowed `~/.cursor/rules/advisor-baseline.mdc` is actually global before relying on it.
- Existing global instructions in Gemini, Codex, and OpenCode may be lost when replaced; preserve their unrelated settings and keep any useful tool-specific guidance outside the shared file.
- A canonical policy accidentally absorbs brain-specific or dotfiles-only rules; inspect its content against the spec boundaries.

---

> **Activation status:** This plan prepares the source adapters only. Existing home-directory conflicts and explicit package ignore rules must be reconciled intentionally before Stow deployment; Cursor additionally requires the documented one-time User Rule in its UI. Do not describe the setup as active until those steps and runtime checks are complete.

### Task 1: Add canonical global instructions and connect file-based tools

**Files:**
- Create: `agents/instructions/global.md`
- Create: `agents/.agents/instructions/global.md` (Stow-visible link to the canonical file)
- Modify: `codex/.codex/AGENTS.md`
- Modify: `opencode/.config/opencode/AGENTS.md`
- Modify: `gemini-cli/.gemini/GEMINI.md`
- Create: `claude/.claude/CLAUDE.md`

**Interfaces:**
- Produces: portable shared instructions and source adapters for Codex, OpenCode, Gemini CLI, and Claude Code; activation remains subject to existing Stow/user-config protections.

- [x] **Step 1: Write the canonical rules.** Include the concise direct/candid baseline already in Codex/OpenCode/Cursor/Gemini, with uncertainty and evidence where material, substantive disagreement with reason/alternative/risk, updating on new evidence, and secret handling. Preserve stronger advisor behavior as opt-in. Do not include confidence tags on every claim, mandatory adversarial tone, tool-specific routing, repo conventions, or brain logging rules.
- [x] **Step 2: Expose the canonical file through Stow.** Add `agents/.agents/instructions/global.md` as a relative symlink to `agents/instructions/global.md`, so the deployed shared path is `~/.agents/instructions/global.md` without depending on the dotfiles clone location.
- [x] **Step 3: Prepare the Codex adapter.** Add the Stow-safe source link. Preserve the existing `/.codex` ignore and live `~/.codex/AGENTS.md`; record that runtime activation requires a deliberate migration.
- [x] **Step 4: Prepare the OpenCode adapter.** Replace duplicate source text with a relative symlink to the canonical file. Verify the source target; preserve the pre-existing Stow conflict and record that deployment/runtime loading remains pending.
- [x] **Step 5: Import shared rules from Gemini CLI and Claude Code.** Add `@~/.agents/instructions/global.md` to `gemini-cli/.gemini/GEMINI.md` and `claude/.claude/CLAUDE.md`. Keep existing Gemini-specific conventions and preferences in `GEMINI.md`.
- [x] **Step 6: Verify the four adapters.** Run `stow -n -v` package-by-package; inspect link targets and import syntax. Do not overwrite existing live config or bypass package ignore/conflict protections. Record where a deployed/runtime check is blocked by existing user configuration; do not claim those tools are active until their normal Stow/manual setup is completed.

### Task 2: Connect Cursor and verify portability

**Files:**
- Modify: `cursor/.cursor/rules/advisor-baseline.mdc`
- Possibly modify: the Cursor user-level rule configured in Cursor's Customize → Rules UI; only if required by current supported global behavior.
- Verify: `agents/instructions/global.md` and the five adapters from Task 1.

**Interfaces:**
- Consumes: `agents/instructions/global.md` from Task 1.
- Produces: a repository-scoped pointer plus the exact one-line Cursor User Rule needed for global behavior; activation requires that UI-managed rule.

- [x] **Step 1: Verify Cursor's current global rules mechanism.** Confirm from current official documentation and installed CLI/config whether the stowed `~/.cursor/rules/advisor-baseline.mdc` is global. Do not infer global behavior from project `.cursor/rules` support. User Rules are UI-managed and not stored in this package.
- [x] **Step 2: Connect the rule using the smallest supported mechanism.** Keep the repository rule as a pointer to `~/.agents/instructions/global.md`; document the exact one-line User Rule needed in Customize → Rules → User Rules. Do not maintain a second full policy by hand.
- [x] **Step 3: Verify Cursor configuration boundaries.** Confirm the repository rule remains project-scoped and the User Rule requires a one-time UI action. Runtime verification across two repositories requires that UI action and an interactive Cursor session; record it as pending if unavailable.
- [x] **Step 4: Review the complete boundary.** Confirm the canonical file is tool-neutral, contains no machine-specific paths or brain-repository logging rules, and root `AGENTS.md` remains dotfiles-specific. Check all five source adapters; record runtime activation blockers and Cursor's one-time manual setup in the relevant config comment when UI-managed global rules cannot be stored in the repository.
