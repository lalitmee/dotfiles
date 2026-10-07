local function map(lhs, rhs, opts)
    opts = opts or {}
    local mode = opts.mode or "n"
    opts.mode = nil
    vim.keymap.set(mode, lhs, rhs, opts)
end

require("blink.cmp").setup({
    keymap = {
        preset = "default",
        ["<Tab>"] = {
            "snippet_forward",
            function()
                if vim.lsp.inline_completion then
                    return vim.lsp.inline_completion.get()
                end
            end,
            "fallback",
        },
    },
    appearance = { use_nvim_cmp_as_default = true, nerd_font_variant = "mono" },
    sources = {
        default = { "lazydev", "snippets", "lsp", "buffer", "ripgrep", "path" },
        per_filetype = { sql = { "snippets", "dadbod", "buffer" } },
        providers = {
            lazydev = { name = "LazyDev", module = "lazydev.integrations.blink", score_offset = 100 },
            dadbod = { name = "Dadbod", module = "vim_dadbod_completion.blink" },
            ripgrep = {
                module = "blink-ripgrep",
                name = "Ripgrep",
                score_offset = -999,
                opts = { future_features = { kill_previous_searches = true } },
            },
            dictionary = { module = "blink-cmp-dictionary", name = "Dict", min_keyword_length = 3, opts = {} },
        },
    },
    enabled = function()
        return not vim.tbl_contains({ "snacks_picker", "snacks_input", "chatgpt-input" }, vim.bo.filetype)
            and vim.bo.buftype ~= "prompt"
            and vim.b.completion ~= false
    end,
    completion = {
        list = { selection = { preselect = true, auto_insert = function(ctx) return ctx.mode == "cmdline" end } },
        menu = { border = "rounded" },
        documentation = { auto_show = true, window = { border = "rounded" } },
        trigger = { prefetch_on_insert = false },
    },
    signature = { enabled = true, window = { border = "rounded" } },
    snippets = {
        preset = "luasnip",
        expand = function(snippet) require("luasnip").lsp_expand(snippet) end,
        active = function(filter)
            if filter and filter.direction then return require("luasnip").jumpable(filter.direction) end
            return require("luasnip").in_snippet()
        end,
        jump = function(direction) require("luasnip").jump(direction) end,
    },
})

require("ts-comments").setup({})

do
    local ls = require("luasnip")
    local types = require("luasnip.util.types")
    local extras = require("luasnip.extras")
    local fmt = require("luasnip.extras.fmt").fmt
    local fmta = require("luasnip.extras.fmt").fmta
    local t, i, c, d, f, s, sn = ls.text_node, ls.insert_node, ls.choice_node, ls.dynamic_node,
        ls.function_node, ls.snippet, ls.snippet_node
    local function firstToUpper(str) return str[1]:sub(1, 1):upper() .. str[1]:sub(2) end
    local function same(index, words)
        local first_char_capital = words and words.first
        return f(function(args) return first_char_capital and firstToUpper(args[1]) or args[1] end, { index })
    end
    local function filename()
        return f(function(_, snip)
            local name = vim.split(snip.snippet.env.TM_FILENAME, ".")
            return name[1] or ""
        end)
    end
    ls.config.set_config({
        history = true,
        updateevents = "TextChanged,TextChangedI",
        enable_autosnippets = true,
        ext_opts = {
            [types.choiceNode] = { active = { hl_mode = "combine", virt_text = { { "● ", "Error" } } } },
            [types.insertNode] = { active = { hl_mode = "combine", virt_text = { { "● ", "WarningMsg" } } } },
        },
        snip_env = { fmt = fmt, fmta = fmta, match = extras.match, rep = extras.rep,
            t = t, f = f, c = c, d = d, i = i, s = s, sn = sn, same = same, filename = filename },
    })
    require("luasnip.loaders.from_vscode").lazy_load()
    require("luasnip.loaders.from_snipmate").lazy_load()
    ls.filetype_extend("all", { "_" })
    require("luasnip.loaders.from_lua").lazy_load()
    lk.command("LuaSnipEdit", function() require("luasnip.loaders").edit_snippet_files() end)
    vim.keymap.set({ "i", "s" }, "<c-j>", function() if ls.jumpable(1) then ls.jump(1) end end, { silent = true })
    vim.keymap.set({ "i", "s" }, "<c-k>", function() if ls.jumpable(-1) then ls.jump(-1) end end, { silent = true })
    vim.keymap.set({ "i", "s" }, "<c-y>", function() if ls.expandable() then ls.expand() end end, { silent = true })
    vim.keymap.set({ "i", "s" }, "<c-l>", function() if ls.choice_active() then ls.change_choice(1) end end)
    vim.keymap.set("i", "<c-u>", function() require("luasnip.extras.select_choice")() end)
