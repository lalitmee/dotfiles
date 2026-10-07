local leet_arg = "leetcode.nvim"

local function map(keys)
    for _, key in ipairs(keys) do
        local opts = vim.deepcopy(key)
        local modes = opts.mode or "n"
        opts.mode = nil
        local lhs, rhs = table.remove(opts, 1), table.remove(opts, 1)
        for _, mode in ipairs(type(modes) == "table" and modes or { modes }) do
            vim.keymap.set(mode, lhs, rhs, opts)
        end
    end
end

require("guess-indent").setup({})

vim.g.mkdp_filetypes = { "markdown" }
vim.keymap.set("n", "<leader>am", "<cmd>MarkdownPreview<cr>", { desc = "Markdown Preview", silent = true })

require("render-markdown").setup({
    render_modes = true,
    sign = { enabled = false },
    latex = { enabled = false },
    overrides = {
        filetype = {
            codecompanion = {
                html = {
                    tag = {
                        buf = { icon = " ", highlight = "CodeCompanionChatIcon" },
                        file = { icon = " ", highlight = "CodeCompanionChatIcon" },
                        group = { icon = " ", highlight = "CodeCompanionChatIcon" },
                        help = { icon = "󰘥 ", highlight = "CodeCompanionChatIcon" },
                        image = { icon = " ", highlight = "CodeCompanionChatIcon" },
                        symbols = { icon = " ", highlight = "CodeCompanionChatIcon" },
                        tool = { icon = "󰯠 ", highlight = "CodeCompanionChatIcon" },
                        url = { icon = "󰌹 ", highlight = "CodeCompanionChatIcon" },
                    },
                },
            },
        },
    },
})
vim.keymap.set("n", "<leader>tm", ":RenderMarkdown toggle<CR>", { desc = "Render Markdown Toggle" })

require("which-key").add({ { "<leader>d", group = "doc" } })
require("neogen").setup({
    snippet_engine = "luasnip",
    enabled = true,
    languages = {
        lua = { template = { annotation_convention = "ldoc" } },
        python = { template = { annotation_convention = "google_docstrings" } },
        rust = { template = { annotation_convention = "rustdoc" } },
        javascript = { template = { annotation_convention = "jsdoc" } },
        typescript = { template = { annotation_convention = "tsdoc" } },
        typescriptreact = { template = { annotation_convention = "tsdoc" } },
    },
})
map({
    { "<leader>dd", "<cmd>Neogen<CR>", desc = "Doc This", silent = true },
    { "<leader>dc", "<cmd>Neogen class<cr>", desc = "Doc This Class", silent = true },
    { "<leader>df", "<cmd>Neogen func<cr>", desc = "Doc This Function", silent = true },
    { "<leader>dt", "<cmd>Neogen type<cr>", desc = "Doc This Type", silent = true },
})

require("refactoring").setup({
    print_var_statements = {
        javascript = { "console.log('%s', %s)", "console.log('%s', { %s })", "console.log('%s', prettyDOM(%s))" },
        javascriptreact = { "console.log('%s', %s)", "console.log('%s', { %s })", "console.log('%s', prettyDOM(%s))" },
        typescript = { "console.log('%s', %s)", "console.log('%s', { %s })", "console.log('%s', prettyDOM(%s))" },
        typescriptreact = { "console.log('%s', %s)", "console.log('%s', { %s })", "console.log('%s', prettyDOM(%s))" },
    },
})
map({
    { "<leader>rp", function() require("refactoring").debug.print_var() end, mode = { "n", "v" }, desc = "Print Var" },
    { "<leader>rd", function() require("refactoring").debug.cleanup() end, mode = { "n", "v" }, desc = "Delete Print Var" },
    { "<leader>rj", function() require("refactoring").debug.printf() end, mode = { "n", "v" }, desc = "Printf Below" },
    { "<leader>rk", function() require("refactoring").debug.printf({ below = false }) end, mode = { "n", "v" }, desc = "Printf Above" },
    { "<leader>rr", function() require("refactoring").select_refactor() end, mode = { "n", "v" }, desc = "List Refactors" },
})

