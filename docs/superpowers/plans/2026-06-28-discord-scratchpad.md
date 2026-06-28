# Discord Scratchpad (Brave PWA) Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Add Discord (Brave PWA) as an i3 scratchpad, with sxhkd keybinding and i3 scratchpad behavior based on its `xprop` attributes.

**Architecture:** Follow existing scratchpad pattern: sxhkd binds keys to `i3run` invocations, i3 config includes `scratchpads.conf` with `for_window` rules matching `instance`/`class` to float and center apps. Discord Brave PWA will be launched via `brave-browser --app-id=...` and identified by its `WM_CLASS`/`instance` from `xprop` (`crx_pliiebkcmokkgndfalahlmimanmbjlab`, `Brave-browser`).

**Tech Stack:** i3, sxhkd, `i3run`, Brave browser PWA, X11 (`xprop`), shell scripts/configs.

## Global Constraints

- i3 config files are under `i3/.config/i3/` and use existing include structure.
- sxhkd config is `sxhkd/.config/sxhkd/sxhkdrc`.
- Scratchpad window rules live in `i3/.config/i3/scratchpads.conf`.
- Follow existing keybinding and scratchpad naming conventions.
- Do not restructure unrelated i3 or sxhkd config sections.

---

### Task 1: Confirm Discord PWA Identification (instance/class)

**Files:**
- Read: `i3/.config/i3/scratchpads.conf`
- Read: `sxhkd/.config/sxhkd/sxhkdrc`

**Interfaces:**
- Consumes: `xprop` attributes for Discord window (provided in spec).
- Produces: Confirmed `instance`/`class` values to be used in i3 `for_window` and `i3run` `--instance`.

- [ ] **Step 1: Launch Discord Brave PWA window**

Run: open Discord as Brave PWA (your existing workflow), ensure a single window is visible.

- [ ] **Step 2: Inspect window with `xprop`**

Run: `xprop`
Click the Discord window.
Expected: output includes:

```text
WM_CLASS(STRING) = "crx_pliiebkcmokkgndfalahlmimanmbjlab", "Brave-browser"
WM_NAME(UTF8_STRING) = "Discord - • Discord | Friends"
WM_WINDOW_ROLE(STRING) = "pop-up"
_NET_WM_WINDOW_TYPE(ATOM) = _NET_WM_WINDOW_TYPE_NORMAL
```

- [ ] **Step 3: Decide matching strategy**

Use primary identifier `instance="crx_pliiebkcmokkgndfalahlmimanmbjlab"` for scratchpad rules (consistent with existing Brave PWA rules in `scratchpads.conf`), and `--instance crx_pliiebkcmokkgndfalahlmimanmbjlab` for `i3run` invocation.

Document this choice directly in the plan and refer to it in later tasks.

---

### Task 2: Add Discord Scratchpad Window Rules in `scratchpads.conf`

**Files:**
- Modify: `i3/.config/i3/scratchpads.conf:35-52` (Brave PWA scratchpads section)

**Interfaces:**
- Consumes: Instance value `crx_pliiebkcmokkgndfalahlmimanmbjlab`.
- Produces: i3 `for_window` rule that floats and centers Discord PWA.

- [ ] **Step 1: Open scratchpad rules file**

Edit: `i3/.config/i3/scratchpads.conf`.

- [ ] **Step 2: Add Discord rule in Brave PWA section**

Locate:

```text
# >> brave pwa scratchpads
# YouTube Music
for_window [instance="crx_cinhimbnkkaeohfgghhklpknlkffjgod"] floating enable, resize set 1800 1000, move position center
# Google Gemini
for_window [instance="crx_gdfaincndogidkdcdkhapmbffkckdkhn"] floating enable, resize set 1800 1000, move position center
# WhatsApp Web
for_window [instance="crx_hnpfjngllnobngcgfapefoaidbinmjnm"] floating enable, resize set 1800 1000, move position center
# musicForProgramming
for_window [instance="crx_jhcembbiknekhcfklaahjjojbciaphaa"] floating enable, resize set 1800 1000, move position center
# NotebookLM
for_window [instance="crx_gjcmcplpgihbecacndmmbaenpfgimlec"] floating enable, resize set 1800 1000, move position center
# ChatGPT
for_window [instance="crx_cadlkienfkclaiaibeoongdcgmdikeeg"] floating enable, resize set 1800 1000, move position center
# Claude
for_window [instance="crx_fmpnliohjhemenmnlpbfagaolkdacoja"] floating enable, resize set 1800 1000, move position center
# X (Twitter)
for_window [instance="crx_lodlkdfmihgonocnmddehnfgiljnadcf"] floating enable, resize set 1800 1000, move position center
```

Add immediately after the existing entries:

```text
# Discord
for_window [instance="crx_pliiebkcmokkgndfalahlmimanmbjlab"] floating enable, resize set 1800 1000, move position center
```

- [ ] **Step 3: Reload i3 and verify behavior**

Run: `i3-msg reload`
Then launch Discord PWA.
Expected: Discord window appears as a floating window, sized approximately 1800x1000, centered on the screen.

---

### Task 3: Add Discord Scratchpad Keybinding in `sxhkdrc`

**Files:**
- Modify: `sxhkd/.config/sxhkd/sxhkdrc:274-393` (scratchpads section)

