# Feature Implementation Plan: Git Worktree Picker Improvements

## 📋 Todo Checklist
- [x] ✅ Vertically align the delete worktree picker results.
- [x] ✅ Change the create worktree picker theme to dropdown.
- [x] ✅ Add a configuration option for the create worktree picker theme.
- [x] ✅ Final Review and Testing

## 🔍 Analysis & Investigation

### Codebase Structure
The relevant files are `nvim/.config/nvim/lua/plugins/git/worktree/telescope.lua` and `nvim/.config/nvim/lua/plugins/git/worktree/hooks.lua`. The `telescope.lua` file contains the definitions for the `create_worktree_picker` and `delete_worktree_picker` functions. The `hooks.lua` file contains the logic that is triggered after a worktree is created, switched, or deleted.

### Current Architecture
The pickers are implemented using the standard `telescope.pickers.new` function. The `delete_worktree_picker` currently formats its entries as a single string, which causes the alignment issue. The `create_worktree_picker` uses the default Telescope theme.

### Dependencies & Integration Points
The implementation relies on the `telescope.nvim` plugin and its API. Specifically, it uses `telescope.pickers`, `telescope.finders`, and `telescope.actions`.

### Considerations & Challenges
- **Dynamic Width Calculation:** For the delete picker, the width of the "branch" column needs to be calculated dynamically to accommodate branch names of different lengths.
- **Theme Configuration:** The theme for the create picker should be easily configurable without changing the code in the future.

## 📝 Implementation Plan

### Prerequisites
- Neovim with `telescope.nvim` installed.
- The `git-worktree` plugin installed and configured.

### Step-by-Step Implementation
1. **Step 1: Vertically align the delete worktree picker results**
   - **Files to modify:** `nvim/.config/nvim/lua/plugins/git/worktree/telescope.lua`
   - **Changes needed:**
     - In the `delete_worktree_picker` function, before calling `pickers.new`, calculate the maximum length of the worktree branch names.
     - Create a custom `entry_maker` function that uses `string.format` to create a formatted string with a fixed width for the branch name.
     - Pass the custom `entry_maker` to the `finders.new_table` call.

     ```lua
     -- Inside delete_worktree_picker function, before pickers.new
     local max_branch_len = 0
     for _, wt in ipairs(wts) do
         if #wt.branch > max_branch_len then
             max_branch_len = #wt.branch
         end
     end

     local entry_maker = function(entry)
         return {
             value = entry,
             display = string.format("%-" .. max_branch_len .. "s    %s", entry.branch, entry.path),
             ordinal = entry.branch,
         }
     end

     -- In pickers.new, update the finder
     finder = finders.new_table({
         results = wts,
         entry_maker = entry_maker,
     }),
     ```

2. **Step 2: Change the create worktree picker theme**
   - **Files to modify:** `nvim/.config/nvim/lua/plugins/git/worktree/telescope.lua`
   - **Changes needed:**
     - At the top of the file, add a configuration option for the theme.
     - In the `create_worktree_picker` function, pass the theme to the `pickers.new` call.

     ```lua
     -- At the top of the file
     local M = {
         create_picker_theme = "dropdown",
     }

     -- In create_worktree_picker function, inside pickers.new
     pickers.new({
         theme = M.create_picker_theme,
     }, {
         -- ... rest of the options
     })
     ```

### Testing Strategy
- After applying the changes, open Neovim and run the `:Telescope git_worktrees delete_worktree` command to verify that the results are vertically aligned.
- Run the `:Telescope git_worktrees create_worktree` command to verify that the picker uses the dropdown theme.
- Test the functionality of both pickers to ensure that creating and deleting worktrees still works as expected.

## 🎯 Success Criteria
- The `delete_worktree_picker` displays the worktree branch and path in two vertically aligned columns.
- The `create_worktree_picker` uses the dropdown theme.
- The theme for the `create_worktree_picker` can be changed by updating the `create_picker_theme` variable.
- All existing functionality of the worktree pickers remains intact.
