local overseer = require("overseer")
local Hooks = require("git-worktree.hooks")
local config = require("git-worktree.config")
local update_on_switch = Hooks.builtins.update_current_buffer_on_switch
local uv = vim.uv

local installed_node_modules = {}

-- Reusable: copy file if exists and missing in target
local function copy_file_if_needed(src, dest)
    if vim.fn.filereadable(src) == 1 and vim.fn.filereadable(dest) == 0 then
        local in_fd = assert(uv.fs_open(src, "r", 438))
        local stat = assert(uv.fs_fstat(in_fd))
        local data = assert(uv.fs_read(in_fd, stat.size, 0))
        uv.fs_close(in_fd)
        local out_fd = assert(uv.fs_open(dest, "w", stat.mode))
        assert(uv.fs_write(out_fd, data, 0))
        uv.fs_close(out_fd)
        vim.notify("📋 Copied " .. vim.fn.fnamemodify(src, ":t") .. " to " .. dest, vim.log.levels.INFO)
    end
end

-- Reusable: copy all .env* files
local function copy_env_files(src_dir, dst_dir)
    local env_files = {
        ".env",
        ".env.local",
        ".env.development.local",
        ".env.test.local",
        ".env.production.local",
    }

    for _, filename in ipairs(env_files) do
        local src = src_dir .. "/" .. filename
        local dst = dst_dir .. "/" .. filename
        copy_file_if_needed(src, dst)
    end
end

-- Reusable: install node_modules if package.json exists and node_modules is missing
local function ensure_node_modules(path)
    if installed_node_modules[path] then
        return -- already handled
    end

    local pkg = path .. "/package.json"
    if vim.fn.filereadable(pkg) == 1 then
        local nm = path .. "/node_modules"
        if vim.fn.isdirectory(nm) == 0 then
            installed_node_modules[path] = true -- ✅ mark before async
            vim.notify("📦 Installing node_modules in " .. path, vim.log.levels.INFO)

            local task = overseer.new_task({
                name = "yarn install (" .. path .. ")",
                cmd = "yarn",
                args = { "install" },
                cwd = path,
                strategy = "toggleterm",
                components = {
                    "default",
                    "on_output_quickfix",
                    "on_exit_set_status",
                    "on_complete_notify",
                },
                env = { CI = "false" },
            })

            task:start()
        end
    end
end

-- CASE 1: on CREATE, always copy .env (if present) + install node_modules
Hooks.register(Hooks.type.CREATE, function(new_path)
    local cwd = vim.fn.getcwd()
    copy_env_files(cwd, new_path)
    ensure_node_modules(new_path)
end)

-- Final: Register switch hook with everything merged
Hooks.register(Hooks.type.SWITCH, function(new_path, prev_path)
    vim.notify("Moved from " .. prev_path .. " to " .. new_path)
    update_on_switch(new_path, prev_path)

    -- Copy all relevant .env* files
    copy_env_files(prev_path, new_path)

    -- Ensure node_modules in the new worktree
    ensure_node_modules(new_path)
end)

Hooks.register(Hooks.type.DELETE, function()
    vim.cmd(config.update_on_change_command)
end)
