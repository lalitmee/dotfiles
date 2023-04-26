return {
    "ecthelionvi/NeoComposer.nvim",
    dependencies = { "kkharji/sqlite.lua" },
    init = function()
        require("telescope").load_extension("macros")
    end,
    opts = {},
}
