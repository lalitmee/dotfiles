local M = {}

----------------------------------------------------------------------
-- NOTE: relaod using telescope {{{
----------------------------------------------------------------------
M.reload = function()
    -- Telescope will give us something like colors.lua,
    -- so this function convert the selected entry to
    -- the module name: ju.colors
    local function get_module_name(s)
        local module_name

        module_name = s:gsub("%.lua", "")
        module_name = module_name:gsub("%/", ".")
        module_name = module_name:gsub("%.init", "")

        return module_name
    end

    local prompt_title = "~ neovim modules ~"

    -- sets the path to the lua folder
    local path = "~/.config/nvim/lua"

    local opts = {
        prompt_title = prompt_title,
        cwd = path,

        attach_mappings = function(_, map)
            -- Adds a new map to ctrl+e.
            map("i", "<c-r>", function(_)
                -- these two a very self-explanatory
                local entry =
                    require("telescope.actions.state").get_selected_entry()
                local name = get_module_name(entry.value)

                -- call the helper method to reload the module
                -- and give some feedback
                R(name)
                vim.notify(name, 2, { title = "RELOADED" })
            end)

            return true
        end,
    }

    -- call the builtin method to list files
    require("telescope.builtin").find_files(opts)
end
-- }}}
----------------------------------------------------------------------

----------------------------------------------------------------------
--- NOTE: reload using namesapce {{{
----------------------------------------------------------------------
-- M.reload_config = function()
--   for name, _ in pairs(package.loaded) do
--     if name:match("^lk") then
--       package.loaded[name] = nil
--     end
--   end
--
--   dofile(vim.env.MYVIMRC)
--   vim.notify("Config Reloaded", 2, { title = "[config] reload" })
-- end

M.reload_config = function()
    -- Handle impatient.nvim automatically.
    local luacache = (_G.__luacache or {}).cache

    for name, _ in pairs(package.loaded) do
        if name:match("") then
            package.loaded[name] = nil

            if luacache then
                luacache[name] = nil
            end
        end
    end

    dofile(vim.env.MYVIMRC)
    vim.notify("Config Reloaded", 2, { title = "[config] reload" })
end
-- }}}
----------------------------------------------------------------------

----------------------------------------------------------------------
-- NOTE: reload module {{{
----------------------------------------------------------------------
M.reload_module = function(module_name)
    local matcher = function(pack)
        return string.find(pack, module_name, 1, true)
    end

    -- Handle impatient.nvim automatically.
    local luacache = (_G.__luacache or {}).cache

    for pack, _ in pairs(package.loaded) do
        if matcher(pack) then
            package.loaded[pack] = nil

            if luacache then
                luacache[pack] = nil
            end
        end
    end
end
-- }}}
----------------------------------------------------------------------

return M

-- vim:foldmethod=marker
