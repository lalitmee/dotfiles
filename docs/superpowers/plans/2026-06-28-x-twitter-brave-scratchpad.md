# Brave X (Twitter) PWA Scratchpad Integration Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Configure the X (Twitter) Brave PWA (`super + t`) as a toggleable i3 scratchpad.

**Architecture:**
1. Add a `super + t` binding in `sxhkdrc` that summons/hides the X Brave PWA via its app-id `lodlkdfmihgonocnmddehnfgiljnadcf`, placed in the scratchpads section near the other social/communication PWAs.
2. Add a `for_window` rule in `scratchpads.conf` to float, size, and center the X PWA window.

**Tech Stack:** i3wm, sxhkd, i3run (i3ass), Brave PWA.

## Global Constraints
- Do not commit or push without explicit user approval.
- Commit messages: Conventional Commits, lowercase (except names/abbreviations like X, PWA, i3), bullet-point bodies, no `Co-Authored-By` trailer.
- After modifying config, reload and verify no parse errors before considering it done.

## App Identity (from xprop)
- **instance / WM_CLASS:** `crx_lodlkdfmihgonocnmddehnfgiljnadcf`
- **app-id:** `lodlkdfmihgonocnmddehnfgiljnadcf`
- **Window title:** `X - (1) Home / X`

## Keybinding Decision
- **`super + t`** → X. Confirmed free (the only active use was a commented-out
  scratch-terminal block at lines 284-286, which stays as a dead comment).
  Single key, mnemonic (**t**witter), faster than any two-modifier chord.

---

### Task 1: Add X keybinding and scratchpad window rule

**Files:**
- Modify: `sxhkd/.config/sxhkd/sxhkdrc` (scratchpads section)
- Modify: `i3/.config/i3/scratchpads.conf` (brave pwa scratchpads block)

**Interfaces:**
- Consumes: existing `i3run --summon --instance crx_<id> -- brave-browser --app-id=<id>` PWA pattern.
- Produces: `super + t` summon/hide binding for X; matching `for_window` float rule.

- [ ] **Step 1: Add the X launcher to sxhkdrc**

  In `sxhkd/.config/sxhkd/sxhkdrc`, add this block in the scratchpads section,
  immediately after the WhatsApp PWA block (the `super + i` communication entry,
  currently lines 361-363):

  ```
  # >> social -> x/twitter (brave pwa)
  super + t
      i3run --summon --instance crx_lodlkdfmihgonocnmddehnfgiljnadcf -- brave-browser --app-id=lodlkdfmihgonocnmddehnfgiljnadcf
  ```

- [ ] **Step 2: Add the i3 window rule**

  In `i3/.config/i3/scratchpads.conf`, append to the `# >> brave pwa scratchpads`
  block (after the Claude line):

  ```
  # X (Twitter)
  for_window [instance="crx_lodlkdfmihgonocnmddehnfgiljnadcf"] floating enable, resize set 1800 1000, move position center
  ```

- [ ] **Step 3: Verify the diffs**

  Run: `git -C /home/lalitmee/dotfiles diff sxhkd/.config/sxhkd/sxhkdrc i3/.config/i3/scratchpads.conf`
  Expected: exactly the two additions above, no other changes.

- [ ] **Step 4: Reload sxhkd and i3, check for parse errors**

  Run:
  ```bash
  ~/.config/bin/sxhkd-reload && i3-msg reload
  ```
  Expected: sxhkd reload exits 0 (no error output); i3 returns `[{"success":true}]`.

- [ ] **Step 5: Manual smoke test**

  Action: Press `super + t`.
  Expected: the X Brave PWA appears, floating, centered, sized 1800×1000.
  Press `super + t` again → it hides.

- [ ] **Step 6: Commit (after user approval)**

  ```bash
  git -C /home/lalitmee/dotfiles add sxhkd/.config/sxhkd/sxhkdrc i3/.config/i3/scratchpads.conf
  git -C /home/lalitmee/dotfiles commit -m "feat(sxhkd): add X (Twitter) PWA scratchpad on super+t

  - bind super+t to summon/hide the X Brave PWA
  - add matching floating window rule in i3 scratchpads.conf (1800x1000, centered)"
  ```

---

## Self-Review

- **Spec coverage:** keybinding (Step 1), i3 float rule (Step 2), verify (Steps 3-5), commit (Step 6). All covered.
- **Placeholder scan:** no TBD/TODO; all code blocks contain exact, final content.
- **Type/string consistency:** instance `crx_lodlkdfmihgonocnmddehnfgiljnadcf` and app-id `lodlkdfmihgonocnmddehnfgiljnadcf` match the xprop capture in every occurrence.
- **assignments.json:** intentionally untouched (consistent with other assistant/social PWAs — summon-anywhere, not workspace-pinned).
