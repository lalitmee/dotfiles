local M = {
    create_picker_theme = "dropdown",
}

local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local conf = require("telescope.config").values
local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")
local Path = require("plenary.path")
local Job = require("plenary.job")
local git_wt = require("git-worktree")

-- Helpers
local function get_repo_info()
    local cwd = vim.fn.getcwd()
    return vim.fn.fnamemodify(cwd, ":t"), vim.fn.fnamemodify(cwd, ":h")
end

local function fetch_branches(cb)
    Job:new({
        command = "git",
        args = { "branch", "-a", "--format", "%(refname:short)" },
        on_exit = function(j)
            local seen = {}
            for _, b in ipairs(j:result()) do
                local clean = b:gsub("^remotes/origin/", "")
                if clean ~= "HEAD" then
                    seen[clean] = true
                end
            end
            local list = vim.tbl_keys(seen)
            table.sort(list)
            cb(list)
        end,
    }):start()
end

-- Create Picker
function M.create_worktree_picker()
    fetch_branches(function(branches)
        vim.schedule(function()
            pickers
                .new({
                    theme = M.create_picker_theme,
                }, {
                    prompt_title = "Create Worktree",
                    finder = finders.new_table({ results = branches }),
                    sorter = conf.generic_sorter({}),
                    attach_mappings = function(_, bufnr)
                        actions.select_default:replace(function()
                            local branch = action_state.get_selected_entry()[1]
                            actions.close(bufnr)

                            local name, parent = get_repo_info()
                            local root = Path:new(parent):joinpath(name .. "-worktrees")
                            root:mkdir({ parents = true })
                            local dest = root:joinpath(branch)

                            print("Creating worktree at:", dest:absolute())
                            git_wt.create_worktree(dest:absolute(), branch, "origin")
                        end)
                        return true
                    end,
                })
                :find()
        end)
    end)
end

-- helper: fetch all worktrees
local function fetch_worktrees(cb)
    Job:new({
        command = "git",
        args = { "worktree", "list", "--porcelain" },
        on_exit = function(job)
            local lines = job:result()
            local worktrees = {}
            local current = {}
            for _, line in ipairs(lines) do
                if line:match("^worktree%s+") then
                    current = { path = line:match("^worktree%s+(.+)") }
                elseif line:match("^branch ") and current.path then
                    current.branch = line:match("^branch%s+refs/heads/(.+)")
                    table.insert(worktrees, current)
                end
            end
            cb(worktrees)
        end,
    }):start()
end

-- Delete Picker
function M.delete_worktree_picker()
    fetch_worktrees(function(wts)
        vim.schedule(function()
            if vim.tbl_isempty(wts) then
                vim.notify("No worktrees to delete", vim.log.levels.INFO)
                return
            end

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

            pickers
                .new({}, {
                    prompt_title = "Delete Worktree (<c-d> to force)",
                    finder = finders.new_table({
                        results = wts,
                        entry_maker = entry_maker,
                    }),
                    sorter = conf.generic_sorter({}),
                    attach_mappings = function(bufnr, map)
                        -- Default action: SAFE delete
                        local function safe_delete()
                            local selection = action_state.get_selected_entry()
                            local path = selection.value.path
                            local branch = selection.value.branch

                            if vim.fn.getcwd() == path then
                                return vim.notify("Cannot delete current worktree", vim.log.levels.WARN)
                            end

                            actions.close(bufnr)
                            -- Check for uncommitted changes
                            Job
                                :new({
                                    command = "git",
                                    args = { "-C", path, "status", "--porcelain" },
                                    on_exit = function(j)
                                        vim.schedule(function()
                                            if #j:result() > 0 then
                                                vim.notify(
                                                    "Uncommitted changes. Use <c-d> to force delete.",
                                                    vim.log.levels.ERROR
                                                )
                                            else
                                                git_wt.delete_worktree(path, false) -- force = false
                                                vim.notify("Deleted worktree: " .. branch, vim.log.levels.INFO)
                                            end
                                        end)
                                    end,
                                })
                                :start()
                        end

                        -- New action: FORCE delete
                        local function force_delete()
                            local selection = action_state.get_selected_entry()
                            local path = selection.value.path
                            local branch = selection.value.branch

                            if vim.fn.getcwd() == path then
                                return vim.notify("Cannot delete current worktree", vim.log.levels.WARN)
                            end

                            actions.close(bufnr)
                            git_wt.delete_worktree(path, true) -- force = true
                            vim.notify("Force-deleted worktree: " .. branch, vim.log.levels.WARN)
                        end

                        -- Set the mappings
                        actions.select_default:replace(safe_delete)
                        map("i", "<c-d>", force_delete)
                        map("n", "<c-d>", force_delete)

                        return true
                    end,
                })
                :find()
        end)
    end)
end

return M
