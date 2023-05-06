return {
    "tiagovla/scope.nvim",
    init = function()
        require("telescope").load_extension("scope")
    end,
    config = true,
}
