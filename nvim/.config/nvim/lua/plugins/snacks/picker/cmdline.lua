local M = {}

function M.run_cmd(cmd)
    if not cmd or cmd == "" then
        return
    end

    if tonumber(cmd) then
        pcall(vim.api.nvim_exec2, cmd, {})
        return
    end

    -- Add to cmd history
    vim.fn.histadd("cmd", cmd)

    -- Validate command
    local ok, parsed = pcall(vim.api.nvim_parse_cmd, cmd, {})
    if not ok then
        vim.notify("Invalid command: " .. cmd, vim.log.levels.ERROR, { title = "Cmdline" })
        return
    end

    -- System command
    if cmd:sub(1, 1) == "!" then
        vim.cmd.split("term://" .. cmd:sub(2))
        return
    end

    -- Run command and get output
    local executed, data = pcall(vim.api.nvim_exec2, cmd, { output = true })
    if not executed then
        local msg = data:match("Vim%([^)]*%):(.*)$") or data
        vim.notify("Error executing command: " .. cmd .. "\n" .. msg, vim.log.levels.ERROR, { title = "Cmdline" })
        return
    end

    local output = data.output
    if not output or #output == 0 then
        return
    end

    -- Split output into lines
    local lines = vim.split(output, "\n")
    if #lines < 5 then
        vim.notify(output, vim.log.levels.INFO, { title = "Cmdline" })
        return
    end

    -- Show output in split buffer
    vim.cmd.split()
    local win = vim.api.nvim_get_current_win()
    local buf = vim.api.nvim_create_buf(true, true)
    vim.wo[win].number = false
    vim.wo[win].relativenumber = false
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
    vim.bo[buf].buftype = "nofile"
    vim.bo[buf].bufhidden = "hide"
    vim.bo[buf].filetype = "sh"
    vim.bo[buf].swapfile = false
    vim.api.nvim_win_set_buf(win, buf)
    local max_height = 15
    vim.cmd.resize(#lines < max_height and #lines or max_height)
end

local function get_history()
    local count = vim.fn.histnr("cmd")
    local history = {}
    local seen = {}
    for i = count, 1, -1 do
        local line = vim.fn.histget("cmd", i)
        if not line:find("^%s*$") and not seen[line] then
            seen[line] = true
            table.insert(history, line)
        end
    end
    return history
end

function M.get_items(opts, ctx)
    ctx = ctx or {}
    local filter = ctx.filter or {}
    local text = filter.search or ""
    local items = {}

    if #text == 0 then
        local history = get_history()
        for _, cmd in ipairs(history) do
            table.insert(items, {
                text = cmd,
                cmd = cmd,
                kind = "history",
            })
        end

        local commands = {}
        for k, v in pairs(vim.api.nvim_get_commands({})) do
            commands[k] = v
        end
        for k, v in pairs(vim.api.nvim_buf_get_commands(0, {})) do
            if type(k) == "string" then
                commands[k] = commands[k] or v
            end
        end
        for _, c in ipairs(vim.fn.getcompletion("", "command")) do
            if not commands[c] and c:find("^%a") then
                commands[c] = { definition = "command completion" }
            end
        end

        local names = {}
        for name in pairs(commands) do
            names[#names + 1] = name
        end
        table.sort(names)
        for _, name in ipairs(names) do
            table.insert(items, {
                text = name,
                cmd = name,
                kind = "command",
                desc = commands[name].definition,
            })
        end

        return items
    end

    if tonumber(text) then
        return {
            {
                text = ":" .. text,
                cmd = text,
                kind = "number",
                desc = "Go to line " .. text,
            },
        }
    end

    local prefix = ""
    local last_space = text:match(".*()%s")
    if last_space then
        prefix = text:sub(1, last_space)
    end

    local completions = vim.fn.getcompletion(text, "cmdline") or {}
    local seen = {}

    for _, comp in ipairs(completions) do
        local full_cmd = prefix .. comp
        if not seen[full_cmd] then
            seen[full_cmd] = true
            table.insert(items, {
                text = full_cmd,
                cmd = full_cmd,
                kind = "command",
            })
        end
    end

    local history = get_history()
    for _, cmd in ipairs(history) do
        if not seen[cmd] then
            local lower_cmd = cmd:lower()
            local lower_text = text:lower()
            if lower_cmd:find(lower_text, 1, true) then
                seen[cmd] = true
                table.insert(items, {
                    text = cmd,
                    cmd = cmd,
                    kind = "history",
                })
            end
        end
    end

    return items
end

function M.cmdline()
    Snacks.picker.pick({
        prompt = ":",
        live = true,
        finder = M.get_items,
        format = "text",
        formatters = { text = { ft = "vim" } },
        layout = {
            preset = "telescope",
            preview = false,
            reverse = false,
            layout = {
                width = 0.6,
                height = 0.4,
            },
        },
        confirm = function(picker, item)
            picker:close()
            if item then
                M.run_cmd(item.cmd or item.text)
            else
                M.run_cmd(picker.input:get())
            end
        end,
        actions = {
            run_input = function(picker)
                picker:close()
                M.run_cmd(picker.input:get())
            end,
            expand = function(picker)
                local item = picker:current()
                if item then
                    picker.input:set("", item.cmd or item.text)
                end
            end,
        },
        win = {
            input = {
                keys = {
                    ["<c-cr>"] = { "run_input", mode = { "i", "n" } },
                    ["<tab>"] = { "expand", mode = "i" },
                },
            },
            list = {
                keys = {
                    ["<c-cr>"] = { "run_input", mode = { "n", "x" } },
                    ["<tab>"] = { "expand", mode = { "n", "x" } },
                },
            },
        },
    })
end

return M
