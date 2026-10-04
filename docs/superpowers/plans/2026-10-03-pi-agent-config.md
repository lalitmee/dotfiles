# Pi Agent Configuration & Dotfiles Integration Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Integrate Pi agent (`@earendil-works/pi-coding-agent`) into the dotfiles repository with a new GNU Stow package `pi`, matching OpenCode and Gemini configurations with the Cobalt2 theme, shared agent skills, shared slash commands, global user directives, and tmux key forwarding.

**Architecture:** Create a `pi/.pi/agent/` stow package structure containing `settings.json`, `APPEND_SYSTEM.md`, and `themes/cobalt2.json`. Deploy via GNU Stow (`stow -v pi`), point resources to existing `~/.agents/skills` and `~/.config/opencode/command`, and configure `extended-keys-format csi-u` in `tmux/.tmux.conf.local`.

**Tech Stack:** GNU Stow, Pi Agent (`@earendil-works/pi-coding-agent`), JSON, Markdown, tmux configuration.

## Global Constraints

- Never auto-commit or push without explicit user approval.
- Never run `./install.sh` without explicit user confirmation.
- Adhere strictly to the Cobalt2 color palette.
- Verify JSON syntax (`jq`) and tmux syntax after changes.
- Preserve untracked credentials (`~/.pi/agent/auth.json`) and session files.

---

### Task 1: Create `pi/.pi/agent/settings.json`

**Files:**
- Create: `pi/.pi/agent/settings.json`

**Interfaces:**
- Consumes: Pi configuration schema from Pi docs
- Produces: Valid JSON configuration pointing to `~/.agents/skills`, `~/.config/opencode/command`, and `cobalt2` theme

- [ ] **Step 1: Create directory hierarchy**
```bash
mkdir -p pi/.pi/agent/themes
```

- [ ] **Step 2: Write `pi/.pi/agent/settings.json`**
```json
{
  "theme": "cobalt2",
  "skills": [
    "~/.agents/skills"
  ],
  "prompts": [
    "~/.config/opencode/command"
  ],
  "defaultTools": [
    "read",
    "bash",
    "edit",
    "write"
  ],
  "enableSkillCommands": true,
  "tuiMode": "fullscreen",
  "quietStartup": "header",
  "autocompleteMaxVisible": 8,
  "terminal": {
    "trueColor": true,
    "showImages": true
  },
  "defaultProjectTrust": "ask",
  "retry": {
    "enabled": true,
    "maxRetries": 3
  }
}
```

- [ ] **Step 3: Validate JSON syntax**
Run: `jq . pi/.pi/agent/settings.json`
Expected: Valid formatted JSON with exit code 0.

---

### Task 2: Create Cobalt2 Theme Definition (`pi/.pi/agent/themes/cobalt2.json`)

**Files:**
- Create: `pi/.pi/agent/themes/cobalt2.json`

**Interfaces:**
- Consumes: Colors from `opencode/.config/opencode/themes/cobalt2-custom.json`
- Produces: Valid theme file matching Pi theme schema

- [ ] **Step 1: Write `pi/.pi/agent/themes/cobalt2.json`**
Write the full theme JSON containing `name`, `appearance: "dark"`, `vars`, and `colors`.

- [ ] **Step 2: Validate JSON syntax**
Run: `jq . pi/.pi/agent/themes/cobalt2.json`
Expected: Valid formatted JSON with exit code 0.

---

### Task 3: Create Global Instructions (`pi/.pi/agent/APPEND_SYSTEM.md`)

**Files:**
- Create: `pi/.pi/agent/APPEND_SYSTEM.md`

**Interfaces:**
- Consumes: Directives from `GEMINI.md` and `AGENTS.md`
- Produces: Markdown instructions appended to Pi system prompt

- [ ] **Step 1: Write `pi/.pi/agent/APPEND_SYSTEM.md`**
```markdown
# User Directives & Preferences

## Core Directives
1. **Confirmation Before Changes**: Always explain proposed changes and ask for explicit user confirmation before modifying or creating files in any project.
2. **Never Auto-Commit**: Do not commit or push changes without explicit user approval.
3. **Iterative Problem-Solving**: Prefer an iterative approach—start with the simplest workable solution and refine it, rather than over-engineering upfront.
4. **Syntax Verification**: Always verify code syntax immediately after making changes to prevent regressions.

## Coding & Tooling Preferences
- **Package Management**: Prefer `yarn` over `npm` whenever JavaScript/Node package management is required.
- **Shell Scripts**: Use fold markers for functions in shell scripts (`# {{{ function_name` and `# }}}`).
- **Dotfiles & Symlinks**: The user's dotfiles are managed via GNU Stow. Never execute `./install.sh` without explicit user confirmation.
- **Git Commits**: Follow Conventional Commits format (`type(scope): description` in imperative lowercase).
```

- [ ] **Step 2: Verify file existence and non-empty content**
Run: `test -s pi/.pi/agent/APPEND_SYSTEM.md`
Expected: Exit code 0.

---

### Task 4: Fine-tune Tmux Extended Keys Configuration

**Files:**
- Modify: `tmux/.tmux.conf.local:349-352`

**Interfaces:**
- Consumes: tmux 3.7c CSI-u recommendation from Pi documentation
- Produces: `set -g extended-keys-format csi-u` in live tmux server

- [ ] **Step 1: Update `tmux/.tmux.conf.local`**
Add `set -g extended-keys-format csi-u` under `# enable extended keys`.

- [ ] **Step 2: Reload tmux configuration**
Run: `tmux source-file ~/.tmux.conf`
Verify: `tmux show-options -g extended-keys-format`
Expected: `extended-keys-format csi-u`

---

### Task 5: Backup Existing Settings & Stow `pi` Package

**Files:**
- Target: `~/.pi/agent/settings.json`, `~/.pi/agent/APPEND_SYSTEM.md`, `~/.pi/agent/themes/`

**Interfaces:**
- Consumes: `pi/` stow package
- Produces: Live symlinks in `~/.pi/agent/`

- [ ] **Step 1: Remove unmanaged 4-line initial settings file**
```bash
rm -f ~/.pi/agent/settings.json
```

- [ ] **Step 2: Stow `pi` package**
Run: `stow -v pi`
Expected: `LINK: .pi/agent/settings.json => ...`, `LINK: .pi/agent/APPEND_SYSTEM.md => ...`, `LINK: .pi/agent/themes => ...`

- [ ] **Step 3: Verify symlinks**
Run: `ls -la ~/.pi/agent/settings.json ~/.pi/agent/APPEND_SYSTEM.md ~/.pi/agent/themes`
Expected: Symlinks pointing to `dotfiles/pi/...`.

---

### Task 6: End-to-End Verification

**Interfaces:**
- Consumes: Pi binary (`pi`), installed extensions, loaded settings
- Produces: Successful startup and resource discovery

- [ ] **Step 1: Test Pi package and extension discovery**
Run: `pi list`
Expected: Output showing loaded packages and resources without syntax errors.

- [ ] **Step 2: Test Pi non-interactive invocation**
Run: `pi -p "echo test" --no-tools` or check `pi --help`
Expected: Executes cleanly without configuration or theme parse errors.

- [ ] **Step 3: Review Git Status**
Run: `git status`
Expected: Untracked files `pi/`, modified `tmux/.tmux.conf.local`, spec and plan docs.
