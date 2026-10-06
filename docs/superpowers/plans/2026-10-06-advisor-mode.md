# Critical Advisor Mode Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Add an explicitly invoked critical-advisor skill and establish concise global assistant preferences across OpenCode, Codex, Gemini CLI/Antigravity, Pi, and Cursor.

**Architecture:** Store the portable advisor workflow as one Agent Skill under the existing `agents/.agents/skills/` Stow package, which is the shared user-level skill directory for most targets. Add short platform-native global instruction files or settings entries that express only the user's baseline style preferences; keep the stronger advisor behavior opt-in through the skill. Add links from Antigravity's separate global skill roots to that canonical skill, and add an OpenCode slash command as a discoverable alias without duplicating workflow logic.

**Tech Stack:** Markdown Agent Skills, OpenCode commands and global rules, Codex `AGENTS.md`, Gemini `GEMINI.md`, Pi `APPEND_SYSTEM.md`, Cursor user rules, GNU Stow.

**Spec:** User request in the 2026-10-06 conversation: create an on-demand skill or command for critical-advisor behavior and identify where general instructions belong in OpenCode, Codex, Gemini/Antigravity, Pi, and Cursor. The approved concise general wording is in the preceding conversation turn.

## Global Constraints

- Keep the critical-advisor mode opt-in; do not make forced disagreement or confidence tags global behavior.
- Keep factual claims grounded in observed evidence; use confidence labels only when uncertainty matters.
- Do not run `./install.sh` without explicit user confirmation.
- Do not commit or push changes without explicit user approval.
- Keep the portable skill as the source of truth for the invoked advisor workflow; platform commands should delegate to it rather than fork its behavior.
- Use this exact always-on baseline in each platform's global instruction file: “Be direct and candid. Don’t agree reflexively: identify a real mistaken assumption or missing consideration when it matters, and otherwise answer directly. Lead with the most useful point and skip warm-ups. Mark uncertainty when it matters and support factual claims with evidence. When you disagree, explain why, offer an alternative, and name the specific risk. Hold your position against unsupported pushback, but update when new evidence changes the picture.”
- Do not modify user-level settings or stow packages into live home-directory locations as part of implementation without explicit approval for deployment.

## Review Focus

- Skill is actually discoverable by each requested assistant — verify common `~/.agents/skills` discovery separately from Antigravity IDE (`~/.gemini/config/skills`) and CLI (`~/.gemini/antigravity-cli/skills`) roots.
- Global instruction files do not accidentally activate the intensive advisor persona on every coding task — inspect each diff for baseline-only language.
- User-facing skill invocation is explicit and discoverable — verify the native invocation mechanism for each platform and document any differences.
- OpenCode's existing `command/` layout differs from current docs' `commands/` spelling — confirm the installed OpenCode version discovers the repository's current layout before adding the alias.
- Cursor account-synced User Rules and local `~/.cursor/rules/` files have different storage behavior — retain the account UI option as an alternative and do not imply a local file syncs.

---

### Task 1: Create the portable critical-advisor skill

**Files:**
- Create: `agents/.agents/skills/advisor/SKILL.md`

**Interfaces:**
- Consumes: the user's agreed advisor wording from the conversation.
- Produces: one on-demand Agent Skill named `advisor`, usable through shared skill discovery.

- [ ] **Step 1: Write the skill frontmatter and trigger description**

Use `name: advisor` and a concise description that says to invoke it when the user asks for advice, critique, a recommendation, or assumption testing. State that it is opt-in and must not be silently applied to unrelated implementation tasks.

- [ ] **Step 2: Write the advisor workflow**

Include these behaviors: identify the decision and constraints; inspect relevant configs/evidence when available; state the strongest concern first; distinguish facts, inferences, and unknowns; challenge only real assumptions; when disagreeing, explain why, give an alternative, and name the concrete risk; hold conclusions against unsupported pushback but update when new evidence changes them; finish with practical options/recommendation. Confidence labels are optional and reserved for material uncertainty.

- [ ] **Step 3: Add an explicit invocation convention**

Document the portable invocation as asking to use the `advisor` skill. Use a native slash skill command where supported; do not promise one identical syntax across all clients.

- [ ] **Step 4: Review the skill for contradictions and scope creep**

Confirm it contains no forced disagreement, no universal confidence-prefix requirement, and no advice to expose private chain-of-thought.

### Task 2: Add an OpenCode slash-command entry point

