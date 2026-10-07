local function map(lhs, rhs, opts)
    opts = opts or {}
    local mode = opts.mode or "n"
    opts.mode = nil
    vim.keymap.set(mode, lhs, rhs, opts)
end

local wk = require("which-key")

require("atone").setup({})
require("better-goto-file").setup({})
require("nvim-surround").setup({})
require("iswap").setup({})
require("nap").setup({
    next_prefix = "]",
    prev_prefix = "[",
    next_repeat = "]]",
    prev_repeat = "[[",
    operators = {
        q = { next = { rhs = "<cmd>cnext<CR>", opts = { desc = "Next QF Item" } }, prev = { rhs = "<cmd>cprev<CR>", opts = { desc = "Previous QF Item" } } },
        h = { next = { rhs = "<cmd>Gitsigns next_hunk<CR>", opts = { desc = "Next hunk" } }, prev = { rhs = "<cmd>Gitsigns next_hunk<CR>", opts = { desc = "Previous hunk" } } },
        ["<Tab>"] = { next = { rhs = "<cmd>tabnext<cr>", opts = { desc = "Next tab" } }, prev = { rhs = "<cmd>tabprevious<cr>", opts = { desc = "Previous tab" } } },
        ["<Space>"] = { next = { rhs = [[<cmd>call append(line("."), [""])<CR>]], opts = { desc = "Empty line below" } }, prev = { rhs = [[<cmd>call append(line(".")-1, [""])<CR>]], opts = { desc = "Empty line above" } } },
        e = { next = { rhs = [[<cmd>m .+1<CR>]], opts = { desc = "Move line down" } }, prev = { rhs = [[<cmd>m .-2<CR>]], opts = { desc = "Move line up" } } },
        t = { next = { rhs = function() require("todo-comments").jump_next() end, opts = { desc = "Move line down" } }, prev = { rhs = function() require("todo-comments").jump_next() end, opts = { desc = "Move line up" } } },
        j = { next = { rhs = function() Snacks.words.jump(1, true) end, opts = { desc = "Next Word" } }, prev = { rhs = function() Snacks.words.jump(-1, true) end, opts = { desc = "Previous Word" } } },
        f = { next = { rhs = [[zczjzo<C-l>]], opts = { desc = "next fold" } }, prev = { rhs = [[zczkzo%0<C-l>]], opts = { desc = "previous fold" } } },
    },
})
require("scratch").setup({
    file_picker = "snacks",
    filetypes = { "js", "json", "lua", "org", "sh", "ts", "txt" },
    scratch_file_dir = require("utils.oslib").get_second_brain_path() .. "/scratch/",
})
require("Navigator").setup({ auto_save = "all" })

local harpoon = require("harpoon")
harpoon:setup({ settings = { save_on_toggle = true, sync_on_ui_close = true } })
harpoon:extend({ UI_CREATE = function(cx)
    for key, action in pairs({ ["C-v"] = { vsplit = true }, ["C-x"] = { split = true }, ["C-t"] = { tabedit = true } }) do
        vim.keymap.set("n", "<" .. key .. ">", function() harpoon.ui:select_menu_item(action) end, { buffer = cx.bufnr })
    end
end })
for i = 1, 5 do
    map("<leader>" .. i, function() require("harpoon"):list():select(i) end, { desc = "Goto File " .. i, silent = true })
end
map("<leader>fa", function() require("harpoon"):list():add() end, { desc = "Add File", silent = true })
map("<leader>fm", function() require("harpoon").ui:toggle_quick_menu(require("harpoon"):list()) end, { desc = "Toggle Harpoon", silent = true })

