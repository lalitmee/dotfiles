# Feature Implementation Plan: Project-Based Branch TODOs

## 📋 Todo Checklist
- [ ] Create a utility function to generate a dynamic, project-specific path for branch TODO files.
- [ ] Modify the `checkmate.nvim` configuration to use this new function.
- [ ] Define a testing strategy to verify the new behavior for `checkmate.nvim` only.

## ❗ Important Implementation Note

This plan has been revised to meet your specific request. The following changes will **only** affect the behavior of the `checkmate.nvim` plugin (triggered by `<leader>T.`).

The configuration and keybindings for the general-purpose scratchpads (from the `LintaoAmons/scratch.nvim` plugin, triggered by `<leader>ka`, etc.) **will not be changed**, and their behavior will remain the same as it is currently.

## 📝 Implementation Plan

### Prerequisites
- The project directory structure (`~/Project/Work` and `~/Project/Personal`) must exist.

### Step-by-Step Implementation

1.  **Step 1: Create the Path Generation Function**
    -   **File to modify**: `nvim/.config/nvim/lua/utils/oslib.lua`
    -   **Changes needed**: Add the `get_project_todo_path` function. This will be used exclusively by `checkmate.nvim` to find the correct file.

    ```lua
    -- Add this new function to the `M` table in nvim/lua/utils/oslib.lua

    M.get_project_todo_path = function()
        -- 1. Determine base path based on Work/Personal environment
        local todo_root
        if vim.env.HOME == "/home/lalitmee" then
            todo_root = vim.env.HOME .. "/Project/Personal/Github/todos"
        else
            todo_root = vim.env.HOME .. "/Projects/Work/Github/todos"
        end

        -- 2. Get project name from the current working directory's name
        local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ":t")
        if not project_name or project_name == "" then
            project_name = "global" -- Fallback if not in a project
        end

        local project_todo_path = todo_root .. "/" .. project_name

        -- 3. Get current git branch name
        local branch_name
        vim.fn.system("git rev-parse --is-inside-work-tree >/dev/null 2>&1")
        if vim.v.shell_error == 0 then
            branch_name = vim.fn.trim(vim.fn.system("git rev-parse --abbrev-ref HEAD"))
            if vim.v.shell_error ~= 0 or branch_name == "" then
                branch_name = "main" -- Fallback for detached HEAD or new repo
            end
        else
            branch_name = "global" -- Fallback if not a git repository
        end

        -- 4. Sanitize branch name for use in a filename
        local sanitized_branch_name = branch_name:gsub("[^%w_-]", "_")

        -- 5. Ensure the directory structure exists
        vim.fn.mkdir(project_todo_path, "p")

        -- 6. Return the final, full file path with the "todo-" prefix
        return project_todo_path .. "/todo-" .. sanitized_branch_name .. ".md"
    end
    ```

2.  **Step 2: Update `checkmate.nvim` Keybinding**
    -   **File to modify**: `nvim/.config/nvim/lua/plugins/tools.lua`
    -   **Changes needed**: In the configuration for `checkmate.nvim`, replace the existing function for the `<leader>T.` keybinding with one that calls the new utility function.

    ```lua
    -- In nvim/lua/plugins/tools.lua, find the "checkmate.nvim" section
    -- and replace its `keys` table with this:
    keys = {
        {
            "<leader>T.",
            function()
                -- Get the dynamic file path from our new utility function
                local todo_file = require("utils.oslib").get_project_todo_path()
                -- Use the Snacks API to open the specific file
                require("folke.snacks").scratch.open({ icon = " ", ft = "markdown", file = todo_file })
            end,
            desc = "Toggle Project/Branch Todo",
        },
    },
    ```

### Testing Strategy
1.  **`checkmate.nvim` Test (Work)**:
    - Navigate to a "Work" project on branch `feature/new-ui`.
    - Press `<leader>T.`.
    - **Verify**: A file named `.../todos/<project>/todo-feature_new-ui.md` opens.
2.  **`checkmate.nvim` Test (Personal)**:
    - Navigate to a "Personal" project on branch `bugfix/login`.
    - Press `<leader>T.`.
    - **Verify**: A file named `.../todos/<project>/todo-bugfix_login.md` opens.
3.  **`scratch.nvim` Test (Behavior Unchanged)**:
    - Navigate to any directory.
    - Press `<leader>ka`.
    - **Verify**: The original, unchanged `scratch.nvim` behavior occurs (e.g., a scratchpad opens based on its original configuration, likely in `~/.local/share/nvim/scratch/` or a `second-brain` directory). **This should not open the project-based TODO file.**
4.  **Feature Test**: Open a branch TODO file using `<leader>T.` and confirm that markdown checkbox toggling still works, verifying `checkmate.nvim`'s features are still active.

## 🎯 Success Criteria
- Pressing `<leader>T.` (from `checkmate.nvim`) opens a branch-specific TODO file in the new, correct, hierarchical storage location, with the `todo-` prefix.
- The `checkmate.nvim` functionality correctly distinguishes between "Work" and "Personal" projects.
- The behavior of the default scratchpad keybindings (`<leader>ka`, etc.) is **completely unchanged**.
- All existing TODO-related features from `checkmate.nvim` (checkbox toggling, etc.) continue to function correctly when using `<leader>T.`.