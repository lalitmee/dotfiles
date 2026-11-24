# Unified Multiplexer Keybindings & Dotfiles Integration Plan

> **Scope:** Port the full keybinding grammar and workflow of [tmux.conf](file:///home/lalitmee/dotfiles/tmux/.config/tmux/tmux.conf) and [tmux.conf.local](file:///home/lalitmee/dotfiles/tmux/.config/tmux/tmux.conf.local) into both **`rex-rune` (`0.11.0` + Rex server)** and **`herdr-app` (`0.1.18`)**, track all portable configurations in GNU Stow packages, and reconcile all `next` / `prev` bindings across all three multiplexers.
>
> **Companion Reference:** [Unified Keybindings Matrix](file:///home/lalitmee/dotfiles/plans/2026-11-25-unified-keybindings-matrix.md)

---

## 1. Goal & Philosophy

1. **Identical muscle memory, app-native UX:** Pressing `C-a` (prefix), `C-a C-g` (`git-mode`), `C-a C-b` (`second-brain`), `C-h/j/k/l` (Vim-aware pane navigation with `Alt+h/j/k/l` fallback), `Alt+[/]` (pane cycling), `Ctrl+Shift+K/J` (session/space cycling), and `C-a p/n` (tab/window cycling) should work identically in `tmux`, `rex-rune`, and `herdr-app`.
2. **Respect platform strengths instead of fighting them:**
   - **`rex-rune` + `~/.config/rex/init.lua`** provides native multi-key chords (`>`), named key modes (`client.mode.enter` / `modename/key`), `key_sequence_hints`, Lua 5.1 action callbacks, foreground-process inspection (`com.superlogical.terminal.process`), and native floating layers (`pane.new_floating`, `pane.minimize_layer`, `pane.restore_layer`).
   - **`herdr-app`** has a flat `keys.json` (no native chords, modes, or conditionals), so modal workflows (`C-a`, `C-b`, 11 sub-modes), Vim-aware `C-h/j/k/l`, sequential pane cycling, and persistent scratchpads live in **GPUI-kit JavaScript mods** (`openOverlay`, `terminal.peek`, `panes()`, `exec()`, `run()`).
3. **Decouple tmux IPC where possible:** Scripts that only launch TUIs/editors (`lazygit`, `btm`, `lazydocker`, `gh dash`, `nvim` second-brain files, `ask.sh`, `cht.sh`, `doc-finder.sh`, `kill-process`, `spotify-action.sh`) run cleanly inside Rex floating panes or Herdr overlays. Scripts coupled to `tmux display-popup` / `sesh` / `workmux` / `tmux-tpad` get thin app-specific wrappers.

---

## 2. Conceptual Mapping Across Multiplexers

| Concept | `tmux` | `rex-rune` (`0.11.0` + Rex Server) | `herdr-app` (`0.1.18`) |
| :--- | :--- | :--- | :--- |
| **Top-level workspace** | Session (`#S`) | Session (under Host in sidebar) | Space (`spaces()`) |
| **Page / Tab** | Window (`#I` / `#W`) | Tab (`client.tab.*`) | Tab (`tab.*`, `tabs()`) |
| **Split / Terminal** | Pane (`#P`) | Pane / Block (`pane.*`) | Pane (`pane.*`, `panes()`) |
| **Prefix / Leader** | `set -g prefix C-a` | `rex.bind("ctrl+a>...", ...)` + `key_sequence_hints` | Focusable GPUI overlay mod (`tmux-leader`) |
| **Custom Key Table** | `switch-client -T <table-name>` | `client.mode.enter { name = "<table-name>" }` + `<mode>/<key>` | Sub-mode router inside `tmux-leader` mod |
| **Repeatable Key** | `bind -r <key>` (`repeat-time 600`) | Sticky key mode (`once = false`) exited with `Esc` / `q` | Sticky mode inside `tmux-leader` / `resize` mod |
| **Popup / Scratchpad (`tpad`)** | `display-popup` + `tmux-tpad` | `pane.new_floating` + `pane.minimize_layer` / `restore_layer` | `openOverlay` / `terminal.peek` managed by `scratchpad` mod |
| **Sidebar / Dashboard** | `multiplexer-sidebar`, `workmux sidebar` | `client.sidebar.toggle` (`Ctrl+Shift+B` / `C-a M-s`) | `layout.toggle:sidebar` + custom GPUI mods |
| **Scrollback Copy / Search** | `copy-mode-vi` + `M-e` (`capture-pane` → `nvim`) | `client.search` (`Ctrl+Shift+F`) + Lua `rex capture` → floating `nvim` (`M-e`) | `terminal.search` (`Ctrl+Shift+F`) + `terminal.select` / `adjust_selection` mod + `hc` capture → `nvim` |
| **Session / Window Switcher** | `sesh`, `tmux.expose`, `window-switcher.sh` | `session.switch` (`Ctrl+K`), `rex.ui.pick` | `app.palette` (`Ctrl+Shift+P`), custom picker mod |
| **Vim-Aware Navigation** | `ps` on `#{pane_tty}` in `if-shell` | `rex.block.call("com.superlogical.terminal", "process")` returning `false` when `^n?vim` | `vim-nav` mod inspecting `panes()[i].program.key` (`"nvim"` / `"vim"`) |

---

## 3. Dotfiles & GNU Stow Portability Design

All portable configuration files live in `/home/lalitmee/dotfiles` and are linked via GNU Stow (`stow -D <pkg> && stow <pkg>`). Ephemeral runtime state, UUIDs, window geometry, and generated type definitions stay untracked in `~/.config/`. **Never run `./install.sh` without explicit confirmation.**

### 3.1 `herdr-app` Stow Package (Existing)

| Path | Track in Git? | Purpose & Notes |
| :--- | :--- | :--- |
| `herdr-app/.config/herdr-app/keys.json` | **Yes** | Flat `global` & `terminal` shortcuts (`next`/`prev`, direct 1–9, leader triggers) |
| `herdr-app/.config/herdr-app/settings.json` | **Yes** | Theme (`cobalt2`), font (`MonoLisa Nerd Font`), UI font, zoom |
| `herdr-app/.config/herdr-app/layouts/lalitmee-main.json` | **Yes** | Portable custom workspace layout |
| `herdr-app/.config/herdr-app/themes/` | **Yes** | Custom themes |
| `herdr-app/.config/herdr-app/mods/<custom>/{main.js,mod.json,*.js}` | **Yes** | Portable custom mods: `worktree-keys`, `tmux-leader`, `vim-nav`, `scratchpad`, `history-jump` |
| `~/.config/herdr-app/{AGENTS.md,herdr.d.ts,gpui-kit.d.ts}` | **No** | Generated documentation/type files maintained by `herdr-app` binary |
| `~/.config/herdr-app/{view.json,window.json,shared.json,seen.json,installed.json}` | **No** | Machine-local window geometry, update markers, and session view state |
| `~/.config/herdr-app/{data,frame,icons,telemetry,update-notes*}` | **No** | Runtime state and caches |
| `herdr-app/.config/herdr-app/mods/*/{gpui-kit.d.ts,jsconfig.json}` | **No** | Auto-generated inside mod folders when opened; verify `.gitignore` excludes `herdr-app/.config/herdr-app/mods/*/gpui-kit.d.ts` and `jsconfig.json` before Phase 4 |

### 3.2 `rex` Stow Package (New)

Create a new top-level stow package `rex/` targeting both the Rex server config (`~/.config/rex`) and the Linux client shortcut overrides (`~/.config/rex-linux`):

| Path | Track in Git? | Purpose & Notes |
| :--- | :--- | :--- |
| `rex/.config/rex/init.lua` | **Yes** | Primary portable config: all `rex.bind` chords, 10 named key modes, `rex.action` definitions, Vim-aware `C-h/j/k/l`, Lua floating-scratchpad manager, `M-e` capture-to-nvim. Works across Linux (`rex-rune`) and macOS Rex. |
| `rex/.config/rex/lib/*.lua` (optional split) | **Yes** | Modular helpers (`modes.lua`, `scratchpad.lua`, `vim_nav.lua`) required by `init.lua` |
| `rex/.config/rex-linux/shortcuts.json` | **Yes** | Linux-specific client shortcut overrides/removals (e.g., freeing `ctrl+b` or default conflicts so `init.lua` owns them cleanly) |
| `~/.config/rex-rune/workspace.json` | **No** | Machine-local UI state: `hosts` socket path, `sessions` UUIDs, `window_size`, `last_host`, update settings. **Action:** during Phase 1, remove the 4 existing `recorded_shortcuts` entries in `workspace.json` so `init.lua` / `shortcuts.json` remain the single source of truth. |

**Relinking commands (to run during implementation):**

```bash
stow -d /home/lalitmee/dotfiles -t "$HOME" rex
stow -d /home/lalitmee/dotfiles -t "$HOME" -R herdr-app
```

---

## 4. Next / Prev Alignment Decisions

Ergonomic weight drives the hierarchy: **2 keys (`Alt+[/]`)** for frequent pane cycling, **3 keys (`Ctrl+Shift+K/J`)** for heavier Session/Space transitions, and **`C-a p/n`** (+ `Ctrl+Shift+Tab`/`Ctrl+Tab` and `Ctrl+PageUp/Down`) for Tab/Window cycling.

| Action | Current `tmux` | Current `herdr-app` | Current `rex-rune` | **Unified Target (All 3)** |
| :--- | :--- | :--- | :--- | :--- |
| **Previous / Next Pane (Sequential)** | *(unbound)* | *(only spatial `pane.go`)* | `pane.focus_previous` / `pane.focus_next` *(unbound)* | **`Alt+[` / `Alt+]`** (`M-[` / `M-]`; `JS Mod` `pane-cycle` helper in `herdr-app`) |
| **Previous / Next Session (Space)** | `M-[` / `M-]` *(to sync)* | `ctrl-shift-k` / `ctrl-shift-j` *(already matches!)* | *(unbound)* | **`Ctrl+Shift+K` / `Ctrl+Shift+J`** (`C-S-K` / `C-S-J`) |
| **Previous / Next Tab (Window)** | `C-a Tab`, `C-a 1-9` *(reclaim `n`/`p`)* | `alt-[`/`]`, `ctrl-tab`/`shift-tab`, `ctrl-pgup`/`pgdn` | `ctrl+shift+k` / `ctrl+shift+j` *(remove from `workspace.json`)* | **`C-a p` / `C-a n`** + `Ctrl+Shift+Tab` / `Ctrl+Tab` + `Ctrl+PageUp` / `Ctrl+PageDown` |
| **Move Tab / Window Left / Right** | `C-a C-S-H` / `C-a C-S-L` | *(unbound)* | `client.tab.move.backward` / `forward` *(unbound)* | **`C-a Ctrl+Shift+H` / `C-a Ctrl+Shift+L`** |
| **Spatial Pane Focus (Vim-aware + Fallback)** | `C-h/j/k/l` (Vim-aware) & `C-a h/k/l` | `alt-h/j/k/l`, `alt-left/right` | `pane.focus.*` *(unbound)* | **Vim-aware `Ctrl+h/j/k/l`** (`nvim`/`vim` only) + **`Alt+h/j/k/l`** fallback + **`C-a h/j/k/l`** |
| **Swap / Move Pane** | `C-a q` (prompt), `C-a J` (join) | `alt-shift-h/j/k/l` | `pane.move.*` *(unbound)* | **`Alt+Shift+h/j/k/l`** (spatial) + **`C-a q`** (swap prompt/picker) |
| **History / Jumplist Back & Forward** | `M-,` / `M-.` (`tmux-jumplist`) | *(missing)* | `client.history.back` / `forward` *(unbound)* | **`Alt+,` / `Alt+.`** (`M-,` / `M-.`) |
| **Previous / Next Agent or Prompt** | *(none)* | `alt-up` / `alt-down` (`agent.prev/next`) | `client.prompt.previous/next` *(unbound)* | **`Alt+Up` / `Alt+Down`** (Agent in `herdr-app`, Prompt in `rex-rune`) |
| **Direct Tab / Window 1–9** | `C-a 1..9` | `ctrl-1..9` | `client.tab.goto` *(unbound)* | **`Ctrl+1..9`** and **`C-a 1..9`** |
| **Direct Space / Session 1–9** | *(via `sesh` / `BTab`)* | `alt-1..9` | *(Lua `session.select` list)* | **`Alt+1..9`** |

---

## 5. Phased Implementation Roadmap

### Phase 1: `rex` Stow Package & Core Bindings (`rex-rune`)
1. Create `rex/.config/rex/init.lua` and `rex/.config/rex-linux/shortcuts.json`, then stow `rex`.
2. Clear the 4 `recorded_shortcuts` in `~/.config/rex-rune/workspace.json` so `init.lua` + `shortcuts.json` own all bindings.
3. Implement core bindings:
   - `ctrl+a>ctrl+a` (`pane.send_key`), splits (`-`, `\`, `_`, `"`, `%`), `c` (new tab), `n` / `p` (next/prev tab), `x` (close pane), `X` (close session), `+` (zoom), `W` (`pane.float` / `pane.return_to_tiles` toggle), `Tab` (`session.switch`), `M-s` (`client.sidebar.toggle`).
   - Reconciled Next/Prev bindings: `Alt+[/]` (`pane.focus_previous/next`), `Ctrl+Shift+K/J` (`session.previous/next`), `Ctrl+Tab`/`Ctrl+Shift+Tab` + `Ctrl+PageDown/Up` (`client.tab.next/previous`), `Alt+,/.`, `Alt+Up/Down`, `Ctrl+1..9`, `C-a 1..9`, `C-a Ctrl+Shift+H/L`.
   - Vim-aware `ctrl+h/j/k/l` (strictly `^n?vim` via `rex.block.call("com.superlogical.terminal", "process", { block_id = ctx.block_id })`) + `Alt+h/j/k/l` direct fallback.
   - Sticky `resize` mode (`C-a r` or `C-a H/J/K/L` entering `resize` mode with `h/j/k/l` & `H/J/K/L` and `Esc`/`q` exit).
4. **Verify:** Run `rex config check`, `rex config reload`, `rex keymap`, and smoke-test `nvim` passthrough + pane splits on live `rex-rune 0.11.0`.

### Phase 2: Rex Declarative Sub-Modes (All 11), Floating Scratchpads & Scrollback Edit
1. Implement `rex/.config/rex/lib/modes.lua` as a **single declarative mode/action registry** registering all 11 sub-modes (`file-picker-mode`, `ask-tools`, `ai-tools`, `second-brain`, `layout-mode`, `dev-mode`, `monitor-mode`, `quick-ref`, `spotify-mode`, `git-mode`, `work-sessions`) uniformly via `client.mode.enter` + `<mode>/<key>` + `<mode>/q` (`client.mode.exit`) — zero per-mode boilerplate duplication.
2. Build `rex/.config/rex/lib/scratchpad.lua`: a data-driven registry of all 25 `tpad` entries (e.g., `lazygit` keyed by cwd git root, `lazydocker`, `gh-dash`, `btm`, 13 second-brain org/md files) toggling `pane.new_floating` vs `pane.minimize_layer` / `pane.restore_layer`.
3. Build `M-e` (`rex capture` scrollback → temp file → `pane.new_floating` running `nvim`) and `C-b e/E` (new tab `nvim`).
4. **Verify:** `rex config check`, test `key_sequence_hints` display for every sub-mode, and toggle `C-a g` (`lazygit`) + `C-a C-b n` (`notes-personal`).

### Phase 3: `herdr-app` Flat Keys, Next/Prev Alignment & Optional `tmux.conf.local` Sync
1. Update [keys.json](file:///home/lalitmee/dotfiles/herdr-app/.config/herdr-app/keys.json):
   - Keep `ctrl-shift-k` / `ctrl-shift-j` as `space.prev` / `space.next` (now aligned with `rex-rune`!).
   - Reassign `alt-[` / `alt-]` from `tab.prev/next` → `pane-cycle.prev` / `pane-cycle.next` (via mod command).
   - Keep `ctrl-tab`/`ctrl-shift-tab`, `ctrl-pagedown/up` as `tab.next`/`tab.prev`, `ctrl-1..9` (`tab.select:1..9`), `alt-1..9` (`space.select:1..9`), and `alt-h/j/k/l` as fallback pane navigation.
   - Add leader triggers (`ctrl-a` → `tmux-leader`, `ctrl-b` → `tmux-leader.layout_mode`), `ctrl-h/j/k/l` (`vim-nav`), `alt-,`/`.` (`history-jump`), `alt-e` (`scratchpad.capture_scrollback`).
2. *(Optional sync in [tmux.conf.local](file:///home/lalitmee/dotfiles/tmux/.config/tmux/tmux.conf.local)):* To keep `tmux` 100% aligned with the new `next`/`prev` decisions, update `M-[/]` → `select-pane -t :.-/.+`, add `C-S-K/J` → `switch-client -p/-n` (supported by `extended-keys on`), reclaim `C-a n/p` → `next-window`/`previous-window`, and move `break-pane -d` to standard tmux `C-a !` (with `btm` remaining on `C-a C-m b`).
3. **Verify:** Inspect `herdr-app status` for zero key/mod errors and validate `tmux` reload if synced.

### Phase 4: `herdr-app` Portable GPUI-Kit Mods
Create/stow modular JS mods under `herdr-app/.config/herdr-app/mods/`:
1. **`tmux-leader` mod** (data-driven `modes.js` registry):
   - Focusable hint overlay capturing single-key chords after `C-a` (including `C-a n/p` for tabs, `C-a !` / `W`, splits, etc.), routing uniformly through a single table definition for all 11 nested sub-modes (`C-f`, `A`, `C-i`, `C-b`, `C-d`, `C-m`, `C-q`, `C-e`, `C-g`, `C-w`) + `C-b` (`layout-mode`), plus sticky `resize` mode (`H/J/K/L`) and `C-a C-a` (`send:\u0001`).
   - Built-in `?` cheatsheet filter driven by the same mode table.
2. **`vim-nav` mod** (+ **`pane-cycle`** helper for `Alt+[/]`):
   - Triggered on `ctrl-h/j/k/l` in `terminal` scope; checks `panes().find(p => p.focused)?.program.key` strictly for `"nvim"` or `"vim"` — sends `Ctrl+h/j/k/l` when in Vim, otherwise calls `run("pane.go", { direction })`.
   - `pane-cycle` cycles `panes()` sequentially on `Alt+[/]` and calls `run("pane.focus", { pane })`.
3. **`scratchpad` mod**:
   - Data-driven registry for all 25 `tpad` entries using `openOverlay` (persistent named dialog/window hosting a terminal block) or `terminal.peek` + `terminal.open`, keyed by instance name (`lazygit` per-dir, `lazydocker`, `gh-dash`, `btm`, 13 second-brain files, 4 quick-ref tools).
4. **`history-jump` mod**:
   - Listens to `focused()` transitions to maintain a per-window jump ring for `Alt-,` / `Alt-.`.
5. **Check `.gitignore`** so generated `gpui-kit.d.ts` and `jsconfig.json` inside `herdr-app/.config/herdr-app/mods/*/` are never committed.

### Phase 5: Shared Script Adapters & End-to-End Parity Audit
1. Audit `~/.config/tmux/scripts/` into **standalone scripts** (usable directly by Rex & Herdr) vs **tmux-coupled scripts** (need adapters):
   - **Works standalone:** `ask-sh/ask.sh`, `cht-sh/cht.sh`, `doc-finder.sh`, `~/.config/bin/kill-process`, `git/git-pull-merge.sh`, `apt-repo-manager.sh`, `popup/ai/tool.sh` (non-tmux branch), `popup/ai/update.sh`, `spotify/spotify-action.sh`.
   - **Needs lightweight adapter / native replacement:** `sesh` (`C-a o`/`C-o`/`S`) → `session.switch` / `rex.ui.pick` / Herdr `picker`; `window-switcher.sh` (`C-a Tab`) → `rex.ui.pick` over tabs/windows; `tmux-file-picker` (`C-a C-f`) → small `fd`/`fzf` wrapper writing selection to active Rex/Herdr terminal; `workmux` (`C-a C-g`) → worktree CLI + `herdr-app` `worktree` mod / `rex` worktree helper.

---

## 6. Confirmed Decisions

1. **Next/Prev hierarchy:** `Alt+[/]` = **Pane** prev/next (2 keys); `Ctrl+Shift+K/J` = **Session/Space** prev/next (3 keys); `C-a p/n` (+ `Ctrl+Shift+Tab`/`Ctrl+Tab`, `Ctrl+PageUp/Down`) = **Tab/Window** prev/next.
2. **Reclaimed `C-a n` / `C-a p`:** `C-a n` = next tab/window, `C-a p` = previous tab/window (`btm` stays at `C-a C-m b`; `break-pane` moves to `C-a !` in `tmux.conf.local`).
3. **Spatial pane navigation:** Vim-aware `Ctrl+h/j/k/l` primary, with `Alt+h/j/k/l` kept as direct fallback in `rex-rune` and `herdr-app`.
4. **All 11 sub-modes together, data-driven:** Build a single declarative mode/action registry in Lua (`modes.lua`) and JS (`modes.js`) plus a shared scratchpad registry (`scratchpad.lua` / `scratchpad` mod) rather than 11 separate hand-coded handlers.
5. **`vim-nav` scope:** Strictly `nvim` / `vim` only.
