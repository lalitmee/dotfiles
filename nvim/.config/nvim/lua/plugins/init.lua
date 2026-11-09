return {
    { --[[ plenary ]]
        "nvim-lua/plenary.nvim",
        event = { "VeryLazy" },
    },

    { --[[ wakatime ]]
        enabled = false,
        -- enabled = vim.env.HOME == "/home/lalitmee",
        "wakatime/vim-wakatime",
        event = { "VimEnter" },
    },
}
