# Neovim → Zed Port Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Port core Vim keybindings, LSP/Git workflows, snippets, tasks, and LSP configs from Neovim to Zed editor

**Architecture:** Three independent waves — (1) core vim keybindings in keymap.json, (2) built-in parity for LSP/Git/case-conversion/diagnostics in keymap.json, (3) extension configs in snippets/ tasks.json and settings.json

**Tech Stack:** Zed editor keymap.json, settings.json, tasks.json, JSON snippets

## Global Constraints

- All Zed config files live under `zed/.config/zed/` (stowable path)
- Zed snippets are static JSON only — no Lua functions, no regex triggers, no choices
- All action names verified against Zed's default vim.json and key-bindings docs
- `action::Sequence` requires Zed build from Nov 2025 or later
- No plugins, extensions, or installable packages — only config files

---

### Task 1: Wave 1 — Core Vim Keybindings

**Files:**
- Modify: `zed/.config/zed/keymap.json` — add VimControl and normal-mode contexts

**Interfaces:**
- Consumes: existing keymap.json structure (4 context blocks: insert, normal, visual, VimControl)
- Produces: normal-mode tweaks for U/H/L/0/^/n/N/C-d/C-u/BS

- [ ] **Step 1: Add VimControl bindings for n/N/C-d/C-u and update H/L context**

Replace the existing `VimControl && !menu` block to add search centering and scroll centering:

```json
{
    "context": "VimControl && !menu",
    "bindings": {
      "H": ["workspace::SendKeystrokes", "0"],
      "L": ["workspace::SendKeystrokes", "$"],
      "n": ["action::Sequence", ["vim::MoveToNextMatch", "editor::ScrollCursorCenter"]],
      "shift-n": ["action::Sequence", ["vim::MoveToPreviousMatch", "editor::ScrollCursorCenter"]],
      "ctrl-d": ["action::Sequence", ["vim::ScrollDown", "editor::ScrollCursorCenter"]],
      "ctrl-u": ["action::Sequence", ["vim::ScrollUp", "editor::ScrollCursorCenter"]]
    }
}
```

