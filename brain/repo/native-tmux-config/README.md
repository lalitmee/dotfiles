# Native tmux config migration

This repo-level effort replaces the upstream Oh My Tmux entry point with a
repo-owned native tmux config while preserving the user's effective bindings,
plugins, and Cobalt2 theme behavior.

- Design draft: [`docs/superpowers/specs/2026-10-14-native-tmux-config-design.md`](../../../docs/superpowers/specs/2026-10-14-native-tmux-config-design.md)
- Current phase: design draft written; awaiting user review before implementation planning.
- Safety constraints: no active tmux reload or entry-point replacement until the isolated config passes and rollback is preserved.
