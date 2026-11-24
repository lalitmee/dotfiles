-- Portable Rex configuration matching tmux.conf.local & herdr-app unified keybindings.
local home = os.getenv("HOME") or ""
package.path = home .. "/.config/rex/?.lua;" .. package.path

local scratchpad = require("lib.scratchpad")
local modes = require("lib.modes")

-- ---------------------------------------------------------------------------
-- 1. Helper Actions (Vim nav, floating toggles, scrollback capture, pickers)
-- ---------------------------------------------------------------------------

local function is_floating_focused(ctx)
    if not ctx or not ctx.session_id or not ctx.block_id then
        return false
    end
    local view = scratchpad.get_view(ctx.session_id)
    local win = scratchpad.active_window(view, ctx.window_id)
    if not win or not win.layers then
        return false
    end
    for _, layer in ipairs(win.layers) do
        if layer.kind ~= "tiled" and layer.blocks then
            for _, blk in ipairs(layer.blocks) do
                if blk.block_id == ctx.block_id then
                    return true
                end
            end
        end
    end
    return false
end

local function toggle_float(ctx)
    if is_floating_focused(ctx) then
        rex.client.queue("pane.return_to_tiles")
    else
        rex.client.queue("pane.float")
    end
end

local function capture_scrollback(ctx, as_tab)
    if not ctx or not ctx.session_id or not ctx.block_id then
        return
    end
    local ok, res = pcall(rex.block.call, "com.superlogical.terminal", "format", {
        session_id = ctx.session_id,
        block_id = ctx.block_id,
        format = "text",
    })
    if not ok or not res or not res.content then
        return
    end
    local tmp = os.tmpname() .. ".rex-pane.txt"
    local f = io.open(tmp, "w")
    if not f then
        return
    end
    f:write(res.content)
    f:close()
    local cmd = string.format("nvim +'set binary noeol' +'$' %q; rm -f %q", tmp, tmp)
    if as_tab then
        scratchpad.open_tab(ctx, "hist", cmd)
    else
        scratchpad.open_floating(ctx, "scrollback", cmd, { bounds = { 0.05, 0.05, 0.9, 0.9 } })
    end
end

local function split_with_ratio(ctx, direction, before, amount)
    rex.client.queue("pane.split", { direction = direction })
    if amount then
        local resize_dir = before and direction or (direction == "right" and "left" or "up")
        rex.client.queue("pane.resize", { direction = resize_dir, amount = amount })
    end
end

local helpers = {
    toggle_float = toggle_float,
    capture_scrollback_tab = function(ctx) capture_scrollback(ctx, true) end,
    split_40_left = function(ctx) split_with_ratio(ctx, "left", true, 6) end,
    split_40_right = function(ctx) split_with_ratio(ctx, "right", false, 6) end,
    split_30_down = function(ctx) split_with_ratio(ctx, "down", false, 8) end,
    split_30_up = function(ctx) split_with_ratio(ctx, "up", true, 8) end,
    new_named_tab = function(_ctx)
        local name = rex.ui.input({ prompt = "Window/Tab name:" })
        if name and name ~= "" then
            rex.client.queue("client.tab.new")
            rex.client.queue("client.tab.rename", { label = name })
        end
    end,
}

rex.action({ name = "toggle_float", title = "Toggle pane float/tiled", run = toggle_float })
rex.action({ name = "capture_scrollback_float", title = "Edit scrollback in nvim", run = function(ctx) capture_scrollback(ctx, false) end })

