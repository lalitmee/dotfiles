local function neotest()
    return require("neotest")
end
local function open()
    neotest().output.open({ enter = true, short = false })
end
local function run_file()
    neotest().run.run(vim.fn.expand("%"))
end
local function run_file_sync()
    neotest().run.run({ vim.fn.expand("%"), concurrent = false })
end
local function nearest()
    neotest().run.run()
end
local function next_failed()
    neotest().jump.prev({ status = "failed" })
end
local function prev_failed()
    neotest().jump.next({ status = "failed" })
end
local function toggle_summary()
    neotest().summary.toggle()
end
local function cancel()
    neotest().run.stop({ interactive = true })
end

return {
    "nvim-neotest/neotest",
    dependencies = {
        {
            "rcarriga/neotest-plenary",
            dependencies = "nvim-lua/plenary.nvim",
        },
        "haydenmeade/neotest-jest",
    },
    cmd = { "Neotest" },
    config = function()
        local namespace = vim.api.nvim_create_namespace("neotest")
        vim.diagnostic.config({
            virtual_text = {
                format = function(diagnostic)
                    return diagnostic.message:gsub("\n", " "):gsub("\t", " "):gsub("%s+", " "):gsub("^%s+", "")
                end,
            },
        }, namespace)
        require("neotest").setup({
            discovery = { enabled = true },
            diagnostic = { enabled = true },
            floating = { border = lk.style.border.rounded },
            quickfix = { enabled = false, open = true },
            adapters = {
                require("neotest-jest")({
                    jestCommand = "npm test --",
                    env = { CI = true },
                    cwd = function()
                        return vim.fn.getcwd()
                    end,
                }),
            },
            -- overseer.nvim
            consumers = {
                overseer = require("neotest.consumers.overseer"),
            },
            overseer = {
                enabled = true,
                force_default = true,
            },
        })
    end,
    init = function()
        local wk = require("which-key")
        wk.register({
            ["n"] = {
                ["name"] = "+neotest",
                ["f"] = { run_file, "run-file" },
                ["F"] = { run_file_sync, "run-file-sync" },
                ["n"] = { next_failed, "next-failed" },
                ["o"] = { open, "open" },
                ["p"] = { prev_failed, "prev-failed" },
                ["q"] = { cancel, "cancel" },
                ["r"] = { nearest, "nearest" },
                ["t"] = { toggle_summary, "toggle-summary" },
            },
        }, { mode = "n", prefix = "<localleader>" })
    end,
}
