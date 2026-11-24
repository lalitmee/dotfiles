local M = {}

local HOME = os.getenv("HOME") or ""

-- All 25 tmux-tpad instances + Tome playbook, normalized into one table.
M.ENTRIES = {
    ["lazygit"] = { title = "Lazygit", sh = "lazygit", per_dir = true },
    ["lazydocker"] = { title = "Lazydocker", sh = "lazydocker" },
    ["gh-dash"] = { title = "GitHub Dash", sh = "gh dash" },
    ["process-viewer"] = { title = "Process Viewer", sh = "btm" },
    ["grimoire"] = { title = "Grimoire Scratchpad", sh = nil },
    ["scratchpad"] = { title = "Scratchpad", sh = nil },
    ["espanso-edit"] = { title = "Espanso Edit", sh = "espanso edit" },
    ["cht-sh"] = { title = "Cht.sh", sh = HOME .. "/.config/tmux/scripts/cht-sh/cht.sh" },
    ["manpage"] = { title = "Man Page", sh = "man zsh" },
    ["git-help"] = { title = "Git Help", sh = "git help -a | less" },
    ["regex-test"] = { title = "Regex Help", sh = 'python3 -c "import re; help(re)" | less' },
    ["worktree-logs"] = { title = "Worktree Logs", sh = "nvim " .. HOME .. "/.local/share/tmux/logs/git-worktree.log" },
    ["tome-playbook"] = { title = "Tome Playbook", sh = "nvim .playbook.md", per_dir = true },

    -- Second-brain instances
    ["notes-personal"] = { title = "Personal Notes", sh = "nvim " .. HOME .. "/Projects/Personal/Github/second-brain/brain/notes/inbox.org" },
    ["notes-work"] = { title = "Work Notes", sh = "nvim " .. HOME .. "/Projects/Work/Github/second-brain/notes/inbox.org" },
    ["todos-personal"] = { title = "Personal Todos", sh = "nvim " .. HOME .. "/Projects/Personal/Github/second-brain/daily/agenda/todos.org" },
    ["todos-work"] = { title = "Work Todos", sh = "nvim " .. HOME .. "/Projects/Work/Github/second-brain/agenda/todos.org" },
    ["daily-personal-todo"] = { title = "Daily Personal Todos", sh = 'nvim "' .. HOME .. '/Projects/Personal/Github/second-brain/daily/agenda/daily/$(date +%Y-%m-%d).org"' },
    ["daily-work-todo"] = { title = "Daily Work Todos", sh = 'nvim "' .. HOME .. '/Projects/Work/Github/second-brain/agenda/daily/$(date +%Y-%m-%d).org"' },
    ["scratch-personal"] = { title = "Personal Scratchpad", sh = "nvim " .. HOME .. "/Projects/Personal/Github/second-brain/sandbox/scratch/inbox.org" },
    ["scratch-work"] = { title = "Work Scratchpad", sh = "nvim " .. HOME .. "/Projects/Work/Github/second-brain/scratch/inbox.org" },
    ["journal-personal"] = { title = "Personal Journal", sh = 'nvim "' .. HOME .. '/Projects/Personal/Github/second-brain/daily/journal/$(date +%Y-%m-%d).org"' },
    ["journal-work"] = { title = "Work Journal", sh = 'nvim "' .. HOME .. '/Projects/Work/Github/second-brain/journal/$(date +%Y-%m-%d).org"' },
    ["ai-notes"] = { title = "AI Notes", sh = "nvim " .. HOME .. "/Projects/Personal/Github/ai-brain/notes/inbox.md" },
    ["ai-journal"] = { title = "AI Journal", sh = 'mkdir -p "' .. HOME .. '/Projects/Personal/Github/ai-brain/journal/$(date +%Y/%m)" && nvim "' .. HOME .. '/Projects/Personal/Github/ai-brain/journal/$(date +%Y/%m/%d).md"' },
    ["backup-logs"] = { title = "Backup Logs", sh = "nvim " .. HOME .. "/.local/share/backup-logs/" },
}

function M.cwd(ctx)
    if not ctx or not ctx.session_id or not ctx.block_id then
        return HOME
    end
    local ok, proc = pcall(rex.block.call, "com.superlogical.terminal", "process", {
        session_id = ctx.session_id,
        block_id = ctx.block_id,
    })
    if ok and proc then
        if proc.foreground and proc.foreground.cwd and proc.foreground.cwd ~= "" then
            return proc.foreground.cwd
        end
        if proc.child and proc.child.cwd and proc.child.cwd ~= "" then
            return proc.child.cwd
        end
        if proc.home and proc.home ~= "" then
            return proc.home
        end
    end
    return HOME
