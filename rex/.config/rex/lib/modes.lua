local scratchpad = require("lib.scratchpad")

local M = {}

local HOME = os.getenv("HOME") or ""
local TMUX_SCRIPTS = HOME .. "/.config/tmux/scripts"

local function spawn_bg(cmd)
    return "nohup " .. cmd .. " >/dev/null 2>&1 &"
end

-- Declarative registry for all 11 tmux modal sub-tables + sticky resize mode.
M.MODES = {
    ["file-picker-mode"] = {
        trigger = "ctrl+a>ctrl+f",
        items = {
            { key = "f", title = "File picker (cwd)", float = "f=$(fd --type f --hidden --exclude .git | fzf); [ -n \"$f\" ] && printf '%s' \"$f\"" },
            { key = "d", title = "AI docs picker", float = TMUX_SCRIPTS .. "/ai-docs-picker.sh" },
            { key = "g", title = "File picker (git root)", float = "root=$(git rev-parse --show-toplevel 2>/dev/null || pwd); f=$(fd --type f --hidden --exclude .git . \"$root\" | fzf); [ -n \"$f\" ] && printf '%s' \"$f\"" },
            { key = "z", title = "Zoxide picker", float = "zoxide query -l | fzf" },
            { key = "v", title = "Zoxide (dir only)", float = "zoxide query -l | fzf" },
            { key = "x", title = "Zoxide (git root)", float = "zoxide query -l | while read -r d; do [ -d \"$d/.git\" ] && echo \"$d\"; done | fzf" },
        },
    },

    ["ask-tools"] = {
        trigger = "ctrl+a>shift+a",
        items = {
            { key = "a", title = "AI ask", float = TMUX_SCRIPTS .. "/ask-sh/ask.sh ai" },
            { key = "c", title = "AI chat", float = TMUX_SCRIPTS .. "/ask-sh/ask.sh ai-chat" },
            { key = "s", title = "Site search", float = TMUX_SCRIPTS .. "/ask-sh/ask.sh site" },
            { key = "/", title = "Web search", float = TMUX_SCRIPTS .. "/ask-sh/ask.sh search" },
            { key = "d", title = "Ducky search", float = TMUX_SCRIPTS .. "/ask-sh/ask.sh ducky" },
            { key = "b", title = "Bang search", float = TMUX_SCRIPTS .. "/ask-sh/ask.sh bang" },
        },
    },

    ["ai-tools"] = {
        trigger = "ctrl+a>ctrl+i",
        items = {
            { key = "a", title = "Antigravity", float = "agy", bounds = { 0.1, 0.2, 0.8, 0.55 } },
            { key = "o", title = "OpenCode", float = "opencode", bounds = { 0.1, 0.2, 0.8, 0.55 } },
            { key = "c", title = "Claude Code", float = "claude", bounds = { 0.1, 0.2, 0.8, 0.55 } },
            { key = "x", title = "Codex", float = "codex", bounds = { 0.1, 0.2, 0.8, 0.55 } },
            { key = "s", title = "Crush", float = "crush", bounds = { 0.1, 0.2, 0.8, 0.55 } },
            { key = "k", title = "Kiro", float = "kiro-cli", bounds = { 0.1, 0.2, 0.8, 0.55 } },
            { key = "r", title = "Grok CLI", float = "grok", bounds = { 0.1, 0.2, 0.8, 0.55 } },
            { key = "p", title = "Pi Agent", float = "pi", bounds = { 0.1, 0.2, 0.8, 0.55 } },
            { key = "h", title = "GitHub Copilot", float = "copilot", bounds = { 0.1, 0.2, 0.8, 0.55 } },
            { key = "g", title = "Cursor Agent", float = "cursor-agent", bounds = { 0.1, 0.2, 0.8, 0.55 } },
            { key = "n", title = "Rename tab", action = "client.tab.rename" },
            { key = "u", title = "Update AI tools (auto)", exec = { "zsh", "-lc", "UPDATE_MODE=--non-interactive " .. TMUX_SCRIPTS .. "/popup/ai/update.sh" } },
            { key = "shift+u", title = "Update AI tools (interactive)", float = "UPDATE_MODE=--interactive " .. TMUX_SCRIPTS .. "/popup/ai/update.sh" },
            { key = "i", title = "Manage AI/CLI tools", float = TMUX_SCRIPTS .. "/popup/ai/manage.sh" },
            { key = "m", title = "Install package", float = TMUX_SCRIPTS .. "/popup/package-install.sh" },
        },
    },

    ["second-brain"] = {
        trigger = "ctrl+a>ctrl+b",
        items = {
            { key = "n", title = "Personal Notes", scratchpad = "notes-personal" },
            { key = "shift+n", title = "Work Notes", scratchpad = "notes-work" },
            { key = "t", title = "Personal Todos", scratchpad = "todos-personal" },
            { key = "shift+t", title = "Work Todos", scratchpad = "todos-work" },
            { key = "d", title = "Daily Personal Todos", scratchpad = "daily-personal-todo" },
            { key = "shift+d", title = "Daily Work Todos", scratchpad = "daily-work-todo" },
            { key = "s", title = "Personal Scratchpad", scratchpad = "scratch-personal" },
            { key = "shift+s", title = "Work Scratchpad", scratchpad = "scratch-work" },
            { key = "j", title = "Personal Journal", scratchpad = "journal-personal" },
            { key = "shift+j", title = "Work Journal", scratchpad = "journal-work" },
            { key = "i", title = "AI Notes", scratchpad = "ai-notes" },
            { key = "shift+i", title = "AI Journal", scratchpad = "ai-journal" },
            { key = "l", title = "Backup Logs", scratchpad = "backup-logs" },
            { key = "f", title = "Search second-brain text", float = TMUX_SCRIPTS .. "/popup/second-brain-search.sh text" },
            { key = "g", title = "Search second-brain files", float = TMUX_SCRIPTS .. "/popup/second-brain-search.sh file" },
            { key = "p", title = "Search personal text", float = TMUX_SCRIPTS .. "/popup/second-brain-search.sh text personal" },
            { key = "w", title = "Search work text", float = TMUX_SCRIPTS .. "/popup/second-brain-search.sh text work" },
            { key = "a", title = "Search AI text", float = TMUX_SCRIPTS .. "/popup/second-brain-search.sh text ai" },
            { key = "k", title = "Search personal files", float = TMUX_SCRIPTS .. "/popup/second-brain-search.sh file personal" },
            { key = "h", title = "Search work files", float = TMUX_SCRIPTS .. "/popup/second-brain-search.sh file work" },
            { key = "c", title = "Search AI files", float = TMUX_SCRIPTS .. "/popup/second-brain-search.sh file ai" },
        },
    },

    ["layout-mode"] = {
        trigger = "ctrl+b",
        items = {
            { key = "ctrl+b", title = "Toggle toolbar", action = "client.toolbar.toggle" },
            { key = "f", title = "Toggle floating pane", fn_name = "toggle_float" },
            { key = "v", title = "Split down", action = "pane.split.down" },
            { key = "shift+h", title = "Split right", action = "pane.split.right" },
            { key = "h", title = "Split left 40%", fn_name = "split_40_left" },
            { key = "l", title = "Split right 40%", fn_name = "split_40_right" },
            { key = "j", title = "Split down 30%", fn_name = "split_30_down" },
            { key = "k", title = "Split up 30%", fn_name = "split_30_up" },
            { key = "n", title = "New named tab", fn_name = "new_named_tab" },
            { key = "ctrl+o", title = "Search lines (tsnv)", tab = "tsnv" },
            { key = "x", title = "Kill process", float = "KILL_PROCESS_INLINE=1 " .. HOME .. "/.config/bin/kill-process" },
            { key = "g", title = "Git pull/merge", float = TMUX_SCRIPTS .. "/git-pull-merge.sh", bounds = { 0.2, 0.15, 0.6, 0.7 } },
            { key = "e", title = "Edit visible scrollback", fn_name = "capture_scrollback_tab" },
            { key = "shift+e", title = "Edit full scrollback", fn_name = "capture_scrollback_tab" },
            { key = "m", title = "Doc finder", float = TMUX_SCRIPTS .. "/doc-finder.sh" },
        },
    },

    ["dev-mode"] = {
        trigger = "ctrl+a>ctrl+d",
        items = {
            { key = "e", title = "Espanso edit", scratchpad = "espanso-edit" },
            { key = "r", title = "Project runner", float = TMUX_SCRIPTS .. "/popup/runner/runner.sh" },
            { key = "a", title = "APT repo manager", float = TMUX_SCRIPTS .. "/apt-repo-manager.sh" },
            { key = "p", title = "Package installer", float = TMUX_SCRIPTS .. "/popup/package-install.sh" },
            { key = "b", title = "Back in 5", float = HOME .. "/.config/tmux/plugins/back-in-5/scripts/main.sh", bounds = { 0.0, 0.0, 1.0, 1.0 } },
            { key = "s", title = "Scratchpad", scratchpad = "scratchpad" },
            { key = "d", title = "Dev env manager", tab = "exec " .. HOME .. "/.local/bin/dact menu" },
        },
    },

    ["monitor-mode"] = {
        trigger = "ctrl+a>ctrl+m",
        items = {
            { key = "b", title = "Process viewer (btm)", scratchpad = "process-viewer" },
        },
    },

    ["quick-ref"] = {
        trigger = "ctrl+a>ctrl+q",
        items = {
            { key = "c", title = "cht.sh", scratchpad = "cht-sh" },
            { key = "m", title = "Man page (zsh)", scratchpad = "manpage" },
            { key = "g", title = "Git help", scratchpad = "git-help" },
            { key = "r", title = "Regex help", scratchpad = "regex-test" },
        },
    },

    ["spotify-mode"] = {
        trigger = "ctrl+a>ctrl+e",
        items = {
            { key = "p", title = "Spotify previous", exec = { "zsh", "-lc", spawn_bg(TMUX_SCRIPTS .. "/popup/spotify/spotify-action.sh previous") } },
            { key = "n", title = "Spotify next", exec = { "zsh", "-lc", spawn_bg(TMUX_SCRIPTS .. "/popup/spotify/spotify-action.sh next") } },
            { key = "s", title = "Spotify play/pause", exec = { "zsh", "-lc", spawn_bg(TMUX_SCRIPTS .. "/popup/spotify/spotify-action.sh play-pause") } },
            { key = "u", title = "Spotify volume up", exec = { "zsh", "-lc", spawn_bg(TMUX_SCRIPTS .. "/popup/spotify/spotify-action.sh volume-up") } },
            { key = "d", title = "Spotify volume down", exec = { "zsh", "-lc", spawn_bg(TMUX_SCRIPTS .. "/popup/spotify/spotify-action.sh volume-down") } },
        },
    },

    ["git-mode"] = {
        trigger = "ctrl+a>ctrl+g",
        items = {
            { key = "w", title = "Worktree interactive", float = TMUX_SCRIPTS .. "/git/git-worktree.sh" },
            { key = "m", title = "Worktree manager", tab = "zsh " .. TMUX_SCRIPTS .. "/worktree-manager.sh --launch" },
            { key = "c", title = "Create worktree", float = TMUX_SCRIPTS .. "/git/git-worktree.sh create" },
            { key = "s", title = "Switch worktree", float = TMUX_SCRIPTS .. "/git/git-worktree.sh switch" },
            { key = "d", title = "Delete worktree", float = TMUX_SCRIPTS .. "/git/git-worktree.sh delete" },
            { key = "v", title = "Git worktree list", float = "git worktree list | less -RX" },
            { key = "a", title = "Git status & worktrees", float = "git status -sb && echo '---' && git worktree list | less -RX" },
            { key = "o", title = "Worktrees overview", float = "git worktree list -v | less -RX" },
            { key = "r", title = "Review diff", float = "git diff | less -RX" },
            { key = "p", title = "GitHub PR status", float = "gh pr status | less -RX" },
            { key = "i", title = "Git status", float = "git status | less -RX" },
            { key = "b", title = "Toggle sidebar", action = "client.sidebar.toggle" },
            { key = "l", title = "Worktree logs", scratchpad = "worktree-logs" },
            { key = "x", title = "Workmux palette", tab = TMUX_SCRIPTS .. "/popup/workmux-palette.sh" },
            { key = "shift+p", title = "PR checkout", float = TMUX_SCRIPTS .. "/git/pr-checkout.sh" },
            { key = ".", title = "History back", action = "client.history.back" },
            { key = "t", title = "History forward", action = "client.history.forward" },
            { key = "shift+r", title = "Reload config", action = "client.config.reload" },
        },
    },

    ["work-sessions"] = {
        trigger = "ctrl+a>ctrl+w",
        items = {
            { key = "0", title = "Work sessions preset 0", float = TMUX_SCRIPTS .. "/work-sessions/work-sessions.sh 0" },
            { key = "1", title = "Work sessions preset 1", float = TMUX_SCRIPTS .. "/work-sessions/work-sessions.sh 1" },
            { key = "2", title = "Work sessions preset 2", float = TMUX_SCRIPTS .. "/work-sessions/work-sessions.sh 2" },
            { key = "3", title = "Work sessions preset 3", float = TMUX_SCRIPTS .. "/work-sessions/work-sessions.sh 3" },
            { key = "4", title = "Work sessions preset 4", float = TMUX_SCRIPTS .. "/work-sessions/work-sessions.sh 4" },
            { key = "5", title = "Work sessions preset 5", float = TMUX_SCRIPTS .. "/work-sessions/work-sessions.sh 5" },
            { key = "p", title = "Work sessions picker", float = TMUX_SCRIPTS .. "/work-sessions/work-sessions.sh" },
            { key = "l", title = "List sessions", action = "session.switch" },
            { key = "k", title = "Close session", action = "session.close" },
        },
    },

    ["resize"] = {
        trigger = "ctrl+a>r",
        sticky = true,
        items = {
            { key = "h", title = "Resize left", action = "pane.resize", args = { direction = "left", amount = 4 } },
            { key = "j", title = "Resize down", action = "pane.resize", args = { direction = "down", amount = 4 } },
            { key = "k", title = "Resize up", action = "pane.resize", args = { direction = "up", amount = 4 } },
            { key = "l", title = "Resize right", action = "pane.resize", args = { direction = "right", amount = 4 } },
            { key = "shift+h", title = "Resize left (fine)", action = "pane.resize", args = { direction = "left", amount = 2 } },
            { key = "shift+j", title = "Resize down (fine)", action = "pane.resize", args = { direction = "down", amount = 2 } },
            { key = "shift+k", title = "Resize up (fine)", action = "pane.resize", args = { direction = "up", amount = 2 } },
            { key = "shift+l", title = "Resize right (fine)", action = "pane.resize", args = { direction = "right", amount = 2 } },
        },
    },
}

