import { home } from "herdr";

const HOME = home();

export const SCRATCHPADS = {
  "lazygit": { title: "Lazygit", sh: "lazygit", perDir: true },
  "lazydocker": { title: "Lazydocker", sh: "lazydocker" },
  "gh-dash": { title: "GitHub Dash", sh: "gh dash" },
  "process-viewer": { title: "Process Viewer", sh: "btm" },
  "grimoire": { title: "Grimoire Scratchpad", sh: null },
  "scratchpad": { title: "Scratchpad", sh: null },
  "espanso-edit": { title: "Espanso Edit", sh: "espanso edit" },
  "cht-sh": { title: "Cht.sh", sh: `${HOME}/.config/tmux/scripts/cht-sh/cht.sh` },
  "manpage": { title: "Man Page", sh: "man zsh" },
  "git-help": { title: "Git Help", sh: "git help -a | less" },
  "regex-test": { title: "Regex Help", sh: 'python3 -c "import re; help(re)" | less' },
  "worktree-logs": { title: "Worktree Logs", sh: `nvim ${HOME}/.local/share/tmux/logs/git-worktree.log` },
  "tome-playbook": { title: "Tome Playbook", sh: "nvim .playbook.md", perDir: true },

  // Second-brain instances
  "notes-personal": { title: "Personal Notes", sh: `nvim ${HOME}/Projects/Personal/Github/second-brain/brain/notes/inbox.org` },
  "notes-work": { title: "Work Notes", sh: `nvim ${HOME}/Projects/Work/Github/second-brain/notes/inbox.org` },
  "todos-personal": { title: "Personal Todos", sh: `nvim ${HOME}/Projects/Personal/Github/second-brain/daily/agenda/todos.org` },
  "todos-work": { title: "Work Todos", sh: `nvim ${HOME}/Projects/Work/Github/second-brain/agenda/todos.org` },
  "daily-personal-todo": { title: "Daily Personal Todos", sh: `nvim "${HOME}/Projects/Personal/Github/second-brain/daily/agenda/daily/$(date +%Y-%m-%d).org"` },
  "daily-work-todo": { title: "Daily Work Todos", sh: `nvim "${HOME}/Projects/Work/Github/second-brain/agenda/daily/$(date +%Y-%m-%d).org"` },
  "scratch-personal": { title: "Personal Scratchpad", sh: `nvim ${HOME}/Projects/Personal/Github/second-brain/sandbox/scratch/inbox.org` },
  "scratch-work": { title: "Work Scratchpad", sh: `nvim ${HOME}/Projects/Work/Github/second-brain/scratch/inbox.org` },
  "journal-personal": { title: "Personal Journal", sh: `nvim "${HOME}/Projects/Personal/Github/second-brain/daily/journal/$(date +%Y-%m-%d).org"` },
  "journal-work": { title: "Work Journal", sh: `nvim "${HOME}/Projects/Work/Github/second-brain/journal/$(date +%Y-%m-%d).org"` },
  "ai-notes": { title: "AI Notes", sh: `nvim ${HOME}/Projects/Personal/Github/ai-brain/notes/inbox.md` },
  "ai-journal": { title: "AI Journal", sh: `mkdir -p "${HOME}/Projects/Personal/Github/ai-brain/journal/$(date +%Y/%m)" && nvim "${HOME}/Projects/Personal/Github/ai-brain/journal/$(date +%Y/%m/%d).md"` },
  "backup-logs": { title: "Backup Logs", sh: `nvim ${HOME}/.local/share/backup-logs/` },
};