**Interfaces:**
- Consumes: Existing scratchpad keybinding patterns using `i3run`.
- Produces: New keybinding that toggles Discord PWA scratchpad via `i3run` with `--summon --instance`.

- [ ] **Step 1: Open sxhkd config file**

Edit: `sxhkd/.config/sxhkd/sxhkdrc`.

- [ ] **Step 2: Choose keybinding for Discord**

Within the scratchpads section (lines ~274-393), pick an unused combination. For example, reuse "communication" and social grouping:

Current entries include:

```text
# >> communication -> telegram
super + u
    i3run --class TelegramDesktop --summon --instance telegram-desktop -- telegram-desktop

# >> communication -> whatsapp (brave pwa)
super + i
    i3run --summon --instance crx_hnpfjngllnobngcgfapefoaidbinmjnm -- brave-browser --app-id=hnpfjngllnobngcgfapefoaidbinmjnm

# >> social -> x/twitter (brave pwa)
super + t
    i3run --summon --instance crx_lodlkdfmihgonocnmddehnfgiljnadcf -- brave-browser --app-id=lodlkdfmihgonocnmddehnfgiljnadcf
```

Plan: Add Discord under "communication" or "social". Example: `super + shift + i` or another preferred combo you choose.

- [ ] **Step 3: Add keybinding entry**

Insert a new block, e.g.:

```text
# >> communication -> discord (brave pwa)
super + shift + i
    i3run --summon --instance crx_pliiebkcmokkgndfalahlmimanmbjlab -- brave-browser --app-id=pliiebkcmokkgndfalahlmimanmbjlab
```

Adjust the keybinding if you prefer a different combination, ensuring it does not conflict with existing ones.

- [ ] **Step 4: Reload sxhkd and test keybinding**

Run: `pkill -USR1 sxhkd` or your existing `sxhkd` reload script (`super + Escape` runs `~/.config/bin/sxhkd-reload`).

Then press the chosen keybinding (e.g. `super + shift + i`):

Expected:

1. If Discord PWA is not running: Brave launches Discord PWA window.
2. If Discord PWA is already running but not visible: window is shown as a floating centered scratchpad.
3. If visible: `i3run --summon` toggles/summons the window in a scratchpad-y way similar to other apps (follows existing `i3run` semantics).

---

### Task 4: Verify Integration and Edge Cases

**Files:**
- Read: `i3/.config/i3/config`
- Read: `i3/.config/i3/scratchpads.conf`
- Read: `sxhkd/.config/sxhkd/sxhkdrc`

**Interfaces:**
- Consumes: i3 includes and keybindings semantics.
- Produces: Confidence that Discord scratchpad integrates cleanly and behaves like other scratchpads.

- [ ] **Step 1: Confirm i3 includes scratchpads.conf**

Check `i3/.config/i3/config`:

```text
include $HOME/.config/i3/scratchpads.conf
```

Ensure this line exists and is unchanged.

- [ ] **Step 2: Test Discord scratchpad from different workspaces**

1. Switch to workspace 1.
2. Use Discord keybinding to summon.
3. Switch to workspace 2.
4. Use keybinding again.

Expected: Discord window appears on the current workspace as a floating scratchpad, consistent with other `i3run`-managed apps.

- [ ] **Step 3: Test interactions with fullscreen and tiling**

1. Open a fullscreen app, then summon Discord.
   - Expected: Discord appears over fullscreen, floating and centered.
2. With tiling windows active, summon Discord.
   - Expected: Discord remains floating, not tiled.

- [ ] **Step 4: Test closing and re-summoning**

1. Close Discord window.
2. Press keybinding again.
   - Expected: Brave launches a new Discord PWA window, appearing as scratchpad.

---

### Task 5: Document Keybinding and Behavior (Optional)

**Files:**
- Optional docs location: this plan file or your personal keybinding cheatsheet referenced by `super + alt + s`.

**Interfaces:**
- Consumes: Finalized keybinding choice and behavior.
- Produces: Human-readable note for future reference.

- [ ] **Step 1: Save this plan as documentation**

Plan is saved here as part of the repo:

`docs/superpowers/plans/2026-06-28-discord-scratchpad.md`

- [ ] **Step 2: Optionally update cheatsheet script/data**

If your `~/.config/bin/sxhkd-cheatsheet` uses a static markdown or JSON list of keybindings, add an entry describing the Discord scratchpad keybinding and behavior.

---

## Self-Review

1. **Spec coverage:**  
   - Discord instance/class from `xprop` used for matching.  
   - i3 scratchpad behavior configured via `for_window`.  
   - sxhkd keybinding added using `i3run` pattern.  
   - Integration and behavior verified.

2. **Placeholder scan:**  
   - All steps specify concrete file paths, code/config snippets, and commands. No "TBD"/"appropriate"/"similar to" placeholders.

3. **Type/name consistency:**  
   - Instance string `crx_pliiebkcmokkgndfalahlmimanmbjlab` is used identically in i3 `for_window` and `i3run` `--instance`.  
   - App-id `pliiebkcmokkgndfalahlmimanmbjlab` matches the `WM_CLASS` first component and Brave PWA convention, consistent across steps.

---

Plan complete.