wk.add({ { "<localleader>b", group = "browse" } })
local browse_opts = {
    picker = "snacks", provider = "duckduckgo", persist_grouped_bookmarks_query = false,
    browser_bookmarks = { enabled = true, browsers = { chrome = true, firefox = true, brave = true }, group_by_folder = true, auto_detect = true },
    layouts = { browse = "dropdown", manual_bookmarks = "dropdown", browser_bookmarks = nil },
    bookmark_picker = { show_nested = false },
    bookmarks = {
        work = { name = "Work", github_pulls = "https://github.com/pulls", mui = "https://mui.com/", ["mui-icons"] = "https://mui.com/components/material-icons/#material-icons", ["v4-mui"] = "https://v4.mui.com/", npm_search = "https://npmjs.com/search?q=%s", bootstrap = "https://getbootstrap.com" },
        dots = { name = "Dotfiles", ThePrimeagen = "https://github.com/ThePrimeagen/.dotfiles", akinsho = "https://github.com/akinsho/dotfiles", tjdevries = "https://github.com/tjdevries/config_manager", whatsthatsmell = "https://github.com/whatsthatsmell/dots", dotfiles = "https://github.com/lalitmee/dotfiles" },
        dev = { name = "Development", ["pkg.go.dev"] = "https://pkg.go.dev/search?q=%s" },
        github = { name = "GitHub", code_search = "https://github.com/search?q=%s&type=code", issues_search = "https://github.com/search?q=%s&type=issues", pulls_search = "https://github.com/search?q=%s&type=pullrequests", repo_search = "https://github.com/search?q=%s&type=repositories", ["spec-kit"] = "https://github.com/github/spec-kit" },
        neovim = { name = "Neovim", ["awesome-neovim"] = "https://github.com/rockerBOO/awesome-neovim", ["browse.nvim"] = "https://github.com/lalitmee/browse.nvim", ["cobalt2.nvim"] = "https://github.com/lalitmee/cobalt2.nvim", ["fzf-lua"] = "https://github.com/ibhagwan/fzf-lua", lualine = "https://github.com/nvim-lualine/lualine.nvim", neovim_github = "https://github.com/neovim/neovim", ["nvim-treesitter"] = "https://github.com/nvim-treesitter/nvim-treesitter", telescope = "https://github.com/nvim-telescope/telescope.nvim" },
        ["ai-tools"] = { name = "AI Tools", ["gemini-cli"] = "https://github.com/google-gemini/gemini-cli", ["spec-kit"] = "https://github.com/github/spec-kit", ["chatgpt-web"] = "https://chat.com", ["chatgpt-plus"] = "https://chat.openai.com/", claude = "https://claude.ai/", gemini = "https://gemini.google.com/", perplexity = "https://www.perplexity.ai/", opencode = "https://opencode.com/", skills = "https://sickn33.github.io/antigravity-awesome-skills", ["mcp-servers"] = "https://mcpservers.org" },
        docs = { name = "Documentation", ["devdocs.io"] = "https://devdocs.io/search?q=%s", learnxinyminutes = "https://learnxinyminutes.com/docs/%s", mdn = "https://developer.mozilla.org/search?q=%s", ["i3wm-docs"] = "https://i3wm.org/docs/", cargo = "https://doc.rust-lang.org/cargo/index.html?search=%s", ["rust:core"] = "https://doc.rust-lang.org/core/?search=%s", ["rust:std"] = "https://doc.rust-lang.org/std/?search=%s" },
        misc = { name = "Miscellaneous", ["i3wm-discussions"] = "https://github.com/i3/i3/discussions", dNotes = "https://github.com/lalitmee/dNotes", ["amazon.in"] = "https://www.amazon.in/s?k=%s", youtube = "https://www.youtube.com/results?search_query=%s", wikipedia = "https://en.wikipedia.org/wiki/Special:Search?search=%s", stackoverflow = "https://stackoverflow.com/search?q=%s" },
        reddit = { name = "Reddit", search = "https://www.reddit.com/search?q=%s", ["sub-reddit-search"] = "https://www.reddit.com/search?q=%s&type=sr", neovim = "https://www.reddit.com/r/neovim", workspaces = "https://www.reddit.com/r/workspaces", vim_porn = "https://www.reddit.com/r/vimporn", ["gemini-cli"] = "https://www.reddit.com/r/GeminiCLI", ["claude-ai"] = "https://www.reddit.com/r/ClaudeAI/", ["gemini-ai"] = "https://www.reddit.com/r/GeminiAI" },
    },
}
require("browse").setup(browse_opts)