rex.action({
    name = "toggle_tpad_lazygit",
    title = "Toggle Lazygit",
    run = function(ctx) scratchpad.toggle(ctx, "lazygit") end,
})
rex.action({
    name = "toggle_tpad_lazydocker",
    title = "Toggle Lazydocker",
    run = function(ctx) scratchpad.toggle(ctx, "lazydocker") end,
})
rex.action({
    name = "toggle_tpad_gh_dash",
    title = "Toggle GitHub Dash",
    run = function(ctx) scratchpad.toggle(ctx, "gh-dash") end,
})
rex.action({
    name = "toggle_tpad_grimoire",
    title = "Toggle Grimoire Scratchpad",
    run = function(ctx) scratchpad.toggle(ctx, "grimoire") end,
})
rex.action({
    name = "toggle_tpad_tome",
    title = "Toggle Tome Playbook",
    run = function(ctx) scratchpad.toggle(ctx, "tome-playbook") end,
})
rex.action({
    name = "toggle_dashboard",
    title = "Toggle Multiplexer Dashboard",
    run = function(ctx) scratchpad.open_floating(ctx, "dashboard", home .. "/.local/bin/multiplexer-sidebar", { bounds = { 0.1, 0.1, 0.8, 0.8 } }) end,
})
rex.action({
    name = "project_session_picker",
    title = "Project Sessionizer",
    run = function(ctx)
        local out = rex.exec({ "zsh", "-lc", "fd --max-depth 3 --type d --glob '.git' ~/Projects 2>/dev/null | xargs -r -n1 dirname" })
        local dirs = {}
        if out and out.stdout then
            for line in out.stdout:gmatch("[^\r\n]+") do
                dirs[#dirs + 1] = line
            end
        end
        if #dirs == 0 then
            rex.client.queue("session.new")
            return
        end
        local picked = rex.ui.pick({ prompt = "Open project session:", items = dirs })
        if picked and picked ~= "" then
            local name = picked:match("([^/]+)$") or picked
            rex.call("session.create", {
                label = name,
                windows = {
                    {
                        label = "main",
                        layout = {
                            block = {
                                flavor = "com.superlogical.terminal.shell",
                                options = { cwd = picked },
                            },
                        },
                    },
                },
            })
        end
    end,
})

-- ---------------------------------------------------------------------------
-- 2. Next / Prev & Direct Navigation (Reconciled Unified Hierarchy)
-- ---------------------------------------------------------------------------

-- 2-key: Sequential Pane cycling
rex.bind("alt+[", "pane.focus_previous")
rex.bind("alt+]", "pane.focus_next")

-- 3-key: Session cycling
rex.bind("ctrl+shift+k", "session.previous")
rex.bind("ctrl+shift+j", "session.next")

-- Tab cycling & reordering
rex.bind("ctrl+a>p", "client.tab.previous")
rex.bind("ctrl+a>n", "client.tab.next")
rex.bind("ctrl+shift+tab", "client.tab.previous")
rex.bind("ctrl+tab", "client.tab.next")
rex.bind("ctrl+pageup", "client.tab.previous")
rex.bind("ctrl+pagedown", "client.tab.next")
rex.bind("ctrl+a>ctrl+shift+h", "client.tab.move.backward")
rex.bind("ctrl+a>ctrl+shift+l", "client.tab.move.forward")

-- Jumplist / History & Prompt navigation
rex.bind("alt+,", "client.history.back")
rex.bind("alt+.", "client.history.forward")
rex.bind("alt+up", "client.prompt.previous")
rex.bind("alt+down", "client.prompt.next")

-- Direct tab 1..9 & direct session 1..9
for i = 1, 9 do
    local s = tostring(i)
    rex.bind("ctrl+" .. s, "client.tab.goto", { index = i })
    rex.bind("ctrl+a>" .. s, "client.tab.goto", { index = i })

    local act_name = "select_session_" .. s
    rex.action({
        name = act_name,
        title = "Select session " .. s,
        run = function(_ctx)
            local res = rex.call("session.list")
            local target = res and res.sessions and res.sessions[i]
            if target then
                rex.client.queue("session.select", { session_id = target.session_id })
            end
        end,
    })
    rex.bind("alt+" .. s, act_name)
end

-- ---------------------------------------------------------------------------
-- 3. Vim-Aware Spatial Pane Navigation (nvim/vim only) + Alt Fallback
-- ---------------------------------------------------------------------------

for key, dir in pairs({ h = "left", j = "down", k = "up", l = "right" }) do
    rex.bind("ctrl+" .. key, function(ctx)
        if scratchpad.is_vim(ctx) then
            return false
        end
        rex.call("session.focus_direction", { session_id = ctx.session_id, direction = dir })
        return true
    end)

    rex.bind("alt+" .. key, "pane.focus." .. dir)
    rex.bind("alt+shift+" .. key, "pane.move." .. dir)
    rex.bind("ctrl+a>" .. key, "pane.focus." .. dir)
    rex.bind("ctrl+a>ctrl+" .. key, "pane.send_key", { key = "ctrl+" .. key })
end

-- Resize entry via C-a H/J/K/L (enters sticky resize mode)
for key, dir in pairs({ h = "left", j = "down", k = "up", l = "right" }) do
    local act_name = "resize_enter_" .. dir
    rex.action({
        name = act_name,
        title = "Resize pane " .. dir,
        run = function(_ctx)
            rex.client.queue("pane.resize", { direction = dir, amount = 2 })
            rex.client.queue("client.mode.enter", { name = "resize" })
        end,
    })
    rex.bind("ctrl+a>shift+" .. key, act_name)
end

-- ---------------------------------------------------------------------------
-- 4. Root & Core C-a Prefix Bindings
-- ---------------------------------------------------------------------------

rex.bind("alt+e", "capture_scrollback_float")
rex.bind("ctrl+shift+f", "client.search")
rex.bind("ctrl+shift+p", "client.palette.toggle")

rex.bind("ctrl+a>ctrl+a", "pane.send_key", { key = "ctrl+a" })
rex.bind("ctrl+a>c", "client.tab.new")
rex.bind("ctrl+a>-", "pane.split.down")
rex.bind("ctrl+a>shift+'", "pane.split.down")
rex.bind("ctrl+a>\\", "pane.split.right")
rex.bind("ctrl+a>shift+5", "pane.split.right")
rex.bind("ctrl+a>shift+-", "pane.split.right")
rex.bind("ctrl+a>shift+=", "pane.zoom")
rex.bind("ctrl+a>x", "pane.close")
rex.bind("ctrl+a>shift+x", "session.close")
rex.bind("ctrl+a>shift+w", "toggle_float")
rex.bind("ctrl+a>tab", "session.switch")
rex.bind("ctrl+a>shift+tab", "session.switch")
rex.bind("ctrl+a>f", "session.switch")
rex.bind("ctrl+a>o", "session.switch")
rex.bind("ctrl+a>ctrl+o", "session.switch")
rex.bind("ctrl+a>shift+s", "client.history.back")
rex.bind("ctrl+a>alt+s", "client.sidebar.toggle")
rex.bind("ctrl+a>alt+d", "toggle_dashboard")
rex.bind("ctrl+a>shift+n", "project_session_picker")
rex.bind("ctrl+a>shift+u", "project_session_picker")
rex.bind("ctrl+a>r", "client.config.reload")
rex.bind("ctrl+a>shift+r", "client.config.reload")
rex.bind("ctrl+a>shift+/", "client.shortcuts")
rex.bind("ctrl+a>/", "client.shortcuts")
rex.bind("ctrl+a>ctrl+c", "session.new")

-- Core scratchpad launchers
rex.bind("ctrl+a>g", "toggle_tpad_lazygit")
rex.bind("ctrl+a>shift+d", "toggle_tpad_lazydocker")
rex.bind("ctrl+a>shift+g", "toggle_tpad_gh_dash")
rex.bind("ctrl+a>t", "toggle_tpad_grimoire")
rex.bind("ctrl+a>ctrl+t", "toggle_tpad_tome")
rex.bind("ctrl+a>ctrl+s", "toggle_tpad_grimoire")

-- ---------------------------------------------------------------------------
-- 5. Register All 11 Modal Sub-Tables + Sticky Resize Mode
-- ---------------------------------------------------------------------------

modes.register(helpers)
