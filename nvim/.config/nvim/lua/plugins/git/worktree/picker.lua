local M = {}
local Job = require("plenary.job")
local git_wt = require("git-worktree")

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
                if clean ~= "HEAD" then seen[clean] = true end
            end
            local list = vim.tbl_keys(seen)
            table.sort(list)
            cb(list)
        end,
    }):start()
end

function M.create_worktree_picker()
    fetch_branches(function(branches)
        vim.schedule(function()
            Snacks.picker.pick(branches, {
                prompt = "Create Worktree",
                layout = { preset = "dropdown" },
                on_confirm = function(item)
                    local branch = type(item) == "string" and item or item.text
                    local name, parent = get_repo_info()
                    local root = vim.fs.joinpath(parent, name .. "-worktrees")
                    vim.fn.mkdir(root, "p")
                    local dest = vim.fs.joinpath(root, branch)
                    vim.notify("Creating worktree at: " .. dest)
                    git_wt.create_worktree(dest, branch, "origin")
                end,
            })
        end)
    end)
end

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

local function safe_delete(wt)
    if vim.fn.getcwd() == wt.path then
        return vim.notify("Cannot delete current worktree", vim.log.levels.WARN, { title = "Git Worktree" })
    end
    Job:new({
        command = "git",
        args = { "-C", wt.path, "status", "--porcelain" },
        on_exit = function(j)
            vim.schedule(function()
                if #j:result() > 0 then
                    vim.notify("Uncommitted changes. Use <c-d> to force delete.", vim.log.levels.ERROR, { title = "Git Worktree" })
                else
                    git_wt.delete_worktree(wt.path, false)
                    vim.notify("Deleted worktree: " .. wt.branch, vim.log.levels.INFO, { title = "Git Worktree" })
                end
            end)
        end,
    }):start()
end

local function force_delete(wt)
    if vim.fn.getcwd() == wt.path then
        return vim.notify("Cannot delete current worktree", vim.log.levels.WARN, { title = "Git Worktree" })
    end
    git_wt.delete_worktree(wt.path, true)
    vim.notify("Force-deleted worktree: " .. wt.branch, vim.log.levels.WARN, { title = "Git Worktree" })
end

function M.delete_worktree_picker()
    fetch_worktrees(function(wts)
        vim.schedule(function()
            if vim.tbl_isempty(wts) then
                vim.notify("No worktrees to delete", vim.log.levels.INFO, { title = "Git Worktree" })
                return
            end
            local items = vim.tbl_map(function(wt)
                return { text = wt.branch .. "  " .. wt.path, data = wt }
            end, wts)
            Snacks.picker.pick(items, {
                prompt = "Delete Worktree (<c-d> to force)",
                layout = { preset = "dropdown" },
                keymap = {
                    ["<c-d>"] = "force_delete",
                },
                on_confirm = function(item)
                    safe_delete(item.data)
                end,
                force_delete = function(item)
                    force_delete(item.data)
                end,
            })
        end)
    end)
end

return M
