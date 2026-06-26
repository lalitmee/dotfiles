# Add OpenCode to Skill Manager Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Add `OpenCode` as a CLI destination in `skill-manager` for enabling and disabling local and remote skills.

**Architecture:** Define `OpenCode` in the `CLI_PATHS` mapping with the path `$HOME/.config/opencode/skills`. Include it in the `fzf` selections for both `search_install()` and `manage_local()`.

**Tech Stack:** Bash, fzf

## Global Constraints

- Indentation: 4 spaces (no tabs), POSIX compliance where possible
- Shebangs: `#!/usr/bin/env bash`
- Variables: Quote all: `"$VARIABLE"`, use `[[ ]]` for conditionals
- Functions: `snake_case` with descriptive names
- Pre-commit checks: Run `pre-commit run --all-files` before finalizing changes
- Git Commit: Subject <= 50 chars (imperative mood, no trailing period), body lines <= 72 chars (bullet points, lowercase start, no capitals unless abbreviations/proper nouns)

---

### Task 1: Update CLI Paths and Selectors in skill-manager

**Files:**
- Modify: `bin/.config/bin/skill-manager:20-27` (Add OpenCode entry to `CLI_PATHS`)
- Modify: `bin/.config/bin/skill-manager:65-72` (Include OpenCode in search selection menu)
- Modify: `bin/.config/bin/skill-manager:130-142` (Include OpenCode in local management selection menu)

**Interfaces:**
- Consumes: Existing `ensure_dirs()`, `search_install()`, `manage_local()`
- Produces: Integration of `OpenCode` in skill-manager options and file system symlinks

- [ ] **Step 1: Read target script segment**

Ensure line ranges are accurate.

- [ ] **Step 2: Add OpenCode to CLI_PATHS map**

Update the target CLI association:

```diff
 declare -A CLI_PATHS=(
     ["Claude Code"]="$HOME/.claude/skills"
     ["Cursor"]="$HOME/.cursor/skills"
     ["Gemini CLI"]="$HOME/.gemini/skills"
     ["Codex CLI"]="$HOME/.codex/skills"
+    ["OpenCode"]="$HOME/.config/opencode/skills"
 )
```

- [ ] **Step 3: Update CLI choices in search_install()**

Add `OpenCode` to the CLI options piped to fzf:

```diff
     # Target selection
     local selected_clis
-    selected_clis=$(printf "%s\n" "Claude Code" "Gemini CLI" "Cursor" "Codex CLI" | "$FZF_BIN" --multi --prompt="Select CLIs to enable skill (Tab to toggle, Enter to confirm) > " --bind="change:first" --height=10 --layout=reverse)
+    selected_clis=$(printf "%s\n" "Claude Code" "Gemini CLI" "Cursor" "Codex CLI" "OpenCode" | "$FZF_BIN" --multi --prompt="Select CLIs to enable skill (Tab to toggle, Enter to confirm) > " --bind="change:first" --height=10 --layout=reverse)
```

- [ ] **Step 4: Update CLI choices in manage_local()**

Include `OpenCode` in local management loops:

```diff
     # Check current symlink status
     local options=()
-    for cli in "Claude Code" "Gemini CLI" "Cursor" "Codex CLI"; do
+    for cli in "Claude Code" "Gemini CLI" "Cursor" "Codex CLI" "OpenCode"; do
         local cli_path="${CLI_PATHS[$cli]}"
```

- [ ] **Step 5: Verify local syntax**

Run: `bash -n bin/.config/bin/skill-manager`
Expected: 0 exit code.


### Task 2: Verification and Checks

**Files:**
- Test: Manual execution of `skill-manager`

- [ ] **Step 1: Run pre-commit checks**

Run: `pre-commit run --all-files`
Expected: Passes.

- [ ] **Step 2: Verify OpenCode directory creation**

Run the script to ensure `~/.config/opencode/skills` gets created automatically:
Run: `./bin/.config/bin/skill-manager` and exit.
Verify: `[[ -d "$HOME/.config/opencode/skills" ]]` returns true.

- [ ] **Step 3: Manually verify symlink toggle**

Run: `./bin/.config/bin/skill-manager`
Action: Select `Manage Local Skills`, select a skill (e.g. `commit`), check if `OpenCode` is listed in the toggles. Enable it and exit.
Verify: `[[ -L "$HOME/.config/opencode/skills/commit" ]]` is true.
Action: Run again, disable it, and verify the symlink is gone.