require("hardtime").setup({ disabled_filetypes = { codecompanion = true, harpoon = true, mason = true, snacks_terminal = true, undotree = true } })
require("textcase").setup({})
wk.add({ { "<leader>x", group = "codesnap" } })
require("codesnap").setup({ save_path = vim.env.HOME .. "/Projects/Personal/Github/code-screenshots", code_font_family = "SauceCodePro Nerd Font", has_line_number = true, watermark = "" })
require("trouble").setup({ focus = true })
local saved_terminal
require("flatten").setup({
    window = { open = "alternate" },
    hooks = {
        should_block = function(argv) return vim.tbl_contains(argv, "-b") end,
        pre_open = function()
            for _, terminal in ipairs(Snacks.terminal.list()) do
                if vim.api.nvim_get_current_buf() == terminal.buf then
                    saved_terminal = terminal
                    break
                end
            end
        end,
        post_open = function(bufnr, winnr, ft, is_blocking)
            if is_blocking and saved_terminal then
                saved_terminal:close()
            else
                vim.api.nvim_set_current_win(winnr)
                require("wezterm").switch_pane.id(tonumber(os.getenv("WEZTERM_PANE")))
            end
            if ft == "gitcommit" or ft == "gitrebase" then
                vim.api.nvim_create_autocmd("BufWritePost", {
                    buffer = bufnr,
                    once = true,
                    callback = vim.schedule_wrap(function() vim.api.nvim_buf_delete(bufnr, {}) end),
                })
            end
        end,
        block_end = function()
            vim.schedule(function()
                if saved_terminal then
                    saved_terminal:open()
                    saved_terminal = nil
                end
            end)
        end,
    },
})
require("http-codes").setup({ use = "snacks" })
require("todo-comments").setup({})
require("persistence").setup({})
require("screenkey").setup({})
wk.add({ { "<leader>T", group = "todo" } })
require("checkmate").setup({
    files = { "todo.md", "**/todo-*.md" }, todo_states = { unchecked = { marker = "[ ]" }, checked = { marker = "[x]" } },
    todo_count_formatter = function(completed, total) return completed and total and string.format("[%d/%d]", completed, total) or "" end,
})
vim.g.db_ui_use_nerd_fonts = 1
vim.g.db_ui_winwidth = 40

