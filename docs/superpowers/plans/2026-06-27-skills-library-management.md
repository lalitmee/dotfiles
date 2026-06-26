# Centralized Skills Library and Interactive Manager Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Clean up global awesome-skills, set up a local git-tracked `skills-library/` directory, configure workspace-level auto-loading, and build an interactive TUI skill manager using `gum`.

**Architecture:** Centralized dotfiles storage for active skills with workspace auto-loading and an interactive script (`skill-manager`) utilizing `gum` to install, list, enable/disable, and clean up active skills globally or for specific CLIs via symlinks.

**Tech Stack:** Bash, git, curl, jq, gum.

---

## Proposed Changes

### Task 1: Cleanup and Workspace Configuration

**Files:**
- Create: `~/dotfiles/skills-library/` (directory)
- Create: `~/dotfiles/.agents/skills.json`
- Modify: Move `~/dotfiles/.agents/skills/karpathy-guidelines` to `~/dotfiles/skills-library/karpathy-guidelines`
- Delete: `~/dotfiles/.agents/skills/karpathy-guidelines`

- [ ] **Step 1: Create local directory structure**
  
  Run:
  ```bash
  mkdir -p ~/dotfiles/skills-library
  ```

- [ ] **Step 2: Relocate the existing karpathy-guidelines skill**
  
  Run:
  ```bash
  mv ~/dotfiles/.agents/skills/karpathy-guidelines ~/dotfiles/skills-library/karpathy-guidelines
  rm -rf ~/dotfiles/.agents/skills/karpathy-guidelines
  ```

