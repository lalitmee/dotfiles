--- @module 'compile'
--- Interactive compilation runner for Neovim with .env support and output navigation.
local M = {}

--- @type string|nil
--- The last shell command executed by the user.
M.last_cmd = nil
--- @type string|nil
--- The last working directory used for compilation.
M.last_cwd = nil
--- @type string|nil
--- Path to the last .env file used (consumed once per execution).
M.last_env = nil
--- @type integer|nil
--- Handle to the current compile output window, if open.
M.compile_window = nil

--- Closes the active compile output window and resets its handle.
--- Does nothing if no compile window is open.
--- @return nil
M.close_compile_window = function()
    if M.compile_window and vim.api.nvim_win_is_valid(M.compile_window) then
        vim.api.nvim_win_close(M.compile_window, true)
    end
    M.compile_window = nil
end

--- Prompts the user for a compilation command and working directory,
--- then executes the command via `M.executor`.
--- Uses `M.last_cmd` and `M.last_cwd` as defaults in prompts.
--- @return nil
M.command = function()
    local cmd = vim.fn.input("Compile command: ", M.last_cmd or "")

    if cmd == nil or cmd == "" then
        vim.notify("Compilation cancelled", vim.log.levels.WARN)
        return
    end

    local default_cwd = M.last_cwd or vim.fn.getcwd()
    local cwd = vim.fn.input("CWD: ", default_cwd)

    if cwd == nil or cwd == "" then
        vim.notify("Compilation cancelled", vim.log.levels.WARN)
        return
    end

    M.executor(cmd, cwd)
end

--- Re-executes the last compilation command and working directory.
--- Shows an error if no prior command exists.
--- @return nil
M.run_last = function()
    if not M.last_cmd then
        vim.notify("No last command to run. Use :Compile first.", vim.log.levels.ERROR)
        return
    end
    M.executor(M.last_cmd, M.last_cwd)
end

--- Prompts the user for a `.env` file path (defaulting to `./.env`),
--- stores it in `M.last_env`, then invokes `M.command()`.
--- The `.env` file is sourced once during the next execution and then cleared.
--- @return nil
M.with_env = function()
    local env_file = vim.fn.input("Path to .env file: ", M.last_env or vim.fs.joinpath(vim.fn.getcwd(), ".env"), "file")
    if env_file == nil or env_file == "" then
        vim.notify("Cancelled", vim.log.levels.WARN)
        return
    end
    M.last_env = env_file
    M.command()
end

