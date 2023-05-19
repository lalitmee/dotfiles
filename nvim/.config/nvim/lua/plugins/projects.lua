local project_nvim = {
    "ahmedkhalf/project.nvim",
    keys = { "<leader>pp" },
    dependencies = {
        "nvim-telescope/telescope.nvim",
    },
    init = function()
        require("telescope").load_extension("projects")
    end,
    config = function()
        require("project_nvim").setup({
            detection_methods = { "pattern", "lsp" },
            patterns = { ".git" },
            show_hidden = true,
            -- show the message on changing the directory
            silent_chdir = false,
            -- change to the directory of the file in the current tab
            scope_chdir = "tab",
        })
    end,
}

local conduct_nvim = {
    "aaditeynair/conduct.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    cmd = {
        "ConductNewProject",
        "ConductLoadProject",
        "ConductLoadLastProject",
        "ConductLoadProjectConfig",
        "ConductReloadProjectConfig",
        "ConductDeleteProject",
        "ConductRenameProject",
        "ConductProjectNewSession",
        "ConductProjectLoadSession",
        "ConductProjectDeleteSession",
        "ConductProjectRenameSession",
    },
    enabled = false,
}

local monorepo_nvim = {
    "imNel/monorepo.nvim",
    keys = {
        "<leader>pm",
        "<leader>pn",
        "<leader>pp",
        "<leader>pt",
    },
    config = true,
    init = function()
        local monorepo = require("monorepo")
        local wk = require("which-key")

        wk.register({
            -- stylua: ignore
            ["p"] = {
                ["m"] = { ":Telescope monorepo<cr>", "monorepo" },
                ["a"] = { function() monorepo.add_project() end, "add-project" },
                ["n"] = { function() monorepo.next_project() end, "next-project" },
                ["P"] = { function() monorepo.previous_project() end, "previous-project" },
                ["r"] = { function() monorepo.remove_project() end, "remove-project" },
                ["t"] = { function() monorepo.toggle_project() end, "toggle-project" },
            },
        }, { mode = "n", prefix = "<leader>" })
    end,
    dependencies = {
        "nvim-telescope/telescope.nvim",
        "nvim-lua/plenary.nvim",
    },
}

return {
    conduct_nvim,
    monorepo_nvim,
    project_nvim,
}
