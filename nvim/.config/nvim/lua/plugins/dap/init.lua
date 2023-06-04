local M = {
    "mfussenegger/nvim-dap",
    cmd = { "DapToggleBreakpoint" },
    dependencies = {
        "jay-babu/mason-nvim-dap.nvim",
        "jbyuki/one-small-step-for-vimkind",
        "rcarriga/nvim-dap-ui",
        "nvim-telescope/telescope-dap.nvim",
        "theHamsta/nvim-dap-virtual-text",
        {
            "microsoft/vscode-js-debug",
            version = "1.x",
            build = "npm i && npm run compile vsDebugServerBundle && mv dist out",
        },
    },
}

M.config = function()
    local dap = require("dap")
    local dapui = require("dapui")
    require("telescope").load_extension("dap")

    require("dap-vscode-js").setup({
        debugger_path = vim.fn.stdpath("data") .. "/lazy/vscode-js-debug",
        adapters = { "pwa-node", "pwa-chrome", "pwa-msedge", "node-terminal", "pwa-extensionHost" },
    })

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

    vim.fn.sign_define("DapBreakpoint", {
        text = icons.ui.Bug,
        texthl = "DiagnosticSignError",
        linehl = "",
        numhl = "",
    })
    vim.fn.sign_define("DapBreakpointCondition", { text = "ü", texthl = "", linehl = "", numhl = "" })
    vim.fn.sign_define("DapStopped", { text = "ඞ", texthl = "Error" })
    -- }}}
    ----------------------------------------------------------------------

    ----------------------------------------------------------------------
    -- NOTE: dap listeners {{{
    ----------------------------------------------------------------------
    dap.listeners.after.event_initialized["dapui_config"] = function()
        dapui.open({ reset = true })
    end
    dap.listeners.before.event_terminated["dapui_config"] = dapui.close
    dap.listeners.before.event_exited["dapui_config"] = dapui.close
    -- }}}
    ----------------------------------------------------------------------

    ----------------------------------------------------------------------
    -- NOTE: dap adapters {{{
    ----------------------------------------------------------------------

    for _, language in ipairs({ "typescript", "javascript", "svelte" }) do
        dap.configurations[language] = {
            -- attach to a node process that has been started with
            -- `--inspect` for longrunning tasks or `--inspect-brk` for short tasks
            -- npm script -> `node --inspect-brk ./node_modules/.bin/vite dev`
            {
                -- use nvim-dap-vscode-js's pwa-node debug adapter
                type = "pwa-node",
                -- attach to an already running node process with --inspect flag
                -- default port: 9222
                request = "attach",
                -- allows us to pick the process using a picker
                processId = require("dap.utils").pick_process,
                -- name of the debug action you have to select for this config
                name = "Attach debugger to existing `node --inspect` process",
                -- for compiled languages like TypeScript or Svelte.js
                sourceMaps = true,
                -- resolve source maps in nested locations while ignoring node_modules
                resolveSourceMapLocations = {
                    "${workspaceFolder}/**",
                    "!**/node_modules/**",
                },
                -- path to src in vite based projects (and most other projects as well)
                cwd = "${workspaceFolder}/src",
                -- we don't want to debug code inside node_modules, so skip it!
                skipFiles = { "${workspaceFolder}/node_modules/**/*.js" },
            },
            {
                type = "pwa-chrome",
                name = "Launch Chrome to debug client",
                request = "launch",
                url = "http://localhost:5173",
                sourceMaps = true,
                protocol = "inspector",
                port = 9222,
                webRoot = "${workspaceFolder}/src",
                -- skip files from vite's hmr
                skipFiles = { "**/node_modules/**/*", "**/@vite/*", "**/src/client/*", "**/src/*" },
            },
            -- only if language is javascript, offer this debug action
            language == "javascript"
                    and {
                        -- use nvim-dap-vscode-js's pwa-node debug adapter
                        type = "pwa-node",
                        -- launch a new process to attach the debugger to
                        request = "launch",
                        -- name of the debug action you have to select for this config
                        name = "Launch file in new node process",
                        -- launch current file
                        program = "${file}",
                        cwd = "${workspaceFolder}",
                    }
                or nil,
        }
    end

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
                local val = tonumber(vim.fn.input({ prompt = "Port:" }))
                assert(val, "Please provide a port number")
                -- local val = 54231
                -- return val
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
    -- NOTE: dap mappings {{{
    ----------------------------------------------------------------------
    local wk = require("which-key")
    wk.register({
        ["d"] = {
            ["name"] = "+dap",
            [":"] = { ":Telescope dap commands<CR>", "dap-commands" },
            ["a"] = {
                function()
                    dap.step_out()
                end,
                "step-out",
            },
            ["b"] = {
                ":Telescope dap list_breakpoints<CR>",
                "dap-list-breakpoints",
            },
            ["c"] = {
                function()
                    dap.continue()
                end,
                "continue",
            },
            ["d"] = {
                function()
                    dap.toggle_breakpoint()
                end,
                "toggle-breakpoint",
            },
            ["e"] = {
                ":Telescope dap configurations<CR>",
                "dap-configurations",
            },
            ["f"] = { ":Telescope dap frames<CR>", "dap-frames" },
            ["i"] = {
                function()
                    dap.step_into()
                end,
                "step-into",
            },
            ["j"] = {
                function()
                    require("osv").launch()
                end,
                "lua-launch",
            },
            ["k"] = {
                function()
                    require("osv").run_this()
                end,
                "lua-run-this",
            },
            ["l"] = {
                function()
                    dap.set_breakpoint(nil, nil, vim.fn.input("Log point message: "))
                end,
                "log-point",
            },
            ["o"] = {
                function()
                    dap.step_over()
                end,
                "step-over",
            },
            ["r"] = {
                function()
                    dap.repl_open()
                end,
                "open-repl",
            },
            ["s"] = {
                function()
                    dap.run_last()
                end,
                "run-last",
            },
            ["t"] = {
                function()
                    dap.set_breakpoint(vim.fn.input("Breakpoint condition: "))
                end,
                "breakpoint-condition",
            },
            ["v"] = { ":Telescope dap variables<CR>", "dap-variables" },
        },
    }, { mode = "n", prefix = "<leader>" })

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

    require("mason-nvim-dap").setup()
end

return M
