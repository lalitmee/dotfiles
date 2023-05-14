local possession = {
    "jedrzejboczar/possession.nvim",
    event = { "VimEnter" },
    init = function()
        require("telescope").load_extension("possession")
        local wk = require("which-key")
        wk.register({
            ["x"] = {
                ["name"] = "+possession",
                ["c"] = { ":PossessionClose<CR>", "close" },
                ["d"] = { ":PossessionDelete<Space>", "delete" },
                ["l"] = { ":PossessionLoad<Space>", "load" },
                ["m"] = { ":PossessionMigrate<Space>", "migrate" },
                ["o"] = { ":Telescope possession list<CR>", "search" },
                ["p"] = { ":PossessionShow<Space>", "show" },
                ["r"] = { ":PossessionRename<Space>", "rename" },
                ["s"] = { ":PossessionSave<Space>", "save" },
            },
        }, { mode = "n", prefix = "<leader>" })
    end,
    config = function()
        require("possession").setup({
            silent = true,
            autosave = {
                current = true, -- or fun(name): boolean
                on_load = true,
                on_quit = true,
            },
        })
    end,
    -- enabled = false,
}

local auto_session = {
    "rmagatti/auto-session",
    event = { "VimEnter" },
    init = function()
        local wk = require("which-key")
        wk.register({
            ["a"] = {
                ["d"] = {
                    ":Autosession delete<CR>",
                    "delete-session-telescope",
                },
                ["D"] = { ":SessionDelete<CR>", "delete-current-session" },
                ["l"] = { ":Autosession search<CR>", "search-sessions" },
                ["s"] = { ":SessionSave<CR>", "save-session" },
                ["S"] = { ":SessionRestore<CR>", "restore-session" },
            },
        }, { mode = "n", prefix = "<leader>" })
    end,
    config = function()
        local function save_tabby_tab_names()
            local cmds = {}
            for _, t in pairs(vim.api.nvim_list_tabpages()) do
                local tabname = require("tabby.feature.tab_name").get_raw(t)
                if tabname ~= "" then
                    table.insert(
                        cmds,
                        'pcall(require("tabby.feature.tab_name").set, '
                            .. t
                            .. ', "'
                            .. tabname:gsub('"', '\\"')
                            .. '")'
                    )
                end
            end

            if #cmds == 0 then
                return ""
            end

            return "lua " .. table.concat(cmds, ";")
        end
        require("auto-session").setup({
            auto_save_enabled = true,
            auto_restore_enabled = true,
            auto_session_use_git_branch = true,
            save_extra_cmds = {
                -- tabby: tabs name
                save_tabby_tab_names,
            },
        })
    end,
    enabled = false,
}

return {
    auto_session,
    possession,
}
