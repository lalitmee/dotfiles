local M = {}

-- Configuration
M.config = {
    width = 40,
    height = 1,
    position = "topright", -- topright, topleft, bottomright, bottomleft, topcenter, bottomcenter
    offset_x = 2,
    offset_y = 2,
    border = "rounded",
    title = "Keys",
    max_keys = 20,
    timeout = 3000, -- ms to clear keys after inactivity
    enabled = false,
    clear_on_mode_change = false,
}

-- State
M.state = {
    buf = nil,
    win = nil,
    keys = {},
    timer = nil,
    last_mode = nil,
}

-- Key name mappings for better display (short names)
local key_names = {
    [" "] = "SPC",
    ["\t"] = "TAB",
    ["\n"] = "RET",
    ["\r"] = "RET",
    ["\x1b"] = "ESC",
    ["\x7f"] = "BS",
    ["<CR>"] = "RET",
    ["<Tab>"] = "TAB",
    ["<Space>"] = "SPC",
    ["<Esc>"] = "ESC",
    ["<BS>"] = "BS",
    ["<Del>"] = "DEL",
    ["<Left>"] = "←",
    ["<Right>"] = "→",
    ["<Up>"] = "↑",
    ["<Down>"] = "↓",
    ["<C-"] = "Ctrl-",
    ["<M-"] = "Alt-",
    ["<S-"] = "Shift-",
}

-- Create floating window
local function create_float()
    if M.state.win and vim.api.nvim_win_is_valid(M.state.win) then
        return
    end

    -- Create buffer
    M.state.buf = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_buf_set_option(M.state.buf, "bufhidden", "wipe")
    vim.api.nvim_buf_set_option(M.state.buf, "filetype", "screenkey")

    -- Window configuration
    local width = M.config.width
    local height = M.config.height

    -- Calculate position dynamically
    local ui = vim.api.nvim_list_uis()[1]
    if not ui then
        return
    end

    local pos_x, pos_y

    if M.config.position == "topleft" then
        pos_x = M.config.offset_x
        pos_y = M.config.offset_y
    elseif M.config.position == "topright" then
        pos_x = ui.width - width - M.config.offset_x
        pos_y = M.config.offset_y
    elseif M.config.position == "topcenter" then
        pos_x = math.floor((ui.width - width) / 2)
        pos_y = M.config.offset_y
    elseif M.config.position == "bottomleft" then
        pos_x = M.config.offset_x
        pos_y = ui.height - height - M.config.offset_y
    elseif M.config.position == "bottomright" then
        pos_x = ui.width - width - M.config.offset_x
        pos_y = ui.height - height - M.config.offset_y
    elseif M.config.position == "bottomcenter" then
        pos_x = math.floor((ui.width - width) / 2)
        pos_y = ui.height - height - M.config.offset_y
    else
        -- Default to topright
        pos_x = ui.width - width - M.config.offset_x
        pos_y = M.config.offset_y
    end

    -- Window options
    local opts = {
        relative = "editor",
        width = width,
        height = height,
        col = pos_x,
        row = pos_y,
        style = "minimal",
        border = M.config.border,
        title = M.config.title,
        title_pos = "center",
    }

    M.state.win = vim.api.nvim_open_win(M.state.buf, false, opts)
    vim.api.nvim_win_set_option(M.state.win, "winblend", 10)

    -- Set up buffer highlights
    vim.api.nvim_buf_set_option(M.state.buf, "modifiable", true)
end

-- Format key for display
local function format_key(key)
    -- Handle special key names
    for pattern, name in pairs(key_names) do
        if key:find(pattern, 1, true) then
            return name
        end
    end

    -- Handle function keys
    if key:match("<F%d+>") then
        return key:gsub("<(F%d+)>", "F%1")
    end

    -- Handle combined keys like <C-a>, <M-space>, etc. (fallback for any remaining <key> format)
    if key:match("<.-.") then
        return key:gsub("<(.*)>", "%1"):gsub("^C%-", "Ctrl-"):gsub("^M%-", "Alt-"):gsub("^S%-", "Shift-")
    end

    -- Return as-is for regular characters and already formatted keys (like Ctrl-A, Alt-X)
    return key
end

