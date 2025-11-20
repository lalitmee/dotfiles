-- The operating system is assigned to a global variable that
-- that can be used elsewhere for conditional system based logic
local uname = vim.loop.os_uname()

if uname.sysname == "Darwin" then
    vim.g.open_command = "open"
    vim.g.system_name = "macOS"
    vim.g.is_mac = true
elseif uname.sysname == "Linux" then
    vim.g.open_command = "xdg-open"
    vim.g.system_name = "Linux"
    vim.g.is_linux = true
end

-- module export
local M = {}

-- Helper function to determine the type of workspace (work/personal) based on the current working directory.
M.get_workspace_type = function()
    local current_cwd = vim.fn.getcwd()
    local work_projects_base = vim.env.HOME .. "/Projects/Work"
    if current_cwd:find(work_projects_base, 1, true) then -- `1, true` for plain string search at the beginning
        return "work"
    else
        return "personal"
    end
end

-- Helper function to determine the base project root based on user
M.get_project_root_path = function()
    local workspace_type = M.get_workspace_type()
    if workspace_type == "work" then
        return vim.env.HOME .. "/Projects/Work/Github"
    else
        return vim.env.HOME .. "/Projects/Personal/Github"
    end
end

M.get_open_cmd = function()
    return vim.g.open_command
end

-- get operating system name
M.get_os = function(table)
    if table == nil then
        table = {
            macOS = "macOS",
            linux = "Linux",
        }
    end

    if os.getenv("HOME"):find("/Users") then
        return table.macOS
    else
        return table.linux
    end
end

-- get username ($USER)
M.get_username = function()
    return os.getenv("USER")
end

-- get home dir ($HOME)
M.get_homedir = function()
    return os.getenv("HOME")
end

M.get_cwd = function()
    return vim.fn["getcwd"]()
end

M.get_python = function()
    local handle = io.popen("which python3")
    local python = handle and handle:read("*a"):sub(1, -2)
    if handle then
        handle:close()
    end
    return python
end

M.get_second_brain_path = function()
    return M.get_project_root_path() .. "/second-brain"
end

M.get_project_todo_path = function()
    -- 1. Determine base path based on Work/Personal environment
    local todo_root = M.get_project_root_path() .. "/todos"

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

M.get_todos_root_path = function()
    local todos_root_path = M.get_project_root_path() .. "/todos"
    vim.fn.mkdir(todos_root_path, "p")
    return todos_root_path
end

return M