require("which-key").add({ { "<leader>ro", group = "overseer" } })
require("overseer").setup({ templates = { "tasks" } })
map({
    { "<leader>ro<leader>", ":OverseerQuickAction<CR>", desc = "Quick Action", silent = true },
    { "<leader>roa", ":OverseerTaskAction<CR>", desc = "Task Action", silent = true },
    { "<leader>rob", ":OverseerBuild<CR>", desc = "Build", silent = true },
    { "<leader>roc", ":OverseerRunCmd<CR>", desc = "Run Cmd", silent = true },
    { "<leader>rod", ":OverseerDeleteBundle<CR>", desc = "Delete Bundle", silent = true },
    { "<leader>rol", ":OverseerLoadBundle<CR>", desc = "Load Bundle", silent = true },
    { "<leader>roo", ":OverseerOpen<CR>", desc = "Open", silent = true },
    { "<leader>roq", ":OverseerClose<CR>", desc = "Close", silent = true },
    { "<leader>ror", ":OverseerRun<CR>", desc = "Run", silent = true },
    { "<leader>ros", ":OverseerSaveBundle ", desc = "Save Bundle", silent = true },
    { "<leader>roj", ":OverseerToggle bottom<CR>", desc = "Toggle On Bottom", silent = true },
    { "<leader>roh", ":OverseerToggle left<CR>", desc = "Toggle On Left", silent = true },
    { "<leader>ro;", ":OverseerToggle right<CR>", desc = "Toggle On Right", silent = true },
})

require("which-key").add({ { "<leader>rh", group = "http" } })
require("kulala").setup({ global_keymaps = false })
map({
    { "<leader>rhr", function() require("kulala").run() end, silent = true, desc = "Run Request" },
    { "<leader>rhl", function() require("kulala").replay() end, silent = true, desc = "Run Last Request" },
    { "<leader>rhe", function() require("kulala").set_selected_env() end, silent = true, desc = "Select Environment" },
})

local leet_keys = {
    { "<leader>cla", "<cmd>Leet<cr>", "Leet menu" },
    { "<leader>clb", "<cmd>Leet lang<cr>", "Leet lang" },
    { "<leader>clc", "<cmd>Leet console<cr>", "Leet console" },
    { "<leader>cld", "<cmd>Leet desc toggle<cr>", "Leet desc toggle" },
    { "<leader>cle", "<cmd>Leet desc status<cr>", "Leet desc status" },
    { "<leader>cli", "<cmd>Leet info<cr>", "Leet info" },
    { "<leader>clj", "<cmd>Leet random<cr>", "Leet random" },
    { "<leader>clk", "<cmd>Leet daily<cr>", "Leet daily" },
    { "<leader>cll", "<cmd>Leet list<cr>", "Leet list" },
    { "<leader>clo", "<cmd>Leet cookie delete<cr>", "Leet cookie delete" },
    { "<leader>clr", "<cmd>Leet run<cr>", "Leet run" },
    { "<leader>cls", "<cmd>Leet submit<cr>", "Leet submit" },
    { "<leader>clf", "<cmd>Leet tabs<cr>", "Leet tabs" },
    { "<leader>clt", "<cmd>Leet test<cr>", "Leet test" },
    { "<leader>clu", "<cmd>Leet cookie update<cr>", "Leet cookie update" },
    { "<leader>clU", "<cmd>Leet cache update<cr>", "Leet cache update" },
}
require("which-key").add({ { "<leader>cl", group = "leetcode" } })
require("leetcode").setup({
    arg = leet_arg,
    lang = "python3",
    theme = { normal = { fg = "#EA4AAA" } },
})
for _, key in ipairs(leet_keys) do
    vim.keymap.set("n", key[1], key[2], { silent = true, desc = key[3] })
end

map({
    { "<leader>cU", "<CMD>ConvertJSONtoLang typescript<CR>", desc = "Convert JSON to TS", mode = { "n", "v" } },
    { "<leader>ct", "<CMD>ConvertJSONtoLangBuffer typescript<CR>", desc = "Convert JSON to TS Buffer", mode = { "n", "v" } },
})
