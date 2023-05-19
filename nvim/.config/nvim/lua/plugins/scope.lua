return {
    "tiagovla/scope.nvim",
    event = { "TabEnter" },
    dependencies = {
        "nvim-telescope/telescope.nvim",
    },
    init = function()
        require("telescope").load_extension("scope")
    end,
    config = true,
}
