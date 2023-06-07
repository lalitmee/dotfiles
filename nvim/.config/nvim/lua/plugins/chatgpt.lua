return {
    ----------------------------------------------------------------------
    --                           ChatGPT.nvim                           --
    ----------------------------------------------------------------------
    {
        "jackMort/ChatGPT.nvim",
        cmd = {
            "ChatGPT",
            "ChatGPTRun",
            "ChatGPTActAs",
            "ChatGPTEditWithInstructions",
        },
        dependencies = { "MunifTanjim/nui.nvim" },
        opts = {
            popup_input = {
                submit = "<Enter>",
            },
        },
    },

    ----------------------------------------------------------------------
    --                          backseat.nvim                           --
    ----------------------------------------------------------------------
    {
        "james1236/backseat.nvim",
        cmd = {
            "Backseat",
            "BackseatAsk",
            "BackseatClear",
            "BackseatClearLine",
        },
        config = true,
    },

    ----------------------------------------------------------------------
    --                         codeexplain.nvim                         --
    ----------------------------------------------------------------------
    {
        "mthbernardes/codeexplain.nvim",
        cmd = { "CodeExplain" },
        build = function()
            vim.cmd([[silent UpdateRemotePlugins]])
        end,
    },

    ----------------------------------------------------------------------
    --                           CodeGPT.nvim                           --
    ----------------------------------------------------------------------
    {
        "dpayne/CodeGPT.nvim",
        dependencies = {
            "MunifTanjim/nui.nvim",
        },
        cmd = { "Chat" },
        config = function()
            require("codegpt.config")
        end,
    },
}
