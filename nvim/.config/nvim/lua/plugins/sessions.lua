local possession = {
    "jedrzejboczar/possession.nvim",
    event = { "VimEnter" },
    init = function()
        require("telescope").load_extension("possession")
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
