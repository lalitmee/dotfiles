# Conventions Module

Load the relevant section when the task involves it.

## Git worktrees

- Primary repo root: `dirname "$(git rev-parse --path-format=absolute --git-common-dir)"`.
  This stays correct when the current directory is already a worktree or a
  monorepo subdirectory.
- `<project-name>` is the basename of that primary repo root directory.
- Create worktrees only at `<primary-root>/../<project-name>-worktrees/<worktree-name>`.
  Never inside the project root or outside that sibling folder.
- If your environment's built-in worktree feature forces a different path, say
  so and ask before proceeding. Do not silently use the other path.

## Markdown

- Use headings, lists, and correctly tagged code fences.
- Put one blank line around headings, lists, and code fences. These are the
  usual markdownlint triggers.
- If the repo has a markdownlint config, follow it over these defaults.

## Shell scripts

- Wrap functions in fold markers (`# {{{` and `# }}}`).

## Node / JavaScript / TypeScript

- Use `yarn` by default, unless the repo's lockfile (`package-lock.json`,
  `pnpm-lock.yaml`) or its `packageManager` field says otherwise. Never create
  a second lockfile.

## Tmux

- Before adding a key binding, check for conflicts with `tmux list-keys`.
- Comment the purpose of each binding.
- Apply changes with `tmux source-file`. If no tmux server is running, skip the
  reload and report that.
