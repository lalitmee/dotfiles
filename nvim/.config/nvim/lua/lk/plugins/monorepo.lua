return {
    "imNel/monorepo.nvim",
    keys = {
        "<leader>pm",
        "<leader>pn",
        "<leader>pp",
        "<leader>pt",
    },
    init = function()
        require("monorepo").setup()

        local wk = require("which-key")
        wk.register({
            ["p"] = {
                ["a"] = {
                    function()
                        require("monorepo").add_project()
                    end,
                    "next-project",
                },
                ["m"] = { ":Telescope monorepo<cr>", "monorepo" },
                ["n"] = {
                    function()
                        require("monorepo").next_project()
                    end,
                    "next-project",
                },
                ["P"] = {
                    function()
                        require("monorepo").previous_project()
                    end,
                    "previous-project",
                },
                ["r"] = {
                    function()
                        require("monorepo").remove_project()
                    end,
                    "next-project",
                },
                ["t"] = {
                    function()
                        require("monorepo").toggle_project()
                    end,
                    "toggle-project",
                },
            },
        }, { mode = "n", prefix = "<leader>" })
    end,
    dependencies = {
        "nvim-telescope/telescope.nvim",
        "nvim-lua/plenary.nvim",
    },
}
