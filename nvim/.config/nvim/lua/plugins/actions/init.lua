local genghis = {
    "chrisgrieser/nvim-genghis",
    dependencies = "stevearc/dressing.nvim",
    init = function()
        local genghis = require("genghis")
        local wk = require("which-key")
        wk.register({
                --stylua: ignore
                ["S"] = {
                    ["a"] = { function() genghis.createNewFile() end, "create-file" },
                    ["c"] = { function() genghis.duplicateFile() end, "duplicate-file" },
                    ["d"] = { function() genghis.trashFile() end, "trash-file" },
                    ["f"] = { function() genghis.copyFilepath() end, "copy-file-path" },
                    ["m"] = { function() genghis.renameFile() end, "move-and-rename-file" },
                    ["n"] = { function() genghis.copyFilename() end, "copy-file-name" },
                    ["r"] = { function() genghis.renameFile() end, "rename-file" },
                    ["s"] = { function() genghis.moveSelectionToNewFile() end, "move-selection-to-file" },
                    ["x"] = { function() genghis.chmodx() end, "make-executable" },
                },
        }, { mode = "n", prefix = "<leader>" })
    end,
}

local autolist = {
    "gaoDean/autolist.nvim",
    ft = {
        "gitcommit",
        "markdown",
        "plaintex",
        "tex",
        "text",
    },
    config = true,
    init = function()
        local autolist = require("autolist")
        autolist.create_mapping_hook("i", "<CR>", autolist.new)
        autolist.create_mapping_hook("i", "<Tab>", autolist.indent)
        autolist.create_mapping_hook("i", "<S-Tab>", autolist.indent, "<C-D>")
        autolist.create_mapping_hook("n", "dd", autolist.force_recalculate)
        autolist.create_mapping_hook("n", "o", autolist.new)
        autolist.create_mapping_hook("n", "O", autolist.new_before)
        autolist.create_mapping_hook("n", ">>", autolist.indent)
        autolist.create_mapping_hook("n", "<<", autolist.indent)
        autolist.create_mapping_hook("n", "<C-r>", autolist.force_recalculate)
        autolist.create_mapping_hook(
            "n",
            "<leader>x",
            autolist.invert_entry,
            ""
        )
    end,
}

return {
    {
        "andymass/vim-matchup",
        event = { "VeryLazy" },
        config = function()
            vim.g.matchup_matchparen_offscreen = { method = "status_manual" }
        end,
    },
    {
        "christoomey/vim-sort-motion",
        keys = {
            "gs",
            { "gs", mode = "v" },
        },
    },
    {
        "famiu/bufdelete.nvim",
        cmd = { "Bdelete" },
    },
    {
        "godlygeek/tabular",
        cmd = { "Tabularize" },
    },
    {
        "kylechui/nvim-surround",
        keys = {
            "ds",
            "ys",
            "cs",
        },
        opts = {},
    },
    {
        "mizlan/iswap.nvim",
        cmd = { "ISwapWith", "ISwap" },
    },
    autolist,
    genghis,
}
