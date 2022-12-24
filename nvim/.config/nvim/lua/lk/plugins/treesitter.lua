local M = {
    "nvim-treesitter/nvim-treesitter",
    run = ":TSUpdate",
    event = "BufReadPost",
    dependencies = {
        { "JoosepAlviste/nvim-ts-context-commentstring" },
        { "nvim-treesitter/nvim-treesitter-context" },
        { "nvim-treesitter/nvim-treesitter-textobjects" },
        { "p00f/nvim-ts-rainbow" },
        {
            "nvim-treesitter/playground",
            cmd = { "TSPlaygroundToggle" },
        },
        {
            "andymass/vim-matchup",
            config = function()
                vim.g.matchup_matchparen_offscreen = { method = "popup" }
            end,
        },
    },
}

function M.config()
    ----------------------------------------------------------------------
    -- NOTE: treesitter settings {{{
    ----------------------------------------------------------------------
    local parsers = require("nvim-treesitter.parsers")

    ----------------------------------------------------------------------
    -- NOTE: treesitter setup {{{
    ----------------------------------------------------------------------
    require("nvim-treesitter.configs").setup({
        ensure_installed = vim.g.enable_treesitter_ft,
        -- Auto install parsers, if missing, for the current buffer
        auto_install = false,
        highlight = { enable = true },
        rainbow = {
            enable = true,
            extended_mode = true,
        },
        matchup = { enable = true },
        autotag = { enable = true },
        indent = {
            enable = true,
            disable = { "css" },
        },
        playground = {
            enable = true,
            updatetime = 25,
            persist_queries = false,
        },
        context_commentstring = {
            enable = true,
            enable_autocmd = false,
        },
        query_linter = {
            enable = true,
            use_virtual_text = true,
            lint_events = { "BufWrite", "CursorHold" },
        },
        incremental_selection = {
            enable = true,
            keymaps = {
                init_selection = "<localleader>tv",
                node_incremental = "<localleader>tv",
                scope_incremental = "]v",
                node_decremental = "[v",
            },
        },
        textobjects = {
            lookahead = true,
            select = {
                enable = true,
                keymaps = {
                    ["af"] = "@function.outer",
                    ["if"] = "@function.inner",
                    ["ac"] = "@class.outer",
                    ["ic"] = "@class.inner",
                    ["aC"] = "@conditional.outer",
                    ["iC"] = "@conditional.inner",
                },
            },
            swap = {
                enable = true,
                swap_next = {
                    ["[w"] = "@parameter.inner",
                },
                swap_previous = {
                    ["]w"] = "@parameter.inner",
                },
            },
            move = {
                enable = true,
                set_jumps = true,
                goto_next_start = {
                    ["]m"] = "@function.outer",
                    ["]c"] = "@class.outer",
                },
                goto_next_end = {
                    ["]M"] = "@function.outer",
                    ["]C"] = "@class.outer",
                },
                goto_previous_start = {
                    ["[m"] = "@function.outer",
                    ["[c"] = "@class.outer",
                },
                goto_previous_end = {
                    ["[M"] = "@function.outer",
                    ["[C"] = "@class.outer",
                },
            },
            tree_docs = {
                enable = true,
                keymaps = {
                    doc_node_at_cursor = "<localleader>tc",
                    doc_all_in_range = "<localleader>tc",
                },
            },
            lsp_interop = {
                enable = true,
                peek_definition_code = {
                    ["df"] = "@function.outer",
                    ["dF"] = "@class.outer",
                },
            },
        },
    })
    -- }}}
    ----------------------------------------------------------------------

    ----------------------------------------------------------------------
    -- NOTE: octo settings {{{
    -- this is to allow markdown highlighting in octo buffers
    ----------------------------------------------------------------------
    local parser_config = parsers.get_parser_configs()
    parser_config.markdown.filetype_to_parsername = "octo"
    -- }}}
    ----------------------------------------------------------------------

    -- }}}
    ----------------------------------------------------------------------
end

return M

-- vim:foldmethod=marker
