# AI Second Brain Setup Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Establish a private, local-first repository `ai-brain` at `$HOME/Projects/Personal/Github/ai-brain` for AI-related notes and daily journal logs, integrated with the tmux `second-brain` mode.

**Architecture:** Use `tmux-tpad` plugin definitions to bind popup Neovim editors targeting `notes/inbox.md` and `journal/YYYY/MM/DD.md` in the new repo.

**Tech Stack:** Bash/Zsh, tmux, Neovim, Git, GitHub CLI (`gh`).

## Global Constraints
- Target local repository path: `$HOME/Projects/Personal/Github/ai-brain`
- Repository structure: Markdown files only, structured with `notes/` and `journal/` folders.
- Journal structure: `journal/YYYY/MM/DD.md` files.
- Tmux bindings: Added to the `second-brain` key table (`i` for Notes, `I` for Journal).
- Never commit or push dotfiles changes without explicit user approval.

---

### Task 1: Setup Local & Remote Git Repository

**Files:**
- Create: `$HOME/Projects/Personal/Github/ai-brain/.cursorrules`
- Create: `$HOME/Projects/Personal/Github/ai-brain/notes/inbox.md`
- Create: `$HOME/Projects/Personal/Github/ai-brain/journal/.gitkeep`

**Interfaces:**
- Consumes: None
- Produces: A newly initialized local and remote private git repository under the user's GitHub account.

- [ ] **Step 1: Check GitHub CLI authentication status**

  Run: `gh auth status`
  Expected: Check if logged in. If not logged in, ask the user to authenticate or run `gh auth login`.

- [ ] **Step 2: Create local directories**

  Run: `mkdir -p $HOME/Projects/Personal/Github/ai-brain/notes $HOME/Projects/Personal/Github/ai-brain/journal`
  Expected: Directories created successfully.

- [ ] **Step 3: Create .cursorrules file**

  Create file `$HOME/Projects/Personal/Github/ai-brain/.cursorrules` with the following content:
  ```markdown
  # AI Brain Workspace Rules

  You are assisting in editing and organizing a personal AI Brain. Follow these instructions strictly:

  - **Language & Style**: Use clean, modern Markdown. Prefer bullet points, headers, and code block snippets.
  - **Journal structure**: Daily journal entries live in `journal/YYYY/MM/DD.md`. Each file must start with `# YYYY-MM-DD` as a level 1 header.
  - **Interlinking**: Use double-bracket wikilinks `[[Note Name]]` to connect notes. If linking to a journal entry, use `[[journal/YYYY/MM/DD]]`.
  - **Permanent Notes**: General ideas, setup notes, and templates belong in the `notes/` directory.
  - **No Placeholders**: Never leave TODOs, TBDs, or template stubs in the notes. Write them out fully or omit them.
  ```

- [ ] **Step 4: Create notes/inbox.md starter note**

  Create file `$HOME/Projects/Personal/Github/ai-brain/notes/inbox.md` with the following content:
  ```markdown
  # AI Brain Inbox

  Welcome to your AI Brain. This repository is optimized for collaboration with AI agents.

  ## Quick Links
  - Journal: `journal/`
  - Notes: `notes/`
  ```

- [ ] **Step 5: Create journal/.gitkeep**

  Create file `$HOME/Projects/Personal/Github/ai-brain/journal/.gitkeep` (empty file to ensure directory is tracked by Git).

- [ ] **Step 6: Initialize git repository and create remote**

  Run commands from `$HOME/Projects/Personal/Github/ai-brain`:
  ```bash
  git init
  git checkout -b main
  git add .
  git commit -m "feat: initial commit with workspace structure and rules"
  gh repo create ai-brain --private --source=. --remote=origin --push
  ```
  Expected: Repo created on GitHub, pushed successfully, remote set to `origin`.

---

### Task 2: Configure Tmux-Tpad Variables and Keybindings

**Files:**
- Modify: `/home/lalitmee/dotfiles/tmux/.tmux.conf.local`

**Interfaces:**
- Consumes: Local files `$HOME/Projects/Personal/Github/ai-brain/notes/inbox.md` and `journal/YYYY/MM/DD.md`.
- Produces: Tmux bindings `i` and `I` mapped in `second-brain` table to toggle these files.

- [ ] **Step 1: Open tmux/.tmux.conf.local and insert tpad configs**

  In `tmux/.tmux.conf.local` around line 700 (after the scratchpad and journal definitions), insert:
  ```tmux
  set -g @tpad-ai-notes-cmd "nvim $HOME/Projects/Personal/Github/ai-brain/notes/inbox.md"
  set -g @tpad-ai-notes-title " AI Notes "

  set -g @tpad-ai-journal-cmd 'mkdir -p $HOME/Projects/Personal/Github/ai-brain/journal/$(date +%Y/%m) && nvim $HOME/Projects/Personal/Github/ai-brain/journal/$(date +%Y/%m/%d).md'
  set -g @tpad-ai-journal-title " AI Journal "
  ```

- [ ] **Step 2: Add key bindings to the second-brain table**

  In `tmux/.tmux.conf.local` around line 1130 (after the journal keybindings), insert:
  ```tmux
  # AI Brain
  bind-key -T second-brain i run-shell "#{@tpad-path} toggle ai-notes"
  bind-key -T second-brain I run-shell "#{@tpad-path} toggle ai-journal"
  ```

- [ ] **Step 3: Verify syntax of tmux configuration**

  Verify that there are no syntax errors in the modified files.
  Run: `tmux -f tmux/.tmux.conf.local -L test start-server \; kill-server`
  Expected: Command runs cleanly without configuration syntax errors.

---

### Task 3: Update help tables and reload

**Files:**
- Modify: `tmux/.config/tmux/scripts/popup/help/tables/second-brain.txt`

**Interfaces:**
- Consumes: Modified help text.
- Produces: Refreshed help popup detailing the new `i` and `I` binds.

- [ ] **Step 1: Add help table descriptions**

  In `tmux/.config/tmux/scripts/popup/help/tables/second-brain.txt`, insert the descriptions sorted alphabetically:
  ```text
  i	AI Notes
  I	AI Journal
  ```

- [ ] **Step 2: Reload tmux configuration**

  Run: `tmux source-file ~/.config/tmux/.tmux.conf`
  Expected: Reload finishes without errors.

- [ ] **Step 3: Verify the bindings**
  - Enter second-brain table: `Prefix C-b` (e.g. `C-a C-b`)
  - Press `?` to open help. Verify `i` and `I` are shown.
  - Press `i`. Verify a popup Neovim session opens `$HOME/Projects/Personal/Github/ai-brain/notes/inbox.md`. Close it.
  - Press `I`. Verify a popup Neovim session opens `$HOME/Projects/Personal/Github/ai-brain/journal/YYYY/MM/DD.md`. Close it.
