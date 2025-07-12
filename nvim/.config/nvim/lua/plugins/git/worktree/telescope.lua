local M = {}

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
                .new({}, {
                    prompt_title = "Create Worktree",
                    finder = finders.new_table({ results = branches }),
                    sorter = conf.generic_sorter({}),
                    attach_mappings = function(_, map)
                        actions.select_default:replace(function(bufnr)
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

            -- format entries
            local items = vim.tbl_map(function(wt)
                return wt.branch .. "    " .. wt.path
            end, wts)

            pickers
                .new({}, {
                    prompt_title = "Delete Worktree",
                    finder = finders.new_table({ results = items }),
                    sorter = conf.generic_sorter({}),
                    attach_mappings = function(_, map)
                        actions.select_default:replace(function(bufnr)
                            local entry = action_state.get_selected_entry()[1]
                            actions.close(bufnr)

                            local branch, path = entry:match("^(%S+)%s+(.+)$")
                            if vim.fn.getcwd() == path then
                                return vim.notify("Cannot delete current worktree", vim.log.levels.WARN)
                            end

                            -- check for uncommitted changes
                            Job
                                :new({
                                    command = "git",
                                    args = { "-C", path, "status", "--porcelain" },
                                    on_exit = function(j2)
                                        vim.schedule(function()
                                            if #j2:result() > 0 then
                                                vim.notify(
                                                    "Uncommitted changes present, aborting",
                                                    vim.log.levels.ERROR
                                                )
                                            else
                                                git_wt.delete_worktree(path, false)
                                                vim.notify("Deleted worktree: " .. branch, vim.log.levels.INFO)
                                            end
                                        end)
                                    end,
                                })
                                :start()
                        end)
                        return true
                    end,
                })
                :find()
        end)
    end)
end

return M