for _, spec in ipairs({
    { "<leader>bt", function()
        vim.cmd("TomePlayBook")
        vim.notify("Enabled Playbook", vim.log.levels.INFO, { title = "Tome" })
    end, "Tome Playbook" },
    { "<leader>tu", ":Atone toggle<CR>", "Atone: Undotree" },
    { "<leader>ii", ":ISwap<CR>", "Iswap" }, { "<leader>il", ":ISwapWithLeft<CR>", "Swap With Left" }, { "<leader>in", ":ISwapNode<CR>", "Swap Nodes" }, { "<leader>ir", ":ISwapWithRight<CR>", "Swap With Right" }, { "<leader>iw", ":ISwapWith<CR>", "Swap With" },
    { "<leader>ka", "<cmd>Scratch<cr>", "New Scratch" }, { "<leader>kc", "<cmd>ScratchWithName<cr>", "New Named Scratch" }, { "<leader>ko", "<cmd>ScratchOpen<cr>", "Open Scratch" }, { "<leader>kf", "<cmd>ScratchOpenFzf<cr>", "Grep in Scratch Files" },
    { "<C-h>", "<cmd>NavigatorLeft<cr>" }, { "<C-l>", "<cmd>NavigatorRight<cr>" }, { "<C-j>", "<cmd>NavigatorDown<cr>" }, { "<C-k>", "<cmd>NavigatorUp<cr>" },
    { "<leader>wh", ":NavigatorLeft<CR>", "Window Left" }, { "<leader>wj", ":NavigatorDown<CR>", "Window Down" }, { "<leader>wk", ":NavigatorUp<CR>", "Window Up" }, { "<leader>wl", ":NavigatorRight<CR>", "Window Right" }, { "<leader>wp", ":NavigatorPrevious<CR>", "Window Previous" },
    { "<leader>tv", ":HardTime toggle<CR>", "Hardtime Toggle" }, { "<leader>xa", ":CodeSnapASCII<CR>", "Codesnap Ascii", { "n", "v" } }, { "<leader>xh", ":CodeSnapHighlight<CR>", "Codesnap Highlight", { "n", "v" } }, { "<leader>xH", ":CodeSnapSaveHighlight<CR>", "Codesnap Save Highlight", { "n", "v" } }, { "<leader>xs", ":CodeSnap<CR>", "Codesnap", { "n", "v" } }, { "<leader>xS", ":CodeSnapSave<CR>", "Codesnap Save", { "n", "v" } },
    { "<leader>qx", "<cmd>Trouble diagnostics toggle<cr>", "Diagnostics (Trouble)" }, { "<leader>qX", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", "Buffer Diagnostics (Trouble)" }, { "<leader>qw", "<cmd>Trouble symbols toggle focus=false<cr>", "Symbols (Trouble)" }, { "<leader>qL", "<cmd>Trouble loclist toggle<cr>", "Location List (Trouble)" }, { "<leader>qQ", "<cmd>Trouble qflist toggle<cr>", "Quickfix List (Trouble)" },
    { "<leader>sh", ":HTTPCodes<CR>", "Http Codes" }, { "<leader>qa", "<cmd>TodoTrouble<cr>", "Todo Trouble" }, { "<leader>qq", "<cmd>TodoQuickFix<cr>", "Todo Quickfix" },
    { "<leader>qs", function() require("persistence").load() end, "Load Session" }, { "<leader>qo", function() require("persistence").select() end, "Select Session" }, { "<leader>ql", function() require("persistence").load({ last = true }) end, "Load Last Session" }, { "<leader>qd", function() require("persistence").stop() end, "Stop Session" },
    { "<leader>tr", ":Screenkey toggle<CR>", "Screenkey Toggle" }, { "<leader>tR", ":Screenkey redraw<CR>", "Screenkey Redraw" },
    { "<leader>T.", function() local path = require("utils.oslib").get_project_todo_path(); Snacks.scratch.open({ icon = " ", ft = "markdown", name = "Todo", file = path }) end, "Toggle Project/Branch Todo" },
    { "<leader>D", "<cmd>DBUIToggle<CR>", "DB UI Toggle" },
}) do
    map(spec[1], spec[2], { desc = spec[3], silent = true, mode = spec[4] })
end

for _, lhs in ipairs({ "<localleader>ba", "<localleader>bb", "<localleader>bd", "<localleader>bf", "<localleader>bi", "<localleader>bl", "<localleader>bB", "<localleader>bm", "<localleader>bM" }) do
    local cmd = lhs:sub(-1)
    local actions = { a = "bookmarks", b = "", d = "devdocs", f = "devdocs_ft", i = "input", l = "bookmarks_manual", B = "bookmarks_browser", m = "mdn", M = "mdn_ft" }
    map(lhs, "<cmd>Browse " .. actions[cmd] .. "<CR>", { desc = "Browse", mode = { "n", "x" } })
end
map("<localleader>bc", function() require("utils.cht").cht() end, { desc = "Cheatsheet" })
map("<localleader>bs", function() require("utils.cht").stack_overflow() end, { desc = "Stackoverflow" })
for _, spec in ipairs({
    { "<leader>qt", function() Snacks.picker.todo_comments() end, "Todo" },
    { "<leader>qf", function() Snacks.picker.todo_comments({ keywords = { "TODO", "FIX" } }) end, "TODO/FIX" },
    { "<leader>qe", function() Snacks.picker.todo_comments({ keywords = { "ERROR", "WARN" } }) end, "ERROR/WARN" },
    { "<leader>qN", function() Snacks.picker.todo_comments({ keywords = { "NOTE" } }) end, "NOTE" },
    { "<leader>qF", function() Snacks.picker.todo_comments({ keywords = { "FIXME" } }) end, "FIXME" },
    { "<leader>qP", function() Snacks.picker.todo_comments({ keywords = { "PERF" } }) end, "PERF" },
    { "<leader>qh", function() Snacks.picker.todo_comments({ keywords = { "HACK" } }) end, "HACK" },
    { "<localleader>p", "<Plug>(TomePlayLine)", "Tome Play Line", "n" }, { "<localleader>P", "<Plug>(TomePlayParagraph)", "Tome Play Paragraph", "n" }, { "<localleader>p", "<Plug>(TomePlaySelection)", "Tome Play Selection", "x" },
}) do map(spec[1], spec[2], { desc = spec[3], mode = spec[4] }) end