**Files:**
- Create: `opencode/.config/opencode/AGENTS.md`
- Create: `opencode/.config/opencode/commands/advisor.md`

**Interfaces:**
- Consumes: the `advisor` skill from the shared Agent Skills directory.
- Produces: OpenCode's global baseline instructions and an `/advisor` command that activates the skill and applies it to `$ARGUMENTS` or the current discussion.

- [ ] **Step 1: Confirm OpenCode command discovery for the installed version**

The installed CLI is OpenCode v2.0.24 and its current v2 docs describe `~/.config/opencode/commands/`; the repository's older command files are in `command/`. Add the new command in the documented plural `commands/` directory without moving existing commands. Do not run an interactive session or deploy the package.

- [ ] **Step 2: Add the concise global baseline**

Create `opencode/.config/opencode/AGENTS.md` with the approved concise baseline preferences and a note that stronger advisor behavior is opt-in via the `advisor` skill. Keep this separate from primary-agent and specialized-agent prompts.

- [ ] **Step 3: Create the thin command wrapper**

Write frontmatter with a clear description and a body that asks OpenCode to load the `advisor` skill, then apply it to the supplied arguments or current topic. Keep workflow text out of the command.

- [ ] **Step 4: Verify repo-level config and command syntax without deploying**

Validate the new Markdown/frontmatter and confirm its path matches the installed version's discovery rules by inspecting the current docs/runtime. Do not stow or modify live home-directory configuration during this task.

### Task 3: Add Codex global instructions

**Files:**
- Create: `codex/.codex/AGENTS.md`

**Interfaces:**
- Consumes: the user's concise always-on style preferences and shared `advisor` skill.
- Produces: Codex user-level instructions when this Stow package is deployed to `~/.codex`.

- [ ] **Step 1: Write only the baseline preferences**

Copy the exact baseline from Global Constraints verbatim. Add one sentence that stronger adversarial critique is opt-in via the `advisor` skill.

- [ ] **Step 2: Verify location and skill discovery against current Codex docs**

Confirm `~/.codex/AGENTS.md` is the global instruction location and that the shared user-level skill at `~/.agents/skills/advisor/SKILL.md` is discoverable. Do not add a redundant Codex-specific copy of the skill.

### Task 4: Add Gemini CLI and Antigravity global instructions

**Files:**
- Modify: `gemini-cli/.gemini/GEMINI.md`
- Create: Antigravity IDE global skill link under `gemini-cli/.gemini/config/skills/advisor/` pointing to `agents/.agents/skills/advisor/`
- Create: Antigravity CLI global skill link under `gemini-cli/.gemini/antigravity-cli/skills/advisor/` pointing to `agents/.agents/skills/advisor/`

**Interfaces:**
- Consumes: baseline preferences and the shared `advisor` skill.
- Produces: global Gemini CLI instructions and Antigravity skill-path adapters in the Stow package, ready to deploy to `~/.gemini`; an advisor skill visible to all three surfaces through their distinct discovery roots.

- [ ] **Step 1: Preserve existing Gemini directives and add the baseline**

Append a short section containing the exact baseline from Global Constraints and a note that the `advisor` skill is opt-in. Do not replace existing coding or tooling directives.

- [ ] **Step 2: Wire Antigravity's separate global skill roots to the canonical skill**

Create relative symlinks or Stow-compatible links from the package's IDE and CLI global skill locations to `agents/.agents/skills/advisor/`. Keep one maintained `SKILL.md` source. Confirm link targets resolve within the repository; do not deploy them to `~/.gemini`.

- [ ] **Step 3: Confirm scope for Gemini CLI and Antigravity separately**

Use `~/.gemini/GEMINI.md` for Gemini CLI's global context. For Antigravity, document the supported global Rules UI / `~/.gemini/AGENTS.md`, `~/.gemini/GEMINI.md`, or modular `~/.gemini/config/rules/*.md` options; do not assume all Antigravity surfaces share identical discovery without checking the installed surface. The official docs list distinct global skill roots for Antigravity IDE (`~/.gemini/config/skills/`) and CLI (`~/.gemini/antigravity-cli/skills/`).

- [ ] **Step 4: Verify global rule and skill loading**

Validate Markdown and links locally. Document the Gemini CLI context status/reload and Antigravity Customizations > Rules/Skills checks for after deployment; do not modify live settings during this task.

### Task 5: Add Pi global instructions

