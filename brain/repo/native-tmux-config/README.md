# Native tmux config migration

This repo-level effort replaces the upstream Oh My Tmux entry point with a
repo-owned native tmux config while preserving the user's effective bindings,
plugins, and Cobalt2 theme behavior.

- Design draft: [`docs/superpowers/specs/2026-10-14-native-tmux-config-design.md`](../../../docs/superpowers/specs/2026-10-14-native-tmux-config-design.md)
- Implementation plan: [`docs/superpowers/plans/2026-10-14-native-tmux-config.md`](../../../docs/superpowers/plans/2026-10-14-native-tmux-config.md)
- Current phase: native configuration is integrated into `main`, active from the primary checkout, and verified against the live tmux server. The entry point moved to the XDG path `~/.config/tmux/tmux.conf` (repo `tmux/.config/tmux/tmux.conf`); TPM plugins live at `~/.config/tmux/plugins`, and `~/.tmux.conf`, `~/.tmux.conf.local`, and the OMT `~/.tmux` clone are retired.
- Rollback: OMT entrypoint backups and the pre-native legacy theme are preserved in `$HOME`; the original OMT backup hashes and paths are recorded in the baseline report.
- Safety constraints: home tmux paths resolve into the primary checkout; retain the rollback copies until the native setup has been used successfully.