end

function M.is_vim(ctx)
    if not ctx or not ctx.session_id or not ctx.block_id then
        return false
    end
    local ok, proc = pcall(rex.block.call, "com.superlogical.terminal", "process", {
        session_id = ctx.session_id,
        block_id = ctx.block_id,
    })
    local fg = ok and proc and proc.foreground
    if not fg then
        return false
    end
    local argv0_base = (fg.argv0 or ""):match("[^/]*$") or ""
    for _, candidate in ipairs({ fg.name or "", argv0_base }) do
        if candidate:match("^n?vim$") or candidate:match("^n?vimdiff$") then
            return true
        end
    end
    return false
end

local function git_root(dir)
    local ok, res = pcall(rex.exec, { "git", "-C", dir, "rev-parse", "--show-toplevel" })
    if ok and res and res.exit_code == 0 and res.stdout then
        local root = res.stdout:gsub("%s+$", "")
        if root ~= "" then
            return root
        end
    end
    return dir
end

function M.get_view(session_id)
    local ok, att = pcall(rex.call, "session.attach", { session_id = session_id })
    if ok and att and att.view then
        return att.view
    end
    local ok2, v = pcall(rex.call, "session.view", { session_id = session_id })
    if ok2 and v and v.windows then
        return v
    end
    return nil
end

function M.active_window(view, window_id)
    if not view or not view.windows then
        return nil
    end
    local target = window_id or view.active_window_id
    for _, w in ipairs(view.windows) do
        if w.window_id == target then
            return w
        end
    end
    return view.windows[1]
end

function M.open_floating(ctx, label, sh_cmd, opts)
    opts = opts or {}
    if not ctx or not ctx.session_id then
        return
    end
    local dir = opts.cwd or M.cwd(ctx)
    local bounds = opts.bounds or { 0.05, 0.05, 0.9, 0.9 }
    local block_opts = {
        cwd = dir,
        interactive = true,
        exit = { on_completion = opts.close_on_exit ~= false },
    }
    if sh_cmd and sh_cmd ~= "" then
        block_opts.command = { "zsh", "-lc", sh_cmd }
    end
    return rex.call("session.new_layer", {
        session_id = ctx.session_id,
        window_id = ctx.window_id,
        bounds = bounds,
        focus = true,
        layout = {
            block = {
                flavor = "com.superlogical.terminal.shell",
                label = label,
                options = block_opts,
            },
        },
    })
end

function M.open_tab(ctx, label, sh_cmd, opts)
    opts = opts or {}
    if not ctx or not ctx.session_id then
        return
    end
    local dir = opts.cwd or M.cwd(ctx)
    local block_opts = {
        cwd = dir,
        interactive = true,
        exit = { on_completion = opts.close_on_exit ~= false },
    }
    if sh_cmd and sh_cmd ~= "" then
        block_opts.command = { "zsh", "-lc", sh_cmd }
    end
    return rex.call("session.new_window", {
        session_id = ctx.session_id,
        label = label,
        focus = true,
        layout = {
            block = {
                flavor = "com.superlogical.terminal.shell",
                label = label,
                options = block_opts,
            },
        },
    })
end

function M.toggle(ctx, name)
    local entry = M.ENTRIES[name]
    if not entry or not ctx or not ctx.session_id then
        return
    end

    local dir = M.cwd(ctx)
    if entry.per_dir then
        dir = git_root(dir)
    end
    local label = "tpad:" .. name .. (entry.per_dir and (":" .. dir) or "")

    local view = M.get_view(ctx.session_id)
    local win = M.active_window(view, ctx.window_id)
    if win and win.layers then
        for _, layer in ipairs(win.layers) do
            if layer.kind ~= "tiled" and layer.blocks then
                for _, blk in ipairs(layer.blocks) do
                    if blk.label == label then
                        local is_focused = false
                        for _, b in ipairs(layer.blocks) do
                            if b.block_id == win.focused_block_id then
                                is_focused = true
                                break
                            end
                        end
                        if layer.state == "minimized" or not is_focused then
                            rex.call("session.set_layer_state", {
                                session_id = ctx.session_id,
                                layer_id = layer.layer_id,
                                state = "normal",
                                focus = true,
                            })
                        else
                            rex.call("session.set_layer_state", {
                                session_id = ctx.session_id,
                                layer_id = layer.layer_id,
                                state = "minimized",
                            })
                        end
                        return
                    end
                end
            end
        end
    end

    M.open_floating(ctx, label, entry.sh, { cwd = dir, bounds = { 0.05, 0.05, 0.9, 0.9 } })
end

return M
