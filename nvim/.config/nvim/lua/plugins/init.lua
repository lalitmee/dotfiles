return {
    { --[[ plenary ]]
        "nvim-lua/plenary.nvim",
        event = { "VeryLazy" },
    },

    { --[[ wakatime ]]
        "wakatime/vim-wakatime",
        event = { "VimEnter" },
    },

    { --[[ icon-picker ]]
        "ziontee113/icon-picker.nvim",
        config = function()
            require("icon-picker")
        end,
        keys = {
            {
                "<leader>ip",
                "<cmd>PickEverything<cr>",
                silent = true,
                desc = "insert-icons",
            },
        },
    },
}