local function sanitize_name(s)
    return (s:gsub("[^a-zA-Z0-9_]", "_"))
end

function M.register(helpers)
    for mode_name, spec in pairs(M.MODES) do
        if spec.trigger then
            rex.bind(spec.trigger, "client.mode.enter", { name = mode_name })
        end

        for _, item in ipairs(spec.items) do
            local key_path = mode_name .. "/" .. item.key
            local sticky = spec.sticky or item.sticky

            if item.action then
                if sticky then
                    rex.bind(key_path, item.action, item.args)
                else
                    local act_name = "mode_" .. sanitize_name(mode_name .. "_" .. item.key)
                    rex.action({
                        name = act_name,
                        title = item.title,
                        run = function(_ctx)
                            rex.client.queue("client.mode.exit")
                            rex.client.queue(item.action, item.args)
                        end,
                    })
                    rex.bind(key_path, act_name)
                end
            elseif item.scratchpad then
                local act_name = "mode_" .. sanitize_name(mode_name .. "_" .. item.key)
                local target = item.scratchpad
                rex.action({
                    name = act_name,
                    title = item.title,
                    run = function(ctx)
                        rex.client.queue("client.mode.exit")
                        scratchpad.toggle(ctx, target)
                    end,
                })
                rex.bind(key_path, act_name)
            elseif item.float then
                local act_name = "mode_" .. sanitize_name(mode_name .. "_" .. item.key)
                local cmd = item.float
                local bounds = item.bounds
                rex.action({
                    name = act_name,
                    title = item.title,
                    run = function(ctx)
                        rex.client.queue("client.mode.exit")
                        scratchpad.open_floating(ctx, item.title, cmd, { bounds = bounds })
                    end,
                })
                rex.bind(key_path, act_name)
            elseif item.tab then
                local act_name = "mode_" .. sanitize_name(mode_name .. "_" .. item.key)
                local cmd = item.tab
                rex.action({
                    name = act_name,
                    title = item.title,
                    run = function(ctx)
                        rex.client.queue("client.mode.exit")
                        scratchpad.open_tab(ctx, item.title, cmd)
                    end,
                })
                rex.bind(key_path, act_name)
            elseif item.exec then
                local act_name = "mode_" .. sanitize_name(mode_name .. "_" .. item.key)
                local argv = item.exec
                rex.action({
                    name = act_name,
                    title = item.title,
                    run = function(_ctx)
                        if not sticky then
                            rex.client.queue("client.mode.exit")
                        end
                        rex.exec(argv)
                    end,
                })
                rex.bind(key_path, act_name)
            elseif item.fn_name and helpers[item.fn_name] then
                local act_name = "mode_" .. sanitize_name(mode_name .. "_" .. item.key)
                local fn = helpers[item.fn_name]
                rex.action({
                    name = act_name,
                    title = item.title,
                    run = function(ctx)
                        if not sticky then
                            rex.client.queue("client.mode.exit")
                        end
                        fn(ctx)
                    end,
                })
                rex.bind(key_path, act_name)
            end
        end

        -- Standard exit & help bindings in every mode
        rex.bind(mode_name .. "/escape", "client.mode.exit")
        if mode_name ~= "layout-mode" then
            rex.bind(mode_name .. "/q", "client.mode.exit")
        else
            rex.action({
                name = "layout_kill_bottom_pane",
                title = "Close focused pane",
                run = function(_ctx)
                    rex.client.queue("client.mode.exit")
                    rex.client.queue("pane.close")
                end,
            })
            rex.bind("layout-mode/q", "layout_kill_bottom_pane")
        end
        rex.bind(mode_name .. "/shift+/", "client.shortcuts")
    end
end

return M