-- Update display
local function update_display()
    if not M.state.buf or not vim.api.nvim_buf_is_valid(M.state.buf) then
        return
    end

    -- Format keys for horizontal display
    local display_line = ""

    if #M.state.keys > 0 then
        local formatted_keys = {}
        for _, key in ipairs(M.state.keys) do
            table.insert(formatted_keys, format_key(key))
        end
        display_line = table.concat(formatted_keys, " ")
    end

    -- Truncate if too long for window
    if #display_line > M.config.width then
        display_line = display_line:sub(-M.config.width + 3) -- Keep last part with "..."
        if #display_line > 3 then
            display_line = "..." .. display_line:sub(4)
        end
    end

    -- Set buffer content (single line)
    vim.api.nvim_buf_set_lines(M.state.buf, 0, -1, false, { display_line })

    -- Add highlighting for special keys
    vim.api.nvim_buf_clear_namespace(M.state.buf, -1, 0, -1)

    -- Highlight Ctrl- combinations
    local ctrl_start = 1
    while true do
        local start_pos = display_line:find("Ctrl%-", ctrl_start)
        if not start_pos then
            break
        end
        vim.api.nvim_buf_add_highlight(M.state.buf, -1, "Special", 0, start_pos - 1, start_pos + 4)
        ctrl_start = start_pos + 1
    end

    -- Highlight Alt- combinations
    local alt_start = 1
    while true do
        local start_pos = display_line:find("Alt%-", alt_start)
        if not start_pos then
            break
        end
        vim.api.nvim_buf_add_highlight(M.state.buf, -1, "Special", 0, start_pos - 1, start_pos + 3)
        alt_start = start_pos + 1
    end

    -- Highlight arrow keys
    local arrow_start = 1
    while true do
        local start_pos = display_line:find("[←→↑↓]", arrow_start)
        if not start_pos then
            break
        end
        vim.api.nvim_buf_add_highlight(M.state.buf, -1, "Directory", 0, start_pos - 1, start_pos)
        arrow_start = start_pos + 1
    end
end

-- Add key to display
local function add_key(key)
    if not M.config.enabled then
        return
    end

    -- Reset timer
    if M.state.timer then
        M.state.timer:stop()
    end

    -- Add key to list
    table.insert(M.state.keys, key)

    -- Keep only recent keys
    if #M.state.keys > M.config.max_keys then
        table.remove(M.state.keys, 1)
    end

    -- Update display
    update_display()

    -- Set timer to clear after inactivity
    M.state.timer = vim.defer_fn(function()
        M.state.keys = {}
        update_display()
    end, M.config.timeout)
end

-- Key capture using vim.on_key (Neovim 0.10+)
local function setup_key_capture()
    if not M.config.enabled then
        return
    end

    M.state.key_handler = vim.on_key(function(key, typed)
        if not M.config.enabled or not typed then
            return
        end

        -- Skip certain internal keys and empty strings
        if key == "" or (key:byte() and key:byte() == 128) then
            return
        end

        -- Handle special keys that might not be captured properly
        if typed == "\n" or typed == "\r" then
            add_key("<CR>")
        elseif typed == "\t" then
            add_key("<Tab>")
        elseif typed == " " or key == "<Space>" or key == "<space>" then
            add_key("<Space>")
        elseif typed == "\x1b" or key == "<Esc>" then
            add_key("<Esc>")
        elseif typed == "\x7f" or key == "<BS>" then
            add_key("<BS>")
        elseif key == "<Del>" then
            add_key("<Del>")
        elseif key:match("<Left>") then
            add_key("<Left>")
        elseif key:match("<Right>") then
            add_key("<Right>")
        elseif key:match("<Up>") then
            add_key("<Up>")
        elseif key:match("<Down>") then
            add_key("<Down>")
        elseif #typed == 1 and typed:byte() < 32 then
            -- Control characters - format as Ctrl-A, Ctrl-B, etc.
            local ctrl_char = string.char(typed:byte() + 64)
            add_key(string.format("Ctrl-%s", ctrl_char))
        elseif key:match("<C%-.-") then
            -- Handle already formatted control keys like <C-a>
            local ctrl_key = key:match("<C%-(.+)")
            if ctrl_key then
                add_key(string.format("Ctrl-%s", ctrl_key:upper()))
            end
        elseif key:match("<M%-.-") then
            -- Handle alt keys
            local alt_key = key:match("<M%-(.+)")
            if alt_key then
                add_key(string.format("Alt-%s", alt_key:upper()))
            end
        elseif key:match("<S%-.-") then
            -- Handle shift keys
            local shift_key = key:match("<S%-(.+)")
            if shift_key then
                add_key(string.format("Shift-%s", shift_key:upper()))
            end
        elseif key:match("<F%d+>") then
            -- Handle function keys
            add_key(key)
        else
            -- Regular keys
            add_key(typed)
        end
    end)
