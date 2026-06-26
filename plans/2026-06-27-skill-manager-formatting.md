# Skill Manager Color Formatting Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Format the enabled/disabled status text in `skill-manager` with distinct colors, and update success messages/icons to match the Cobalt2 theme palette.

**Architecture:** Define ANSI color constants at the top of `skill-manager`. Pass the `--ansi` flag to the `fzf` command inside `manage_local()` to interpret colorized list options. Update `echo` commands outputting status and success messages to use `echo -e` with ANSI escape sequences.

**Tech Stack:** Bash, fzf, jq

## Global Constraints

- Indentation: 4 spaces (no tabs), POSIX compliance where possible
- Shebangs: `#!/usr/bin/env bash`
- Variables: Quote all: `"$VARIABLE"`, use `[[ ]]` for conditionals
- Functions: `snake_case` with descriptive names
- Pre-commit checks: Run `pre-commit run --all-files` before finalizing changes
- Git Commit: Subject <= 50 chars (imperative mood, no trailing period), body lines <= 72 chars (bullet points, lowercase start, no capitals unless abbreviations/proper nouns)

---

### Task 1: Add ANSI Color Constants and Colorize Status List

**Files:**
- Modify: `bin/.config/bin/skill-manager:5-26` (Define color constants)
- Modify: `bin/.config/bin/skill-manager:114-130` (Colorize Enabled/Disabled status and update fzf with `--ansi`)

**Interfaces:**
- Consumes: Existing `ensure_dirs()`, `manage_local()`
- Produces: Colorized local management list options rendered in `fzf`

- [ ] **Step 1: Read target script segment**

Read the existing imports and `manage_local` function to ensure lines are targeted correctly.

- [ ] **Step 2: Add Cobalt2 ANSI color constants**

Insert the following color definitions below the `REPO_INDEX_URL` setting:

```bash
# Cobalt2 theme-inspired ANSI colors
COLOR_SUCCESS="\e[1;32m"      # Bright green (success checkmark, Enabled status)
COLOR_PRIMARY="\e[1;33m"      # Yellow (primary text/accent highlight)
COLOR_ACCENT="\e[1;35m"       # Pink (accent highlight)
COLOR_INFO="\e[1;34m"         # Blue (information)
COLOR_DANGER="\e[1;31m"       # Red (error cross, Disabled status)
COLOR_RESET="\e[0m"
```

- [ ] **Step 3: Colorize Enabled and Disabled status labels**

Update `manage_local()` to format `[Enabled]` and `[Disabled]` status text using color constants and pass `--ansi` to the `fzf` command.

```diff
     # Check current symlink status
     local options=()
     for cli in "Claude Code" "Gemini CLI" "Cursor" "Codex CLI"; do
         local cli_path="${CLI_PATHS[$cli]}"
         local padded_cli
         padded_cli=$(printf "%-15s" "$cli")
         if [[ -L "$cli_path/$skill_id" ]]; then
-            options+=("$padded_cli [Enabled]")
+            options+=("${padded_cli} ${COLOR_SUCCESS}[Enabled]${COLOR_RESET}")
         else
-            options+=("$padded_cli [Disabled]")
+            options+=("${padded_cli} ${COLOR_DANGER}[Disabled]${COLOR_RESET}")
         fi
     done

     local action_choices
-    action_choices=$(printf "%s\n" "${options[@]}" | "$FZF_BIN" --multi --prompt="Toggle CLI activation for $skill_id (Tab to toggle, Enter to confirm) > " --bind="change:first" --height=10 --layout=reverse)
+    action_choices=$(printf "%s\n" "${options[@]}" | "$FZF_BIN" --ansi --multi --prompt="Toggle CLI activation for $skill_id (Tab to toggle, Enter to confirm) > " --bind="change:first" --height=10 --layout=reverse)
```

- [ ] **Step 4: Verify local syntax**

Run: `bash -n bin/.config/bin/skill-manager`
Expected: Passes without syntax errors.


### Task 2: Colorize Success Messages and Icons

**Files:**
- Modify: `bin/.config/bin/skill-manager:34-40` (Colorize fetch information)
- Modify: `bin/.config/bin/skill-manager:65-95` (Colorize download/install messages)
- Modify: `bin/.config/bin/skill-manager:130-145` (Colorize enable/disable status outcomes)
- Modify: `bin/.config/bin/skill-manager:147-162` (Colorize cleanup messages)

**Interfaces:**
- Consumes: Task 1 ANSI Color constants
- Produces: Colorized terminal status output for all management operations

- [ ] **Step 1: Colorize fetch message**

Update the message in `fetch_index()`:

```diff
 fetch_index() {
     if [[ ! -f "$CACHE_FILE" ]]; then
-        echo "Fetching remote skills list..." >&2
+        echo -e "${COLOR_INFO}Fetching remote skills list...${COLOR_RESET}" >&2
         curl -s "$REPO_INDEX_URL" > "$CACHE_FILE"
     fi
 }
```

