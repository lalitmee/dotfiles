local M = {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v2.x",
    dependencies = {
        { "MunifTanjim/nui.nvim" },
        { "s1n7ax/nvim-window-picker" },
    },
    cmd = {
        "NeoTreeFocusToggle",
        "NeoTreeRevealToggle",
        "NeoTreeRevealInSplitToggle",
    },
}

M.enabled = false

M.config = function()
    local path_config = {
        show_path = "relative", -- "none", "relative", "absolute"
    }

    require("neo-tree").setup({
        popup_border_style = "rounded",
        window = {
            position = "float",
            width = 40,
            mapping_options = {
                noremap = true,
                nowait = true,
            },
            mappings = {
                ["<space>"] = {
                    "toggle_node",
                    nowait = false,
                },
                ["<2-LeftMouse>"] = "open",
                ["<cr>"] = "open",
                ["<esc>"] = "revert_preview",
                ["P"] = { "toggle_preview", config = { use_float = true } },
                ["S"] = "open_split",
                ["s"] = "open_vsplit",
                ["t"] = "open_tabnew",
                ["w"] = "open_with_window_picker",
                ["C"] = "close_node",
                ["z"] = "close_all_nodes",
                ["Z"] = "expand_all_nodes",
                ["a"] = {
                    "add",
                    config = path_config,
                },
                ["A"] = {
                    "add_directory",
                    config = path_config,
                },
                ["d"] = "delete",
                ["r"] = "rename",
                ["y"] = "copy_to_clipboard",
                ["x"] = "cut_to_clipboard",
                ["p"] = "paste_from_clipboard",
                ["c"] = {
                    "copy",
                    config = path_config,
                },
                ["m"] = "move",
                ["q"] = "close_window",
                ["R"] = "refresh",
                ["?"] = "show_help",
                ["<"] = "prev_source",
                [">"] = "next_source",
            },
        },
        filesystem = {
            filtered_items = {
                hide_dotfiles = false,
            },
        },
    })
end

return M