end

-- Remove key capture
local function remove_key_capture()
    if M.state.key_handler then
        M.state.key_handler = nil
    end
end

-- Setup autocmds
local function setup_autocmds()
    local group = vim.api.nvim_create_augroup("ScreenKey", { clear = true })

    -- Clear keys on mode change
    if M.config.clear_on_mode_change then
        vim.api.nvim_create_autocmd("ModeChanged", {
            group = group,
            pattern = "*",
            callback = function()
                local current_mode = vim.api.nvim_get_mode().mode
                if current_mode ~= M.state.last_mode then
                    M.state.keys = {}
                    update_display()
                    M.state.last_mode = current_mode
                end
            end,
        })
    end

    -- Handle window resize
    vim.api.nvim_create_autocmd("VimResized", {
        group = group,
        callback = function()
            if M.state.win and vim.api.nvim_win_is_valid(M.state.win) then
                vim.api.nvim_win_close(M.state.win, true)
                M.state.win = nil
                if M.config.enabled then
                    create_float()
                    update_display()
                end
            end
        end,
    })
end

-- Toggle screenkey
function M.toggle()
    M.config.enabled = not M.config.enabled

    if M.config.enabled then
        create_float()
        setup_autocmds()
        setup_key_capture()
        M.state.last_mode = vim.api.nvim_get_mode().mode
        vim.notify("🎹 ScreenKey enabled", vim.log.levels.INFO)
    else
        if M.state.win and vim.api.nvim_win_is_valid(M.state.win) then
            vim.api.nvim_win_close(M.state.win, true)
            M.state.win = nil
        end
        if M.state.timer then
            M.state.timer:stop()
            M.state.timer = nil
        end
        M.state.keys = {}
        remove_key_capture()
        vim.api.nvim_del_augroup_by_name("ScreenKey")
        vim.notify("🎹 ScreenKey disabled", vim.log.levels.INFO)
    end
end

-- Clear keys manually
function M.clear()
    M.state.keys = {}
    update_display()
    if M.state.timer then
        M.state.timer:stop()
        M.state.timer = nil
    end
end

-- Setup function
function M.setup(opts)
    M.config = vim.tbl_deep_extend("force", M.config, opts or {})

    -- Validate position
    local valid_positions = {
        "topleft",
        "topright",
        "topcenter",
        "bottomleft",
        "bottomright",
        "bottomcenter",
    }
    local is_valid = false
    for _, pos in ipairs(valid_positions) do
        if M.config.position == pos then
            is_valid = true
            break
        end
    end
    if not is_valid then
        M.config.position = "topright" -- default fallback
    end

    -- Create user commands
    vim.api.nvim_create_user_command("ScreenKeyToggle", M.toggle, { desc = "Toggle ScreenKey display" })
    vim.api.nvim_create_user_command("ScreenKeyEnable", function()
        if not M.config.enabled then
            M.toggle()
        end
    end, { desc = "Enable ScreenKey display" })
    vim.api.nvim_create_user_command("ScreenKeyDisable", function()
        if M.config.enabled then
            M.toggle()
        end
    end, { desc = "Disable ScreenKey display" })
    vim.api.nvim_create_user_command("ScreenKeyClear", M.clear, { desc = "Clear ScreenKey display" })

    -- Default keymapping (optional)
    vim.keymap.set("n", "<leader>sk", M.toggle, { desc = "Toggle ScreenKey" })
    vim.keymap.set("n", "<leader>sc", M.clear, { desc = "Clear ScreenKey" })
end

-- Auto-setup if not configured
if vim.g.screenkey_setup ~= false then
    M.setup()
end

return M
