# Overseer.nvim v2.0 Migration Plan

> **Status**: ⏳ **WAITING FOR RELEASE** - v2.0 PR [#448](https://github.com/stevearc/overseer.nvim/pull/448) is not yet merged
>
> **Current Version**: v1.6.0 (tagged)
> **Target Version**: v2.0 (when released)

## 📋 Overview

This document outlines the migration plan for upgrading from overseer.nvim v1.6.0 to v2.0, based on the breaking changes described in [PR #448](https://github.com/stevearc/overseer.nvim/pull/448).

## 🔍 Current Configuration Analysis

### Current Setup in `nvim/.config/nvim/lua/plugins/coding.lua`

```lua
{ --[[ oversser.nvim ]]
    "stevearc/overseer.nvim",
    tag = "v1.6.0",  -- ⚠️ NEEDS REMOVAL
    cmd = {
        "OverseerBuild",           -- ❌ REMOVED in v2.0
        "OverseerClose",           -- ✅ KEEP
        "OverseerDeleteBundle",    -- ❌ REMOVED in v2.0
        "OverseerLoadBundle",      -- ❌ REMOVED in v2.0
        "OverseerOpen",            -- ✅ KEEP
        "OverseerQuickAction",     -- ❌ REMOVED in v2.0
        "OverseerRun",             -- ✅ KEEP
        "OverseerTaskAction",      -- ✅ KEEP
        "OverseerToggle",          -- ✅ KEEP
    },
    keys = {
        { "<leader>ro<leader>", ":OverseerQuickAction<CR>", desc = "Quick Action" },      -- ❌ REMOVED
        { "<leader>roa", ":OverseerTaskAction<CR>", desc = "Task Action" },              -- ✅ KEEP
        { "<leader>rob", ":OverseerBuild<CR>", desc = "Build" },                         -- ❌ REMOVED
        { "<leader>roc", ":OverseerRunCmd<CR>", desc = "Run Cmd" },                       -- ⚠️ CHECK
        { "<leader>rod", ":OverseerDeleteBundle<CR>", desc = "Delete Bundle" },           -- ❌ REMOVED
        { "<leader>rol", ":OverseerLoadBundle<CR>", desc = "Load Bundle" },               -- ❌ REMOVED
        { "<leader>roo", ":OverseerOpen<CR>", desc = "Open" },                            -- ✅ KEEP
        { "<leader>roq", ":OverseerClose<CR>", desc = "Close" },                          -- ✅ KEEP
        { "<leader>ror", ":OverseerRun<CR>", desc = "Run" },                              -- ✅ KEEP
        { "<leader>ros", ":OverseerSaveBundle ", desc = "Save Bundle" },                  -- ❌ REMOVED
        { "<leader>roj", ":OverseerToggle bottom<CR>", desc = "Toggle On Bottom" },      -- ✅ KEEP
        { "<leader>roh", ":OverseerToggle left<CR>", desc = "Toggle On Left" },          -- ✅ KEEP
        { "<leader>ro;", ":OverseerToggle right<CR>", desc = "Toggle On Right" },       -- ✅ KEEP
    },
    opts = {
        templates = { "tasks" },  -- ❌ REMOVED - Auto-loaded in v2.0
    },
}
```

### Current Hooks Integration in `nvim/.config/nvim/lua/plugins/git/worktree/hooks.lua`

```lua
-- ✅ STRATEGY: terminal (should still work in v2.0)
strategy = "terminal",
```

## 🚨 Breaking Changes in v2.0

### 1. **Removed Features**

- ❌ **Third-party task strategies** (toggleterm) - No longer supported
- ❌ **Bundles** - No more "save to bundle", "load from bundle"
- ❌ **OverseerBuild command** - Removed
- ❌ **OverseerQuickAction command** - Removed
- ❌ **Manual template loading** - Now automatic

### 2. **API Changes**

- ❌ **run_cmd API** - Deleted (affects OverseerRunCmd)
- ❌ **Behavior trees** - Replaced with functions
- ❌ **Keymap syntax** - Changed format
- ❌ **Template configuration** - No longer needed

### 3. **Requirements**

- ✅ **Neovim 0.11+** - Drop support for older versions
- ✅ **Strategy compatibility** - Terminal strategy should still work

## 📋 Migration Plan

### **PHASE 1: Preparation** ⏳

#### 1.1 Prerequisites

- [ ] **Check Neovim version**: Must be 0.11+

  ```bash
  nvim --version
  ```

- [ ] **Backup current configuration**

  ```bash
  cp nvim/.config/nvim/lua/plugins/coding.lua nvim/.config/nvim/lua/plugins/coding.lua.backup
  ```

- [ ] **Wait for v2.0 release** - Monitor [PR #448](https://github.com/stevearc/overseer.nvim/pull/448)

#### 1.2 Pre-migration Testing

- [ ] **Test current functionality** - Ensure everything works with v1.6.0
- [ ] **Document current workflow** - Note which features you use most
- [ ] **Test hooks integration** - Ensure worktree yarn install works

### **PHASE 2: Remove Breaking Changes** 🔧

#### 2.1 Remove Tag Constraint

```lua
-- BEFORE:
tag = "v1.6.0",

-- AFTER:
-- Remove tag constraint to allow latest version
```

#### 2.2 Remove Deprecated Commands

```lua
-- REMOVE from cmd list:
"OverseerBuild",           -- ❌ Removed in v2.0
"OverseerDeleteBundle",    -- ❌ No more bundles
"OverseerLoadBundle",      -- ❌ No more bundles
"OverseerSaveBundle",      -- ❌ No more bundles
"OverseerQuickAction",     -- ❌ Replaced by new features
```

#### 2.3 Remove Deprecated Keymaps

```lua
-- REMOVE these keymaps:
{ "<leader>ro<leader>", ":OverseerQuickAction<CR>", desc = "Quick Action" },
{ "<leader>rob", ":OverseerBuild<CR>", desc = "Build" },
{ "<leader>rod", ":OverseerDeleteBundle<CR>", desc = "Delete Bundle" },
{ "<leader>rol", ":OverseerLoadBundle<CR>", desc = "Load Bundle" },
{ "<leader>ros", ":OverseerSaveBundle ", desc = "Save Bundle" },
```

#### 2.4 Update Template Configuration

```lua
-- REMOVE from opts:
templates = { "tasks" },  -- ❌ Templates auto-load in v2.0
```

#### 2.5 Check RunCmd Command

```lua
-- CHECK if this still works:
{ "<leader>roc", ":OverseerRunCmd<CR>", desc = "Run Cmd" },
-- If not, replace with OverseerShell
```

### **PHASE 3: Keep Working Features** ✅

#### 3.1 Preserve Working Commands

```lua
-- KEEP these commands:
"OverseerClose",
"OverseerOpen",
"OverseerRun",
"OverseerTaskAction",
"OverseerToggle",
```

#### 3.2 Preserve Working Keymaps

```lua
-- KEEP these keymaps:
{ "<leader>roa", ":OverseerTaskAction<CR>", desc = "Task Action" },
{ "<leader>roo", ":OverseerOpen<CR>", desc = "Open" },
{ "<leader>roq", ":OverseerClose<CR>", desc = "Close" },
{ "<leader>ror", ":OverseerRun<CR>", desc = "Run" },
{ "<leader>roj", ":OverseerToggle bottom<CR>", desc = "Toggle On Bottom" },
{ "<leader>roh", ":OverseerToggle left<CR>", desc = "Toggle On Left" },
{ "<leader>ro;", ":OverseerToggle right<CR>", desc = "Toggle On Right" },
```

### **PHASE 4: Add New v2.0 Features** 🚀

#### 4.1 Add OverseerShell Keymaps

```lua
-- ADD new keymaps for v2.0 features:
{ "<leader>roc", ":OverseerShell<CR>", desc = "Run Command" },
{ "<leader>rot", ":OverseerShell --template<CR>", desc = "Run Template" },
{ "<leader>ron", ":OverseerNew<CR>", desc = "New Task" },
{ "<leader>roe", ":OverseerEdit<CR>", desc = "Edit Task" },
```

#### 4.2 Leverage Auto-loaded Templates

- ✅ **Templates auto-load** - No manual configuration needed
- ✅ **Better template discovery** - Automatic detection
- ✅ **Simplified setup** - Less configuration required

### **PHASE 5: Update Hooks Integration** 🔗

#### 5.1 Test Terminal Strategy

```lua
-- In hooks.lua - should still work:
strategy = "terminal",
```

#### 5.2 Consider New Default Strategy

- ✅ **Terminal strategy** - Should continue working
- ✅ **New default behavior** - May be more efficient
- ✅ **Buffer management** - Should be improved

### **PHASE 6: Testing and Validation** 🧪

#### 6.1 Core Functionality Tests

- [ ] **OverseerOpen** - Task list opens correctly
- [ ] **OverseerRun** - Tasks run properly
- [ ] **OverseerToggle** - Toggle functionality works
- [ ] **OverseerTaskAction** - Task actions work

#### 6.2 Hooks Integration Tests

- [ ] **Worktree creation** - Yarn install runs without errors
- [ ] **Worktree switching** - Terminal strategy works
- [ ] **Buffer management** - No buffer ID conflicts
- [ ] **Task completion** - Notifications work correctly

#### 6.3 New Features Tests

- [ ] **OverseerShell** - Command execution works
- [ ] **Auto-loaded templates** - Templates are discovered
- [ ] **Task management** - New features function properly

## 🎯 Expected Benefits

### **New Features You'll Gain**

- ✅ **Auto-loaded templates** - No manual template configuration
- ✅ **OverseerShell** - More flexible than old RunCmd
- ✅ **Better task management** - Enhanced task organization
- ✅ **Improved performance** - Faster and more stable
- ✅ **Checkhealth support** - Better debugging and diagnostics
- ✅ **Simplified configuration** - Less manual setup required

### **Workflow Improvements**

- ✅ **Cleaner keymap layout** - Remove unused keymaps
- ✅ **Better task discovery** - Automatic template loading
- ✅ **Enhanced task list** - More customization options
- ✅ **Future-proof setup** - Ready for ongoing updates

## ⚠️ Potential Risks & Mitigation

### **Risks**

- ❌ **Bundle functionality loss** - Replaced by new serialization features
- ❌ **Some keymaps removed** - Need to find replacements
- ❌ **Template loading changes** - Now automatic (should be better)
- ❌ **RunCmd API changes** - May need OverseerShell replacement

### **Mitigation Strategies**

- ✅ **Test each phase individually** - Don't change everything at once
- ✅ **Keep backup of working config** - Easy rollback if needed
- ✅ **Use new OverseerShell** - Replace missing RunCmd functionality
- ✅ **Leverage auto-loaded templates** - Simpler than manual configuration
- ✅ **Monitor v2.0 release notes** - Stay updated on changes

## 📝 Final Configuration

### **After Migration - Complete Config**

```lua
{ --[[ oversser.nvim ]]
    "stevearc/overseer.nvim",
    -- No tag constraint - use latest version
    cmd = {
        "OverseerClose",
        "OverseerOpen",
        "OverseerRun",
        "OverseerTaskAction",
        "OverseerToggle",
    },
    keys = {
        { "<leader>roa", ":OverseerTaskAction<CR>", desc = "Task Action" },
        { "<leader>roc", ":OverseerShell<CR>", desc = "Run Command" },
        { "<leader>roe", ":OverseerEdit<CR>", desc = "Edit Task" },
        { "<leader>roh", ":OverseerToggle left<CR>", desc = "Toggle On Left" },
        { "<leader>roj", ":OverseerToggle bottom<CR>", desc = "Toggle On Bottom" },
        { "<leader>ron", ":OverseerNew<CR>", desc = "New Task" },
        { "<leader>roo", ":OverseerOpen<CR>", desc = "Open" },
        { "<leader>roq", ":OverseerClose<CR>", desc = "Close" },
        { "<leader>ror", ":OverseerRun<CR>", desc = "Run" },
        { "<leader>rot", ":OverseerShell --template<CR>", desc = "Run Template" },
        { "<leader>ro;", ":OverseerToggle right<CR>", desc = "Toggle On Right" },
    },
    -- No opts needed - templates auto-load
}
```

## 🚀 Ready to Migrate?

### **When v2.0 is Released**

1. ✅ **Follow this migration plan** step by step
2. ✅ **Test each phase** before moving to the next
3. ✅ **Keep backups** of working configurations
4. ✅ **Monitor for issues** and adjust as needed

### **Success Criteria**

- ✅ **All core functionality works** - Open, Run, Toggle, TaskAction
- ✅ **Hooks integration works** - Worktree yarn install functions
- ✅ **New features available** - OverseerShell, auto-loaded templates
- ✅ **No breaking errors** - Clean migration without issues

---

**📅 Last Updated**: January 2025
**🔗 Reference**: [PR #448](https://github.com/stevearc/overseer.nvim/pull/448)
**📋 Status**: ⏳ Waiting for v2.0 release