Note: H/L remain as `workspace::SendKeystrokes` because they simulate `0` and `$` which are already valid VimControl bindings. The `ctrl-d`/`ctrl-u` use `action::Sequence` which is confirmed working (Zed discussion #9494, Nov 2025). `n`/`N` override the default `vim::MoveToNextMatch` bindings in the same context.

- [ ] **Step 2: Add normal-mode bindings for U, 0/^, Backspace**

Add to the existing `vim_mode == normal && !menu` context:

```json
      // core vim tweaks
      "U": "vim::Redo",
      "0": "vim::FirstNonWhitespace",
      "^": "vim::StartOfLine",
      "backspace": "pane::GoBack",
```

This goes after the `"enter": "editor::ToggleFold"` line and before the `"shift-y"` line.

- [ ] **Step 3: Verify keymap.json is valid JSON**

Zed will silently ignore malformed keymap.json. Run:

```bash
python3 -m json.tool /home/lalitmee/dotfiles/zed/.config/zed/keymap.json > /dev/null && echo "valid" || echo "invalid"
```

If invalid, fix JSON syntax (trailing commas are the most common issue — Zed allows them but JSON tools don't).

- [ ] **Step 4: Commit**

```bash
git add zed/.config/zed/keymap.json
git commit -m "feat(zed): add core vim keybindings (n/N zz, C-d/C-u zz, U, H/L, 0/^, BS back)"
```

---

### Task 2: Wave 2 — LSP, Git, Case Conversion, Diagnostics

**Files:**
- Modify: `zed/.config/zed/keymap.json` — add LSP leader group, Git group, case conversion, diagnostics

**Interfaces:**
- Consumes: existing `vim_mode == normal && !menu` context block
- Consumes: existing `VimControl && !menu` context block

- [ ] **Step 1: Add LSP group under `space l` in `vim_mode == normal && !menu`**

```json
      // lsp group
      "space l d": "editor::GoToDefinition",
      "space l D": "editor::FindAllReferences",
      "space l r": "editor::Rename",
      "space l n": "editor::GoToDiagnostic",
      "space l h": "editor::Hover",
      "space l a": "editor::ToggleCodeActions",
      "space l i": "editor::GoToImplementation",
      "space l y": "workspace::CopyPath",
      "space l f": "editor::Format",
```

- [ ] **Step 2: Add Git group in normal mode**

Note: Move the existing `"space g s": "workspace::ToggleRightDock"` to the new git section and change it:

```json
      // git group
      "space g s": "git_panel::ToggleFocus",
```

Add these under `VimControl && !menu` (they work in normal + visual mode):

```json
      // git hunks (no leader)
      "g b": "editor::BlameHover",
      "g d": "editor::GoToHunk",
      "g j": "editor::GoToHunk",
      "g k": "editor::GoToPrevHunk",
```

- [ ] **Step 3: Add case conversion operators under `VimControl && !menu`**

```json
      // case conversion (cr operator)
      "c r s": "editor::ConvertToSnakeCase",
      "c r c": "editor::ConvertToUpperCamelCase",
      "c r m": "editor::ConvertToLowerCamelCase",
      "c r -": "editor::ConvertToKebabCase",
      "c r u": "editor::ConvertToUpperCase",
      "c r .": "editor::ConvertToTitleCase",
      "c r o": "editor::ConvertToOppositeCase",
```

These are motion operators — they wait for a text-object or visual selection after the `cr` prefix, then apply the transform.

- [ ] **Step 4: Add diagnostics binding in normal mode**

```json
      "space e": "diagnostics::Deploy",
```

- [ ] **Step 5: Verify and commit**

```bash
python3 -m json.tool /home/lalitmee/dotfiles/zed/.config/zed/keymap.json > /dev/null && echo "valid" || echo "invalid"
git add zed/.config/zed/keymap.json
git commit -m "feat(zed): add lsp, git, case-conversion, and diagnostics bindings"
```

---

### Task 3: Wave 3 — Snippets (all languages)

**Files:**
- Create: `zed/.config/zed/snippets/all.json`
- Create: `zed/.config/zed/snippets/lua.json`
- Create: `zed/.config/zed/snippets/json.json`
- Create: `zed/.config/zed/snippets/sxhkdrc.json`
- Create: `zed/.config/zed/snippets/javascript.json`
- Create: `zed/.config/zed/snippets/typescript.json`
- Create: `zed/.config/zed/snippets/markdown.json`

**Strategy:** Each LuaSnip snippet is evaluated for portability:
- Static body (no functions, no choices) → port to JSON with `$1`, `$2` tabstops
- Has choices (`c()` nodes) → pick the most common variant, or create multiple snippets
- Lua functions (`f()`, `d()`), regex triggers, clipboard access → drop

**Note:** The typescriptreact luasnippets file is identical to typescript.lua (same content, just with `interface` missing `export` choice). We port typescript — that covers TSX via Zed's language inheritance.

- [ ] **Step 1: Create `snippets/all.json`**

Port only static snippets from `all.lua` — drop `td` (dynamic `f()` for comment string), `hr` (dynamic), `cbox` (dynamic), `fdm` (dynamic). All four LuaSnip snippets in `all.lua` use `vim.bo.commentstring` which is a Lua function and cannot be replicated in JSON.

Result: `all.json` is an empty snippet file (just the skeleton):

```json
{}
```

- [ ] **Step 2: Create `snippets/lua.json`**

Port static snippets from `lua.lua`. Drop `req` (uses Lua function to extract last path segment), `use` (clipboard detection + choices), `wk` (commented out in source).

```json
{
  "local var": {
    "prefix": "loc",
    "body": ["local ${1:name} = ${2:module/package}"]
  },
  "local require": {
    "prefix": "locr",
    "body": ["local ${1:name} = require('${1:name}')"]
  },
  "note comment": {
    "prefix": "note",
    "body": ["-- NOTE: ${1:description}"]
  },
  "todo comment": {
    "prefix": "todo",
    "body": ["-- TODO: ${1:description}"]
  },
  "stylua ignore": {
    "prefix": "stn",
    "body": ["-- stylua: ignore"]
  },
  "reload require": {
    "prefix": "re",
    "body": ["local ${1:ok}, ${2:package} = lk.require(\"${2:package}\")"]
  },
  "notify": {
    "prefix": "no",
    "body": ["vim.notify(P(${1:var}))"]
  }
}
```

- [ ] **Step 3: Create `snippets/json.json`**

Port static snippets from `json.lua`. Drop one snippet (npmp uses `c()` choice for version).

```json
{
  "npm package": {
    "prefix": "npmp",
    "body": ["\"${1:package}\": \"^${2:1.0.0}\","]
  }
}
```

- [ ] **Step 4: Create `snippets/sxhkdrc.json`**

```json
{
  "doc comment": {
    "prefix": "com",
    "body": ["# ${1:classification} -> ${2:type}"]
  }
}
```

- [ ] **Step 5: Create `snippets/javascript.json`**

Port static snippets from `javascript.lua`. Drop: `log` (has choices), `ptd` (has choices), `useS` (uses `same()` + choices), `befo` (has choices), `ff(%d%d%d%d)` (regex trigger + Lua function). Create separate `befo` → beforeEach and `bfa` → beforeAll (bfa already exists).

```json
{
  "debugger": {
    "prefix": "de",
    "body": ["debugger"]
  },
  "console log": {
    "prefix": "clg",
    "body": ["console.log(${1:name})"]
  },
  "import react": {
    "prefix": "imr",
    "body": ["import React from 'react'"]
  },
  "react functional component": {
    "prefix": "rfc",
    "body": [
      "import React from 'react'",
      "",
      "function ${1:Component}(${2:props}) {",
      "  return (",
      "    <div>",
      "      ${3:children}",
      "    </div>",
      "  )",
      "}",
      "",
      "export default ${1:Component}"
    ]
  },
  "useEffect": {
    "prefix": "useE",
    "body": [
      "useEffect(() => {",
      "  ${1:// content goes here}",
      "}, [${2:dependencies}])"
    ]
  },
  "useState": {
    "prefix": "usest",
    "body": ["const [${1:state}, set${1:state}] = useState(${2:initalState})"]
  },
  "test mocks": {
    "prefix": "mocks",
    "body": [
      "const ${1:mocks} = [",
      "  {",
      "    request: {",
      "      query: ${2:query},",
      "      variables: {",
      "        ${3:variables}",
      "      },",
      "    },",
      "    result: {",
      "      data: {",
      "        ${4:data}",
      "      },",
      "    }",
      "  },",
      "]"
    ]
  },
  "import test utilities": {
    "prefix": "imrt",
    "body": [
      "import { MockedProvider } from \"@apollo/client/testing\";",
      "import \"@testing-library/jest-dom/extend-expect\";",
      "import { render } from \"@testing-library/react\";",
      "import React from \"react\";"
    ]
  },
  "test id attribute": {
    "prefix": "tid",
    "body": ["data-testid={${1:TEST_ID}}"]
  },
  "beforeEach": {
    "prefix": "befo",
    "body": [
      "beforeEach(() => {",
      "  ${1:// TODO: body}",
      "})"
    ]
  },
  "beforeAll": {
    "prefix": "bfa",
    "body": [
      "beforeAll(() => {",
      "  ${1:// TODO: body}",
      "})"
    ]
  },
  "export const object": {
    "prefix": "cst",
    "body": [
      "export const ${1:name} = {",
      "  ${2:// TODO: body}",
      "}"
    ]
  }
}
```

- [ ] **Step 6: Create `snippets/typescript.json`**

Same as javascript.json + TypeScript-specific snippets from `typescript.lua`. Drop `useS`, `atom` (uses `fmta` + choices), `hook` (uses `fmta`). Keep `int` (interface snippet).

```json
{
  "debugger": {
    "prefix": "de",
    "body": ["debugger"]
  },
  "console log": {
    "prefix": "clg",
    "body": ["console.log(${1:name})"]
  },
  "import react": {
    "prefix": "imr",
    "body": ["import React from 'react'"]
  },
  "react functional component": {
    "prefix": "rfc",
    "body": [
      "import React from 'react'",
      "",
      "function ${1:Component}(${2:props}) {",
      "  return (",
      "    <div>",
      "      ${3:children}",
      "    </div>",
      "  )",
      "}",
      "",
      "export default ${1:Component}"
    ]
  },
  "useEffect": {
    "prefix": "useE",
    "body": [
      "useEffect(() => {",
      "  ${1:// content goes here}",
      "}, [${2:dependencies}])"
    ]
  },
  "useState": {
    "prefix": "usest",
    "body": ["const [${1:state}, set${1:state}] = useState(${2:initalState})"]
  },
  "test mocks": {
    "prefix": "mocks",
    "body": [
      "const ${1:mocks} = [",
      "  {",
      "    request: {",
      "      query: ${2:query},",
      "      variables: {",
      "        ${3:variables}",
      "      },",
      "    },",
      "    result: {",
      "      data: {",
      "        ${4:data}",
      "      },",
      "    }",
      "  },",
      "]"
    ]
  },
  "import test utilities": {
    "prefix": "imrt",
    "body": [
      "import { MockedProvider } from \"@apollo/client/testing\";",
      "import \"@testing-library/jest-dom/extend-expect\";",
      "import { render } from \"@testing-library/react\";",
      "import React from \"react\";"
    ]
  },
  "test id attribute": {
    "prefix": "tid",
    "body": ["data-testid={${1:TEST_ID}}"]
  },
  "beforeEach": {
    "prefix": "befo",
    "body": [
      "beforeEach(() => {",
      "  ${1:// TODO: body}",
      "})"
    ]
  },
  "beforeAll": {
    "prefix": "bfa",
    "body": [
      "beforeAll(() => {",
      "  ${1:// TODO: body}",
      "})"
    ]
  },
  "export const object": {
    "prefix": "cst",
    "body": [
      "export const ${1:name} = {",
      "  ${2:// TODO: body}",
      "}"
    ]
  },
  "interface": {
    "prefix": "int",
    "body": [
      "interface ${1:Component} {",
      "  ${2:type: string;}",
      "}"
    ]
  }
}
```

- [ ] **Step 7: Create `snippets/markdown.json`**

Port static snippets from `markdown.lua`. All three snippets in the source use `checkmate` plugin functions (`cms.todo`, `cms.metadata`) with Lua callbacks — these are dynamic and cannot be ported. Only static content goes here.

```json
{}
```

- [ ] **Step 8: Verify snippets directory**

```bash
ls -la /home/lalitmee/dotfiles/zed/.config/zed/snippets/
# Expected: all.json, lua.json, json.json, sxhkdrc.json, javascript.json, typescript.json, markdown.json
```

- [ ] **Step 9: Commit**

```bash
git add zed/.config/zed/snippets/
git commit -m "feat(zed): add snippets ported from luasnip (static only)"
```

---

### Task 4: Wave 3 — Tasks

**Files:**
- Create: `zed/.config/zed/tasks.json`

**Strategy:** Each overseer template maps to a Zed task entry. Zed tasks support `label`, `command`, `args`, `cwd`, `reveal` (always/sometimes/never), `hide` (when-done/never), `env`, `use_new_terminal`, and `allow_concurrent_runs`. They do NOT support Lua conditions. Where overseer had `condition = { filetype = { "go" } }`, we leave it off — the user runs the task when relevant.

- [ ] **Step 1: Create tasks.json**

```json
[
  // C++
  {
    "label": "g++ build",
    "command": "g++",
    "args": ["$ZED_FILE"],
    "reveal": "always",
    "hide": "never"
  },
  {
    "label": "g++ build and run",
    "command": "bash",
    "args": ["-c", "g++ \"$ZED_FILE\" -o \"${ZED_FILE%.*}.out\" && \"${ZED_FILE%.*}.out\""],
    "reveal": "always",
    "hide": "never"
  },
  // Go
  {
    "label": "go build",
    "command": "go",
    "args": ["build"],
    "reveal": "always",
    "hide": "never"
  },
  // Node
  {
    "label": "node run",
    "command": "node",
    "args": ["$ZED_FILE"],
    "reveal": "always",
    "hide": "never"
  },
  // Python
  {
    "label": "python run",
    "command": "python",
    "args": ["$ZED_FILE"],
    "reveal": "always",
    "hide": "never"
  },
  // npm
  {
    "label": "npm run budgets",
    "command": "npm",
    "args": ["run", "budgets"],
    "reveal": "always",
    "hide": "never"
  },
  {
    "label": "npm run build",
    "command": "npm",
    "args": ["run", "build"],
    "reveal": "always",
    "hide": "never"
  },
  {
    "label": "npm run dev",
    "command": "npm",
    "args": ["run", "dev"],
    "reveal": "always",
    "hide": "never"
  },
  {
    "label": "npm install",
    "command": "npm",
    "args": ["install"],
    "reveal": "always",
    "hide": "never"
  },
  {
    "label": "npm start",
    "command": "npm",
    "args": ["start"],
    "reveal": "always",
    "hide": "never"
  },
  {
    "label": "npm tsc-watch",
    "command": "npm",
    "args": ["tsc-watch"],
    "reveal": "always",
    "hide": "never"
  },
  // yarn
  {
    "label": "yarn run budgets",
    "command": "yarn",
    "args": ["run", "budgets"],
    "reveal": "always",
    "hide": "never"
  },
  {
    "label": "yarn run build",
    "command": "yarn",
    "args": ["run", "build"],
    "reveal": "always",
    "hide": "never"
  },
  {
    "label": "yarn run dev",
    "command": "yarn",
    "args": ["run", "dev"],
    "reveal": "always",
    "hide": "never"
  },
  {
    "label": "yarn install",
    "command": "yarn",
    "args": ["install"],
    "reveal": "always",
    "hide": "never"
  },
  {
    "label": "yarn start",
    "command": "yarn",
    "args": ["run", "start"],
    "reveal": "always",
    "hide": "never"
  },
  {
    "label": "yarn tsc-watch",
    "command": "yarn",
    "args": ["tsc-watch"],
    "reveal": "always",
    "hide": "never"
  },
  // Rust
  {
    "label": "rustlings watch",
    "command": "rustlings",
    "args": ["watch"],
    "reveal": "always",
    "hide": "never"
  }
]
```

- [ ] **Step 2: Verify JSON**

```bash
python3 -m json.tool /home/lalitmee/dotfiles/zed/.config/zed/tasks.json > /dev/null && echo "valid" || echo "invalid"
```

- [ ] **Step 3: Commit**

```bash
git add zed/.config/zed/tasks.json
git commit -m "feat(zed): add tasks.json ported from overseer templates"
```

---

### Task 5: Wave 3 — LSP Server Configs + Language Overrides

**Files:**
- Modify: `zed/.config/zed/settings.json`

**Strategy:** Port server-specific settings from `nvim/.config/nvim/lua/plugins/lsp/servers.lua` to Zed's `settings.json` under `lsp`. Zed uses `lsp.<server_name>.settings` to pass initialization options.

- [ ] **Step 1: Add LSP server configs**

Add to the top level of `settings.json` (before the final `}`):

```json
  "lsp": {
    "clangd": {
      "binary": {
        "path": "clangd",
        "arguments": ["--background-index", "--suggest-missing-includes", "--clang-tidy", "--header-insertion=iwyu"]
      }
    },
    "gopls": {
      "settings": {
        "hints": {
          "assignVariableTypes": true,
          "compositeLiteralFields": true,
          "compositeLiteralTypes": true,
          "constantValues": true,
          "functionTypeParameters": true,
          "parameterNames": true,
          "rangeVariableTypes": true
        }
      }
    },
    "lua_ls": {
      "settings": {
        "Lua": {
          "hint": { "enable": true },
          "format": { "enable": false },
          "diagnostics": {
            "globals": ["P", "R", "RELOAD", "Snacks", "__lk_global_callbacks", "after_each", "before_each", "describe", "it", "lk", "require", "vim", "_dd", "_bt"]
          },
          "completion": {
            "keywordSnippet": "Replace",
            "callSnippet": "Replace"
          },
          "workspace": {
            "checkThirdParty": false
          },
          "telemetry": {
            "enable": false
          }
        }
      }
    },
    "rust-analyzer": {
      "settings": {
        "rust-analyzer": {
          "inlayHints": { "locationLinks": true },
          "diagnostics": { "enable": true },
          "hover": { "actions": { "enable": true } },
          "procMacro": { "enable": true },
          "cargo": { "allFeatures": true },
          "checkOnSave": {
            "command": "clippy",
            "extraArgs": ["--no-deps"]
          }
        }
      }
    }
  },
```

For `lua_ls` workspace library (`${3rd}/luv/library` and `vim.api.nvim_get_runtime_file`), these are Neovim-specific paths. Zed does not have nvim runtime files, but lua_ls in Zed already handles standard Lua workspace detection. Omit the workspace.library override.

- [ ] **Step 2: Add language overrides**

Add language-specific settings mirroring the `after/ftplugin/` directory. Key overrides:

```json
  "languages": {
    "INI": {
      "editor": {
        "folding": { "strategy": "marker" }
      }
    },
    "C": {
      "tab_size": 4,
      "hard_tabs": true
    },
    "C++": {
      "tab_size": 4,
      "hard_tabs": true
    },
    "Go": {
      "tab_size": 4,
      "hard_tabs": true,
      "format_on_save": "on"
    },
    "Python": {
      "tab_size": 4,
      "hard_tabs": false
    },
    "Rust": {
      "tab_size": 4,
      "hard_tabs": false,
      "format_on_save": "on"
    },
    "Lua": {
      "tab_size": 2,
      "hard_tabs": false,
      "formatter": "stylua"
    },
    "Zig": {
      "tab_size": 4,
      "hard_tabs": false
    },
    "YAML": {
      "tab_size": 2,
      "hard_tabs": false
    },
    "JSON": {
      "tab_size": 2,
      "hard_tabs": false
    },
    "JavaScript": {
      "tab_size": 2,
      "hard_tabs": false
    },
    "TypeScript": {
      "tab_size": 2,
      "hard_tabs": false
    },
    "CSS": {
      "tab_size": 2,
      "hard_tabs": false
    },
    "HTML": {
      "tab_size": 2,
      "hard_tabs": false
    },
    "Markdown": {
      "tab_size": 2,
      "hard_tabs": false,
      "soft_wrap": "editor_width"
    }
  },
```

Note: Some languages may overlap with the existing `"languages"` key in settings.json. Use a single `"languages"` key with all entries merged (Ini marker folding + language-specific settings above).

- [ ] **Step 3: Verify JSON**

```bash
python3 -m json.tool /home/lalitmee/dotfiles/zed/.config/zed/settings.json > /dev/null && echo "valid" || echo "invalid"
```

- [ ] **Step 4: Commit**

```bash
git add zed/.config/zed/settings.json
git commit -m "feat(zed): add lsp server configs and language overrides"
```

---

### Task 6: Documentation

**Files:**
- Modify: `zed/README.md`

- [ ] **Step 1: Add known gaps section to README**

Append to `zed/README.md` noting the keybinding groups, droppped snippets by category, and known gaps.

The exact content depends on what's already in the README (307 lines). At minimum, add:

````markdown
## Keybinding Groups

All custom bindings are in `keymap.json` organized by context:

- **VimControl** (normal + visual): `H`/`L` (0/$), `n`/`N` (search repeat + zz), `C-d`/`C-u` (scroll + zz), git hunks (`g b/d/j/k`), case conversion (`cr{s/c/m/-/u/.}`)
- **Normal**: `U` (redo), `0`/`^` (swapped), `Backspace` (go back), leader bindings for LSP (`space l *`), git panel (`space g s`), diagnostics (`space e`)

## Snippet Status

Ported from `nvim/.config/nvim/luasnippets/` to `snippets/*.json`:

| Language | Ported | Dropped (dynamic) |
|----------|--------|-------------------|
| all      | —      | td, hr, cbox, fdm |
| lua      | loc, locr, note, todo, stn, re, no | req (function), use (clipboard) |
| json     | npmp   | — |
| sxhkdrc  | com    | — |
| js/ts    | de, clg, imr, rfc, useE, usest, mocks, imrt, tid, befo, bfa, cst, int (ts only) | log (choices), ptd (choices), befo/bfa choices, ff (regex), useS (dynamic), atom (dynamic), hook (dynamic) |
| markdown | —      | all (checkmate plugin) |

## Tasks

`tasks.json` defines 18 tasks ported from overseer: C++ (build, build+run), Go (build), Node (run), Python (run), npm (budgets, build, dev, install, start, tsc-watch), yarn (same), Rust (rustlings watch).

## Known Gaps

These Neovim features have no Zed equivalent:
- Expression mappings, undo breakpoints, `very magic`, `cgn`/`gV`/counted dot-repeat
- Lua function-based snippets, regex-trigger snippets, snippet choices
- Lazygit, Telescope dropdowns, CodeCompanion inline chat, grug-far, oil.nvim
- Project switcher (covered by existing `space space`/`space p f`)
````

- [ ] **Step 2: Re-stow zed config (if already stowed)**

```bash
cd /home/lalitmee/dotfiles && stow zed 2>/dev/null || echo "not stowed yet — run ./install.sh later"
```

- [ ] **Step 3: Commit**

```bash
git add zed/README.md
git commit -m "docs(zed): update readme with keybindings, snippets, tasks, and gaps"
```

---

## Execution Handoff

Plan complete and saved to `docs/superpowers/plans/2026-07-09-neovim-to-zed-port.md`.

**Two execution options:**

1. **Subagent-Driven (recommended)** — I dispatch a fresh subagent per task, review between tasks, fast iteration
2. **Inline Execution** — Execute tasks in this session, batch execution with checkpoints

**Which approach?**
