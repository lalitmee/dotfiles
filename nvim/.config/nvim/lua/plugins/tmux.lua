return {
    { -- [[ tmux-awesome-manager.nvim ]]
        -- "otavioschwanck/tmux-awesome-manager.nvim",
        "lalitmee/tmux-awesome-manager.nvim",
        dev = true,
        event = "VeryLazy",
        dependencies = {
            "nvim-telescope/telescope.nvim",
        },
        opts = {
            per_project_commands = {
                -- project name = { { cmd, name } }
                ["portfolio"] = {
                    { cmd = "yarn dev", name = "yarn-dev" },
                    { cmd = "yarn build", name = "yarn-build" },
                    { cmd = "npm run dev", name = "npm-run-dev" },
                    { cmd = "npm install", name = "npm-install" },
                    { cmd = "npm run build", name = "npm-run-build" },
                    { cmd = "yarn add %1", name = "yarn-add" },
                },
            },
            session_name = "Neovim Terminals",
            use_icon = false,
            icon = " ",
            picker = "telescope",
            project_open_as = "window",
        },
        config = function(_, opts)
            local tmux_manager = require("tmux-awesome-manager")

            tmux_manager.setup(opts)

            local yarn_add = tmux_manager.run({
                cmd = "yarn add %1",
                name = "Yarn Add Package",
                questions = { { question = "Package name:", required = true } },
            })

            local wk = require("which-key")
            wk.add({
                { "<localleader>t", group = "tmux" },
                {
                    "<localleader>ts",
                    function()
                        tmux_manager.send_text_to()
                    end,
                    desc = "Tmux: Send text to terminal",
                    mode = "v",
                },
                {
                    "<localleader>to",
                    function()
                        tmux_manager.switch_orientation()
                    end,
                    desc = "Tmux: Switch Orientation",
                },
                {
                    "<localleader>tn",
                    function()
                        tmux_manager.switch_open_as()
                    end,
                    desc = "Tmux: Switch Open As",
                },
                {
                    "<localleader>tK",
                    function()
                        tmux_manager.kill_all_terms()
                    end,
                    desc = "Tmux: Kill All Terms",
                },

                {
                    "<localleader>tp",
                    function()
                        tmux_manager.list_project_commands()
                    end,
                    desc = "Tmux: List Project Commands",
                },
                {
                    "<localleader>tP",
                    function()
                        tmux_manager.run_project_terms()
                    end,
                    desc = "Tmux: Run Project Terminals",
                },

                {
                    "<localleader>tf",
                    function()
                        tmux_manager.list_terms()
                    end,
                    desc = "Tmux: List All Terminals",
                },
                {
                    "<localleader>tl",
                    function()
                        tmux_manager.list_open_terms()
                    end,
                    desc = "Tmux: List Open Terminals",
                },

                {
                    "<localleader>tr",
                    function()
                        yarn_add()
                    end,
                    desc = "Tmux: Run Yarn Add",
                },
            })
        end,
    },
}
