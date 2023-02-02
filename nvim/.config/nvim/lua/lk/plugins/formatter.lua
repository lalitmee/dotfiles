local M = {
    "mhartington/formatter.nvim",
    event = { "BufWritePost" },
    cmd = { "FormatWrite" },
    enabled = false,
}

M.config = function()
    local formatter = require("formatter")
    local util = require("formatter.util")

    ----------------------------------------------------------------------
    -- NOTE: clang-format {{{
    ----------------------------------------------------------------------
    local clang_format = require("formatter.filetypes.cpp").clangformat
    -- }}}
    ----------------------------------------------------------------------

    ----------------------------------------------------------------------
    -- NOTE: prettier {{{
    ----------------------------------------------------------------------
    local prettier = function()
        return {
            exe = "prettierd",
            args = {
                util.escape_path(util.get_current_buffer_file_path()),
            },
            stdin = true,
        }
    end
    -- }}}
    ----------------------------------------------------------------------

    ----------------------------------------------------------------------
    -- NOTE: rustfmt {{{
    ----------------------------------------------------------------------
    local rustfmt = require("formatter.filetypes.rust").rustfmt
    -- }}}
    ----------------------------------------------------------------------

    ----------------------------------------------------------------------
    -- NOTE: python format {{{
    ----------------------------------------------------------------------
    local black = require("formatter.filetypes.python").black
    -- }}}
    ----------------------------------------------------------------------

    --------------------------------------------------------------------------------
    --  NOTE: shfmt {{{
    --------------------------------------------------------------------------------
    local shfmt = require("formatter.filetypes.sh").shfmt
    -- }}}
    --------------------------------------------------------------------------------

    --------------------------------------------------------------------------------
    --  NOTE: toml {{{
    --------------------------------------------------------------------------------
    local taplo_fmt = require("formatter.filetypes.toml").taplo
    -- }}}
    --------------------------------------------------------------------------------

    ----------------------------------------------------------------------
    -- NOTE: styluafmt {{{
    ----------------------------------------------------------------------
    local styluafmt = function()
        return {
            exe = "stylua",
            args = {
                "--config-path ~/.config/stylua/stylua.toml",
                "-",
            },
            stdin = true,
        }
    end
    -- }}}
    ----------------------------------------------------------------------

    ----------------------------------------------------------------------
    -- NOTE: formatter setup {{{
    ----------------------------------------------------------------------
    formatter.setup({
        filetype = {
            c = { clang_format },
            cpp = { clang_format },
            css = { prettier },
            graphql = { prettier },
            html = { prettier },
            javascript = { prettier },
            javascriptreact = { prettier },
            json = { prettier },
            less = { prettier },
            lua = { styluafmt },
            markdown = { prettier },
            python = { black },
            rust = { rustfmt },
            sass = { prettier },
            scss = { prettier },
            sh = { shfmt },
            toml = { taplo_fmt },
            typescript = { prettier },
            typescriptreact = { prettier },
            vue = { prettier },
            yaml = { prettier },
            ["*"] = {
                require("formatter.filetypes.any").remove_trailing_whitespace,
            },
        },
    })
    -- }}}
    ----------------------------------------------------------------------

    ----------------------------------------------------------------------
    -- NOTE: formatter autocmd {{{
    ----------------------------------------------------------------------
    lk.augroup("formatter_au", {
        {
            event = { "BufWritePost" },
            pattern = { "*" },
            command = function()
                vim.cmd([[FormatWrite]])
            end,
        },
    })
    -- }}}
    ----------------------------------------------------------------------
end

return M

-- vim:foldmethod=marker
