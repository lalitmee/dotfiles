# Neovim vim.pack Migration Design

## Goal

Create a separate Neovim configuration branch that replaces Lazy.nvim with
Neovim's built-in `vim.pack`, then use it as a real-world trial before deciding
whether to keep the migration. Start with eager plugin loading and keep the
implementation deliberately simple. Track existing lazy/trigger-loaded
plugins and trial findings in
`/home/lalitmee/Projects/Personal/Github/ai-brain/notes/neovim-plugin-loading.md`.

## Architecture

- Replace `lua/lazy_init.lua` with a small native `vim.pack` setup.
- Declare and install the existing plugin set through `vim.pack`; make plugins
  available before the existing `utils` and `core` configuration loads.
- Preserve plugin-specific configuration in `lua/plugins/` where practical,
  converting Lazy spec fields into ordinary Lua setup and removing fields that
  only Lazy understands.
- Keep existing plugin selection and conditional behavior. Do not add a custom
  lazy-loading framework.
- Replace Lazy-specific APIs and filesystem paths used by consumers.

## Runtime and plugin state

- Load configured plugins eagerly during startup; do not reproduce event,
  command, filetype, or key-triggered loading.
- Use vim.pack's native lockfile and update flow; `lazy-lock.json` is no longer
  the active lockfile for this branch.
- Translate only build steps needed by existing plugins, using `PackChanged`
  hooks where appropriate.
- Retain local development overrides only where they remain useful and fit the
  native setup.
- The trial requires a Neovim version/build that provides `vim.pack`.

## Plugin-loading inventory

Add the approved note to the ai-brain repository. Record each configured plugin
that currently uses lazy or trigger-based loading, its current trigger, and a
post-migration status. During the trial, add observed regressions and identify
only the triggers worth restoring. Do not create a `superpowers` directory or
put this inventory in the design-doc tree.

## Migration scope

Preserve the existing plugin set and behavior unrelated to Lazy. Remove the
Lazy bootstrap and obsolete active-lockfile references. Migrate integrations
that directly depend on Lazy APIs or paths, including the toggle utility,
CodeCompanion path construction, Snacks picker integration, and plugin reload
helper. Avoid unrelated plugin upgrades, removals, or refactors.

## Validation

- Confirm a clean vim.pack installation/bootstrap and successful startup.
- Run Neovim health checks and targeted checks for integrations that depended
  on Lazy APIs or paths.
- Exercise the current Neovim configuration in normal use during the trial and
  update the ai-brain inventory with outcomes and worthwhile loading triggers.

## Success criteria

- The configuration starts with the existing plugin set installed and loaded
  through `vim.pack`, without requiring Lazy.nvim.
- Existing plugin setup and key workflows work, except for regressions clearly
  recorded for trial evaluation.
- The ai-brain note captures the old trigger inventory and provides a place to
  record trial outcomes.
- The branch remains an evaluation branch; keeping or reverting the migration
  is decided after real use, not assumed by implementation.

## Out of scope

- Reimplementing Lazy's trigger/dependency machinery.
- Removing or replacing plugins for unrelated reasons.
- Pushing the branch or deciding the long-term plugin manager as part of the
  implementation.
