require("snacks").setup(require("plugins.snacks.opts"))
require("plugins.snacks.picker.sources")
require("plugins.snacks.setup")

local function set_keys(keys)
    for _, key in ipairs(keys) do
        local opts = vim.deepcopy(key)
        local lhs, rhs = table.remove(opts, 1), table.remove(opts, 1)
        if rhs then
            local mode = opts.mode or "n"
            opts.mode = nil
            vim.keymap.set(mode, lhs, rhs, opts)
        end
    end
end

set_keys(require("plugins.snacks.keys_general"))
set_keys(require("plugins.snacks.picker.keys"))
