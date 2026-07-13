# Ponytail Config — Design

## Purpose

Track ponytail's configuration in dotfiles via stow, making the mode choice explicit and portable across machines.

## Decision

- **Mode:** `full` (the default ladder: YAGNI → stdlib → native → one line → minimum)
- **Config file:** `~/.config/ponytail/config.json`
- **Tracking:** stow-managed from `ponytail/.config/ponytail/config.json`
- **Why a config file when `full` is the default:** explicit documentation, one-edit mode changes, machine-portability via dotfiles
- **Stow command:** `stow ponytail`

## Config contents

```json
{
  "defaultMode": "full"
}
```

## Scope

Single file, one field. No env vars, no multiple configs, no repo-wide defaults — if needed later they'd get their own design.