- [ ] **Step 2: Colorize download & installation messages**

Update `search_install()` outputs to use color:

```diff
-    echo "Downloading $skill_id..."
+    echo -e "${COLOR_PRIMARY}Downloading $skill_id...${COLOR_RESET}"
     cd "$temp_dir"
     git init -q
     git remote add origin https://github.com/sickn33/antigravity-awesome-skills.git
     git config core.sparseCheckout true
     echo "skills/$skill_id/*" >> .git/info/sparse-checkout
     git pull -q --depth=1 origin main
 
     local dest_dir="$SKILLS_LIB_DIR/$skill_id"
     if [[ -d "skills/$skill_id" ]]; then
         mkdir -p "$dest_dir"
         cp -r "skills/$skill_id/"* "$dest_dir/"
-        echo "✓ Saved skill to $dest_dir"
+        echo -e "${COLOR_SUCCESS}✓${COLOR_RESET} ${COLOR_PRIMARY}Saved skill to $dest_dir${COLOR_RESET}"
 
         # Create symlinks
         while IFS= read -r cli; do
             if [[ -n "$cli" ]]; then
                 local cli_path="${CLI_PATHS[$cli]}"
                 ln -sf "$dest_dir" "$cli_path/$skill_id"
-                echo "✓ Enabled in $cli: $cli_path/$skill_id"
+                echo -e "${COLOR_SUCCESS}✓${COLOR_RESET} ${COLOR_PRIMARY}Enabled in $cli:${COLOR_RESET} \e[2m$cli_path/$skill_id\e[0m"
             fi
         done <<< "$selected_clis"
     else
-        echo "Error: Skill $skill_id not found in remote repository."
+        echo -e "${COLOR_DANGER}Error:${COLOR_RESET} ${COLOR_PRIMARY}Skill $skill_id not found in remote repository.${COLOR_RESET}"
     fi
```

- [ ] **Step 3: Colorize local enablement/disablement messages**

Update `manage_local()` outputs:

```diff
     # Update symlinks based on selection
     for cli in "${!CLI_PATHS[@]}"; do
         local cli_path="${CLI_PATHS[$cli]}"
         if echo "$action_choices" | grep -q "$cli"; then
             # Keep or create symlink
             ln -sf "$dest_dir" "$cli_path/$skill_id"
-            echo "✓ Enabled in $cli"
+            echo -e "${COLOR_SUCCESS}✓${COLOR_RESET} ${COLOR_PRIMARY}Enabled in $cli${COLOR_RESET}"
         else
             # Remove symlink if exists
             if [[ -L "$cli_path/$skill_id" ]]; then
                 rm -f "$cli_path/$skill_id"
-                echo "✗ Disabled in $cli"
+                echo -e "${COLOR_DANGER}✗${COLOR_RESET} ${COLOR_PRIMARY}Disabled in $cli${COLOR_RESET}"
             fi
         fi
     done
```

- [ ] **Step 4: Colorize cleanup messages**

Update `cleanup_global()` outputs:

```diff
 cleanup_global() {
-    echo "Cleaning up all awesome-skills in global paths..."
+    echo -e "${COLOR_PRIMARY}Cleaning up all awesome-skills in global paths...${COLOR_RESET}"
     # Read manifest entries, delete them
     local manifest="$HOME/.gemini/skills/.antigravity-install-manifest.json"
     if [[ -f "$manifest" ]]; then
         jq -r '.entries[]' "$manifest" | while read -r entry; do
             if [[ -d "$HOME/.gemini/skills/$entry" ]]; then
                 rm -rf "$HOME/.gemini/skills/$entry"
-                echo "Removed global skill: $entry"
+                echo -e "${COLOR_SUCCESS}✓${COLOR_RESET} ${COLOR_PRIMARY}Removed global skill: $entry${COLOR_RESET}"
             fi
         done
         rm -f "$manifest"
     fi
-    echo "Global cleanup done."
+    echo -e "${COLOR_SUCCESS}✓${COLOR_RESET} ${COLOR_PRIMARY}Global cleanup done.${COLOR_RESET}"
 }
```


### Task 3: Verification and Checks

**Files:**
- Test: Manual execution of `skill-manager`

- [ ] **Step 1: Validate file syntax**

Run: `bash -n bin/.config/bin/skill-manager`
Expected: 0 exit code.

- [ ] **Step 2: Run pre-commit checks**

Run: `pre-commit run --all-files`
Expected: Passes.

- [ ] **Step 3: Manually test the manager**

Run the skill manager interactively:
```bash
./bin/.config/bin/skill-manager
```
Go to `Manage Local Skills`, select `commit`, and verify:
- The menu lists `[Enabled]` in bold bright green.
- The menu lists `[Disabled]` in bold bright red.
- Confirming selection prints colorized success output with cobalt2 checkmark icons.