end
map("<leader>ie", ":LuaSnipEdit<CR>", { desc = "Edit Snippets" })

do
    local ufo = require("ufo")
    vim.opt.sessionoptions:append("folds")
    vim.o.foldcolumn, vim.o.foldlevel, vim.o.foldlevelstart, vim.o.foldenable = "0", 99, 99, true
    lk.nnoremap("zR", ufo.openAllFolds, { desc = "open all folds" })
    lk.nnoremap("zM", ufo.closeAllFolds, { desc = "close all folds" })
    lk.nnoremap("zr", ufo.openFoldsExceptKinds, { desc = "open folds except kinds" })
    lk.nnoremap("zm", ufo.closeFoldsWith, { desc = "close folds with" })
    lk.nnoremap("zK", function() if not ufo.peekFoldedLinesUnderCursor() then vim.lsp.buf.hover() end end,
        { desc = "preview fold" })
    ufo.setup({
        fold_virt_text_handler = function(virt_text, lnum, end_lnum, width)
            local suffix = " {...} ┣━━"
            local lines = ("┫ %d lines ┣━━"):format(end_lnum - lnum)
            local cur_width = 0
            for _, section in ipairs(virt_text) do cur_width = cur_width + vim.fn.strdisplaywidth(section[1]) end
            suffix = suffix .. ("━"):rep(width - cur_width - vim.fn.strdisplaywidth(lines) - 10)
            table.insert(virt_text, { suffix, "Normal" })
            table.insert(virt_text, { lines, "Normal" })
            return virt_text
        end,
        close_fold_kinds_for_ft = {
            javascript = { "imports", "comment" }, javascriptreact = { "imports", "comment" },
            typescript = { "imports", "comment" }, typescriptreact = { "imports", "comment" },
        },
        open_fold_hl_timeout = 0,
        provider_selector = function(_, filetype)
            if filetype == "org" then return nil end
            return { "treesitter", "indent" }
        end,
        disable_filetype = { "org" },
    })
end

require("yanky").setup({ highlight = { timer = 40 }, system_clipboard = { sync_with_ring = false } })
for _, key in ipairs({
    { "<c-n>", "<Plug>(YankyCycleForward)", "n" }, { "<c-p>", "<Plug>(YankyCycleBackward)", "n" },
    { "P", "<Plug>(YankyPutBefore)", "n" }, { "P", "<Plug>(YankyPutBefore)", "x" },
    { "gP", "<Plug>(YankyGPutBefore)", "n" }, { "gP", "<Plug>(YankyGPutBefore)", "x" },
    { "gp", "<Plug>(YankyGPutAfter)", "n" }, { "gp", "<Plug>(YankyGPutAfter)", "x" },
    { "p", "<Plug>(YankyPutAfter)", "n" }, { "p", "<Plug>(YankyPutAfter)", "x" },
    { "y", "<Plug>(YankyYank)", "n" }, { "y", "<Plug>(YankyYank)", "x" },
}) do vim.keymap.set(key[3], key[1], key[2]) end
map("<leader>ay", ":YankyRingHistory<CR>", { desc = "Yank Ring History" })
map("<leader>ty", function() Snacks.picker.yank_history() end, { desc = "Yank History" })

vim.g.matchup_matchparen_offscreen = { method = "status_manual" }
map("gs", "<Plug>(SortMotion)", { mode = { "n", "v" } })
require("flash").setup({ modes = { search = { enabled = true }, chat = { jump_labels = true } } })
require("which-key").add({ { "<leader>j", group = "jump", mode = { "n", "v" } } })
map("<leader>jc", function() require("flash").jump({ continue = true }) end,
    { mode = { "n", "o", "x", "v" }, desc = "Continue Last Search" })
