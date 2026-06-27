# Claude PWA Scratchpad — Design

**Date:** 2026-06-27
**Status:** Approved

## Goal

Add the Claude browser PWA (installed as a Brave app) as an i3 scratchpad,
toggled by an easily-pressed `super` keybinding, following the existing Brave
PWA scratchpad pattern.

## App Identity

Captured via `xprop`:

- **WM_CLASS / instance:** `crx_fmpnliohjhemenmnlpbfagaolkdacoja`
- **app-id:** `fmpnliohjhemenmnlpbfagaolkdacoja`
- **Window title:** "Claude - New chat - Claude"

## Keybinding Decision

No free single `super + <letter>` existed. Chosen resolution:

- **`super + a`** → Claude (mnemonic: **A**nthropic / **A**ssistant), grouped
  with the other assistant PWAs (`super + g` Gemini, `super + c` ChatGPT).
- **`super + ctrl + a`** → alsamixer (relocated from `super + a`). Confirmed
  free; the `super + ctrl + {h,j,k,l}` chord does not include `a`.

## Changes

### 1. `sxhkd/.config/sxhkd/sxhkdrc`

**Relocate alsamixer** from `super + a` to `super + ctrl + a`:

```
# >> audio mixer -> alsamixer
super + ctrl + a
    i3run --summon --title alsamixer -- ghostty --title=alsamixer -e alsamixer
```

**Add Claude** in the assistant group (near Gemini/ChatGPT):

```
# >> assistant -> claude (brave pwa)
super + a
    i3run --summon --instance crx_fmpnliohjhemenmnlpbfagaolkdacoja -- brave-browser --app-id=fmpnliohjhemenmnlpbfagaolkdacoja
```

### 2. `i3/.config/i3/scratchpads.conf`

Append to the `# >> brave pwa scratchpads` block, matching the 1800×1000
centered convention used by all other PWAs:

```
# Claude
for_window [instance="crx_fmpnliohjhemenmnlpbfagaolkdacoja"] floating enable, resize set 1800 1000, move position center
```

### 3. `assignments.json`

**No change.** That file assigns apps to fixed workspaces only (e.g.
Excalidraw → ws6). The other assistant PWAs are not in it, so Claude stays a
pure summon-anywhere scratchpad.

## Help Table

The `sxhkd-cheatsheet` is generated from sxhkdrc comments, so the per-binding
comments are the help table. No separate table to update (CLAUDE.md directive
#3 satisfied).

## Verification

- `sxhkd-reload` (or `super + Escape`) and confirm no parse errors.
- `super + a` summons Claude; pressing again hides it.
- `super + ctrl + a` summons alsamixer.
- Claude window appears floating, centered, sized 1800×1000.
