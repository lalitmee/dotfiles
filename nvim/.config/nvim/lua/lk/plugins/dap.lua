local M = {
    "rcarriga/nvim-dap-ui",
    dependencies = {
        { "jbyuki/one-small-step-for-vimkind" },
        { "mfussenegger/nvim-dap" },
        { "theHamsta/nvim-dap-virtual-text" },
    },
}

function M.config()
    local dap_status_ok, dap = lk.require("dap")
    if not dap_status_ok then
        return
    end

    local dap_ui_status_ok, dapui = lk.require("dapui")
    if not dap_ui_status_ok then
        return
    end

    ----------------------------------------------------------------------
    -- NOTE: dap ui setup {{{
    ----------------------------------------------------------------------
    dapui.setup({
        icons = { expanded = "▾", collapsed = "▸" },
        mappings = {
            -- Use a table to apply multiple mappings
            expand = { "<CR>", "<2-LeftMouse>" },
            open = "o",
            remove = "d",
            edit = "e",
            repl = "r",
            toggle = "t",
        },
        layouts = {
            -- You can change the order of elements in the sidebar
            elements = {
                -- Provide as ID strings or tables with "id" and "size" keys
                {
                    id = "scopes",
                    size = 0.25, -- Can be float or integer > 1
                },
                { id = "breakpoints", size = 0.25 },
                -- { id = "stacks", size = 0.25 },
                -- { id = "watches", size = 00.25 },
            },
            size = 40,
            position = "right", -- Can be "left", "right", "top", "bottom"
        },
        floating = {
            max_height = nil, -- These can be integers or a float between 0 and 1.
            max_width = nil, -- Floats will be treated as percentage of your screen.
            border = "rounded", -- Border style. Can be "single", "double" or "rounded"
            mappings = {
                close = { "q", "<Esc>" },
            },
        },
        windows = { indent = 1 },
    })
    -- }}}
    ----------------------------------------------------------------------

    ----------------------------------------------------------------------
    -- NOTE: dap virtual text setup {{{
    ----------------------------------------------------------------------
    require("nvim-dap-virtual-text").setup({
        enabled = true,

        -- DapVirtualTextEnable, DapVirtualTextDisable, DapVirtualTextToggle, DapVirtualTextForceRefresh
        enabled_commands = false,

        -- highlight changed values with NvimDapVirtualTextChanged, else always NvimDapVirtualText
        highlight_changed_variables = true,
        highlight_new_as_changed = true,

        -- prefix virtual text with comment string
        commented = false,

        show_stop_reason = true,

        -- experimental features:
        -- position of virtual text, see `:h nvim_buf_set_extmark()`
        virt_text_pos = "eol",
        -- show virtual text for all stack frames not only current. Only works for debugpy on my machine.
        all_frames = false,
    })
    -- }}}
    ----------------------------------------------------------------------

    ----------------------------------------------------------------------
    -- NOTE: sign definitions {{{
    ----------------------------------------------------------------------
    local icons = lk.style.icons

    vim.fn.sign_define(
        "DapBreakpoint",
        { text = icons.ui.Bug, texthl = "DiagnosticSignError", linehl = "", numhl = "" }
    )
    vim.fn.sign_define("DapBreakpointCondition", { text = "ü", texthl = "", linehl = "", numhl = "" })
    vim.fn.sign_define("DapStopped", { text = "ඞ", texthl = "Error" })
    -- }}}
    ----------------------------------------------------------------------

    ----------------------------------------------------------------------
    -- NOTE: dap listeners {{{
    ----------------------------------------------------------------------
    dap.listeners.after.event_initialized["dapui_config"] = function()
        dapui.open()
    end
    dap.listeners.before.event_terminated["dapui_config"] = function()
        dapui.close()
    end
    dap.listeners.before.event_exited["dapui_config"] = function()
        dapui.close()
    end
    -- }}}
    ----------------------------------------------------------------------

    ----------------------------------------------------------------------
    -- NOTE: dap adapters {{{
    ----------------------------------------------------------------------

    ----------------------------------------------------------------------
    -- NOTE: lua adapter {{{
    ----------------------------------------------------------------------
    dap.adapters.nlua = function(callback, config)
        callback({ type = "server", host = config.host, port = config.port })
    end

    dap.configurations.lua = {
        {
            type = "nlua",
            request = "attach",
            name = "Attach to running Neovim instance",
            host = function()
                return "127.0.0.1"
            end,
            port = function()
                -- local val = tonumber(vim.fn.input('Port: '))
                -- assert(val, "Please provide a port number")
                local val = 54231
                return val
            end,
        },
    }
    -- }}}
    ----------------------------------------------------------------------

    ----------------------------------------------------------------------
    -- NOTE: go adapter {{{
    --  https://github.com/mfussenegger/nvim-dap/wiki/Debug-Adapter-installation#go-using-delve-directly
    ----------------------------------------------------------------------
    dap.adapters.go = function(callback, _)
        local stdout = vim.loop.new_pipe(false)
        local handle, pid_or_err
        local port = 38697

        handle, pid_or_err = vim.loop.spawn("dlv", {
            stdio = { nil, stdout },
            args = { "dap", "-l", "127.0.0.1:" .. port },
            detached = true,
        }, function(code)
            stdout:close()
            handle:close()

            print("[delve] Exit Code:", code)
        end)

        assert(handle, "Error running dlv: " .. tostring(pid_or_err))

        stdout:read_start(function(err, chunk)
            assert(not err, err)

            if chunk then
                vim.schedule(function()
                    require("dap.repl").append(chunk)
                    print("[delve]", chunk)
                end)
            end
        end)

        -- Wait for delve to start
        vim.defer_fn(function()
            callback({ type = "server", host = "127.0.0.1", port = port })
        end, 100)
    end

    dap.configurations.go = {
        {
            type = "go",
            name = "Debug (from vscode-go)",
            request = "launch",
            showLog = false,
            program = "${file}",
            dlvToolPath = vim.fn.exepath("dlv"), -- Adjust to where delve is installed
        },
        {
            type = "go",
            name = "Debug (No File)",
            request = "launch",
            program = "",
        },
        {
            type = "go",
            name = "Debug",
            request = "launch",
            program = "${file}",
            showLog = true,
            -- console = "externalTerminal",
            -- dlvToolPath = vim.fn.exepath "dlv",
        },
        {
            name = "Test Current File",
            type = "go",
            request = "launch",
            showLog = true,
            mode = "test",
            program = ".",
            dlvToolPath = vim.fn.exepath("dlv"),
        },
    }
    -- }}}
    ----------------------------------------------------------------------

    ----------------------------------------------------------------------
    -- NOTE: pthon adapter {{{
    ----------------------------------------------------------------------
    dap.configurations.python = {
        {
            type = "python",
            request = "launch",
            name = "Build api",
            program = "${file}",
            args = { "--target", "api" },
            console = "integratedTerminal",
        },
    }

    -- }}}
    ----------------------------------------------------------------------

    -- }}}
    ----------------------------------------------------------------------

    ----------------------------------------------------------------------
    -- NOTE: dap commands {{{
    ----------------------------------------------------------------------
    local command = lk.command

    command("DapContinue", function()
        dap.continue()
    end, {})

    command("DapStepOver", function()
        dap.step_over()
    end, {})

    command("DapStepInto", function()
        dap.step_into()
    end, {})

    command("DapStepOut", function()
        dap.step_out()
    end, {})

    command("DapToggleBreakpoint", function()
        dap.toggle_breakpoint()
    end, {})

    command("DapSetBreakpointCond", function()
        dap.set_breakpoint(vim.fn.input("Breakpoint condition: "))
    end, {})

    command("DapSetLogpoint", function()
        dap.set_breakpoint(nil, nil, vim.fn.input("Log point message: "))
    end, {})

    command("DapReplOpen", function()
        dap.repl_open()
    end, {})

    command("DapRunLast", function()
        dap.run_last()
    end, {})

    ----------------------------------------------------------------------
    -- NOTE: osv commands {{{
    ----------------------------------------------------------------------
    command("OsvLaunch", function()
        require("osv").launch()
    end, {})

    command("OsvRunThis", function()
        require("osv").run_this()
    end, {})
    -- }}}
    ----------------------------------------------------------------------

    -- }}}
    ----------------------------------------------------------------------

    ----------------------------------------------------------------------
    -- NOTE: fallback terminal {{{
    ----------------------------------------------------------------------
    dap.defaults.fallback.external_terminal = {
        command = "/usr/bin/kitty",
        args = { "-e" },
    }
    dap.defaults.fallback.force_external_terminal = true
    -- }}}
    ----------------------------------------------------------------------
end

return M

-- vim:foldmethod=marker