map("R", function() require("flash").treesitter_search() end,
    { mode = { "o", "x" }, desc = "Flash Treesitter Search" })
map("<c-s>", function() require("flash").toggle() end, { mode = "c", desc = "Toggle Flash Search" })
map("<leader>jj", function() require("flash").jump() end,
    { mode = { "n", "v", "x", "o" }, desc = "Jump", silent = true })
map("<leader>jl", function()
    require("flash").jump({ search = { mode = "search" }, label = { after = { 0, 0 } }, pattern = "^" })
end, { mode = { "n", "v", "x", "o" }, desc = "Line", silent = true })
map("<leader>jr", function() require("flash").remote() end,
    { mode = { "n", "v", "x", "o" }, desc = "Remote", silent = true })
map("<leader>jt", function() require("flash").treesitter() end,
    { mode = { "n", "v", "x", "o" }, desc = "Treesitter", silent = true })
map("<leader>jw", function() require("flash").jump({ pattern = vim.fn.expand("<cword>") }) end,
    { mode = { "n", "v", "x", "o" }, desc = "Current Word" })
map("<leader>jW", function()
    require("flash").jump({
        pattern = ".",
        search = { mode = function(pattern)
            if pattern:sub(1, 1) == "." then pattern = pattern:sub(2) end
            return ([[\v<%s\w*>]]):format(pattern), ([[\v<%s]]):format(pattern)
        end },
        jump = { pos = "range" },
    })
end, { mode = { "n", "v", "x", "o" }, desc = "Select Word" })
map("<leader>jb", function()
    require("flash").jump({ search = { mode = function(str) return "\\<" .. str end } })
end, { mode = { "n", "v", "x", "o" }, desc = "Beginning Of Words", silent = true })
map("<leader>jd", function()
    require("flash").jump({ matcher = function(win)
        return vim.tbl_map(function(diag)
            return { pos = { diag.lnum + 1, diag.col }, end_pos = { diag.end_lnum + 1, diag.end_col - 1 } }
        end, vim.diagnostic.get(vim.api.nvim_win_get_buf(win)))
    end, action = function(match, state)
        vim.api.nvim_win_call(match.win, function()
            vim.api.nvim_win_set_cursor(match.win, match.pos)
            vim.diagnostic.open_float()
            vim.api.nvim_win_set_cursor(match.win, state.pos)
        end)
    end })
end, { mode = { "n", "v", "x", "o" }, desc = "Diagnostics", silent = true })
map("<leader>jww", function()
    local Flash = require("flash")
    local function format(opts)
        return { { opts.match.label1, "FlashMatch" }, { opts.match.label2, "FlashLabel" } }
    end
    Flash.jump({
        search = { mode = "search" },
        label = { after = false, before = { 0, 0 }, uppercase = false, format = format },
        pattern = [[\<]],
        action = function(match, state)
            state:hide()
            Flash.jump({
                search = { max_length = 0 }, highlight = { matches = false }, label = { format = format },
                matcher = function(win)
                    return vim.tbl_filter(function(m) return m.label == match.label and m.win == win end, state.results)
                end,
                labeler = function(matches)
                    for _, m in ipairs(matches) do m.label = m.label2 end
                end,
            })
        end,
        labeler = function(matches, state)
            local labels = state:labels()
            for i, item in ipairs(matches) do
                item.label1 = labels[math.floor((i - 1) / #labels) + 1]
                item.label2 = labels[(i - 1) % #labels + 1]
                item.label = item.label1
            end
        end,
    })
end, { mode = { "n", "v", "x", "o" }, desc = "2 Char Jump" })
require("grug-far").setup({})
require("which-key").add({ { "<leader>ss", group = "grug-far-sar", mode = { "n", "v" } } })
map("<leader>ss/", function() require("grug-far").open({ prefills = { paths = vim.fn.expand("%") } }) end,
    { desc = "File Search", silent = true })
map("<leader>sso", function() require("grug-far").toggle_instance({ instanceName = "far", staticTitle = "Find and Replace" }) end,
    { desc = "Open", silent = true })
map("<leader>ssw", function() require("grug-far").open({ prefills = { search = vim.fn.expand("<cword>") } }) end,
    { mode = { "n", "v" }, desc = "Current Word Search", silent = true })
map("<leader>sse", function() require("grug-far").open({ engine = "astgrep" }) end,
    { desc = "AST Grep Engine", silent = true })
map("<leader>sst", function() require("grug-far").open({ transient = true }) end,
    { desc = "Transient", silent = true })
map("<leader>sss", [[:<C-u>lua require('grug-far').with_visual_selection({ prefills = { paths = vim.fn.expand("%") } })<CR>]],
    { mode = { "n", "v" }, desc = "Current File Search With Visual Selection", silent = true })
require("ssr").setup({
    border = "rounded", min_width = 50, min_height = 5, max_width = 120, max_height = 25,
    adjust_window = true,
    keymaps = { close = "q", next_match = "n", prev_match = "N", replace_confirm = "<cr>", replace_all = "<leader><cr>" },
})
map("<leader>se", function() require("ssr").open() end, { mode = { "n", "v" }, desc = "open ssr" })
map("<leader>ae", ":Oil<CR>", { desc = "File Browser", silent = true })
map("<leader>ao", ":Oil --float<CR>", { desc = "File Browser Float", silent = true })
require("oil").setup({
    columns = { "icon" },
    float = { win_options = { winblend = 0 }, padding = 5, max_height = 120, max_width = 160 },
    view_options = { show_hidden = true }, skip_confirm_for_simple_edits = true,
    keymaps = { gr = { callback = function()
        local prefills = { paths = require("oil").get_current_dir() }
        local grug_far = require("grug-far")
        if not grug_far.has_instance("explorer") then
            grug_far.open({ instanceName = "explorer", prefills = prefills, staticTitle = "Find and Replace from Explorer" })
        else
            grug_far.open_instance("explorer")
            grug_far.update_instance_prefills("explorer", prefills, false)
        end
    end, desc = "Oil: Search in directory" } },
})

require("bqf").setup({
    auto_enable = true,
    preview = { auto_previw = true, win_height = 25, win_vheight = 25 },
    filter = { fzf = { extra_opts = { "--bind", "ctrl-s:select-all,ctrl-d:deselect-all", "--prompt", "Filter > " } } },
})
require("pqf").setup({})
map("<leader>hm", ":Messages<CR>", { desc = "Messages", silent = true })
map("<leader>hv", ":Verbose<space>", { desc = "Verbose", silent = true })
map("<leader>sl", ":S/<C-R><C-W>//<LEFT>", { silent = false, desc = "Replace Word <cursor> (line)" })
map("<leader>sf", ":%S/<C-r><C-w>//c<left><left>", { silent = false, desc = "Replace Word <cursor> (file)" })
map("<leader>sv", [["zy:'<'>S/<C-r><C-o>"//c<left><left>]], { mode = "x", silent = false, desc = "Replace Word <cursor> (visual)" })

require("lualine").setup({
    options = {
        theme = "cobalt2", globalstatus = true, section_separators = { left = "", right = "" },
        component_separators = { left = "", right = "" },
    },
    sections = {
        lualine_a = {
            { "searchcount", color = "lualine_b_normal" }, { "selectioncount", color = "lualine_b_normal" },
            { "mode", fmt = function(str) return "<" .. str:sub(1, 1) .. ">" end, color = { gui = "bold" } },
        },
        lualine_b = { { "branch", icon = "", fmt = function(str) return str:sub(1, 30) end } },
        lualine_c = {
            { "%=", type = "stl" }, { "filetype", icon_only = true, padding = { left = 1, right = 0 } },
            { "filename", path = 4 },
            { "diagnostics", sources = { "nvim_diagnostic" }, symbols = { error = "E:", warn = "W:", hint = "H:", info = "I:" }, always_visible = false },
        },
        lualine_x = { require("utils.lualine").get_trailing_whitespace, require("utils.lualine").get_mixed_indent },
        lualine_y = { { "tabs", mode = 1 } }, lualine_z = { { "progress", color = { gui = "bold" } } },
    },
    extensions = { "man", "quickfix" },
})
map("<leader>wr", ":LualineRenameTab<space>", { desc = "Rename Lualine Tab", silent = true })
require("scope").setup({})
require("quicker").setup({})
map("<leader>s/", function() require("rip-substitute").sub() end, { mode = { "n", "x" }, desc = "Rip Substitute" })
require("rip-substitute").setup({})
