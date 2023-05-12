local M = {
    "L3MON4D3/LuaSnip",
    event = { "InsertEnter" },
    dependencies = {
        "rafamadriz/friendly-snippets",
        "honza/vim-snippets",
    },
}

 M.config = function()
    local ls = require("luasnip")
    local types = require("luasnip.util.types")
    local extras = require("luasnip.extras")
    local fmt = require("luasnip.extras.fmt").fmt

    local t, i, c, d, f, s, sn =
        ls.text_node, ls.insert_node, ls.choice_node, ls.dynamic_node, ls.function_node, ls.snippet, ls.snippet_node

    ----------------------------------------------------------------------
    -- NOTE: helper functions {{{
    ----------------------------------------------------------------------
    local firstToUpper = function(str)
        return (str[1]:sub(1, 1):upper() .. str[1]:sub(2))
    end

    -- repeat the same word
    local same = function(index, words)
        words = words or {}
        local first_char_capital = words.first
        return f(function(args)
            if first_char_capital then
                return firstToUpper(args[1])
            end
            return args[1]
        end, { index })
    end

    -- get the file name of the current file
    local filename = function()
        return f(function(_, snip)
            local name = vim.split(snip.snippet.env.TM_FILENAME, ".", true)
            return name[1] or ""
        end)
    end
    -- }}}
    ----------------------------------------------------------------------

    ----------------------------------------------------------------------
    -- NOTE: configurations {{{
    ----------------------------------------------------------------------
    ls.config.set_config({
        -- This tells LuaSnip to remember to keep around the last snippet.
        -- You can jump back into it even if you move outside of the selection
        history = true,

        updateevents = "TextChanged,TextChangedI",

        enable_autosnippets = true,

        ext_opts = {
            [types.choiceNode] = {
                active = {
                    hl_mode = "combine",
                    virt_text = { { "● ", "Error" } },
                },
            },
            [types.insertNode] = {
                active = {
                    hl_mode = "combine",
                    virt_text = { { "● ", "WarningMsg" } },
                },
            },
        },
        snip_env = {
            fmt = fmt,
            match = extras.match,
            rep = extras.rep,
            t = t,
            f = f,
            c = c,
            d = d,
            i = i,
            s = s,
            sn = sn,
            same = same,
            filename = filename,
        },
    })
    -- }}}
    ----------------------------------------------------------------------

    ----------------------------------------------------------------------
    -- NOTE: loading snippets {{{
    ----------------------------------------------------------------------
    -- NOTE: snippets from extension and from `snippet` dir
    require("luasnip.loaders.from_vscode").lazy_load()
    require("luasnip.loaders.from_snipmate").lazy_load()
    ls.filetype_extend("all", { "_" })

    -- NOTE: custom snippets created in `lua` format
    require("luasnip.loaders.from_lua").lazy_load()
    lk.command("LuaSnipEdit", function()
        require("luasnip.loaders.from_lua").edit_snippet_files()
    end, {})
    -- }}}
    ----------------------------------------------------------------------

    ----------------------------------------------------------------------
    -- NOTE: key mappings {{{
    ----------------------------------------------------------------------
    -- <c-j> is my forward key
    -- this will jump to the next item within the snippet.
    vim.keymap.set({ "i", "s" }, "<c-j>", function()
        if ls.jumpable(1) then
            ls.jump(1)
        end
    end, { silent = true })

    -- <c-k> is my jump backwards key.
    -- this always moves to the previous item within the snippet
    vim.keymap.set({ "i", "s" }, "<c-k>", function()
        if ls.jumpable(-1) then
            ls.jump(-1)
        end
    end, { silent = true })

    -- <c-y> is my expansion key
    -- this will expand the current item or jump to the next item within the snippet.
    vim.keymap.set({ "i", "s" }, "<c-y>", function()
        if ls.expandable() then
            ls.expand()
        end
    end, { silent = true })

    -- <c-l> is selecting within a list of options.
    -- This is useful for choice nodes (introduced in the forthcoming episode 2)
    vim.keymap.set("i", "<c-l>", function()
        if ls.choice_active() then
            ls.change_choice(1)
        end
    end)

    vim.keymap.set("i", "<c-u>", require("luasnip.extras.select_choice"))
    -- }}}
    ----------------------------------------------------------------------
end

return M
