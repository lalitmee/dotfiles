# 🛡️ Neovim Security Audit – Directory & Execution Surface Map

This document provides a **complete, security-focused overview** of **all directories and execution surfaces affected by Neovim and its third‑party GitHub plugins**, tailored for **Linux systems following the XDG Base Directory specification**.

It is designed to help you perform a **thorough security audit** of your Neovim setup, including plugins, binaries, native code, and hidden execution vectors.

---

## 1️⃣ Core Neovim Directories (XDG‑Compliant)

Neovim strictly follows the **XDG Base Directory specification**.

### 🔹 Configuration Directory (Highest Priority)

```
~/.config/nvim/
```

**Contains**

* `init.lua` / `init.vim`
* `lua/` (plugin configuration, LazyVim‑style setup)
* `after/`
* `ftplugin/`
* `plugin/`

🔐 **Audit Focus**

* `os.execute`
* `vim.fn.system`
* `vim.loop.spawn`
* `io.popen`
* Autocommands executing shell commands
* `require()` of untrusted modules

---

### 🔹 Data Directory (Plugins, Binaries, Native Code)

```
~/.local/share/nvim/
```

**Important Subdirectories**

```
~/.local/share/nvim/
├── lazy/          # GitHub plugin source code (lazy.nvim)
├── site/          # pack/* style plugins (legacy)
├── mason/         # LSP / DAP / formatter binaries
├── treesitter/    # Native compiled parsers (.so)
├── swap/
├── undo/
├── shada/
```

🔐 **Audit Focus (CRITICAL)**

* `lazy/*` → third‑party GitHub Lua code
* `mason/bin/*` → downloaded executables
* `treesitter/*.so` → native shared objects

---

### 🔹 State Directory (Runtime State)

```
~/.local/state/nvim/
```

**Contains**

* Logs
* Session files
* Plugin runtime state

🔐 **Audit Focus**

* Session restore commands
* Logs triggering shell execution

---

### 🔹 Cache Directory (Low Risk)

```
~/.cache/nvim/
```

**Contains**

* Compiled Lua cache
* LSP cache
* Telescope cache

🔐 Usually safe, but scan for unexpected binaries or scripts.

---

## 2️⃣ Plugin Manager–Specific Directories

### 🔹 lazy.nvim (Most Common Modern Setup)

```
~/.local/share/nvim/lazy/
```

Each directory is a **full Git repository clone**:

```
lazy/
├── telescope.nvim/
├── nvim-lspconfig/
├── plenary.nvim/
└── ...
```

🔐 **Audit Checklist**

* `plugin/*.lua`
* `lua/**/*.lua`
* Search for:

  * `vim.fn.system`
  * `vim.loop.spawn`
  * `jobstart`
  * `curl`, `wget`, `git` usage

---

## 3️⃣ Mason (High‑Risk Execution Surface)

### 🔹 Mason Root

```
~/.local/share/nvim/mason/
```

```
mason/
├── bin/           # Executables (LSPs, linters, formatters)
├── packages/      # Downloaded archives
└── registries/
```

🔐 **Critical Audit Steps**

```bash
ls -lh ~/.local/share/nvim/mason/bin
file ~/.local/share/nvim/mason/bin/*
```

These are **precompiled or downloaded binaries** executed directly by Neovim.

---

## 4️⃣ Treesitter Native Code

### 🔹 Treesitter Parsers

```
~/.local/share/nvim/treesitter/
```

Example:

```
c.so
lua.so
javascript.so
```

These are **native shared objects (.so)** compiled locally.

🔐 **Audit Command**

```bash
ldd ~/.local/share/nvim/treesitter/*.so
```

---

## 5️⃣ Runtime Path (Effective Code Load Order)

Run inside Neovim:

```vim
:echo &runtimepath
```

Anything listed here **can execute Lua or Vimscript code**.

---

## 6️⃣ System‑Wide Locations (Rare but Important)

### 🔹 Global Neovim Config

```
/etc/xdg/nvim/
/usr/share/nvim/
```

Audit if present:

```bash
ls /etc/xdg/nvim
```

---

## 7️⃣ Environment Variables That Change Paths

Audit environment:

```bash
env | grep -E 'XDG|NVIM'
```

Important Variables:

* `XDG_CONFIG_HOME`
* `XDG_DATA_HOME`
* `XDG_STATE_HOME`
* `XDG_CACHE_HOME`
* `NVIM_APPNAME`

Example:

```
NVIM_APPNAME=lazyvim
→ ~/.config/lazyvim/
→ ~/.local/share/lazyvim/
```

---

## 8️⃣ Hidden Execution Vectors (Commonly Missed)

### 🔹 Autocommands

```vim
:autocmd
```

### 🔹 Keymaps Executing Shell Commands

```vim
:map
```

### 🔹 Recursive Code Scan

```bash
rg "system\\(|jobstart|spawn|popen|curl|wget|os.execute" \
   ~/.config/nvim ~/.local/share/nvim
```

---

## 9️⃣ Minimal Security Audit Checklist ✅

### **Must Audit**

* `~/.config/nvim/**`
* `~/.local/share/nvim/lazy/**`
* `~/.local/share/nvim/mason/bin/**`
* `~/.local/share/nvim/treesitter/*.so`

### **Optional / Low Risk**

* `~/.cache/nvim/**`
* `~/.local/state/nvim/**`

---

## 🔒 10️⃣ Optional Hardening Ideas

* Disable `os.execute` globally
* Plugin allow‑listing
* Diff‑audit plugins before updates
* Run Neovim under `firejail` or `bubblewrap`
* Lock Mason to checksummed binaries

---

**This document is intended to be used as a living security audit reference for Neovim.**
