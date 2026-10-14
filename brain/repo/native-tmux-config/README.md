# Native tmux config migration

This repo-level effort replaces the upstream Oh My Tmux entry point with a
repo-owned native tmux config while preserving the user's effective bindings,
plugins, and Cobalt2 theme behavior.

- Design draft: [`docs/superpowers/specs/2026-10-14-native-tmux-config-design.md`](../../../docs/superpowers/specs/2026-10-14-native-tmux-config-design.md)
- Implementation plan: [`docs/superpowers/plans/2026-10-14-native-tmux-config.md`](../../../docs/superpowers/plans/2026-10-14-native-tmux-config.md)
- Current phase: implementation and authorized cutover complete; post-review corrections are under validation.
- Rollback: timestamped OMT, local-settings, and theme backups remain beside the original home paths; see the baseline report for names and hashes.
- Safety constraints: the active entrypoint and dependencies resolve into the feature worktree; keep it in place until the native config is copied into the primary checkout or an explicit rollback is performed.
