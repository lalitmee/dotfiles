local M = {}

local lang = ""
local file_type = ""

function M.open_term(cmd, opts)
    opts = opts or {}

    local position = opts.direction == "vertical" and "right" or "float"
    local on_exit = opts.on_exit

    local term = Snacks.terminal.open(cmd, {
        cwd = "git_dir",
        interactive = false,
        win = { position = position },
    })

    if opts.on_open == cht_on_open then
        local buf = term.buf
        vim.schedule(function()
            pcall(vim.api.nvim_buf_set_name, buf, "cheatsheet-" .. buf)
            pcall(vim.api.nvim_set_option_value, "filetype", "cheat", { buf = buf })
            pcall(vim.api.nvim_set_option_value, "syntax", lang, { buf = buf })
        end)
    end

    if on_exit then
        term:on("TermClose", on_exit, { buf = true })
    end
end

function M.cht()
    local buf = vim.api.nvim_get_current_buf()
    lang = ""
    file_type = vim.api.nvim_get_option_value("filetype", { buf = buf })
    vim.ui.input({
        prompt = "cht.sh input: ",
        default = file_type .. " ",
        kind = "browse",
    }, function(input)
        local cmd = ""
        if input == "" or not input then
            return
        elseif input == "h" then
            cmd = ""
        else
            local search = ""
            local delimiter = " "
            for w in (input .. delimiter):gmatch("(.-)" .. delimiter) do
                if lang == "" then
                    lang = w
                else
                    if search == "" then
                        search = w
                    else
                        search = search .. "+" .. w
                    end
                end
            end
            cmd = lang
            if search ~= "" then
                cmd = cmd .. "/" .. search
            end
        end
        cmd = "curl cht.sh/" .. cmd
        M.open_term(cmd, { direction = "vertical", on_open = cht_on_open, on_exit = cht_on_exit })
    end)
end

function M.stack_overflow()
    local buf = vim.api.nvim_get_current_buf()
    file_type = vim.api.nvim_get_option_value("filetype", { buf = buf })
    vim.ui.input({
        prompt = "so input: ",
        default = file_type .. " ",
        kind = "browse",
    }, function(input)
        local cmd = ""
        if input == "" or not input then
            return
        elseif input == "h" then
            cmd = "-h"
        else
            cmd = input
        end
        cmd = "so " .. cmd
        M.open_term(cmd, { direction = "float" })
    end)
end

return M
