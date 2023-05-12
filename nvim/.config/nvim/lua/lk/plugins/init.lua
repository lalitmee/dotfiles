return {
    ---------------------------------------------------------------------------
    --  NOTE: must {{{
    ---------------------------------------------------------------------------
    {
        "nvim-lua/plenary.nvim",
        event = { "VeryLazy" },
    },
    -- }}}
    ---------------------------------------------------------------------------

    ---------------------------------------------------------------------------
    --  NOTE: enhancements {{{
    ---------------------------------------------------------------------------
    {
        "NMAC427/guess-indent.nvim",
        event = { "VeryLazy" },
        opts = {},
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
    -- }}}
    ---------------------------------------------------------------------------
}
