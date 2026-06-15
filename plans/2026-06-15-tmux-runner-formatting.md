# Tmux Runner Output Formatting Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Format the output of commands executed via the tmux runner script (`runner.sh`) using `gum style` and styled boxes to make labels, command names, paths, success/error banners, and exit instructions clearly identifiable.

**Architecture:** 
1. Update the global `gum_style` utility script to support environment variable overrides (`GUM_STYLE_BORDER_COLOR` and `GUM_STYLE_TEXT_COLOR`) in a backwards-compatible manner.
2. Update the temp script creation inside `runner.sh` to use `gum style` inline for styling the `Running:`, `Directory:`, and divider lines.
3. Update the exit state banners inside the temp script to invoke the `gum_style` utility with custom color schemes based on the command's exit code.

**Tech Stack:** Zsh, Tmux, Gum

---

## Color Brainstorming & Options

Here are three distinct color options based on modern aesthetics and your preferred **Cobalt2** color theme:

### Option 1: Cobalt2 Neon (Recommended)
This aligns with the cobalt2 palette, using cyan accents, yellow highlights, and clear semantic success/error coloring.
* **Labels (`Running:`, `Directory:`)**: Bold Cyan (`#00e5ff` or ANSI `81`)
* **Command Name**: Bold Gold/Yellow (`#ffc600` or ANSI `214`)
* **Directory Path**: Soft Slate Gray (`#90a4ae` or ANSI `246`)
* **Success Banner**: Bold Emerald Green border/text (`#3ad900` or ANSI `10`)
* **Failure Banner**: Bold Coral Red border/text (`#ff003c` or ANSI `9`)
* **Exit Info (`Press Ctrl-D...`)**: Dim Indigo/Slate (`#78909c` or ANSI `242`)

### Option 2: Cyberpunk Glow
High contrast neon theme.
* **Labels**: Neon Pink (`#ff007f`)
* **Command Name**: Neon Cyan (`#00f0ff`)
* **Directory Path**: Soft Purple (`#bd93f9`)
* **Success Banner**: Neon Cyan box (`#00f0ff`)
* **Failure Banner**: Neon Pink box (`#ff007f`)
* **Exit Info**: Dark Violet (`#6272a4`)

### Option 3: Minimalist Nord
Understated slate and pastel colors.
* **Labels**: Frost Blue (`#81a1c1`)
* **Command**: Soft Yellow (`#ebcb8b`)
* **Directory**: Pale Gray (`#d8dee9`)
* **Success Banner**: Mint Green box (`#a3be8c`)
* **Failure Banner**: Crimson box (`#bf616a`)
* **Exit Info**: Slate Gray (`#4c566a`)

Option 1 (Cobalt2 Neon) is implemented in the tasks below.

---

## Proposed Changes

### Utilities

#### [MODIFY] [bin/.config/bin/gum_style](file:///home/lalitmee/dotfiles/bin/.config/bin/gum_style#L4-L5)
Enable optional overrides for `border_color` and `text_color` via environment variables.

### Tmux Runner

#### [MODIFY] [tmux/.config/tmux/scripts/popup/runner/runner.sh](file:///home/lalitmee/dotfiles/tmux/.config/tmux/scripts/popup/runner/runner.sh#L100-L139)
Inject styled outputs into the temp execution script using `gum style` and `gum_style`.

---

## Tasks

### Task 1: Add Custom Color Overrides to `gum_style`

