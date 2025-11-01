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

            local npm_start = tmux_manager.run({ cmd = "npm start", name = "NPM Start" })
            local npm_test = tmux_manager.run({ cmd = "npm test", name = "NPM Test" })
            local npm_build = tmux_manager.run({ cmd = "npm run build", name = "NPM Build" })
            local npm_budgets = tmux_manager.run({ cmd = "npm run budgets", name = "NPM Budgets" })
            local npm_install = tmux_manager.run({ cmd = "npm install", name = "NPM Install" })

            local yarn_start = tmux_manager.run({ cmd = "yarn start", name = "Yarn Start" })
            local yarn_test = tmux_manager.run({ cmd = "yarn test", name = "Yarn Test" })
            local yarn_build = tmux_manager.run({ cmd = "yarn run build", name = "Yarn Build" })
            local yarn_budgets = tmux_manager.run({ cmd = "yarn run budgets", name = "Yarn Budgets" })
            local yarn_install = tmux_manager.run({ cmd = "yarn install", name = "Yarn Install" })

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
                    "<localleader>ts",
                    function()
                        tmux_manager.switch_orientation()
                    end,
                    desc = "Tmux: Switch Orientation",
                },
                {
                    "<localleader>tS",
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
                    "<localleader>to",
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

                { "<localleader>tn", group = "NPM Commands" },
                {
                    "<localleader>tnr",
                    function()
                        npm_start()
                    end,
                    desc = "Tmux: Run NPM Start",
                },
                {
                    "<localleader>tnt",
                    function()
                        npm_test()
                    end,
                    desc = "Tmux: Run NPM Test",
                },
                {
                    "<localleader>tnb",
                    function()
                        npm_build()
                    end,
                    desc = "Tmux: Run NPM Build",
                },
                {
                    "<localleader>tnu",
                    function()
                        npm_budgets()
                    end,
                    desc = "Tmux: Run NPM Budgets",
                },
                {
                    "<localleader>tni",
                    function()
                        npm_install()
                    end,
                    desc = "Tmux: Run NPM Install",
                },

                { "<localleader>ty", group = "Yarn Commands" },
                {
                    "<localleader>tyr",
                    function()
                        yarn_start()
                    end,
                    desc = "Tmux: Run Yarn Start",
                },
                {
                    "<localleader>tyt",
                    function()
                        yarn_test()
                    end,
                    desc = "Tmux: Run Yarn Test",
                },
                {
                    "<localleader>tyb",
                    function()
                        yarn_build()
                    end,
                    desc = "Tmux: Run Yarn Build",
                },
                {
                    "<localleader>tyu",
                    function()
                        yarn_budgets()
                    end,
                    desc = "Tmux: Run Yarn Budgets",
                },
                {
                    "<localleader>tyi",
                    function()
                        yarn_install()
                    end,
                    desc = "Tmux: Run Yarn Install",
                },
            })
        end,
    },
}
