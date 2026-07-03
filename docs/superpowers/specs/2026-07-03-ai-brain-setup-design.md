# Spec: AI Second Brain Setup

## 1. Problem Statement

The user wants to establish a separate, private, local-first repository (`ai-brain`) to track notes, prompts, system requirements, plans, and session-based logs/discoveries related to LLMs and AI. This should be kept separate from the user's existing Org-mode second-brain. 

The setup needs to:
1. Initialize a private GitHub-connected local repository structured for AI interaction.
2. Integrate this repository into the existing tmux `second-brain` key table with fast popup editor access.
3. Establish prompt rules (`.cursorrules`) at the root of the repository so AI editors interact with it properly.

---

## 2. Proposed Solution

1. Create a private repository `ai-brain` on GitHub (using `gh` CLI if authenticated) and clone/setup locally at `$HOME/Projects/Personal/Github/ai-brain`.
2. Structure the repository with:
   - `notes/inbox.md` for permanent notes/prompts/discoveries.
   - `journal/YYYY/MM/DD.md` for dated daily LLM session logs.
   - `.cursorrules` to instruct editing LLMs to maintain a clean structure.
3. Configure `tmux-tpad` instances for the new paths.
4. Bind `i` (AI Notes) and `I` (AI Journal) in the tmux `second-brain` key table.
5. Update the tmux helper command mapping.

---

## 3. Components

### 3A. Folder Structure & Rules
Inside `$HOME/Projects/Personal/Github/ai-brain`:
- **`notes/`**: Folder for thematic markdown files. `notes/inbox.md` is the landing page.
- **`journal/`**: Nested date folders like `journal/2026/07/03.md`.
- **`.cursorrules`**: Root configuration containing workspace-specific instructions for AI assistants.

**`.cursorrules` Content:**
```markdown
# AI Brain Workspace Rules

You are assisting in editing and organizing a personal AI Brain. Follow these instructions strictly:

- **Language & Style**: Use clean, modern Markdown. Prefer bullet points, headers, and code block snippets.
- **Journal structure**: Daily journal entries live in `journal/YYYY/MM/DD.md`. Each file must start with `# YYYY-MM-DD` as a level 1 header.
- **Interlinking**: Use double-bracket wikilinks `[[Note Name]]` to connect notes. If linking to a journal entry, use `[[journal/YYYY/MM/DD]]`.
- **Permanent Notes**: General ideas, setup notes, and templates belong in the `notes/` directory.
- **No Placeholders**: Never leave TODOs, TBDs, or template stubs in the notes. Write them out fully or omit them.
```

### 3B. Tmux configuration
**File:** `tmux/.tmux.conf.local`

**Changes:**
1. Add `tmux-tpad` configuration variables:
```tmux
set -g @tpad-ai-notes-cmd "nvim $HOME/Projects/Personal/Github/ai-brain/notes/inbox.md"
set -g @tpad-ai-notes-title " AI Notes "

set -g @tpad-ai-journal-cmd 'mkdir -p $HOME/Projects/Personal/Github/ai-brain/journal/$(date +%Y/%m) && nvim $HOME/Projects/Personal/Github/ai-brain/journal/$(date +%Y/%m/%d).md'
set -g @tpad-ai-journal-title " AI Journal "
```

2. Add keybindings in the `second-brain` table:
```tmux
# AI Brain
bind-key -T second-brain i run-shell "#{@tpad-path} toggle ai-notes"
bind-key -T second-brain I run-shell "#{@tpad-path} toggle ai-journal"
```

### 3C. Help Table Update
**File:** `tmux/.config/tmux/scripts/popup/help/tables/second-brain.txt`

**Changes:**
Add the following entries (sorted alphabetically):
```text
i	AI Notes
I	AI Journal
```

---

## 4. Files Modified / Created

| File | Action | Description |
|------|--------|-------------|
| `$HOME/Projects/Personal/Github/ai-brain` | **Create** | Root directory of the new Git repository |
| `ai-brain/.cursorrules` | **Create** | AI assistant guidelines |
| `ai-brain/notes/inbox.md` | **Create** | Entry point for notes |
| `tmux/.tmux.conf.local` | **Edit** | Add tmux-tpad setup & key bindings |
| `tmux/.config/tmux/scripts/popup/help/tables/second-brain.txt` | **Edit** | Add help descriptions |

---

## 5. Verification Plan

1. **Syntax Check**: Verify that `tmux/.tmux.conf.local` syntax is valid.
2. **Reload configuration**: Run `tmux source-file ~/.config/tmux/.tmux.conf` to reload.
3. **Verify Keybinds**:
   - Press `Prefix C-b` then `i`. Verify that a popup opens Neovim editing `$HOME/Projects/Personal/Github/ai-brain/notes/inbox.md`.
   - Press `Prefix C-b` then `I`. Verify that a popup opens Neovim editing `$HOME/Projects/Personal/Github/ai-brain/journal/$(date +%Y/%m/%d).md` (and creates the subfolders if not present).
4. **Help Popup**:
   - Press `Prefix C-b` then `?`. Verify that `i` and `I` are shown in the help table.
