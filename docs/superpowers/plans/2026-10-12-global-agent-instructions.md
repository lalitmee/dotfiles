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

- A tool silently ignores an instruction import or global file; verify loaded instructions using its supported context inspection or a minimal session.
- A symlink or imported relative path resolves differently after GNU Stow deployment; verify both the repo source and deployed path.
- Cursor only applies User Rules configured through its UI; verify whether the existing stowed `~/.cursor/rules/advisor-baseline.mdc` is actually global before relying on it.
- Existing global instructions in Gemini, Codex, and OpenCode may be lost when replaced; preserve their unrelated settings and keep any useful tool-specific guidance outside the shared file.
- A canonical policy accidentally absorbs brain-specific or dotfiles-only rules; inspect its content against the spec boundaries.

---

### Task 1: Add canonical global instructions and connect file-based tools

**Files:**
- Create: `agents/instructions/global.md`
- Create: `agents/.agents/instructions/global.md` (Stow-visible link to the canonical file)
- Modify: `codex/.codex/AGENTS.md`
- Modify: `opencode/.config/opencode/AGENTS.md` and `opencode/.config/opencode/opencode.json`
- Modify: `gemini-cli/.gemini/GEMINI.md`
- Create: `claude/.claude/CLAUDE.md`

**Interfaces:**
- Produces: portable shared instructions consumed by the global configuration for Codex, OpenCode, Gemini CLI, and Claude Code.

- [ ] **Step 1: Write the canonical rules.** Include the concise direct/candid baseline already in Codex/OpenCode/Cursor/Gemini, with uncertainty and evidence where material, substantive disagreement with reason/alternative/risk, updating on new evidence, and secret handling. Preserve stronger advisor behavior as opt-in. Do not include confidence tags on every claim, mandatory adversarial tone, tool-specific routing, repo conventions, or brain logging rules.
- [ ] **Step 2: Expose the canonical file through Stow.** Add `agents/.agents/instructions/global.md` as a relative symlink to `agents/instructions/global.md`, so the deployed shared path is `~/.agents/instructions/global.md` without depending on the dotfiles clone location.
- [ ] **Step 3: Connect Codex to the canonical file.** Codex already reads `$CODEX_HOME/AGENTS.md`; replace its duplicated baseline with a Stow-safe link to the canonical file if the deployed link resolves correctly. Otherwise use the smallest verified adapter and record why a direct link is not viable.
- [ ] **Step 4: Configure OpenCode to load the canonical file.** Add `~/.agents/instructions/global.md` to the existing `instructions` list in `opencode/.config/opencode/opencode.json`. Remove `opencode/.config/opencode/AGENTS.md` after verifying the configured instruction source loads in a minimal session, preventing duplicate injection.
- [ ] **Step 5: Import shared rules from Gemini CLI and Claude Code.** Add `@~/.agents/instructions/global.md` to `gemini-cli/.gemini/GEMINI.md` and `claude/.claude/CLAUDE.md`. Keep existing Gemini-specific conventions and preferences in `GEMINI.md`.
- [ ] **Step 5: Verify the four tools.** Run `stow -n -v codex opencode gemini-cli claude` (or package-by-package if the command syntax does not support multiple packages); inspect link targets. Verify the loaded instruction source for each tool with its context display or a minimal interactive session. Expected: the shared baseline is present once and existing unrelated settings remain intact.

### Task 2: Connect Cursor and verify portability

**Files:**
- Modify: `cursor/.cursor/rules/advisor-baseline.mdc`
- Possibly modify: the Cursor user-level rule configured in Cursor's Customize → Rules UI; only if required by current supported global behavior.
- Verify: `agents/instructions/global.md` and the five adapters from Task 1.

**Interfaces:**
- Consumes: `agents/instructions/global.md` from Task 1.
- Produces: a Cursor global rule that applies the canonical baseline across projects, without a separately maintained policy copy.

- [ ] **Step 1: Verify Cursor's current global rules mechanism.** Confirm from current official documentation and an installed Cursor session whether the stowed `~/.cursor/rules/advisor-baseline.mdc` is loaded globally and whether it can reference an external Markdown file. Do not infer global behavior from project `.cursor/rules` support.
- [ ] **Step 2: Connect the rule using the smallest supported mechanism.** Prefer a direct reference to `~/.agents/instructions/global.md`. If Cursor has no file-based global import, keep its User Rule minimal and point it to the canonical file, or use the smallest documented adapter needed; do not silently maintain a second full policy by hand. If this requires unavoidable manual UI setup, document the one-time setup clearly.
- [ ] **Step 3: Verify Cursor in two repositories.** Confirm the baseline applies in a repository without its own Cursor rule and remains compatible with a project-specific rule. Expected: global defaults load, project guidance remains local, and no policy conflicts are introduced.
- [ ] **Step 4: Review the complete boundary.** Confirm the canonical file is tool-neutral, contains no machine-specific paths or brain-repository logging rules, and root `AGENTS.md` remains dotfiles-specific. Check all five tools' effective loaded instructions and record any Cursor-specific manual setup in the relevant package README or config comment only if needed for future portability.