**Files:**
- Modify: [bin/.config/bin/gum_style](file:///home/lalitmee/dotfiles/bin/.config/bin/gum_style#L4-L5)

- [ ] **Step 1: Read the configuration section of `gum_style`**
  Verify the current variable assignments around lines 3-6.

- [ ] **Step 2: Update variables to support environment overrides**
  Modify lines 4-5 to:
  ```zsh
  border_color="${GUM_STYLE_BORDER_COLOR:-#00AAFF}"  # Set the border color
  text_color="${GUM_STYLE_TEXT_COLOR:-#FFC600}"      # Set the text color
  ```

- [ ] **Step 3: Verify syntax of `gum_style`**
  Run:
  ```bash
  zsh -n /home/lalitmee/dotfiles/bin/.config/bin/gum_style
  ```

---

### Task 2: Implement Output Styling in `runner.sh`

**Files:**
- Modify: [tmux/.config/tmux/scripts/popup/runner/runner.sh](file:///home/lalitmee/dotfiles/tmux/.config/tmux/scripts/popup/runner/runner.sh#L100-L139)

- [ ] **Step 1: Read the `create_command_script` function in `runner.sh`**
  Review lines 100-139.

- [ ] **Step 2: Replace standard `echo` lines with `gum` styled equivalents**
  Update the script generation in the `cat > "$temp_script" <<EOF` block to:
  ```zsh
  create_command_script() {
      local temp_script
      local current_pane_path_literal
      local command_to_run_literal
  
      temp_script="$(mktemp /tmp/tmux-runner.XXXXXX)"
      current_pane_path_literal="$(printf "%q" "$current_pane_path")"
      command_to_run_literal="$(printf "%q" "$command_to_run")"
  
      cat > "$temp_script" <<EOF
  tmux setw allow-rename off 2>/dev/null
  trap 'echo ""; echo "Process interrupted. Press Enter to close the window."; read; exit' INT
  
  current_pane_path=$current_pane_path_literal
  command_to_run=$command_to_run_literal
  
  if command -v gum >/dev/null 2>&1; then
      running_label="\$(gum style --foreground '#00e5ff' --bold 'Running:')"
      running_val="\$(gum style --foreground '#ffc600' --bold "\$command_to_run")"
      dir_label="\$(gum style --foreground '#00e5ff' --bold 'Directory:')"
      dir_val="\$(gum style --foreground '#95a2b3' --italic "\$current_pane_path")"
      echo "\${running_label} \${running_val}"
      echo "\${dir_label} \${dir_val}"
      gum style --foreground '#00aaff' '───────────────────────────────────'
  else
      echo "Running: \$command_to_run"
      echo "Directory: \$current_pane_path"
      echo "───────────────────────────────────"
  fi
  
  cd -- "\$current_pane_path"
  eval "\$command_to_run"
  exit_code=\$?
  
  if command -v gum_style >/dev/null 2>&1; then
      if [[ \$exit_code -eq 0 ]]; then
          echo ""
          GUM_STYLE_BORDER_COLOR="#3ad900" GUM_STYLE_TEXT_COLOR="#3ad900" gum_style "✅ Command completed successfully"
      elif [[ \$exit_code -eq 130 ]]; then
          echo ""
          GUM_STYLE_BORDER_COLOR="#ffc600" GUM_STYLE_TEXT_COLOR="#ffc600" gum_style "⚠️  Command was interrupted"
      else
          echo ""
          GUM_STYLE_BORDER_COLOR="#ff003c" GUM_STYLE_TEXT_COLOR="#ff003c" gum_style "❌ Command failed with exit code \$exit_code"
      fi
      echo ""
      gum style --foreground '#78909c' --italic "Press Ctrl-D or 'exit' to close this window..."
  else
      if [[ \$exit_code -eq 0 ]]; then
          echo ""
          echo "✅ Command completed successfully"
      elif [[ \$exit_code -eq 130 ]]; then
          echo ""
          echo "⚠️  Command was interrupted"
      else
          echo ""
          echo "❌ Command failed with exit code \$exit_code"
      fi
      echo ""
      echo "Press Ctrl-D or 'exit' to close this window..."
  fi
  
  exec /bin/zsh
  EOF
  
      echo "$temp_script"
  }
  ```

- [ ] **Step 3: Verify syntax of `runner.sh`**
  Run:
  ```bash
  zsh -n /home/lalitmee/dotfiles/tmux/.config/tmux/scripts/popup/runner/runner.sh
  ```

---

### Task 3: Reload and Verify

**Files:**
- None (manual run)

- [ ] **Step 1: Reload tmux configuration**
  Run:
  ```bash
  tmux source-file ~/.tmux.conf
  ```

- [ ] **Step 2: Simulate keybinding run**
  Run the test trigger from pane `%46` to see the styled layout:
  ```bash
  tmux run-shell -t %46 "zsh /home/lalitmee/.config/tmux/scripts/popup/runner/runner.sh '#{pane_id}' '#{pane_current_path}'"
  ```
