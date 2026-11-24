# Unified Keybindings Matrix: `tmux` ↔ `rex-rune` ↔ `herdr-app`

> **Companion Plan:** [Unified Multiplexer Keybindings & Dotfiles Integration Plan](file:///home/lalitmee/dotfiles/plans/2026-11-25-unified-multiplexer-keybindings-plan.md)
>
> **Legend (Parity Status):**
> - `Native` — Supported directly via built-in action / `rex.bind` / `keys.json`
> - `Lua Helper` — Implemented in `~/.config/rex/init.lua` via Lua 5.1 + `rex` API
> - `JS Mod` — Implemented via GPUI-kit mod under `herdr-app/.config/herdr-app/mods/`
> - `Adapter Needed` — External script currently calls `tmux` IPC and needs a generic / app-specific wrapper
> - `Gap` — No direct equivalent; documented workaround provided

---

## Table 1: Next / Prev & Direct Navigation (Reconciled)

| Key | Action | `tmux` (`tmux.conf.local`) | `rex-rune` (`init.lua` / `shortcuts.json`) | `herdr-app` (`keys.json` / Mod) | Parity (`rex` / `herdr`) |
| :--- | :--- | :--- | :--- | :--- | :--- |
| `Alt+[` (`M-[`) | Previous pane (sequential, 2 keys) | `select-pane -t :.-` *(optional sync edit)* | `pane.focus_previous` | `pane-cycle.prev` (`JS Mod` over `panes()`) | `Native` / `JS Mod` |
| `Alt+]` (`M-]`) | Next pane (sequential, 2 keys) | `select-pane -t :.+` *(optional sync edit)* | `pane.focus_next` | `pane-cycle.next` (`JS Mod` over `panes()`) | `Native` / `JS Mod` |
| `Ctrl+Shift+K` | Previous session / space (3 keys) | `switch-client -p` *(optional sync edit via `extended-keys`)* | `session.previous` | `space.prev` *(matches existing `keys.json`)* | `Native` / `Native` |
| `Ctrl+Shift+J` | Next session / space (3 keys) | `switch-client -n` *(optional sync edit via `extended-keys`)* | `session.next` | `space.next` *(matches existing `keys.json`)* | `Native` / `Native` |
| `C-a p` / `C-a n` | Previous / Next tab (window) | `previous-window` / `next-window` *(reclaimed; optional sync edit)* | `client.tab.previous` / `client.tab.next` | `tab.prev` / `tab.next` (`tmux-leader`) | `Native` / `JS Mod` |
| `Ctrl+PageUp` / `Ctrl+Shift+Tab` | Previous tab (alt) | `previous-window` *(optional)* | `client.tab.previous` | `tab.prev` | `Native` / `Native` |
| `Ctrl+PageDown` / `Ctrl+Tab` | Next tab (alt) | `next-window` *(optional)* | `client.tab.next` | `tab.next` | `Native` / `Native` |
| `C-a Ctrl+Shift+H` | Move tab / window left | `swap-window -t -1 \; select-window -t -1` | `client.tab.move.backward` | `tab.move` (`by: -1` via `tmux-leader` / `keys.json`) | `Native` / `Native` |
| `C-a Ctrl+Shift+L` | Move tab / window right | `swap-window -t +1 \; select-window -t +1` | `client.tab.move.forward` | `tab.move` (`by: +1` via `tmux-leader` / `keys.json`) | `Native` / `Native` |
| `Ctrl+h/j/k/l` | Focus pane L/D/U/R (`nvim`/`vim`-aware) | `if-shell ps ... send-keys \| select-pane` | Lua `is_vim(ctx)` (`^n?vim`) → `false` else `pane.focus.*` | `vim-nav` mod (`nvim`/`vim` only → send or `pane.go`) | `Lua Helper` / `JS Mod` |
| `Alt+h/j/k/l` | Focus pane L/D/U/R (direct fallback) | *(optional)* | `pane.focus.left/down/up/right` | `pane.go:left/down/up/right` | `Native` / `Native` |
| `Alt+Shift+h/j/k/l` | Swap / move pane L/D/U/R | *(via `C-a q`)* | `pane.move.left/down/up/right` | `pane.swap:left/down/up/right` | `Native` / `Native` |
| `Alt+,` (`M-,`) | Jumplist / History back | `tmux-jumplist` back | `client.history.back` | `history-jump` mod (`pane.focus` ring) | `Native` / `JS Mod` |
| `Alt+.` (`M-.`) | Jumplist / History forward | `tmux-jumplist` forward | `client.history.forward` | `history-jump` mod (`pane.focus` ring) | `Native` / `JS Mod` |
| `Alt+Up` | Previous agent / prompt | *(none)* | `client.prompt.previous` | `agent.prev` | `Native` / `Native` |
| `Alt+Down` | Next agent / prompt | *(none)* | `client.prompt.next` | `agent.next` | `Native` / `Native` |
| `Ctrl+1..9` & `C-a 1..9` | Select tab / window 1–9 | `select-window -t 1..9` (`C-a 1..9`) | `client.tab.goto` `{ index = 1..9 }` | `tab.select:1..9` (`ctrl-1..9` + `tmux-leader`) | `Native` / `Native` + `JS Mod` |
| `Alt+1..9` | Select space / session 1–9 | *(via `sesh`)* | Lua `session.list` index select | `space.select:1..9` | `Lua Helper` / `Native` |

---

## Table 2: Root (No-Prefix), Search & Copy Bindings

| Key | Action | `tmux` (`tmux.conf.local`) | `rex-rune` | `herdr-app` | Parity (`rex` / `herdr`) |
| :--- | :--- | :--- | :--- | :--- | :--- |
| `C-a` | Enter prefix mode | `set -g prefix C-a` | `ctrl+a>` chord root | `mod.open:tmux-leader` | `Native` / `JS Mod` |
| `C-b` | Enter `layout-mode` | `bind -T root C-b switch-client -T layout-mode` | `client.mode.enter { name = "layout-mode", once = true }` | `tmux-leader.layout_mode` | `Native` / `JS Mod` |
| `Alt+e` (`M-e`) | Edit pane scrollback in `nvim` | `display-popup` + `capture-pane -p -S -` → `nvim` | Lua `rex capture` → temp file → `pane.new_floating` `nvim` | `scratchpad` mod (`hc` capture → `openOverlay` `nvim`) | `Lua Helper` / `JS Mod` |
| `Ctrl+Shift+F` | Search screen & scrollback | *(copy-mode `/`)* | `client.search` (`libghostty-vt`) | `terminal.search` | `Native` / `Native` |
| `Ctrl+Shift+C` / `V` | Copy / Paste | `tmux-yank` / OSC 52 | `pane.copy` / `pane.paste` | `terminal.copy` / `terminal.paste` | `Native` / `Native` |
| `C-a Enter` | Enter vi copy mode | `copy-mode` (`mode-keys vi`, `v` select, `C-h/j/k/l`, `i`/`Esc` exit) | **Gap** (no vi copy mode; fallback: `client.search` or `M-e` `nvim`) | **Partial** (`terminal.select` + `terminal.adjust_selection` via `vi-copy` mod, or `M-e` `nvim`) | `Gap` / `JS Mod` |
| `Ctrl+Shift+P` | Command Palette | *(via `C-a ?` / `/`)* | `client.palette.toggle` | `app.palette` | `Native` / `Native` |

---

## Table 3: Prefix (`C-a`) Core Window, Pane, Session & Utility Bindings

| Key (`C-a` +) | Action | `tmux` (`tmux.conf` / `tmux.conf.local`) | `rex-rune` (`init.lua`) | `herdr-app` (`tmux-leader` / `keys.json`) | Parity (`rex` / `herdr`) |
| :--- | :--- | :--- | :--- | :--- | :--- |
| `C-a` | Send literal `C-a` to app | `send-prefix` | `pane.send_key { key = "ctrl+a" }` | `send:\u0001` | `Native` / `JS Mod` |
| `c` | New tab/window in cwd | `new-window -c '#{pane_current_path}'` | `client.tab.new` | `tab.new` | `Native` / `Native` |
| `-` / `"` | Split pane horizontally (down) | `split-window -v -c '#{pane_current_path}'` | `pane.split.down` | `pane.split:down` | `Native` / `Native` |
| `\` / `%` / `_` | Split pane vertically (right) | `split-window -h -c '#{pane_current_path}'` | `pane.split.right` | `pane.split:right` | `Native` / `Native` |
| `+` | Zoom / unzoom pane | `resize-pane -Z` | `pane.zoom` | `pane.zoom` | `Native` / `Native` |
| `x` | Kill current pane | `kill-pane` | `pane.close` | `pane.close` | `Native` / `Native` |
| `X` | Kill current session/space | `switch-client -n \; kill-session` | `session.close` | `space.close` (`confirmed: true`) | `Native` / `Native` |
| `n` | Next tab / window *(reclaimed)* | `next-window` *(optional sync edit)* | `client.tab.next` | `tab.next` | `Native` / `JS Mod` |
| `p` | Previous tab / window *(reclaimed)* | `previous-window` *(optional sync edit)* | `client.tab.previous` | `tab.prev` | `Native` / `JS Mod` |
| `!` | Break pane to new window/tab *(moved from `n`)* | `break-pane -d` *(optional sync edit)* | **Gap** (`pane.move_to_new_tab` unsupported in `0.11.0`; fallback: `pane.float`) | **Gap** (fallback: `terminal.peek` / `terminal.park` + `tab.new`) | `Gap` / `Gap` |
| `W` | Toggle pane tiled ↔ floating | `if-shell #{pane_floating_flag} join-pane 'break-pane -W'` | Lua toggle `pane.float` / `pane.return_to_tiles` | `terminal.peek` / `terminal.keep` toggle via `JS Mod` | `Lua Helper` / `JS Mod` |
| `J` | Join pane from prompt (`tmux.conf:20`) | `command-prompt ... join-pane -h -s '%%'` | `rex.ui.pick` pane → `pane.move_to_tab` | `JS Mod` picker → `terminal.show` / `terminal.keep` | `Lua Helper` / `JS Mod` |
| `q` | Swap pane prompt | `display-panes \; command-prompt swap-pane` | `rex.ui.pick` pane → `pane.swap` | `JS Mod` picker → `pane.swap { target }` | `Lua Helper` / `JS Mod` |
| `.` | Move window/tab to index | `move-window-index.sh` | `rex.ui.input` → `client.tab.move` | `JS Mod` prompt → `tab.move { index }` | `Lua Helper` / `JS Mod` |
| `f` | Find window/tab | `find-window -Z` | `session.switch` / `rex.ui.pick` | `app.palette` / `JS Mod` tab filter | `Native` / `JS Mod` |
| `Tab` | Fuzzy window/tab switcher | `display-popup ... window-switcher.sh` | `rex.ui.pick` across tabs (`session.select`) | `JS Mod` fuzzy tab/pane picker | `Lua Helper` / `JS Mod` |
| `BTab` | Native session/space switcher | `new-pane ... switch-mode -ks` | `session.switch` (`Ctrl+K`) | `app.palette` / `spaces` picker | `Native` / `JS Mod` |
| `M-s` | Toggle sidebar | `multiplexer-sidebar --sidebar` | `client.sidebar.toggle` | `layout.toggle:sidebar` | `Native` / `Native` |
| `M-d` | Toggle dashboard | `multiplexer-sidebar` (80% popup) | `pane.new_floating` running `multiplexer-sidebar` | `openOverlay` running `multiplexer-sidebar` or native `spaces`/`agents` | `Lua Helper` / `JS Mod` |
| `h` / `k` / `l` | Select pane L/U/R (repeatable) | `bind -r h/k/l select-pane` | `pane.focus.left/up/right` (sticky `nav` mode optional) | `pane.go:left/up/right` | `Native` / `Native` |
| `H` / `K` / `L` | Resize pane L/U/R (repeatable) | `bind -r H/K/L resize-pane 2` | `pane.resize` + enter `resize` mode (`h/j/k/l`) | `pane.resize` + enter `resize` mod (`h/j/k/l`) | `Lua Helper` / `JS Mod` |
| `C-h/j/k/l` | Fallback raw `Ctrl+h/j/k/l` | `send-keys C-h/j/k/l` | `pane.send_key { key = "ctrl+h/j/k/l" }` | `send:\u0008` / `\u000a` / `\u000b` / `\u000c` | `Native` / `JS Mod` |
| `g` | Toggle `lazygit` popup (per-dir) | `tpad-wrapper.sh toggle lazygit` | `scratchpad.toggle("lazygit", { per_dir = true })` | `scratchpad` mod (`lazygit`, per-dir) | `Lua Helper` / `JS Mod` |
| `D` | Toggle `lazydocker` popup | `tpad-wrapper.sh toggle lazydocker` | `scratchpad.toggle("lazydocker")` | `scratchpad` mod (`lazydocker`) | `Lua Helper` / `JS Mod` |
| `G` | Toggle `gh dash` popup | `tpad-wrapper.sh toggle gh-dash` | `scratchpad.toggle("gh-dash")` | `scratchpad` mod (`gh-dash`) | `Lua Helper` / `JS Mod` |
| `p` *(in `C-a C-m b`)* | Toggle `btm` process viewer *(freed `C-a p` for prev tab)* | `C-a C-m b` (`tpad-wrapper.sh toggle process-viewer`) | `scratchpad.toggle("process-viewer")` (`monitor-mode/b`) | `scratchpad` mod (`process-viewer` via `C-a C-m b`) | `Lua Helper` / `JS Mod` |
| `t` | Toggle `grimoire` scratchpad | `tpad-wrapper.sh toggle grimoire` | `scratchpad.toggle("grimoire")` | `scratchpad` mod (`grimoire`) | `Lua Helper` / `JS Mod` |
| `o` / `C-o` | `sesh` fzf / gum session picker | `sesh/fzf.sh` / `sesh/gum.sh` | `session.switch` / `rex.ui.pick` (projects + sessions) | `picker` / `JS Mod` project+space launcher | `Adapter Needed` |
| `S` | Last session / space | `sesh last` | `client.history.back` (session/tab jump) | `history-jump` mod (last space) | `Lua Helper` / `JS Mod` |
| `N` / `U` | `tmux-sessionizer` / `tmuxinator` | `neww tmux-sessionizer.sh` / `tmuxinator` | `rex.ui.pick` project folder → `session.new` | `space.new` picker mod | `Adapter Needed` |
| `m` | Toggle mouse mode | `set -g mouse on/off` | **Gap** (GUI mouse always active) | **Gap** (`terminal.right_click` toggles program/menu) | `Gap` / `Gap` |
| `b` / `P` | List / choose paste buffer | `list-buffers` / `choose-buffer` | OS clipboard manager / `pane.paste` | OS clipboard manager / `terminal.paste` | `Gap` / `Gap` |
| `r` / `R` | Reload config | `source-file ~/.config/tmux/tmux.conf` | `client.config.reload` | Live-reload automatic on save | `Native` / `Native` |
| `u` | Update plugins | `tpm/bindings/update_plugins` | N/A | N/A | `N/A` |
| `e` | `tmux.expose` mission control | `@tmux-expose-key 'e'` | `session.switch` | `spaces` / `agents` overview | `Gap` / `Gap` |
| `F` / `j` | `tmux-fingers` / `tmux-flash` | Hint copy / jump | **Gap** (no visual hint-jump in `rex-rune` or `herdr-app`) | **Gap** | `Gap` / `Gap` |
| `C-t` / `C-s` | `tome` playbook / scratchpad | `@tome_key` / `@tome_scratch_key` | `scratchpad.toggle("tome-playbook")` | `scratchpad` mod (`tome-playbook`) | `Lua Helper` / `JS Mod` |
| `?` / `/` | Keybinding search / global help | `search-keybindings.sh` / `help.sh global` | `client.shortcuts` / `key_sequence_hints` | `app.help` / `tmux-leader` `?` filter | `Native` / `Native` + `JS Mod` |

---

## Table 4: All 11 Modal Sub-Tables

Each mode is entered via its trigger chord and exited with `q` (or `Esc` in `rex-rune` / `herdr-app`), with `?` displaying that mode's bindings.

### 4.1 `C-a C-f` — `file-picker-mode`

| Key | Action | `tmux` Command | `rex-rune` (`file-picker/`) | `herdr-app` (`tmux-leader`) | Parity |
| :--- | :--- | :--- | :--- | :--- | :--- |
| `f` | File picker (cwd) | `tmux-file-picker` | `pane.new_floating` running `fd+fzf` → `pane.send` | `files` mod / `openOverlay` `fd+fzf` → `send` | `Adapter Needed` |
| `d` | AI docs picker | `ai-docs-picker.sh` | `pane.new_floating` running `ai-docs-picker` | `openOverlay` running `ai-docs-picker` | `Adapter Needed` |
| `g` | File picker (git root) | `tmux-file-picker -g` | `fd+fzf` at git root → `pane.send` | `openOverlay` `fd+fzf` at git root | `Adapter Needed` |
| `z` | Zoxide picker | `tmux-file-picker --zoxide` | `zoxide query -l \| fzf` → `pane.send` | `openOverlay` `zoxide \| fzf` → `send` | `Adapter Needed` |
| `v` | Zoxide (dir only) | `tmux-file-picker --zoxide --dir-only` | `zoxide \| fzf` (cd) | `openOverlay` `zoxide \| fzf` (cd) | `Adapter Needed` |
| `x` | Zoxide (git root) | `tmux-file-picker --zoxide --git-root` | `zoxide` git roots → `fzf` | `openOverlay` `zoxide` git roots | `Adapter Needed` |
| `?` / `q` | Help / Exit mode | `help.sh` / `switch-client -T root` | Hints / `client.mode.exit` | Overlay filter / close `tmux-leader` | `Native` / `JS Mod` |

### 4.2 `C-a A` — `ask-tools`

| Key | Action | `tmux` Command | `rex-rune` (`ask-tools/`) | `herdr-app` (`tmux-leader`) | Parity |
| :--- | :--- | :--- | :--- | :--- | :--- |
| `a` | AI ask | `ask.sh ai` | `pane.new_floating` `zsh -lc '~/.config/tmux/scripts/ask-sh/ask.sh ai'` | `openOverlay` running `ask.sh ai` | `Lua Helper` / `JS Mod` |
| `c` | AI chat | `ask.sh ai-chat` | `pane.new_floating` `ask.sh ai-chat` | `openOverlay` `ask.sh ai-chat` | `Lua Helper` / `JS Mod` |
| `s` | Site search | `ask.sh site` | `pane.new_floating` `ask.sh site` | `openOverlay` `ask.sh site` | `Lua Helper` / `JS Mod` |
| `/` | Web search | `ask.sh search` | `pane.new_floating` `ask.sh search` | `openOverlay` `ask.sh search` | `Lua Helper` / `JS Mod` |
| `d` | Ducky search | `ask.sh ducky` | `pane.new_floating` `ask.sh ducky` | `openOverlay` `ask.sh ducky` | `Lua Helper` / `JS Mod` |
| `b` | Bang search | `ask.sh bang` | `pane.new_floating` `ask.sh bang` | `openOverlay` `ask.sh bang` | `Lua Helper` / `JS Mod` |
| `?` / `q` | Help / Exit mode | `help.sh` / exit | Hints / `client.mode.exit` | Overlay filter / close | `Native` / `JS Mod` |

### 4.3 `C-a C-i` — `ai-tools`

| Key | Action | `tmux` Command | `rex-rune` (`ai-tools/`) | `herdr-app` (`tmux-leader`) | Parity |
| :--- | :--- | :--- | :--- | :--- | :--- |
| `a` | Antigravity | `tool.sh agy` | `pane.new_floating` `agy` (or standalone launcher) | `openOverlay` / `tab.new { argv: ["agy"] }` | `Adapter Needed` |
| `o` | OpenCode | `tool.sh opencode` | `pane.new_floating` `opencode` | `tab.new { argv: ["opencode"] }` / overlay | `Lua Helper` / `JS Mod` |
| `c` | Claude Code | `tool.sh claude` | `pane.new_floating` `claude` | `tab.new { argv: ["claude"] }` / overlay | `Lua Helper` / `JS Mod` |
| `x` | Codex | `tool.sh codex` | `pane.new_floating` `codex` | `tab.new { argv: ["codex"] }` / overlay | `Lua Helper` / `JS Mod` |
| `s` | Crush | `tool.sh crush` | `pane.new_floating` `crush` | `tab.new { argv: ["crush"] }` / overlay | `Lua Helper` / `JS Mod` |
| `k` | Kiro | `tool.sh kiro` | `pane.new_floating` `kiro` | `tab.new { argv: ["kiro"] }` / overlay | `Lua Helper` / `JS Mod` |
| `r` | Grok CLI | `tool.sh grok` | `pane.new_floating` `grok` | `tab.new { argv: ["grok"] }` / overlay | `Lua Helper` / `JS Mod` |
| `p` | Pi Agent | `tool.sh pi` | `pane.new_floating` `pi` | `tab.new { argv: ["pi"] }` / overlay | `Lua Helper` / `JS Mod` |
| `h` | GitHub Copilot | `tool.sh copilot` | `pane.new_floating` `copilot` | `tab.new { argv: ["copilot"] }` / overlay | `Lua Helper` / `JS Mod` |
| `g` | Cursor Agent | `tool.sh cursor-agent` | `pane.new_floating` `cursor-agent` | `tab.new { argv: ["cursor-agent"] }` / overlay | `Lua Helper` / `JS Mod` |
| `n` | Rename chat tab | `rename-chat.sh #{pane_id}` | `rex capture` → rename script → `tab.rename` | `JS Mod` capture → `tab.rename` | `Adapter Needed` |
| `u` / `U` | Update AI tools | `update.sh` (non-int / interactive) | `rex.exec` / `pane.new_floating` `update.sh` | `exec` / `openOverlay` `update.sh` | `Lua Helper` / `JS Mod` |
| `i` / `m` | Manage / install pkg | `manage.sh` / `package-install.sh` | `pane.new_floating` running script (adapter) | `openOverlay` running script (adapter) | `Adapter Needed` |
| `?` / `q` | Help / Exit mode | `help.sh` / exit | Hints / `client.mode.exit` | Overlay filter / close | `Native` / `JS Mod` |

### 4.4 `C-a C-b` — `second-brain`

| Key | Action | `tmux` Command | `rex-rune` (`second-brain/`) | `herdr-app` (`tmux-leader`) | Parity |
| :--- | :--- | :--- | :--- | :--- | :--- |
| `n` / `N` | Personal / Work Notes | `tpad toggle notes-personal/work` | `scratchpad.toggle("notes-personal/work")` | `scratchpad` mod (`notes-personal/work`) | `Lua Helper` / `JS Mod` |
| `t` / `T` | Personal / Work Todos | `tpad toggle todos-personal/work` | `scratchpad.toggle("todos-personal/work")` | `scratchpad` mod (`todos-personal/work`) | `Lua Helper` / `JS Mod` |
| `d` / `D` | Daily Personal / Work Todo | `tpad toggle daily-*-todo` | `scratchpad.toggle("daily-*-todo")` | `scratchpad` mod (`daily-*-todo`) | `Lua Helper` / `JS Mod` |
| `s` / `S` | Personal / Work Scratch | `tpad toggle scratch-personal/work` | `scratchpad.toggle("scratch-personal/work")` | `scratchpad` mod (`scratch-personal/work`) | `Lua Helper` / `JS Mod` |
| `j` / `J` | Personal / Work Journal | `tpad toggle journal-personal/work` | `scratchpad.toggle("journal-personal/work")` | `scratchpad` mod (`journal-personal/work`) | `Lua Helper` / `JS Mod` |
| `i` / `I` | AI Notes / AI Journal | `tpad toggle ai-notes / ai-journal` | `scratchpad.toggle("ai-notes / ai-journal")` | `scratchpad` mod (`ai-notes / ai-journal`) | `Lua Helper` / `JS Mod` |
| `l` | Backup Logs | `tpad toggle backup-logs` | `scratchpad.toggle("backup-logs")` | `scratchpad` mod (`backup-logs`) | `Lua Helper` / `JS Mod` |
| `f` / `g` | Search all (text / file) | `second-brain-search.sh text / file` | `pane.new_floating` `rg+fzf` / `fd+fzf` | `openOverlay` `second-brain-search` (adapter) | `Adapter Needed` |
| `p` / `w` / `a` | Text search (personal / work / ai) | `second-brain-search.sh text <scope>` | `pane.new_floating` `rg+fzf` (`<scope>`) | `openOverlay` `rg+fzf` (`<scope>`) | `Adapter Needed` |
| `k` / `h` / `c` | File search (personal / work / ai) | `second-brain-search.sh file <scope>` | `pane.new_floating` `fd+fzf` (`<scope>`) | `openOverlay` `fd+fzf` (`<scope>`) | `Adapter Needed` |
| `?` / `q` | Help / Exit mode | `help.sh` / exit | Hints / `client.mode.exit` | Overlay filter / close | `Native` / `JS Mod` |

### 4.5 `C-b` — `layout-mode`

| Key | Action | `tmux` Command | `rex-rune` (`layout-mode/`) | `herdr-app` (`tmux-leader` layout) | Parity |
| :--- | :--- | :--- | :--- | :--- | :--- |
| `C-b` | Toggle status/toolbar | `set-option status` | `client.toolbar.toggle` | `layout.switch` or toggle bar block | `Native` / `JS Mod` |
| `f` | Toggle floating pane | `break-pane -W` / `join-pane` | Lua `pane.float` / `pane.return_to_tiles` | `terminal.peek` / `terminal.keep` | `Lua Helper` / `JS Mod` |
| `v` / `H` | Split down / right | `splitw -d` / `splitw -hd` | `pane.split.down` / `pane.split.right` | `pane.split:down` / `pane.split:right` | `Native` / `Native` |
| `q` | Kill bottom pane | `kill-pane -t '#{bottom}'` | `pane.close` (or target bottom via Lua) | `pane.close` | `Lua Helper` / `JS Mod` |
| `h` / `l` | Split L/R (40%) | `splitw -hbp 40` / `-hp 40` | Lua `pane.split` + `pane.resize` | `JS Mod` `pane.split` + `pane.resize` | `Lua Helper` / `JS Mod` |
| `j` / `k` | Split D/U (30%) | `splitw -p 30` / `-bp 30` | Lua `pane.split` + `pane.resize` | `JS Mod` `pane.split` + `pane.resize` | `Lua Helper` / `JS Mod` |
| `n` | Named new window/tab | `command-prompt ... new-window -n` | `rex.ui.input` → `client.tab.new` + `rename` | `tab.new { name }` via prompt | `Lua Helper` / `JS Mod` |
| `C-o` | Search lines (`tsnv`) | `neww tsnv` | `rex.session.new_window` (`tsnv`) | `tab.new { argv: ["tsnv"] }` | `Lua Helper` / `JS Mod` |
| `x` | Kill process (`kill-process`) | `display-popup ... kill-process` | `pane.new_floating` `~/.config/bin/kill-process` | `openOverlay` `kill-process` | `Lua Helper` / `JS Mod` |
| `g` | Git pull/merge popup | `display-popup ... git-pull-merge.sh` | `pane.new_floating` `git-pull-merge.sh` | `openOverlay` `git-pull-merge.sh` | `Lua Helper` / `JS Mod` |
| `e` / `E` | Edit visible / full scrollback | `capture-pane` → `neww nvim` | `rex capture` → new tab `nvim` | `hc` capture → `tab.new` `nvim` | `Lua Helper` / `JS Mod` |
| `m` | Doc finder | `display-popup ... doc-finder.sh` | `pane.new_floating` `doc-finder.sh` | `openOverlay` `doc-finder.sh` | `Lua Helper` / `JS Mod` |
| `?` | Help | `help.sh layout-mode` | Hints (`key_sequence_hints`) | Overlay filter | `Native` / `JS Mod` |

### 4.6 `C-a C-d` (`dev-mode`), `C-a C-m` (`monitor-mode`), `C-a C-q` (`quick-ref`), `C-a C-e` (`spotify-mode`)

| Mode & Key | Action | `tmux` Command | `rex-rune` | `herdr-app` | Parity |
| :--- | :--- | :--- | :--- | :--- | :--- |
| **`C-a C-d` (`dev-mode`)** `e` | Espanso edit | `tpad toggle espanso-edit` | `scratchpad.toggle("espanso-edit")` | `scratchpad` mod (`espanso-edit`) | `Lua Helper` / `JS Mod` |
| `r` | Project runner | `runner.sh` | `pane.new_floating` `runner.sh` (adapter) | `openOverlay` `runner.sh` (adapter) | `Adapter Needed` |
| `a` | APT repo manager | `apt-repo-manager.sh` | `pane.new_floating` `apt-repo-manager.sh` | `openOverlay` `apt-repo-manager.sh` | `Lua Helper` / `JS Mod` |
| `p` | Package installer | `package-install.sh` | `pane.new_floating` `package-install.sh` | `openOverlay` `package-install.sh` | `Adapter Needed` |
| `b` | Back in 5 | `back-in-5/scripts/main.sh` | `pane.new_floating` `back-in-5` | `openOverlay` `back-in-5` | `Lua Helper` / `JS Mod` |
| `s` | Scratchpad | `tpad toggle scratchpad` | `scratchpad.toggle("scratchpad")` | `scratchpad` mod (`scratchpad`) | `Lua Helper` / `JS Mod` |
| `d` | `dact menu` | `neww ... dact menu` | `rex.session.new_window` `dact menu` | `tab.new { argv: ["zsh", "-lc", "~/.local/bin/dact menu"] }` | `Lua Helper` / `JS Mod` |
| **`C-a C-m` (`monitor-mode`)** `b` | Process viewer (`btm`) | `tpad toggle process-viewer` | `scratchpad.toggle("process-viewer")` | `scratchpad` mod (`process-viewer`) | `Lua Helper` / `JS Mod` |
| **`C-a C-q` (`quick-ref`)** `c`/`m`/`g`/`r` | `cht.sh` / `man zsh` / `git help` / Python `re` | `tpad toggle cht-sh/manpage/git-help/regex-test` | `scratchpad.toggle(...)` | `scratchpad` mod (`cht-sh`/`manpage`/`git-help`/`regex-test`) | `Lua Helper` / `JS Mod` |
| **`C-a C-e` (`spotify-mode`)** `p`/`n`/`s`/`u`/`d` | Prev / Next / Play-Pause / Vol +/- | `spotify-action.sh <arg>` | `rex.exec { ".../spotify-action.sh", "<arg>" }` | `exec(".../spotify-action.sh", ["<arg>"])` | `Lua Helper` / `JS Mod` |

### 4.7 `C-a C-g` — `git-mode` & `C-a C-w` — `work-sessions`

| Mode & Key | Action | `tmux` Command | `rex-rune` | `herdr-app` | Parity |
| :--- | :--- | :--- | :--- | :--- | :--- |
| **`C-a C-g`** `w` / `c` / `s` / `d` | Worktree menu / create / switch / delete | `git-worktree.sh [create\|switch\|delete]` | `pane.new_floating` `git-worktree.sh` / `worktree` adapter | Built-in `worktree` mod (`openOverlay` / `worktree-keys`) | `Adapter Needed` / `JS Mod` |
| `m` / `P` | Global worktree manager / PR checkout | `worktree-manager.sh` / `pr-checkout.sh` | `pane.new_floating` script (adapter) | `worktree` mod + `openOverlay` `pr-checkout.sh` | `Adapter Needed` |
| `v` / `p` / `i` | Worktree list / PRs / git status | `workmux list [--pr]` / `status --git` | `pane.new_floating` `git`/`gh` summary adapter | `spaces` mod + `worktree` mod / overlay | `Adapter Needed` |
| `a` / `o` / `r` / `x` / `b` / `.` / `t` / `R` | `workmux` dashboard / diff / palette / sidebar / jumps / resurrect | `workmux dashboard` / `sidebar` / `last-done` / `resurrect` | **Adapter / Gap** (`workmux` is tmux-native; map `.`/`t` to `agent` status / `client.history`) | **Native Alternative**: `herdr-app` `agents` + `spaces` + `changes` mods cover dashboard/diff/status | `Adapter Needed` / `JS Mod` |
| `l` | Worktree logs | `tpad toggle worktree-logs` | `scratchpad.toggle("worktree-logs")` | `scratchpad` mod (`worktree-logs`) | `Lua Helper` / `JS Mod` |
| **`C-a C-w`** `0..5`, `p`, `l`, `k` | Preset repo picker, list, kill work sessions | `work-sessions.sh <0..5\|--list\|--kill>` | `rex.ui.pick` + `session.new`/`close` (adapter) | `openOverlay` repo picker → `space.new`/`close` | `Adapter Needed` |

---

## Table 5: Persistent Scratchpads (`tmux-tpad` — All 25 Instances)

| Category | Instance Name | Target Command (`tmux.conf.local:315-396`) | `rex-rune` Floating Layer | `herdr-app` `scratchpad` Mod |
| :--- | :--- | :--- | :--- | :--- |
| **Utility (12)** | `lazygit` | `lazygit` *(per-dir git root)* | Named floating pane keyed by git root | `openOverlay` keyed by git root |
| | `lazydocker` | `lazydocker` | Named floating pane `"lazydocker"` | `openOverlay` `"lazydocker"` |
| | `gh-dash` | `gh dash` | Named floating pane `"gh-dash"` | `openOverlay` `"gh-dash"` |
| | `process-viewer` | `btm` | Named floating pane `"process-viewer"` | `openOverlay` `"process-viewer"` |
| | `grimoire` | `zsh` | Named floating pane `"grimoire"` | `openOverlay` `"grimoire"` |
| | `scratchpad` | `zsh` *(empty cmd)* | Named floating pane `"scratchpad"` | `openOverlay` `"scratchpad"` |
| | `espanso-edit` | `espanso edit` | Named floating pane `"espanso-edit"` | `openOverlay` `"espanso-edit"` |
| | `cht-sh` | `~/.config/tmux/scripts/cht-sh/cht.sh` | Named floating pane `"cht-sh"` | `openOverlay` `"cht-sh"` |
| | `manpage` | `man zsh` | Named floating pane `"manpage"` | `openOverlay` `"manpage"` |
| | `git-help` | `git help -a \| less` | Named floating pane `"git-help"` | `openOverlay` `"git-help"` |
| | `regex-test` | `python3 -c "import re; help(re)" \| less` | Named floating pane `"regex-test"` | `openOverlay` `"regex-test"` |
| | `worktree-logs` | `nvim ~/.local/share/tmux/logs/git-worktree.log` | Named floating pane `"worktree-logs"` | `openOverlay` `"worktree-logs"` |
| **Second-Brain (13)** | `notes-personal` | `nvim ~/Projects/Personal/Github/second-brain/brain/notes/inbox.org` | Named floating pane `"notes-personal"` | `openOverlay` `"notes-personal"` |
| | `notes-work` | `nvim ~/Projects/Work/Github/second-brain/notes/inbox.org` | Named floating pane `"notes-work"` | `openOverlay` `"notes-work"` |
| | `todos-personal` | `nvim ~/Projects/Personal/Github/second-brain/daily/agenda/todos.org` | Named floating pane `"todos-personal"` | `openOverlay` `"todos-personal"` |
| | `todos-work` | `nvim ~/Projects/Work/Github/second-brain/agenda/todos.org` | Named floating pane `"todos-work"` | `openOverlay` `"todos-work"` |
| | `daily-personal-todo` | `nvim .../daily/agenda/daily/$(date +%Y-%m-%d).org` | Named floating pane `"daily-personal-todo"` | `openOverlay` `"daily-personal-todo"` |
| | `daily-work-todo` | `nvim .../agenda/daily/$(date +%Y-%m-%d).org` | Named floating pane `"daily-work-todo"` | `openOverlay` `"daily-work-todo"` |
| | `scratch-personal` | `nvim .../sandbox/scratch/inbox.org` | Named floating pane `"scratch-personal"` | `openOverlay` `"scratch-personal"` |
| | `scratch-work` | `nvim .../scratch/inbox.org` | Named floating pane `"scratch-work"` | `openOverlay` `"scratch-work"` |
| | `journal-personal` | `nvim .../daily/journal/$(date +%Y-%m-%d).org` | Named floating pane `"journal-personal"` | `openOverlay` `"journal-personal"` |
| | `journal-work` | `nvim .../journal/$(date +%Y-%m-%d).org` | Named floating pane `"journal-work"` | `openOverlay` `"journal-work"` |
| | `ai-notes` | `nvim ~/Projects/Personal/Github/ai-brain/notes/inbox.md` | Named floating pane `"ai-notes"` | `openOverlay` `"ai-notes"` |
| | `ai-journal` | `mkdir -p .../ai-brain/journal/$(date +%Y/%m) && nvim .../$(date +%Y/%m/%d).md` | Named floating pane `"ai-journal"` | `openOverlay` `"ai-journal"` |
| | `backup-logs` | `nvim ~/.local/share/backup-logs/` | Named floating pane `"backup-logs"` | `openOverlay` `"backup-logs"` |
