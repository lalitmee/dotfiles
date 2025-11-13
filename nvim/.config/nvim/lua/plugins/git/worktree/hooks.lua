local overseer = require("overseer")
local Hooks = require("git-worktree.hooks")
local config = require("git-worktree.config")
local update_on_switch = Hooks.builtins.update_current_buffer_on_switch
local uv = vim.uv

-- Tracks which worktree paths have already run `yarn install`
local installed_node_modules = {}

-- Keeps reference to running yarn install tasks per path
local running_installs = {}

-- ---------------------------------------------------------------------------
-- Copies a file from `src` to `dest` only if:
--   - `src` exists (is readable), AND
--   - `dest` does not already exist
-- This is useful for copying env files only once per worktree.
-- ---------------------------------------------------------------------------
local function copy_file_if_needed(src, dest)
    if vim.fn.filereadable(src) == 1 and vim.fn.filereadable(dest) == 0 then
        local in_fd = assert(uv.fs_open(src, "r", 438))
        local stat = assert(uv.fs_fstat(in_fd))
        local data = assert(uv.fs_read(in_fd, stat.size, 0))
        uv.fs_close(in_fd)

        local out_fd = assert(uv.fs_open(dest, "w", stat.mode))
        assert(uv.fs_write(out_fd, data, 0))
        uv.fs_close(out_fd)

        vim.notify("📋 Copied " .. vim.fn.fnamemodify(src, ":t") .. " to " .. dest, vim.log.levels.INFO, { title = "Git Worktree" })
    end
end

-- ---------------------------------------------------------------------------
-- Copies standard environment files (.env, .env.local, etc.) from
-- the current/previous worktree into the new one.
-- ---------------------------------------------------------------------------
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

-- ---------------------------------------------------------------------------
-- Ensures that `node_modules` exists in the given worktree path.
-- If:
--   - package.json exists AND
--   - node_modules is missing AND
--   - the install hasn't already been attempted
-- Then:
--   - Cancels any in-progress install for this worktree
--   - Starts a new `yarn install` task via `overseer.nvim`
-- ---------------------------------------------------------------------------
local function ensure_node_modules(path)
    if installed_node_modules[path] then
        return -- ✅ Skip if already installed
    end

    -- Cancel any previous install still running
    if running_installs[path] then
        local task = running_installs[path]
        if task:is_running() then
            vim.notify("🛑 Cancelling previous yarn install in " .. path, vim.log.levels.WARN, { title = "Git Worktree" })
            task:dispose()
        end
    end

    local pkg = path .. "/package.json"
    if vim.fn.filereadable(pkg) == 1 then
        local nm = path .. "/node_modules"
        if vim.fn.isdirectory(nm) == 0 then
            vim.notify("📦 Installing node_modules in " .. path, vim.log.levels.INFO, { title = "Git Worktree" })

            -- Mark install attempt immediately to avoid duplicate triggers
            installed_node_modules[path] = true

            -- Defer the yarn install to avoid buffer conflicts after worktree switch
            vim.defer_fn(function()
                local task = overseer.new_task({
                    name = "yarn install (" .. path .. ")",
                    cmd = "yarn",
                    args = { "install" },
                    cwd = path,
                    strategy = "terminal",
                    components = {
                        "default",
                        { "on_output_quickfix", open = false },
                        "on_exit_set_status",
                        "on_complete_notify",
                    },
                    env = { CI = "false" },
                })

                running_installs[path] = task
                task:start()
            end, 100) -- 100ms delay to ensure buffer operations are complete
        end
    end
end

-- ---------------------------------------------------------------------------
-- Removes all loaded, unmodified buffers that are NOT part of the currently
-- active worktree path. This keeps the buffer list clean and scoped.
-- ---------------------------------------------------------------------------
local function wipe_non_worktree_buffers(current_path)
    local buffers = vim.api.nvim_list_bufs()

    for _, buf in ipairs(buffers) do
        local name = vim.api.nvim_buf_get_name(buf)
        if name ~= "" and not name:match("^" .. vim.pesc(current_path)) then
            local is_loaded = vim.api.nvim_buf_is_loaded(buf)
            local is_modified = vim.api.nvim_get_option_value("modified", { buf = buf })

            if is_loaded and not is_modified then
                vim.api.nvim_buf_delete(buf, { force = true })
            end
        end
    end
end

-- ---------------------------------------------------------------------------
-- CREATE HOOK
-- Triggered when a new worktree is created.
-- - Copies .env files from the current directory into the new worktree.
-- - Runs `yarn install` if needed.
-- ---------------------------------------------------------------------------
Hooks.register(Hooks.type.CREATE, function(new_path)
    local cwd = vim.fn.getcwd()
    copy_env_files(cwd, new_path)
    ensure_node_modules(new_path)
end)

-- ---------------------------------------------------------------------------
-- SWITCH HOOK
-- Triggered when switching to a different worktree.
-- - Updates the buffer.
-- - Deletes all non-relevant buffers.
-- - Copies .env files from the previous worktree.
-- - Runs `yarn install` if needed.
-- ---------------------------------------------------------------------------
Hooks.register(Hooks.type.SWITCH, function(new_path, prev_path)
    vim.notify("Moved from " .. prev_path .. " to " .. new_path, vim.log.levels.INFO, { title = "Git Worktree" })
    update_on_switch(new_path, prev_path)

    wipe_non_worktree_buffers(new_path)
    copy_env_files(prev_path, new_path)
    ensure_node_modules(new_path)
end)

-- ---------------------------------------------------------------------------
-- DELETE HOOK
-- Triggered when a worktree is removed.
-- Just runs the configured update command (e.g., refresh project view).
-- ---------------------------------------------------------------------------
Hooks.register(Hooks.type.DELETE, function()
    vim.cmd(config.update_on_change_command)
end)
