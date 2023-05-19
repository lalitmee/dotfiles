return {
    ---------------------------------------------------------------------------
    --  NOTE: must {{{
    ---------------------------------------------------------------------------
    {
        "nvim-lua/plenary.nvim",
        event = { "VeryLazy" },
    },
    { -- trying this for sometime
        "nathom/filetype.nvim",
        lazy = false,
        init = function()
            vim.g.did_load_filetypes = 1 --disable loading normal filetypes
        end,
        -- enabled = false
    },
    -- }}}
    ---------------------------------------------------------------------------

    ---------------------------------------------------------------------------
    --  NOTE: enhancements {{{
    ---------------------------------------------------------------------------
    {
        "NMAC427/guess-indent.nvim",
        event = { "VeryLazy" },
        config = true,
    },
    {
        "wakatime/vim-wakatime",
        event = { "VimEnter" },
    },
    {
        "ziontee113/icon-picker.nvim",
        config = function()
            require("icon-picker")
        end,
        cmd = { "PickEverything" },
    },
    {
        "nanotee/zoxide.vim",
        cmd = { "Z", "Lz", "Tz", "Zi", "Lzi", "Tzi" },
    },
    -- }}}
    ---------------------------------------------------------------------------
}