--- Executes a shell command in a given working directory and streams output
--- to a dedicated scratch window named `[Compile]`.
--- - Closes any existing compile window.
--- - Sources `M.last_env` (if set) before the command and then unsets it.
--- - Supports clickable file paths (e.g., `file:line`) via `<CR>` mapping.
--- - Press `q` to close the window.
--- @param cmd string Shell command to execute.
--- @param cwd string Working directory for the command.
--- @return nil
M.executor = function(cmd, cwd)
    if M.compile_window ~= nil then
        M.close_compile_window()
    end

    if not cmd then
        vim.notify("No command to execute", vim.log.levels.ERROR)
        return
    end
    M.last_cmd = cmd
    M.last_cwd = cwd
    if M.last_env then
        cmd = ". " .. M.last_env .. " && " .. cmd
        M.last_env = nil -- reset last_env since it may not be necessary all the time
    end

    local original_window = vim.api.nvim_get_current_win()
    local compile_buffer = vim.api.nvim_create_buf(false, true)
    M.compile_window = vim.api.nvim_open_win(compile_buffer, true, {
        split = "below",
        win = -1,
        height = math.floor(vim.o.lines * 0.5),
        style = "minimal",
    })
    local actual_cwd = cwd or vim.fn.getcwd()
    local cmd_table = { "sh", "-c", cmd }

    if not cmd or cmd == "" then
        vim.notify("Error: 'cmd' is required.", vim.log.levels.ERROR)
        return
    end

    vim.api.nvim_buf_set_keymap(compile_buffer, "n", "<CR>", "", {
        callback = function()
            local line = vim.api.nvim_get_current_line()

            local cfile = vim.fn.expand("<cfile>")
            local start_idx = line:find(cfile, 1, true)
            if not start_idx then
                print("Path not found on current line")
                return
            end
            local trimmed_line = line:sub(start_idx)

            -- Pipe this all into quickfix to take advantage of the errorformatting that it does
            local original_qf_state = vim.fn.getqflist({ all = 0 })
            local original_efm = vim.go.errorformat

            local temp_efm = table.concat({
                "%f:%l:%c:%m",
                "%f:%l:%c",
                "%f:%l",
            }, ",")
            vim.go.errorformat = temp_efm .. "," .. original_efm
            vim.fn.setqflist({}, "r", { lines = { trimmed_line } })
            local qf_items = vim.fn.getqflist()

            vim.go.errorformat = original_efm
            vim.fn.setqflist({}, "r", {
                items = original_qf_state.items,
                title = original_qf_state.title,
            })

            local lnum = qf_items[1].lnum
            local col = qf_items[1].col

            local full_path = vim.fs.normalize(vim.fs.joinpath(actual_cwd, cfile))
            if not vim.uv.fs_stat(full_path) and vim.uv.fs_stat(cfile) then
                full_path = vim.fs.normalize(cfile)
            end
            if not vim.uv.fs_stat(full_path) then
                return nil
            end

            if not vim.api.nvim_win_is_valid(original_window) then
                vim.notify("Original window is no longer valid", vim.log.levels.ERROR)
                return
            end

            local open_to_cmd = "edit +" .. lnum .. " " .. vim.fn.fnameescape(full_path)
            if type(col) == "number" and col > 0 then
                open_to_cmd = open_to_cmd .. " | normal! " .. col .. "|"
            end

            vim.fn.win_execute(original_window, open_to_cmd)
            vim.api.nvim_set_current_win(original_window)
        end,
        noremap = true,
        silent = true,
    })
    vim.api.nvim_buf_set_keymap(compile_buffer, "n", "q", "", {
        callback = function()
            M.close_compile_window()
        end,
        noremap = true,
        silent = true,
    })

    vim.api.nvim_buf_set_name(compile_buffer, "[Compile]")
    vim.api.nvim_set_option_value("buftype", "nofile", { buf = compile_buffer })
    vim.api.nvim_set_option_value("bufhidden", "wipe", { buf = compile_buffer })
    vim.api.nvim_set_option_value("swapfile", false, { buf = compile_buffer })
    vim.api.nvim_set_option_value("filetype", "compile", { buf = compile_buffer })

    --- @param err string|nil
    --- @param data string|nil
    local on_data = function(err, data)
        if err then
            vim.schedule(function()
                vim.api.nvim_buf_set_lines(compile_buffer, -1, -1, false, { "[Stream error: " .. err .. "]" })
            end)
            return
        end
        if data == nil then
            return
        end
        vim.schedule(function()
            local lines = vim.split(data, "\n", { trimempty = false })
            vim.api.nvim_buf_set_lines(compile_buffer, -1, -1, false, lines)
        end)
    end

    --- @param obj {code: integer}
    local on_exit = function(obj)
        vim.schedule(function()
            local status_line = "[Command finished with code " .. obj.code .. "]"
            vim.api.nvim_buf_set_lines(compile_buffer, -1, -1, false, { "", status_line })
        end)
    end

    vim.system(cmd_table, {
        cwd = actual_cwd,
        text = true,
        stdout = on_data,
        stderr = on_data,
    }, on_exit)

    vim.api.nvim_create_autocmd("BufWipeout", {
        buffer = compile_buffer,
        once = true,
        callback = function()
            M.compile_window = nil
        end,
    })
end

vim.api.nvim_create_user_command("Compile", function(args)
    local fargs = args.fargs
    if #fargs == 0 then
        M.command()
    elseif #fargs == 1 then
        if fargs[1] == "with-env" then
            M.with_env()
        elseif fargs[1] == "last" then
            M.run_last()
        else
            vim.notify("Error: Unknown argument '" .. fargs[1] .. "'", vim.log.levels.ERROR)
        end
    else
        vim.notify("Error: Too many arguments for Compile", vim.log.levels.ERROR)
    end
end, {
    nargs = "*",
    desc = "Compiles the project (supports with-env, last)",
    complete = function(arglead, _, _)
        local completions = { "with-env", "last" }

        local filtered = {}
        for _, item in ipairs(completions) do
            if vim.startswith(item, arglead) then
                table.insert(filtered, item)
            end
        end
        return filtered
    end,
})