**Files:**
- Modify: `pi/.pi/agent/APPEND_SYSTEM.md`

**Interfaces:**
- Consumes: baseline preferences and shared `advisor` skill.
- Produces: Pi user-level appended system instructions when deployed to `~/.pi/agent`.

- [ ] **Step 1: Add a separate response-style section**

Preserve existing coding and tooling rules. Add the exact baseline from Global Constraints and state that detailed challenge/recommendation behavior is available through the `advisor` skill.

- [ ] **Step 2: Verify Pi configuration statically**

Validate the Markdown and confirm the canonical skill is in Pi's documented shared skill root. Document the Pi reload/discovery smoke check for after deployment; do not modify live settings during this task.

### Task 6: Add Cursor global instructions

**Files:**
- Create: `cursor/.cursor/rules/advisor-baseline.mdc`

**Interfaces:**
- Consumes: baseline preferences and shared `advisor` skill.
- Produces: machine-local Cursor global instructions managed by this Stow package; account-synced User Rules remain a documented alternative.

- [ ] **Step 1: Choose the Cursor global storage target**

Use `~/.cursor/rules/advisor-baseline.mdc` through this dotfiles package so the baseline is reproducible with the rest of the config. Clearly document that this local file does not sync with the Cursor account; mention User Rules in Customize > Rules as the account-synced alternative.

- [ ] **Step 2: Add baseline-only wording**

Write the exact baseline from Global Constraints and the opt-in advisor-skill reference. Keep the intensive challenge behavior out of always-applied rules.

- [ ] **Step 3: Verify rule and skill discovery**

Validate Markdown/frontmatter and document the Cursor UI/skill-discovery smoke check for after deployment. Do not modify account-level Cursor settings.

### Task 7: Document the per-platform locations and deployment boundary

**Files:**
- Create: `docs/assistant-instructions.md`

**Interfaces:**
- Consumes: official platform documentation and the implemented config paths above.
- Produces: a compact map of global instruction locations, skill discovery locations, invocation syntax, and whether each setting is account-synced or Stow-managed.

- [ ] **Step 1: Add the cross-platform location table**

Cover OpenCode (`~/.config/opencode/AGENTS.md`), Codex (`~/.codex/AGENTS.md`), Gemini CLI (`~/.gemini/GEMINI.md`), Antigravity global Rules UI or supported `~/.gemini` rules files, Pi (`~/.pi/agent/APPEND_SYSTEM.md`), and Cursor (User Rules UI or `~/.cursor/rules/*.mdc`). Show shared `~/.agents/skills/advisor/` discovery for OpenCode, Codex, Gemini CLI, Pi, and Cursor, plus Antigravity IDE (`~/.gemini/config/skills/advisor/`) and CLI (`~/.gemini/antigravity-cli/skills/advisor/`) links to the same canonical skill. Record each tool's explicit invocation behavior.

- [ ] **Step 2: Add source links and deployment notes**

Link the official docs used to validate each location. Explain that editing the Stow package updates repository content but linking/deploying to live home-directory paths is a separate operation; never use `./install.sh` without confirmation.

- [ ] **Step 3: Review for current naming and scope accuracy**

Cross-check the table against each platform's current docs and confirm the distinctions between Gemini CLI and Antigravity, and between Cursor account User Rules and local rule files.

## Documentation Sources

- OpenCode instructions/rules: <https://dev.opencode.ai/v2/docs/instructions/>
- OpenCode skills: <https://opencode.ai/docs/skills>
- OpenCode commands: <https://dev.opencode.ai/v2/docs/commands/>
- Codex global instructions: <https://developers.openai.com/codex/guides/agents-md>
- Codex skills: <https://developers.openai.com/codex/skills>
- Gemini CLI context files: <https://github.com/google-gemini/gemini-cli/blob/main/docs/reference/configuration.md>
- Gemini CLI skills: <https://github.com/google-gemini/gemini-cli/blob/main/docs/cli/using-agent-skills.md>
- Antigravity rules: <https://www.antigravity.google/docs/rules/>
- Antigravity skills and per-surface roots: <https://www.antigravity.google/docs/skills>
- Pi configuration and instructions: <https://pi.dev/docs/latest/configuration>
- Pi skills: <https://pi.dev/docs/latest/skills>
- Cursor rules: <https://cursor.com/help/customization/rules>
- Cursor skills: <https://cursor.com/help/customization/skills>
