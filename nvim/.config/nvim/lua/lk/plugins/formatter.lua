local M = {
    "mhartington/formatter.nvim",
    event = { "BufWritePost" },
    cmd = { "FormatWrite" },
}

function M.config()
    local ok, formatter = lk.require("formatter")
    if not ok then
        return
    end

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
    local rustfmt = require("formatter.filetypes.rust")
    -- }}}
    ----------------------------------------------------------------------

    ----------------------------------------------------------------------
    -- NOTE: python format {{{
    ----------------------------------------------------------------------
    local black = require("formatter.filetypes.python").black
    -- }}}
    ----------------------------------------------------------------------

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
            javascript = { prettier },
            javascriptreact = { prettier },
            typescript = { prettier },
            typescriptreact = { prettier },
            css = { prettier },
            less = { prettier },
            sass = { prettier },
            scss = { prettier },
            json = { prettier },
            graphql = { prettier },
            markdown = { prettier },
            python = { black },
            vue = { prettier },
            yaml = { prettier },
            html = { prettier },
            rust = { rustfmt },
            lua = { styluafmt },
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
