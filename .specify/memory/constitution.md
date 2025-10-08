<!--
SYNC IMPACT REPORT
- Version: 1.0.0 (from unversioned template)
- Rationale: Initial versioning of the constitution based on established project guidelines from GEMINI.md and README.md.
- Modified Principles:
  - PRINCIPLE_1: Renamed and defined as "Clarity and Intent"
  - PRINCIPLE_2: Renamed and defined as "Safety and User Confirmation"
  - PRINCIPLE_3: Renamed and defined as "Holistic & Precise Changes"
  - PRINCIPLE_4: Renamed and defined as "Rigorous Verification"
  - PRINCIPLE_5: Renamed and defined as "Proactive Knowledge Management"
- Added Sections:
  - Agent Guidelines
- Removed Sections:
  - SECTION_2_NAME, SECTION_3_NAME (and their content)
- Templates Requiring Updates:
  - ✅ .specify/templates/plan-template.md (Updated constitution check gates)
  - ✅ .specify/templates/tasks-template.md (Added note on constitutional alignment)
  - ✅ .specify/templates/spec-template.md (Checked, no changes needed)
- Follow-up TODOs:
  - TODO(RATIFICATION_DATE): Determine original adoption date.
-->
# Dotfiles Constitution

## Core Principles

### I. Clarity and Intent
Before implementing a solution, the agent MUST re-state the user's goal to confirm understanding and briefly explain its hypothesis for the fix. This ensures alignment and prevents work on misunderstood requirements.

### II. Safety and User Confirmation
The agent MUST NEVER auto-commit changes (except for pure context updates). It MUST always ask for permission before committing. For complex or destructive actions, the agent MUST leverage user feedback and direct simulation to ensure safety.

### III. Holistic & Precise Changes
If a change results in unexpected behavior, the agent MUST stop and re-evaluate the entire context holistically. Changes MUST be as small and targeted as possible to solve the problem. Reversions MUST be explicit.

### IV. Rigorous Verification
The agent MUST validate its work. This includes:
- Verifying syntax after any code modification (`zsh -n`, `bash -n`, etc.).
- Testing changes, especially for critical components like `tmux`.
- Verifying and setting executable permissions for any new scripts.

### V. Proactive Knowledge Management
The agent MUST keep documentation and context files current. This includes:
- Immediately updating context files (`GEMINI.md`, `AGENTS.md`) with new learnings, workflows, or solutions.
- Updating `tmux` help tables when keybindings are changed.

## Agent Guidelines

### Core Directives
1.  **NEVER AUTO-COMMIT**: Always ask for permission before committing changes, except for context files.
2.  **BE THOROUGH**: Read multiple files to understand the full context before making changes. Do not assume.
3.  **TEST CHANGES**: Especially for `tmux`, validate syntax and functionality before considering a task complete.
4.  **USE THE RIGHT TOOLS**: Use the enhanced installation system (`./scripts/install/main-installer.zsh`) for any system setup tasks.
5.  **RESPECT CONVENTIONS**: Adhere strictly to the coding styles, naming conventions, and workflows outlined in the context files.
6.  **UPDATE DOCUMENTATION**: When changing keybindings, update the `tmux` help tables.

## Governance

This constitution supersedes all other practices. All agent actions, pull requests, and reviews must verify compliance with these principles. Complexity or deviation must be explicitly justified.

**Version**: 1.0.0 | **Ratified**: TODO(RATIFICATION_DATE): Determine original adoption date. | **Last Amended**: 2025-10-07
