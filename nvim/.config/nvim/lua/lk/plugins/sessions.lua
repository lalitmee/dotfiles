local M = {
    "rmagatti/auto-session",
    event = { "VimEnter" },
}

M.config = function()
    require("auto-session").setup({
        auto_save_enabled = true,
        auto_restore_enabled = true,
        auto_session_use_git_branch = true,
        save_extra_cmds = {
            -- tabby: tabs name
            function()
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
            end,
        },
    })
end

return M
