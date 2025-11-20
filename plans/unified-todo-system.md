# Refined Plan: Unified Todo System & Code Modularity

This plan outlines the process for unifying the todo system management within Neovim and refactoring the supporting Lua code for better modularity and reusability.

## 📋 Todo Checklist

- [ ] ✅ **Phase 1: Refactor `oslib.lua` for Reusability**
    - [x] ✅ Create `_get_workspace_type()` function
    - [x] ✅ Update `_get_project_root_path()` to use `_get_workspace_type()`
    - [x] ✅ Update Existing Functions to Use the New Helper
- [ ] ✅ **Phase 2: Ensure Robust Todo Directory Creation**
    - [x] ✅ Modify `M.get_todos_root_path()` for On-Demand Creation
    * [x] ✅ Remove Pre-emptive Directory Creation from `init.lua`
    * [x] ✅ Verify Project-Specific Directory Creation
- [ ] ⏳ **Phase 3: Validation and Testing**
    - [ ] ⏳ Test Path Resolution
    - [ ] ⏳ Test Directory Creation
    - [ ] ⏳ Cleanup

---

## Addressing User Feedback: `vim.fn.mkdir` Placement

**User Concern:** The user questioned the placement of `vim.fn.mkdir` in `nvim/.config/nvim/lua/utils/init.lua`, suggesting it's a bug and should be executed when the directory is accessed.

**Previous Rationale:** The initial placement in `init.lua` was intended to provide a robust, session-level guarantee that the root `todos` directory always exists as soon as Neovim starts, preventing potential errors from other plugins or functions trying to access it without a prior check.

**Refined Approach:** While the `init.lua` approach is robust, moving the `mkdir` call directly into the `M.get_todos_root_path()` function aligns better with an "on-demand" and "point-of-access" creation philosophy. This ensures that whenever the *root* path for todos is requested, it implicitly guarantees its existence. This is a semantically cleaner and more modular approach.

---

## Addressing User Feedback: Dynamic Project Type Determination

**User Concern:** The user wants a more dynamic way to identify "work" vs. "personal" projects for todo storage, based on the current working directory, rather than a hardcoded home directory check.
*   If the current working directory (`vim.fn.getcwd()`) is inside `~/Projects/Work`, then it's a "work" project.
*   Otherwise, it's a "personal" project (implicitly `~/Projects/Personal`).

**Refined Approach:** A new helper function, `_get_workspace_type()`, will be created to determine the project type based on the current working directory. The existing `_get_project_root_path()` function will then be modified to utilize this new function, making the path determination more flexible and directly tied to the user's current project context.

---

## Phase 1: Refactor `oslib.lua` for Reusability

**Goal:** Eliminate redundant logic for determining project paths based on the environment (personal vs. work) and implement dynamic project type detection.

1.  **Create `_get_workspace_type()` function:**
    *   In `nvim/.config/nvim/lua/utils/oslib.lua`, create a new private helper function named `_get_workspace_type()`.
    *   This function will:
        *   Get the current working directory (`vim.fn.getcwd()`).
        *   Define `work_projects_base = vim.env.HOME .. "/Projects/Work"`.
        *   If `getcwd()` starts with `work_projects_base`, return the string `"work"`.
        *   Else, return the string `"personal"`.

2.  **Update `_get_project_root_path()` to use `_get_workspace_type()`:**
    *   In `nvim/.config/nvim/lua/utils/oslib.lua`, modify the private helper function named `_get_project_root_path()`.
    *   This function will now:
        *   Call `_get_workspace_type()` to determine the current workspace type.
        *   Based on the returned type, construct and return the appropriate base path:
            *   If "work", return `vim.env.HOME .. "/Projects/Work/Github"`.
            *   If "personal", return `vim.env.HOME .. "/Projects/Personal/Github"`.

3.  **Update Existing Functions to Use the New Helper:**
    *   Modify `M.get_second_brain_path()` to call `_get_project_root_path()` and append `/second-brain` to the result.
    *   Modify `M.get_project_todo_path()` to call `_get_project_root_path()` to get its base `todos` path, removing the duplicated `if/else` block.

## Phase 2: Ensure Robust Todo Directory Creation

**Goal:** Guarantee that the `todos` directory structure exists before any attempt is made to create or access files within it, preventing potential errors in Neovim.

1.  **Modify `M.get_todos_root_path()` for On-Demand Creation:**
    *   In `oslib.lua`, modify the `M.get_todos_root_path()` function.
    *   This function will now *both* construct the full path to the main `todos` directory *and* ensure its existence using `vim.fn.mkdir(todos_root_path, "p")` *before* returning the path.

2.  **Remove Pre-emptive Directory Creation from `init.lua`:**
    *   Remove the `vim.fn.mkdir(require("utils.oslib").get_todos_root_path(), "p")` call from `nvim/.config/nvim/lua/utils/init.lua`. This will no longer be necessary as `M.get_todos_root_path()` will handle its own creation.

3.  **Verify Project-Specific Directory Creation:**
    *   Confirm that the existing logic within `M.get_project_todo_path()`—which creates the project-specific subdirectory (e.g., `.../todos/my-project/`)—is still correct and functioning as intended after the refactoring. The `vim.fn.mkdir(project_todo_path, "p")` call should remain.

## Phase 3: Validation and Testing

**Goal:** Verify that the refactoring works as expected and that the directory creation issue is resolved.

1.  **Test Path Resolution:**
    *   Add temporary `print()` statements in `oslib.lua` to verify that `_get_workspace_type()`, `_get_project_root_path()`, `get_second_brain_path`, `get_todos_root_path`, and `get_project_todo_path` all return the correct paths and types in different working directories (e.g., inside and outside `~/Projects/Work`).

2.  **Test Directory Creation:**
    *   Temporarily rename your existing `~/Projects/Personal/Github/todos` directory to `todos_backup`.
    *   Start Neovim and trigger the todo system initialization (e.g., by calling a function that uses `M.get_todos_root_path()`).
    *   Verify that the `~/Projects/Personal/Github/todos` directory is automatically re-created.
    *   Navigate into a project and create a todo to ensure the project-specific subdirectory and todo file are also created correctly.

3.  **Cleanup:**
    *   Remove the temporary `print()` statements.
    *   Restore your original `todos` directory from the backup.