- [ ] **Step 3: Create workspace configuration file `~/dotfiles/.agents/skills.json`**
  
  Create the file [skills.json](file:///home/lalitmee/dotfiles/.agents/skills.json) with this content:
  ```json
  {
    "entries": [
      { "path": "../skills-library" }
    ]
  }
  ```

- [ ] **Step 4: Verify workspace config loading**
  
  Verify the config file exists and has correct json:
  ```bash
  cat ~/dotfiles/.agents/skills.json
  ```

- [ ] **Step 5: Run global cleanup command**
  
  Identify matching skills from `~/.gemini/skills/.antigravity-install-manifest.json` and delete them from `~/.gemini/skills/`.
  
  Run:
  ```bash
  # Read manifest entries, delete them, and delete the manifest file
  if [ -f ~/.gemini/skills/.antigravity-install-manifest.json ]; then
      jq -r '.entries[]' ~/.gemini/skills/.antigravity-install-manifest.json | while read -r entry; do
          if [ -d "$HOME/.gemini/skills/$entry" ]; then
              rm -rf "$HOME/.gemini/skills/$entry"
              echo "Removed: $entry"
          fi
      done
      rm -f ~/.gemini/skills/.antigravity-install-manifest.json
  fi
  ```

---

### Task 2: Implement Interactive Skill Manager Script

**Files:**
- Create: `~/dotfiles/bin/skill-manager`

- [ ] **Step 1: Write interactive skill-manager script**
  
  Create the file [skill-manager](file:///home/lalitmee/dotfiles/bin/skill-manager) with the following content:
  ```bash
  #!/usr/bin/env bash
  
  set -euo pipefail
  
  SKILLS_LIB_DIR="$HOME/dotfiles/skills-library"
  CACHE_FILE="/tmp/antigravity-skills-index.json"
  REPO_INDEX_URL="https://raw.githubusercontent.com/sickn33/antigravity-awesome-skills/main/skills_index.json"
  
  # Target CLI destinations for symlinks
  declare -A CLI_PATHS=(
      ["Claude Code"]="$HOME/.claude/skills"
      ["Cursor"]="$HOME/.cursor/skills"
      ["Gemini CLI"]="$HOME/.gemini/skills"
      ["Codex CLI"]="$HOME/.codex/skills"
  )
  
  ensure_dirs() {
      mkdir -p "$SKILLS_LIB_DIR"
      for cli in "${!CLI_PATHS[@]}"; do
          mkdir -p "${CLI_PATHS[$cli]}"
      done
  }
  
  fetch_index() {
      if [[ ! -f "$CACHE_FILE" ]]; then
          echo "Fetching remote skills list..." >&2
          curl -s "$REPO_INDEX_URL" > "$CACHE_FILE"
      fi
  }
  
  search_install() {
      fetch_index
      
      # Select skill via gum
      local selection
      selection=$(jq -r '.entries[] | "\(.id) - \(.description)"' "$CACHE_FILE" | gum filter --placeholder "Fuzzy search remote skills..." --height 15)
      
      if [[ -z "$selection" ]]; then
          echo "No skill selected."
          return
      fi
      
      local skill_id
      skill_id=$(echo "$selection" | cut -d' ' -f1)
      
      # Target selection
      local selected_clis
      selected_clis=$(printf "%s\n" "${!CLI_PATHS[@]}" | gum choose --no-limit --header "Select CLIs to enable this skill in:" --height 10)
      
      if [[ -z "$selected_clis" ]]; then
          echo "No CLIs selected."
          return
      fi
      
      # Download using git sparse checkout
      local temp_dir
      temp_dir=$(mktemp -d /tmp/ag-skill-dl-XXXXXX)
      
      echo "Downloading $skill_id..."
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
          echo "✓ Saved skill to $dest_dir"
          
          # Create symlinks
          while IFS= read -r cli; do
              if [[ -n "$cli" ]]; then
                  local cli_path="${CLI_PATHS[$cli]}"
                  ln -sf "$dest_dir" "$cli_path/$skill_id"
                  echo "✓ Enabled in $cli: $cli_path/$skill_id"
              fi
          done <<< "$selected_clis"
      else
          echo "Error: Skill $skill_id not found in remote repository."
      fi
      
      rm -rf "$temp_dir"
  }
  
  manage_local() {
      if [[ ! -d "$SKILLS_LIB_DIR" ]] || [[ -z "$(ls -A "$SKILLS_LIB_DIR")" ]]; then
          echo "No local skills found in $SKILLS_LIB_DIR"
          return
      fi
      
      local skill_id
      skill_id=$(ls -1 "$SKILLS_LIB_DIR" | gum filter --placeholder "Select local skill to manage...")
      
      if [[ -z "$skill_id" ]]; then
          echo "No skill selected."
          return
      fi
      
      local dest_dir="$SKILLS_LIB_DIR/$skill_id"
      
      # Check current symlink status
      local options=()
      for cli in "${!CLI_PATHS[@]}"; do
          local cli_path="${CLI_PATHS[$cli]}"
          if [[ -L "$cli_path/$skill_id" ]]; then
              options+=("$cli (Enabled)")
          else
              options+=("$cli (Disabled)")
          fi
      done
      
      local action_choices
      action_choices=$(printf "%s\n" "${options[@]}" | gum choose --no-limit --header "Toggle CLI activation for $skill_id:" --height 10)
      
      # Update symlinks based on selection
      for cli in "${!CLI_PATHS[@]}"; do
          local cli_path="${CLI_PATHS[$cli]}"
          if echo "$action_choices" | grep -q "$cli (Enabled)"; then
              # Keep or create symlink
              ln -sf "$dest_dir" "$cli_path/$skill_id"
              echo "✓ Enabled in $cli"
          else
              # Remove symlink if exists
              if [[ -L "$cli_path/$skill_id" ]]; then
                  rm -f "$cli_path/$skill_id"
                  echo "✗ Disabled in $cli"
              fi
          fi
      done
  }
  
  cleanup_global() {
      echo "Cleaning up all awesome-skills in global paths..."
      # Read manifest entries, delete them
      local manifest="$HOME/.gemini/skills/.antigravity-install-manifest.json"
      if [[ -f "$manifest" ]]; then
          jq -r '.entries[]' "$manifest" | while read -r entry; do
              if [[ -d "$HOME/.gemini/skills/$entry" ]]; then
                  rm -rf "$HOME/.gemini/skills/$entry"
                  echo "Removed global skill: $entry"
              fi
          done
          rm -f "$manifest"
      fi
      echo "Global cleanup done."
  }
  
  main() {
      ensure_dirs
      
      local action
      action=$(gum choose \
          "🔍 Search & Install Skill (Remote)" \
          "🛠️  Manage Local Skills (Enable/Disable in CLIs)" \
          "🧹 Clean Up Global CLI Skills" \
          "🚪 Exit")
          
      case "$action" in
          "🔍 Search & Install Skill (Remote)")
              search_install
              ;;
          "🛠️  Manage Local Skills (Enable/Disable in CLIs)")
              manage_local
              ;;
          "🧹 Clean Up Global CLI Skills")
              cleanup_global
              ;;
          *)
              echo "Exiting."
              ;;
      esac
  }
  
  main "$@"
  ```

- [ ] **Step 2: Make the script executable**
  
  Run:
  ```bash
  chmod +x ~/dotfiles/bin/skill-manager
  ```

- [ ] **Step 3: Verify script syntax**
  
  Run:
  ```bash
  bash -n ~/dotfiles/bin/skill-manager
  ```

---

### Task 3: Implement Global Skill Definition (`skill-manager/SKILL.md`) & Symlinks Setup

**Files:**
- Create: `~/dotfiles/skills-library/skill-manager/SKILL.md`

- [ ] **Step 1: Write `SKILL.md` for `skill-manager`**
  
  Create the file [SKILL.md](file:///home/lalitmee/dotfiles/skills-library/skill-manager/SKILL.md) with this content:
  ```markdown
  ---
  name: skill-manager
  description: Manage and install active agentic skills. Use when the user asks to search, install, list, or enable/disable skills.
  ---
  
  # Skill Manager
  
  Manage your local central library of skills and download new on-demand skills from the awesome-skills repository.
  
  ## Usage
  
  To search, install, toggle, or clean up skills, run the interactive manager in your terminal:
  
  ```text
  ~/dotfiles/bin/skill-manager
  ```
  ```

- [ ] **Step 2: Symlink `skill-manager` to make it globally available**
  
  Run:
  ```bash
  ln -sf ~/dotfiles/skills-library/skill-manager ~/.gemini/skills/skill-manager
  ln -sf ~/dotfiles/skills-library/skill-manager ~/.claude/skills/skill-manager
  ```

---

## Verification Plan

### Automated Tests
- Validate bash syntax of the manager script: `bash -n ~/dotfiles/bin/skill-manager`

### Manual Verification
1. Run `~/dotfiles/bin/skill-manager` and select `🛠️ Manage Local Skills`. Ensure it lists the relocated `karpathy-guidelines` and `skill-manager`.
2. Toggle `karpathy-guidelines` active for Gemini CLI, and verify symlink is created at `~/.gemini/skills/karpathy-guidelines`.
3. Try searching for a new remote skill (e.g. `ab-test-setup`) and verify it installs into `~/dotfiles/skills-library/ab-test-setup` and is symlinked to the selected target CLI.
